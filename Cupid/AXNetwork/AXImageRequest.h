//
//  AXImageRequest.h
//
//  Created by Alex on 12-12-5.
//
//

#import <Foundation/Foundation.h>
#import "AXURLRequstLoader.h"

@protocol AXImageRequestDelegate <NSObject>
@optional

- (void)URL:(NSURL*)URL didFinishLoadingWithImage:(UIImage*)image;
- (void)URL:(NSURL*)URL didFailWithError:(NSError*)error;

@end

@interface AXImageRequest : NSObject <AXURLRequestLoaderDelegate>

+ (void)requestURL:(NSURL*)URL delegate:(id<AXImageRequestDelegate>)delegate;
+ (void)cancelRequest:(id<AXImageRequestDelegate>)delegate;
+ (void)removeDelegate:(id<AXImageRequestDelegate>)delegate;
+ (void)updateCachedImage:(UIImage*)image URL:(NSURL*)URL;
+ (void)clearCache;
+ (void)clearDiskCache;
+ (void)clearMemoryCache;

@end

