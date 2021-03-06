//
//  Config.m
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "Config.h"

@implementation Config

- (void)saveIsLogin:(BOOL)isLogin
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    [settings setBool:isLogin forKey:@"isLogin"];
    [settings synchronize];
}

- (BOOL)getIsLogin
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    return [settings boolForKey:@"isLogin"];
}

- (void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    [settings setObject:userName forKey:@"UserName"];
    [settings setObject:pwd forKey:@"Password"];
    [settings synchronize];
}

- (void)removeUserPwd
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    [settings removeObjectForKey:@"Password"];
    [settings synchronize];
}

- (NSString *)getUserName
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    return [settings objectForKey:@"UserName"];
}

- (NSString *)getPwd
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    return [settings objectForKey:@"Password"];
}

- (void)saveUserInfo:(NSDictionary *)info
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    NSMutableDictionary *newinfos = [NSMutableDictionary dictionaryWithDictionary:[settings objectForKey:@"UserInfo"]];

    [newinfos addEntriesFromDictionary:info];

    NSDictionary *infos = [NSDictionary dictionaryWithDictionary:newinfos];
    [settings setObject:infos forKey:@"UserInfo"];

    [settings synchronize];
}

- (void)removeUserInfo
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    [settings removeObjectForKey:@"UserInfo"];
    [settings synchronize];
}

- (NSDictionary *)getUserInfo
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    return [settings objectForKey:@"UserInfo"];
}

- (NSString *)getUserInfoForKey:(NSString *)key
{
    return [[self getUserInfo] objectForKey:key];
}

- (NSString *)getUserId
{
    return [self getUserInfoForKey:@"id"];
}

- (NSString *)getUserMark
{
    return [self getUserInfoForKey:@"mark"];
}

- (NSString *)getUserNewuid
{
    return [self getUserInfoForKey:@"newuid"];
}

- (NSString *)getUserScore
{
    return [self getUserInfoForKey:@"score"];
}

- (void)setUserScore:(NSInteger)score
{
    NSUserDefaults      *settings = [NSUserDefaults standardUserDefaults];
    NSNumber            *temp = [NSNumber numberWithInt:score];
    NSMutableDictionary *newinfos = [NSMutableDictionary dictionaryWithDictionary:[settings objectForKey:@"UserInfo"]];

    [newinfos setValue:temp forKey:@"score"];
    NSDictionary *infos = [NSDictionary dictionaryWithDictionary:newinfos];
    [settings setObject:infos forKey:@"UserInfo"];

    [settings synchronize];
}

- (NSString *)getDict:(NSString *)dict ValueByKey:(NSString *)key
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    return [[settings objectForKey:dict] objectForKey:key];
}

static Config *instance = nil;
+ (Config *)Instance
{
    @synchronized(self) {
        if (nil == instance) {
            instance = [self new];
        }
    }
    return instance;
}

@end