//
//  AXImageView.h
//
//  Created by Alex on 12-12-23.
//
//

#import <UIKit/UIKit.h>
#import "AXImageRequest.h"

@interface AXImageView : UIImageView <AXImageRequestDelegate>

- (id)initWithImageNamed:(NSString*)imageName;
- (void)loadImageFromURL:(NSURL*)URL;

@property (retain) NSURL *URL;

@end
