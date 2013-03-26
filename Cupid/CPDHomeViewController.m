//
//  CPDHomeViewController.m
//  Cupid
//
//  Created by Alex on 13-3-25.
//  Copyright (c) 2013年 Cupid angel team. All rights reserved.
//

#import "CPDHomeViewController.h"
#import "CPDSeekPanelViewController.h"
#import "CPDWaitPanelViewController.h"

@implementation CPDHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.title = @"Cupid";

	self.view.backgroundColor = [UIColor colorWithHex:0xffffff];

	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(80, 100, 160, 60);
	[button setTitle:@"包养" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(CPDShowSeekPanel:) forControlEvents:(UIControlEventTouchUpInside)];

	[self.view addSubview:button];

	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(80, 180, 160, 60);
	[button setTitle:@"求包养" forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage imageNamed:@"Icon.png"] forState:UIControlStateNormal];
    //button.backgroundColor = [UIColor colorWithHex:0x232433];
    [button addTarget:self action:@selector(CPDShowWaitPanel:) forControlEvents:(UIControlEventTouchUpInside)];

	[self.view addSubview:button];
	
}
     
-(IBAction)CPDShowSeekPanel:(id)sender{
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"开启包养之旅！" message:@"haha!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    //[alert show];
    CPDSeekPanelViewController *seekPanelViewController = [[CPDSeekPanelViewController alloc] init];
    [[self navigationController] pushViewController:seekPanelViewController animated:YES];
}

-(IBAction)CPDShowWaitPanel:(id)sender{
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"开启求包养之旅！" message:@"haha!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    //[alert show];
    CPDWaitPanelViewController *waitPanelViewController = [[CPDWaitPanelViewController alloc] init];
    [[self navigationController] pushViewController:waitPanelViewController animated:YES];
}

@end
