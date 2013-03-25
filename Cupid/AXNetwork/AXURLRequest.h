//
//  AXURLRequest.h
//
//  Created by Alex on 12-12-5.
//
//

#import <Foundation/Foundation.h>
#import "AXURLRequstLoader.h"

@protocol AXURLRequestDelegate <NSObject>
@optional

- (void)URL:(NSURL*)URL didFinishLoadingWithData:(NSData*)data;
- (void)URL:(NSURL*)URL didFailWithError:(NSError*)error;

@end

@interface AXURLRequest : NSObject <AXURLRequestLoaderDelegate>

+ (void)requestURL:(NSURL*)URL delegate:(id<AXURLRequestDelegate>)delegate;
+ (void)removeDelegate:(id<AXURLRequestDelegate>)delegate;

@end

