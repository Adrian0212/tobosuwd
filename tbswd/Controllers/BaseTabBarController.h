//
//  BaseTabBarController.h
//  tbswd
//
//  Created by admin on 14/9/4.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface BaseTabBarController : UITabBarController

@property(nonatomic, retain) UIButton *centerButton;

// 隐藏中间突起按钮
- (void)hideCenterButton;

// 显示中间突起按钮
- (void)showCenterButton;

@end