//
//  AXURLRequstLoader.m
//
//  Created by Alex on 12-12-5.
//
//

#import "NSString+.h"
#import "AXNetwork.h"
#import "AXURLRequstLoader.h"

@implementation AXURLRequstLoader
{
	id<AXURLRequestLoaderDelegate> _request;
	NSURL *_URL;
	NSURLConnection *_connection;
	NSHTTPURLResponse *_response;
	NSMutableData* _connectionData;
	BOOL _isLoading;
}

- (void)dealloc
{
	//NSLog(@"AXURLRequstLoader dealloc: %@, _connectionData: %d", _URL, [_connectionData retainCount]);
	[self cancelConnection];
	[_URL release];
	[super dealloc];
}

- (id)initWithURL:(NSURL*)URL request:(id<AXURLRequestLoaderDelegate>)request
{
	self = [super init];
	if (self) {
		_request = request;
		_URL = [URL retain];
		_isLoading = NO;

		NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
		[URLRequest setValue:USER_AGENT forHTTPHeaderField:@"User-Agent"];
		[URLRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

		_response = nil;
		_connectionData = [[NSMutableData alloc] init];
		_connection = [[NSURLConnection alloc] initWithRequest:URLRequest delegate:self];
		[URLRequest release];
	}
	return self;
}

- (void)start
{
	//NSLog(@"start load: %@", _URL);
	[AXNetwork requestStart];
	[_connection start];
	_isLoading = YES;
}

- (void)cancelConnection
{
	if (_isLoading == YES) {
		_isLoading = NO;
		[_connection cancel];
		[_connection release];
		[_connectionData release];
		[_response release];
		[AXNetwork requestStop];
	}
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
	if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
		_response = [httpResponse retain];
	}
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
	[_connectionData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
	//NSLog(@"finish load: %@", _URL);
	[_request loader:self URL:_URL didFinishLoadingWithData:_connectionData response:_response];
	//[self cancelConnection];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError*)error
{
	[_request loader:self URL:_URL didFailWithError:error];
	//[self cancelConnection];
}

@end
