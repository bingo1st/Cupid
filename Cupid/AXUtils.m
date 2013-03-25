//
//  AXUtils.m
//
//  Created by Alex on 12-11-14.
//
//

#import "AXUtils.h"

CGFloat DegreesToRadians(CGFloat degrees)
{
	return degrees * M_PI / 180;
};

CGFloat RadiansToDegrees(CGFloat radians)
{
	return radians * 180 / M_PI;
};

CGAffineTransform CGAffineTransformMakeOrientatedTranslation(CGFloat tx,CGFloat ty) {
	UIInterfaceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
	CGAffineTransform transform;
	if (interfaceOrientation == UIDeviceOrientationLandscapeRight) {
		transform = CGAffineTransformMakeRotation(DegreesToRadians(-90.0f));
	} else if (interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
		transform = CGAffineTransformMakeRotation(DegreesToRadians(90.0f));
	} else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
		transform = CGAffineTransformMakeRotation(DegreesToRadians(180.0f));
	} else {
		transform = CGAffineTransformIdentity;
	}
	transform = CGAffineTransformTranslate(transform, tx, ty);
	return transform;
};

@implementation AXUtils

+ (NSString*)formatTime:(NSTimeInterval)time
{

	time = time / 1000;
	
	NSDate *dateNow = [NSDate date];
	NSTimeInterval timeNow = [dateNow timeIntervalSince1970];
	NSString *timeString;

	if (timeNow - time < 60) {
		timeString = @"刚刚更新";
		
	} else if (timeNow - time < 3600) {
		timeString = [NSString stringWithFormat:@"%d分钟前", (NSInteger)((timeNow - time) / 60)];
		
	} else {
		
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
		
		if (timeNow - time <= 3600 * 24) {
			[dateFormatter setDateFormat:@"dd"];
			if ([[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:dateNow]]) {
				[dateFormatter setDateFormat:@"今天 HH:mm"];
			} else {
				[dateFormatter setDateFormat:@"昨天 HH:mm"];
			}
			
		} else {
			[dateFormatter setDateFormat:@"yyyy"];
			if ([[dateFormatter stringFromDate:date] isEqualToString:[dateFormatter stringFromDate:dateNow]]) {
				[dateFormatter setDateFormat:@"MM-dd"];
			} else {
				[dateFormatter setDateFormat:@"yyyy-MM-dd"];
			}
		}
		timeString = timeString = [dateFormatter stringFromDate:date];
		[dateFormatter release];
	}
	
	return timeString;
}

@end
