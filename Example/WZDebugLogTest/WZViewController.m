//
//  WZViewController.m
//  WZDebugLogTest
//
//  Created by wangzz on 14-3-30.
//  Copyright (c) 2014年 wangzz. All rights reserved.
//

#import "WZViewController.h"
#import "WZDebugLog.h"

@interface WZViewController ()

@end

@implementation WZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 120, 40)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"print log" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onButtonAction:(id)sender
{
    WZLogDebug(@"It is a debug log.");
    WZLogInfo(@"It is a info log.");
    WZLogWarn(@"It is a warn log!");
    WZLogError(@"It is a debug log!");
}

@end
