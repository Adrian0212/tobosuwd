//
//  Utils.h
//  tbswd
//
//  Created by Adrian on 14-8-15.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "GCDiscreetNotificationView.h"
#import "CommonCrypto/CommonDigest.h"

@interface Utils : NSObject

/**
 *  颜色转换
 *
 *  @param stringToConvert 16进制颜色值 #FFFFFF
 *
 *  @return 返回RGB颜色值
 */
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;

/**
 *  MD5加密
 *
 *  @param stringToConvert 需加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString *)convert2Md5:(NSString *)stringToConvert;

/**
 *  提示框显示
 *
 *  @param hud   提示框对象
 *  @param view  显示提示框的界面
 *  @param title 提示框内容
 */
+ (void)showHUD:(MBProgressHUD *)hud inView:(UIView *)view withTitle:(NSString *)title;

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom;

+ (void)TakeException:(NSException *)exception;

@end