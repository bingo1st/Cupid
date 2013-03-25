//
//  UIColor+UIColor.m
//
//  Created by Alex on 12-8-5.
//
//

#import "UIColor+.h"

@implementation UIColor (UIColorPlus)

+ (UIColor*)colorWithHex:(NSInteger)hexValue
{
	return [self colorWithHex:hexValue alpha:1];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:(((float)((hexValue & 0xFF0000) >> 16))/255.0f)
						   green:(((float)((hexValue & 0xFF00) >> 8))/255.0f)
							blue:(((float)(hexValue & 0xFF))/255.0f)
						   alpha:alpha
			];
}


+ (UIColor*)colorWithHexAndAlpha:(NSInteger)hexValue
{
	return [UIColor colorWithRed:(((float)((hexValue & 0xFF000000) >> 24))/255.0f)
						   green:(((float)((hexValue & 0xFF0000) >> 16))/255.0f)
							blue:(((float)((hexValue & 0xFF00) >> 8))/255.0f)
						   alpha:(((float)(hexValue & 0xFF))/255.0f)
			];
}

+ (UIColor *) colorWithHexString:(NSString *)hexString
{
	NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
	if([cleanString length] == 3) {
		cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
					   [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
					   [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
					   [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
	}
	if([cleanString length] == 6) {
		cleanString = [cleanString stringByAppendingString:@"ff"];
	}

	unsigned int baseValue;
	[[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];

	float red = ((baseValue >> 24) & 0xFF)/255.0f;
	float green = ((baseValue >> 16) & 0xFF)/255.0f;
	float blue = ((baseValue >> 8) & 0xFF)/255.0f;
	float alpha = ((baseValue) & 0xFF)/255.0f;

	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
