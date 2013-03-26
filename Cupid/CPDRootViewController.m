//
//  CPDRootViewController.m
//  Cupid
//
//  Created by Apollo on 13-3-25.
//  Copyright (c) 2013年 Cupid angel team. All rights reserved.
//

#import "CPDHomeViewController.h"
#import "CPDRootViewController.h"

static CPDRootViewController *gRootViewController = nil;


@implementation CPDRootViewController

+ (id)sharedController
{
	if (gRootViewController == nil) {
        gRootViewController = [[CPDRootViewController alloc] init];
    }

	return gRootViewController;
}

- (id)init
{
    self = [super init];
    if (self) {
		[[UINavigationBar appearance] setTintColor:[UIColor colorWithHex:0xce4035]];
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	CPDHomeViewController *homeViewController = [[CPDHomeViewController alloc] init];
	[self pushViewController:homeViewController animated:NO];
	[homeViewController release];
	
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
