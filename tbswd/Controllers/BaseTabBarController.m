//
//  BaseTabBarController.m
//  tbswd
//
//  Created by admin on 14/9/4.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBar setBarTintColor:[Utils hexStringToColor:@"#f5f5f5"]];
    [self.tabBar setSelectedImageTintColor:[Utils hexStringToColor:@"ff6600"]];

    NSArray *itemImage = [NSArray arrayWithObjects:@"icon_mine_01.png", @"icon_mine_02.png", @"", @"icon_mine_03.png", @"icon_mine_04.png", nil];
    //    NSArray *itemSelectedImage = [NSArray arrayWithObjects:@"icon_mine_01.png", @"icon_mine_02.png", @"", @"icon_mine_03.png", @"icon_mine_04.png",nil];

    int i = 0;

    for (UITabBarItem *item in self.tabBar.items) {
        [item setImage:[UIImage imageNamed:itemImage[i]]];
        i++;
        //        [item setTitle:[NSString stringWithFormat:@"%d", i++]];
        //        [item setTitleTextAttributes: forState:UIControlStateNormal];
    }

    [self addCenterButtonWithImage:[UIImage imageNamed:@"camera_button_take.png"] highlightImage:[UIImage imageNamed:@"tabBar_cameraButton_ready_matte.png"]];
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

@end