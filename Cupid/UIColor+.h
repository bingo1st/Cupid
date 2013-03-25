//
//  UIColor+UIColor.h
//  Weibo
//
//  Created by Alex on 12-8-5.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColorPlus)

+ (UIColor*)colorWithHex:(NSInteger)hexValue;
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;
+ (UIColor*)colorWithHexString:(NSString *)hexString;
+ (UIColor*)colorWithHexAndAlpha:(NSInteger)hexValue;

@end
