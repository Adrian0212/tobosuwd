//
//  BaseTableViewController.h
//  tbswd
//
//  Created by admin on 14/8/27.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface BaseTableViewController : UITableViewController

@property (retain, nonatomic) UINavigationBar   *navBar;
@property (retain, nonatomic) UIButton          *backButton;

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

@end