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

// 保存登录用户名以及密码
- (void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd;
- (NSString *)getUserName;
- (NSString *)getPwd;

+ (Config *)Instance;

@end