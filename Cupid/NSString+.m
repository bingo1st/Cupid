//
//  NSString+NSString_.m
//
//  Created by Alex on 12-7-31.
//
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+.h"

@implementation NSString (NSStringPlus)

-(NSString *) md5
{
	const char *cStr = [self UTF8String];
	unsigned char digest[16];
	CC_MD5(cStr, strlen(cStr), digest);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[output appendFormat:@"%02x", digest[i]];
	}
	return  output;
}

- (NSDictionary *)parseQueryString
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	NSArray *_parameters = [self componentsSeparatedByString:@"&"];
	for (NSInteger i = 0; i < [_parameters count]; i++) {
		NSArray *keyValues = [[_parameters objectAtIndex:i] componentsSeparatedByString:@"="];
		if ([keyValues count] >= 2) {
			NSString *key = [[[keyValues objectAtIndex:0] lowercaseString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
			if (key.length > 0) {
				NSString *value  = [[[keyValues objectAtIndex:1] stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
				[parameters setObject:value forKey:key];
			}
		}
	}

	return parameters;
}

@end
