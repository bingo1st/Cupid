//
//  CPDHomeViewController.m
//  Cupid
//
//  Created by Alex on 13-3-25.
//  Copyright (c) 2013年 Cupid angel team. All rights reserved.
//

#import "CPDHomeViewController.h"


@implementation CPDHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.title = @"Cupid";

	self.view.backgroundColor = [UIColor colorWithHex:0xeeeeee];

	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(80, 100, 160, 60);
	[button setTitle:@"挑人" forState:UIControlStateNormal];

	[self.view addSubview:button];

	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(80, 180, 160, 60);
	[button setTitle:@"被挑" forState:UIControlStateNormal];

	[self.view addSubview:button];
	
}


@end
