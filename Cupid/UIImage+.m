//
//  UIImage+UIImage_.m
//
//  Created by Alex on 12-10-7.
//

#import "UIImage+.h"

@implementation UIImage (UIImagePlus)

//用图片的原始尺寸和限制的最大宽度计算缩放后的图片尺寸，
//如果图片尺寸大于最大宽度，图框尺寸为缩放后的图片尺寸，
//如果图片尺寸小于最大宽度，图框尺寸为最大宽度*最大宽度
+ (CGSize)getImageSizeWithSize:(CGSize)imageSize maxWidth:(CGFloat)maxWidth
{
	//先根据屏幕分辨率进行图片缩放
	CGFloat screenScale = [[UIScreen mainScreen] scale];
	imageSize = CGSizeMake(imageSize.width / screenScale, imageSize.height / screenScale);

	///计算图片缩放尺寸
	if (maxWidth > 0) {
		if (imageSize.width > maxWidth) {
			imageSize.height = (CGFloat)(NSInteger)(imageSize.height * maxWidth / imageSize.width);
			imageSize.width = maxWidth;
		}
	}
	return imageSize;
}

@end
