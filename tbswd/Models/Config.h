//
//  Config.h
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

@property BOOL isLogin; // 是否已经登录

// 登陆标记设置及获取
- (void)saveIsLogin:(BOOL)isLogin;
- (BOOL)getIsLogin;

// 保存登录用户名以及密码
- (void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd;
// 清除用户密码
- (void)removeUserPwd;
// 获取登录用户名以及密码
- (NSString *)getUserName;
- (NSString *)getPwd;

// 保存用户信息字典
- (void)saveUserInfo:(NSDictionary *)info;
// 清除用户信息字典
- (void)removeUserInfo;
// 获取用户信息字典
- (NSDictionary *)getUserInfo;
// 根据Key获取用户信息
- (NSString *)getUserInfoForKey:(NSString *)key;
// 获取用户id(此ID不唯一)
- (NSString *)getUserId;
// 获取用户类型
- (NSString *)getUserMark;
// 获取用户id(此ID唯一)
- (NSString *)getUserNewuid;
// 获取用户积分
- (NSString *)getUserScore;
// 保存用户积分
- (void)setUserScore:(NSInteger)score;

+ (Config *)Instance;

@end