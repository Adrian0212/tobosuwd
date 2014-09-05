//
//  BaseUIViewController.h
//  Connect
//
//  Created by wengchunjie on 14-4-1.
//  Copyright (c) 2014年 wengchunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabBarController.h"
#import "Utils.h"

@interface BaseUIViewController : UIViewController

@property (retain, nonatomic) UINavigationBar       *navBar;
@property (retain, nonatomic) UIButton              *backButton;
@property (retain, nonatomic) BaseTabBarController  *baseTabBarController;

// 隐藏导航栏
- (void)hideNavigationBar;
// 显示导航栏
- (void)showNavigationBar;
// 隐藏导航栏返回按钮
- (void)hideBackButton;
// 显示导航栏返回按钮
- (void)showBackButton;
// 设置导航栏标题
- (void)setBarTitle:(NSString *)title;
// 设置导航栏浅色样式
- (void)setDefaultThemeBar;
// 设置导航栏橘色样式
- (void)setOrangeThemeBar;
// 关闭软键盘
- (void)closeKeyBoard;
// 隐藏标签栏
- (void)hideTabBar;
// 显示标签栏
- (void)showTabBar;

@end