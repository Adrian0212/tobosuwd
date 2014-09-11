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

/**
 *  toast消息框显示
 *
 *  @param text      消息内容
 *  @param view      显示消息的界面
 *  @param isLoading 是否有加载图标
 *  @param isBottom  是否在底部显示
 */
+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom;

/**
 *  异常日志输出
 *
 *  @param exception 异常
 */
+ (void)TakeException:(NSException *)exception;

/**
 *  缩放图片
 *
 *  @param image 原始图片
 *  @param size  缩放尺寸
 *
 *  @return 缩放后的图片
 */
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

/**
 *  调整字符串行高
 *
 *  @param string 字符串
 *  @param height 行高
 *
 *  @return 带有行高的字符串
 */
+ (NSAttributedString *)rezieString:(NSString *)string toHeight:(float)height;

@end