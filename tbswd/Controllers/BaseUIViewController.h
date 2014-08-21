//
//  BaseUIViewController.h
//  Connect
//
//  Created by wengchunjie on 14-4-1.
//  Copyright (c) 2014年 wengchunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseUIViewController : UIViewController

// 隐藏导航栏
- (void)hideNavigationBar;
// 显示导航栏
- (void)showNavigationBar;
// 设置导航栏标题
- (void)setBarTitle:(NSString *)title;
// 关闭软键盘
- (void)closeKeyBoard;

@end