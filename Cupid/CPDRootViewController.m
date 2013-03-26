//
//  CPDRootViewController.m
//  Cupid
//
<<<<<<< HEAD
//  Created by Alex on 13-3-25.
=======
//  Created by Apollo on 13-3-25.
>>>>>>> db7474f5865be265c339aaa6a47fc21942a169cd
//  Copyright (c) 2013年 Cupid angel team. All rights reserved.
//

#import "CPDRootViewController.h"
<<<<<<< HEAD
#import "CPDHomeViewController.h"

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
=======

@interface CPDRootViewController ()

@end

@implementation CPDRootViewController
@synthesize controllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
>>>>>>> db7474f5865be265c339aaa6a47fc21942a169cd
    }
    return self;
}

<<<<<<< HEAD
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


=======
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

>>>>>>> db7474f5865be265c339aaa6a47fc21942a169cd
@end
