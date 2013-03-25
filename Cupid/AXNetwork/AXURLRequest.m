//
//  AXURLRequest.m
//
//  Created by Alex on 12-12-5.
//
//

#import "NSString+.h"
#import "AXURLRequest.h"
#import "AXURLRequstLoader.h"

static AXURLRequest* gMainRequest = nil;

@implementation AXURLRequest
{
	NSMutableDictionary *_loadingURLKeysWithDelegates;
	NSRecursiveLock *_lock;
}

- (id)init {
	self = [super init];
	if (self) {
		_loadingURLKeysWithDelegates = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc {
	[_loadingURLKeysWithDelegates release];
	[_lock release];
	[super dealloc];
}

+ (void)requestURL:(NSURL*)URL delegate:(id<AXURLRequestDelegate>)delegate
{
	if (!gMainRequest) {
		gMainRequest = [[AXURLRequest alloc] init];
	}
	[gMainRequest requestURL:URL delegate:delegate];
}

+ (void)removeDelegate:(id<AXURLRequestDelegate>)delegate
{
	if (!gMainRequest) {
		gMainRequest = [[AXURLRequest alloc] init];
	}
	[gMainRequest removeDelegate:delegate];
}

- (void)requestURL:(NSURL*)URL delegate:(id<AXURLRequestDelegate>)delegate
{
	NSString *URLKey = [[URL absoluteString] md5];

	[_lock lock];
	NSMutableArray *delegates = [_loadingURLKeysWithDelegates objectForKey:URLKey];
	if (delegates != nil) {
		[delegates addObject:delegate];
		[_lock unlock];
	} else {
		[_loadingURLKeysWithDelegates setObject:[NSMutableArray arrayWithObject:delegate] forKey:URLKey];
		[_lock unlock];
		AXURLRequstLoader *requestLoader = [[[AXURLRequstLoader alloc] initWithURL:URL request:self] autorelease];
		[requestLoader start];
	}
}

- (void)removeDelegate:(id<AXURLRequestDelegate>)delegate
{
	NSString *URLKey;
	for (URLKey in _loadingURLKeysWithDelegates) {
		NSMutableArray *delegates = [_loadingURLKeysWithDelegates objectForKey:URLKey];
		[delegates removeObject:delegate];
	}
}

- (void)URL:(NSURL*)URL didFinishLoadingWithData:(NSData*)data response:(NSHTTPURLResponse*)response
{
	NSString *URLKey = [[URL absoluteString] md5];
	NSMutableArray *delegates = [_loadingURLKeysWithDelegates objectForKey:URLKey];
	if (delegates != nil) {
		for (id<AXURLRequestDelegate> delegate in delegates) {
			if (delegates != nil) {
				if ([delegate respondsToSelector:@selector(URL:didFinishLoadingWithData:)]) {
					[delegate URL:URL didFinishLoadingWithData:data];
				}
			}
		}
		[_lock lock];
		[_loadingURLKeysWithDelegates removeObjectForKey:URLKey];
		[_lock unlock];
	}
}

- (void)URL:(NSURL*)URL didFailWithError:(NSError*)error
{
	NSString *URLKey = [[URL absoluteString] md5];
	NSMutableArray *delegates = [_loadingURLKeysWithDelegates objectForKey:URLKey];
	if (delegates != nil) {
		for (id<AXURLRequestDelegate> delegate in delegates) {
			if (delegates != nil) {
				if ([delegate respondsToSelector:@selector(URL:didFailWithError:)]) {
					[delegate URL:URL didFailWithError:error];
				}
			}
		}
		[_lock lock];
		[_loadingURLKeysWithDelegates removeObjectForKey:URLKey];
		[_lock unlock];
	}
}

@end

