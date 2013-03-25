//
//  AXImageRequest.m
//
//  Created by Alex on 12-12-5.
//
//

#import "NSString+.h"
#import "AXImageRequest.h"
#import "AXURLRequstLoader.h"

static AXImageRequest *gMainImageRequest = nil;
static NSString *kCacheDirectoryName = @"URLCache";


@implementation AXImageRequest
{
	NSMutableDictionary *_loadingURLKeysWithDelegates;
	NSMutableDictionary *_cachedURLWithDelegates;
	NSMutableDictionary *_imageCaches;
	NSRecursiveLock *_lock;
	NSString* _cachePath;
}

- (id)init
{
	self = [super init];
	if (self) {
		_loadingURLKeysWithDelegates = [[NSMutableDictionary alloc] init];
		_cachedURLWithDelegates = [[NSMutableDictionary alloc] init];
		_imageCaches = [[NSMutableDictionary alloc] init];
		
		_lock = [[NSRecursiveLock alloc] init];
		 NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		_cachePath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:kCacheDirectoryName] retain];

		//BOOL succeeded = YES;
		NSFileManager* fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:_cachePath]) {
			[_lock lock];
			/*succeeded = */[fileManager createDirectoryAtPath: _cachePath
					  withIntermediateDirectories: YES
									   attributes: nil
											error: nil];
			[_lock unlock];
		}

	}
	return self;
}

- (void)dealloc
{
	[_loadingURLKeysWithDelegates release];
	[_cachedURLWithDelegates release];
	[_imageCaches release];
	[_lock release];
	[_cachePath release];
	[super dealloc];
}

+ (id)sharedRequest
{
	static dispatch_once_t once;
	
	dispatch_once(&once, ^{
        gMainImageRequest = [[AXImageRequest alloc] init];
    });
	
	return gMainImageRequest;
}

+ (void)requestURL:(NSURL*)URL delegate:(id<AXImageRequestDelegate>)delegate
{
	[[AXImageRequest sharedRequest] requestURL:URL delegate:delegate];
}

+ (void)removeDelegate:(id<AXImageRequestDelegate>)delegate
{
	[[AXImageRequest sharedRequest] removeDelegate:delegate];
}


+ (void)updateCachedImage:(UIImage*)image URL:(NSURL*)URL
{
	[[AXImageRequest sharedRequest] updateCachedImage:image URL:URL];
}


+ (void)cancelRequest:(id<AXImageRequestDelegate>)delegate
{
	[[AXImageRequest sharedRequest] cancelRequest:delegate];
}

+ (void)clearCache
{
	[[AXImageRequest sharedRequest] clearCache];
}

+ (void)clearDiskCache
{
	[[AXImageRequest sharedRequest] clearDiskCache];
}

+ (void)clearMemoryCache
{
	[[AXImageRequest sharedRequest] clearMemoryCache];
}

- (void)updateCachedImage:(UIImage*)image URL:(NSURL*)URL
{
	[_lock lock];
	[image retain];
	[_imageCaches removeObjectForKey:URL];
	[_imageCaches setObject:image forKey:URL];
	[image release];
	[_lock unlock];
}

- (void)updateCachedURL:(NSURL*)URL delegate:(id<AXImageRequestDelegate>)delegate
{
	NSMutableArray *delegates = [_cachedURLWithDelegates objectForKey:URL];
	NSString *delegateId = [NSString stringWithFormat:@"%p", delegate];
	if (delegates != nil) {
		if ([delegates indexOfObject:delegateId] == NSNotFound) {
			[delegates addObject:delegateId];
		}
	} else {
		[_cachedURLWithDelegates setObject:[NSMutableArray arrayWithObject:delegateId] forKey:URL];
	}
}

- (void)clearCache
{
	[self clearDiskCache];
	[self clearMemoryCache];
}

- (void)clearDiskCache
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		[_lock lock];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSError *error;

		NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:kCacheDirectoryName];
		if ([fileManager moveItemAtPath:_cachePath toPath:tempPath error:&error]) {
			[fileManager removeItemAtPath:tempPath error:&error];
		}
		[_lock unlock];
	});
}

- (void)clearMemoryCache
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		[_lock lock];
		[_imageCaches removeAllObjects];
		[_cachedURLWithDelegates removeAllObjects];
		[_lock unlock];
	});
}


- (void)requestURL:(NSURL*)URL delegate:(id<AXImageRequestDelegate>)delegate
{
	NSString *URLKey = [[URL absoluteString] md5];

	[_lock lock];

	__weak id weakDelegate;
	weakDelegate = delegate;

	//Check cache
	UIImage *image = [_imageCaches objectForKey:URL];
	if (image != nil) {
		//NSLog(@"load url from memory: %@", URL);
		[self updateCachedURL:URL delegate:delegate];
		[delegate URL:URL didFinishLoadingWithImage:image];
		[_lock unlock];
		return;
	}

	NSMutableArray *delegates = [_loadingURLKeysWithDelegates objectForKey:URLKey];
	if (delegates != nil) {
		//The URL is still loading
		[delegates addObject:weakDelegate];
		[_lock unlock];
	} else {

		[_lock unlock];

		//Check disk cache first.
		if ([delegate respondsToSelector:@selector(URL:didFinishLoadingWithImage:)]) {
		
			[URLKey retain];
			[URL retain];
			
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				
				NSFileManager *fileManager = [NSFileManager defaultManager];
				NSString *filePath = [_cachePath stringByAppendingPathComponent:URLKey];
				if ([fileManager fileExistsAtPath:filePath]) {
					
					NSError *error = nil;
					NSData *data = [[NSData alloc] initWithContentsOfFile:filePath options:NSMappedRead error:&error];
					
					if (error) {
						[data release];
						if ([delegate respondsToSelector:@selector(URL:didFailWithError:)]) {
							[delegate URL:URL didFailWithError:error];
						}
					} else {
						//NSLog(@"load url from disk cache: %@", URL);
						UIImage *image = [[UIImage alloc] initWithData:data];
						[data release];
						[_lock lock];
						if (image != nil) {
							[self updateCachedURL:URL delegate:delegate];
							[_imageCaches setObject:image forKey:URL];
						}
						[_lock unlock];
						[delegate URL:URL didFinishLoadingWithImage:image];
						[image release];
					}

				} else {

					[_lock lock];
					[_loadingURLKeysWithDelegates setObject:[NSMutableArray arrayWithObject:weakDelegate] forKey:URLKey];
					[_lock unlock];

					
					dispatch_async(dispatch_get_main_queue(), ^{
						AXURLRequstLoader *requestLoader = [[AXURLRequstLoader alloc] initWithURL:URL request:self];
						[requestLoader start];
					});
				}
			});
			
			[URLKey release];
			[URL release];
		}
	
	}
}

