//
//  ViewController.m
//  testOurApps
//
//  Created by 建红 杨 on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "UIDevice+Custom.h"
#import "OurAppsVC.h"

@interface ViewController () <OurAppsVCDelegate>

@end

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 100, 40);
    [button setTitle:@"弹出查看" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton1:) 
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 180, 100, 40);
    [button setTitle:@"推入查看" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton2:) 
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


#pragma mark - ClickEvent

- (void)clickButton1:(id)sender
{
    OurAppsVC *ourAppsVC = [[OurAppsVC alloc] init];
    ourAppsVC.appleID = @"441076723";
    ourAppsVC.delegate = self;
    //
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ourAppsVC];
    if ([UIDevice systemVersionID] < __IPHONE_5_0) {
        [self presentModalViewController:nav animated:YES];
    }
    else {
        [self presentViewController:nav animated:YES completion:nil];
    }
    [nav release];
    [ourAppsVC release];
}

- (void)clickButton2:(id)sender
{
    OurAppsVC *ourAppsVC = [[OurAppsVC alloc] init];
    ourAppsVC.appleID = @"446324237";
    ourAppsVC.delegate = self;
    [self.navigationController pushViewController:ourAppsVC animated:YES];
    [ourAppsVC release];
}


#pragma mark - OurAppsVCDelegate

// 返回
- (void)ourAppsVCBack:(OurAppsVC *)ourAppsVC
{
    if ([UIDevice systemVersionID] < __IPHONE_5_0) {
        [self dismissModalViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// 应用项被点击
- (void)ourAppsVC:(OurAppsVC *)ourAppsVC clickAppItem:(DataAppItem *)dataAppItem
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dataAppItem.appURL]];
}

@end
