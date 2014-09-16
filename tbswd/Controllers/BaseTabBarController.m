//
//  BaseTabBarController.m
//  tbswd
//
//  Created by admin on 14/9/4.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "BaseTabBarController.h"
#import "WriteQueController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *itemImage = [NSArray arrayWithObjects:@"icon_tabbar_01.png", @"icon_tabbar_02.png", @"", @"icon_tabbar_03.png", @"icon_tabbar_04.png", nil];
    NSArray *itemSelectedImage = [NSArray arrayWithObjects:@"icon_tabbar_01_selected.png", @"icon_tabbar_02_selected.png", @"", @"icon_tabbar_03_selected.png", @"icon_tabbar_04_selected.png", nil];

    // 去除tabbar上的阴影
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];

    int i = 0;

    for (UITabBarItem *item in self.tabBar.items) {
        // 下移image的位置
        [item setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
        [item setImage:[UIImage imageNamed:itemImage[i]]];
        [item setSelectedImage:[UIImage imageNamed:itemSelectedImage[i]]];
        // 设置使用原图
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        i++;
    }

    [self addCenterButtonWithImage:[UIImage imageNamed:@"icon_tabbar_center.png"] highlightImage:[UIImage imageNamed:@"icon_tabbar_center.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage
{
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];

    _centerButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    _centerButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [_centerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_centerButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];

    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;

    if (heightDifference < 0) {
        _centerButton.center = self.tabBar.center;
    } else {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference / 2.0;
        _centerButton.center = center;
    }

    // 添加按钮点击事件
    [_centerButton addTarget:self action:@selector(showWriteQueView) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_centerButton];
}

- (void)hideCenterButton
{
    if (_centerButton) {
        [_centerButton setHidden:YES];
    }
}

- (void)showCenterButton
{
    if (_centerButton) {
        [_centerButton setHidden:NO];
    }
}

- (void)showWriteQueView
{
    UIStoryboard            *mainStoryboard = [UIStoryboard storyboardWithName:@"wenda" bundle:nil];
    WriteQueController      *writeQue = [mainStoryboard instantiateViewControllerWithIdentifier:@"WriteQue"];
    UINavigationController  *navigationController = [[UINavigationController alloc] initWithRootViewController:writeQue];

    [self presentViewController:navigationController animated:YES completion:nil];
}

@end