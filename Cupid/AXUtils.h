//
//  AXUtils.h
//
//  Created by Alex on 12-11-14.
//
//

#import <Foundation/Foundation.h>
#include <time.h>
#import "NSString+.h"
#import "UIColor+.h"
#import "AXImageView.h"

#define LOG(obj) NSLog(@"%@", obj)
#define LOG_FRAME(view) NSLog(@"%@: %@", [view class], NSStringFromCGRect(view.frame))
#define LANG(key) NSLocalizedString(key, nil)

NSTimeInterval __time;

#define TIMER_START __time = [[NSDate date] timeIntervalSince1970]
#define TIMER_STOP NSLog(@"Time: %f", ([[NSDate date] timeIntervalSince1970] - __time))

CGFloat DegreesToRadians(CGFloat degrees);
CGFloat RadiansToDegrees(CGFloat radians);
CGAffineTransform CGAffineTransformMakeOrientatedTranslation(CGFloat tx,CGFloat ty);

@interface AXUtils : NSObject

+ (NSString*)formatTime:(NSTimeInterval)time;

@end