- (void)cancelRequest:(id<AXImageRequestDelegate>)delegate
{
	[_lock lock];
	NSString *URLKey;
	for (URLKey in _loadingURLKeysWithDelegates) {
		NSMutableArray *delegates = [_loadingURLKeysWithDelegates objectForKey:URLKey];
		if (delegates != nil) {
			[delegates removeObjectIdenticalTo:delegate];
		}
	}
	[_lock unlock];
}

- (void)removeDelegate:(id<AXImageRequestDelegate>)delegate
{
	[self cancelRequest:delegate];
	[_lock lock];

	NSURL *URL;
	NSString *delegateId = [NSString stringWithFormat:@"%p", delegate];
	//NSLog(@"removeDelegate: %@ <%p>", delegate, delegate);


	NSMutableArray *cachedURLKeys = [NSMutableArray arrayWithArray:[_cachedURLWithDelegates allKeys]];
	NSArray *cachedURLWithDelegatesKeys = [_cachedURLWithDelegates allKeys];
	[cachedURLKeys removeObjectsInArray:cachedURLWithDelegatesKeys];
	[_imageCaches removeObjectsForKeys:cachedURLKeys];


	NSMutableArray *removedURLs = [[NSMutableArray alloc] init];
	for (URL in _cachedURLWithDelegates) {
		NSMutableArray *delegates = [_cachedURLWithDelegates objectForKey:URL];
		[delegates removeObject:delegateId];
		if ([delegates count] <= 0) {
			[removedURLs addObject:URL];
			[_imageCaches removeObjectForKey:URL];
		}
	}

	//NSLog(@"removeCache: %@", removedURLs);

	[_cachedURLWithDelegates removeObjectsForKeys:removedURLs];
	[removedURLs release];

	[_lock unlock];
	
}

- (void)loader:(NSObject*)loader URL:(NSURL*)URL didFinishLoadingWithData:(NSData*)data response:(NSHTTPURLResponse*)response
{
	NSString *URLKey = [[[URL absoluteString] md5] retain];
	NSMutableArray *delegates = [_loadingURLKeysWithDelegates objectForKey:URLKey];
	
	if (delegates != nil) {
		[URL retain];
		[data retain];
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

			UIImage *image = [[UIImage alloc] initWithData:data];
			if (image != nil) {
				[_lock lock];

				NSMutableArray *__delegates = [_loadingURLKeysWithDelegates objectForKey:URLKey];

				[_imageCaches setObject:image forKey:URL];

				if (__delegates != nil) {

					__weak id delegate;
					for (delegate in __delegates) {
			
						if ([delegate respondsToSelector:@selector(URL:didFinishLoadingWithImage:)]) {
							//[_lock lock];
							[self updateCachedURL:URL delegate:delegate];
							//[_lock unlock];
							[delegate URL:URL didFinishLoadingWithImage:image];
						}

					}
				

					//[_loadingURLKeysWithDelegates setObject:[NSMutableArray array] forKey:URLKey];
					[_loadingURLKeysWithDelegates removeObjectForKey:URLKey];

				}
				[_lock unlock];
			}
			[image release];

			//Saving cache data to disk
			NSFileManager *fileManager = [NSFileManager defaultManager];

			if (![fileManager fileExistsAtPath:_cachePath]) {
				[fileManager createDirectoryAtPath: _cachePath
									   withIntermediateDirectories: YES
														attributes: nil
															 error: nil];
			}

			[fileManager createFileAtPath:[_cachePath stringByAppendingPathComponent:URLKey] contents:data attributes:nil];

		});
		[URL release];
		[data release];
	}
	[loader release];
	[URLKey release];
}

- (void)loader:(NSObject*)loader URL:(NSURL*)URL didFailWithError:(NSError*)error
{
	NSString *URLKey = [[[URL absoluteString] md5] retain];
	NSMutableArray *delegates = [_loadingURLKeysWithDelegates objectForKey:URLKey];
	
	if (delegates != nil) {
		[URL retain];
		[error retain];
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[_lock lock];
			NSMutableArray *__delegates = [_loadingURLKeysWithDelegates objectForKey:URLKey];
			if (__delegates != nil) {
				for (id<AXImageRequestDelegate> delegate in delegates) {
					if ([delegate respondsToSelector:@selector(URL:didFailWithError:)]) {
						[delegate URL:URL didFailWithError:error];
					}
				}
			}
			[_loadingURLKeysWithDelegates setObject:[NSMutableArray array] forKey:URLKey];
			[_lock unlock];
		});
		[URL release];
		[error release];
	}
	[loader release];
	[URLKey release];
}

@end
