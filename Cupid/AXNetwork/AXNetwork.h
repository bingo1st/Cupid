//
//  Network.h
//
//  Created by Alex on 12-8-10.
//
//

#import <Foundation/Foundation.h>
#define USER_AGENT @"AX"

@interface AXNetwork : NSObject

+ (void)requestStart;
+ (void)requestStop;

@end
