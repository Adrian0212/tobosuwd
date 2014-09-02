//
//  IndexController.m
//  tbswd
//
//  Created by admin on 14/8/15.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "IndexController.h"
#import "QuelistController.h"
@interface IndexController ()

@end

@implementation IndexController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 引导页面出现时，隐藏导航栏
- (void)viewWillAppear:(BOOL)animated
{
    [self hideNavigationBar];
}

// 引导页面消失时，显示导航栏
- (void)viewWillDisappear:(BOOL)animated
{
    [self showNavigationBar];
}

- (IBAction)jumpToWenda:(id)sender
{
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"wenda" bundle:nil];
//    UIViewController *wendaObj = [mainStoryboard instantiateViewControllerWithIdentifier:@"wenda"];
//    [self.navigationController pushViewController:wendaObj animated:YES];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"wenda" bundle:nil];
    self.view.window.rootViewController = [mainStoryboard instantiateInitialViewController];


    }

@end