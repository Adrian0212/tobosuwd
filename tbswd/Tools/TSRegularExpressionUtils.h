//
//  TSRegularExpressionUtils.h
//  tbswd
//
//  Created by admin on 14/8/25.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSRegularExpressionUtils : NSObject

/**
 *  邮箱验证
 *
 *  @param email 邮箱
 *
 *  @return 正确返回YES，错误返回NO
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  手机号码验证(手机号以13， 15，18开头)
 *
 *  @param mobile 手机号码
 *
 *  @return 正确返回YES，错误返回NO
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 *  登陆用户名验证
 *
 *  @param name 登陆用户名
 *
 *  @return 正确返回YES，错误返回NO
 */
+ (BOOL)validateUserName:(NSString *)name;

/**
 *  密码验证(可包含特殊字符!@#)
 *
 *  @param passWord 密码
 *
 *  @return 正确返回YES，错误返回NO
 */
+ (BOOL)validatePassword:(NSString *)passWord;

/**
 *  昵称验证
 *
 *  @param nickname 昵称
 *
 *  @return 正确返回YES，错误返回NO
 */
+ (BOOL)validateNickname:(NSString *)nickname;

/**
 *  身份证号码验证
 *
 *  @param identityCard 身份证号码
 *
 *  @return 正确返回YES，错误返回NO
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

@end