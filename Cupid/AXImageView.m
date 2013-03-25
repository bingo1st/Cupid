//
//  AXImageView.m
//
//  Created by Alex on 12-12-23.
//
//

#import "AXImageRequest.h"
#import "AXImageView.h"

@implementation AXImageView
{
	Boolean _isLocalImage;
}

@synthesize URL = _URL;

- (id)init
{
    self = [super init];
    if (self) {
		_isLocalImage = NO;
		
		self.contentMode = UIViewContentModeScaleAspectFill;
		self.clipsToBounds = YES;
    }
    return self;
}


- (id)initWithImageNamed:(NSString*)imageName
{
    self = [super init];
    if (self) {
		_isLocalImage = YES;

		UIImage *image = [UIImage imageNamed:imageName];
		self.image = image;
		self.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    return self;
}

- (void)dealloc
{
	if (_isLocalImage == NO) {
		//NSLog(@"AXImageView dealloc URL:%@", self.URL);
		self.URL = nil;
		[AXImageRequest removeDelegate:self];
	}
	[super dealloc];
}

- (void)setImage:(UIImage *)image
{
	if (image == nil) {
		self.URL = nil;
	}
	[super setImage:image];
}

- (void)loadImageFromURL:(NSURL*)URL
{
	if ([self.URL isEqual:URL]) {
		return;
	}
	self.image = nil;
	self.URL = URL;
	
	__block id imageView = self;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		[AXImageRequest cancelRequest:imageView];
		if (URL) {
			[AXImageRequest requestURL:URL delegate:imageView];
		}
	});
}

#pragma mark - AXImageRequestDelegate

- (void)URL:(NSURL*)URL didFinishLoadingWithImage:(UIImage*)image
{
	[image retain];

	CGSize viewSize = self.bounds.size;
	CGFloat scale = [[UIScreen mainScreen] scale];
	if (image.size.width / scale > viewSize.width) {
		
		CGFloat newHeight = (image.size.height / image.size.width) * viewSize.width;
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(viewSize.width, newHeight), NO, 0);
		[image drawInRect:CGRectMake(0, 0, viewSize.width, newHeight)];
		[image release];
		image = UIGraphicsGetImageFromCurrentImageContext();
		[image retain];
		UIGraphicsEndImageContext();

		//NSLog(@"resize:%@: %@", URL, NSStringFromCGSize(image.size));
		[AXImageRequest updateCachedImage:image URL:URL];
	}

	__block AXImageView *view = self;
	dispatch_async(dispatch_get_main_queue(), ^{
		//NSLog(@"AXImageView didFinishLoadingWithImage");
		if (view) {
			if ([URL isEqual:view.URL]) {
				view.image = image;
			}
		}
	});
	[image release];

}


- (void)URL:(NSURL*)URL didFailWithError:(NSError*)error
{
	self.URL = nil;
}


@end
