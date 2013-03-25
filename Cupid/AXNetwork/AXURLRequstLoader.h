//
//  AXURLRequstLoader.h
//
//  Created by Alex on 12-12-5.
//
//

#import <Foundation/Foundation.h>

@protocol AXURLRequestLoaderDelegate <NSObject>

- (void)loader:(NSObject*)loader URL:(NSURL*)URL didFinishLoadingWithData:(NSData*)data response:(NSURLResponse *)response;
- (void)loader:(NSObject*)loader URL:(NSURL*)URL didFailWithError:(NSError*)error;

@end

@class AXURLRequest;

@interface AXURLRequstLoader : NSObject <NSURLConnectionDelegate>

- (id)initWithURL:(NSURL*)URL request:(id<AXURLRequestLoaderDelegate>)request;
- (void)start;

@end
