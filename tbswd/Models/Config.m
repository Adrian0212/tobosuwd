//
//  Config.m
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "Config.h"

@implementation Config

- (void)saveUserNameAndPwd:(NSString *)userName andPwd:(NSString *)pwd
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    [settings removeObjectForKey:@"UserName"];
    [settings removeObjectForKey:@"Password"];
    [settings setObject:userName forKey:@"UserName"];
    [settings setObject:pwd forKey:@"Password"];
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

static Config *instance = nil;
+ (Config *)Instance
{
    @synchronized(self) {
        if (nil == instance) {
            [self new];
        }
    }
    return instance;
}

@end