//
//  Utils.m
//  tbswd
//
//  Created by Adrian on 14-8-15.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "Utils.h"

@interface Utils ()

@end

@implementation Utils

+ (UIColor *)hexStringToColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }

    if ([cString length] != 6) {
        return [UIColor blackColor];
    }

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;

    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float)r / 255.0f)
                    green       :((float)g / 255.0f)
                    blue        :((float)b / 255.0f)
                    alpha       :1.0f];
}

+ (NSString *)convert2Md5:(NSString *)stringToConvert
{
    const char      *cStr = [stringToConvert UTF8String];
    unsigned char   result[CC_MD5_DIGEST_LENGTH]; // 开辟一个16字节（128位：md5加密出来就是128位/bit）的空间

    /*
     *   extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     *   把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    CC_MD5(cStr, strlen(cStr), result);

    /*
     *   x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     *   NSLog("%02X", 0x888);  //888
     *   NSLog("%02X", 0x4); //04
     */
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ] lowercaseString];
}

+ (void)showHUD:(MBProgressHUD *)hud inView:(UIView *)view withTitle:(NSString *)title
{
    [view addSubview:hud];
    hud.labelText = title;      // 显示提示
    hud.dimBackground = YES;    // 使背景成黑灰色，让MBProgressHUD成高亮显示
    hud.square = YES;           // 设置显示框的高度和宽度一样
    [hud show:YES];
}

// +(void)ToastNotification:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
// {
//        [view addSubview:hud];
//    hud.labelText = text;
//    hud.mode = MBProgressHUDModeText;
//    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
//    //    HUD.yOffset = 100.0f;
//    //    HUD.xOffset = 100.0f;
//    [hud showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//    } completionBlock:^{
//        [hud removeFromSuperview];
//    }];
//
// }

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom ? GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];

    [notificationView show:YES];
    [notificationView hideAnimatedAfter:2.6];
}

+ (void)TakeException:(NSException *)exception
{
    NSArray     *arr = [exception callStackSymbols];
    NSString    *reason = [exception reason];
    NSString    *name = [exception name];
    NSString    *url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@", name, reason, [arr componentsJoinedByString:@"\n"]];
    NSArray     *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString    *path = [paths objectAtIndex:0];

    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  // size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   // 返回的就是已经改变的图片
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  // size 为CGSize类型，即你所需要的图片尺寸

    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];

    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return scaledImage;   // 返回的就是已经改变的图片
}

@end