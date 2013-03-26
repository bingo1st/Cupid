//
//  CPDRootViewController.m
//  Cupid
//
//  Created by Apollo on 13-3-25.
//  Copyright (c) 2013年 Cupid angel team. All rights reserved.
//

#import "CPDRootViewController.h"

@interface CPDRootViewController ()

@end

@implementation CPDRootViewController
@synthesize controllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Cupid";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
