//
//  LoginController.m
//  tbswd
//
//  Created by Adrian on 14-8-11.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBarTitle:@"登陆界面"];

    _userName = [[Config Instance] getUserName];
    _userPwd = [[Config Instance] getPwd];

    if (_userName) {
        _userAccount.text = _userName;
    }

    if (_userPwd) {
        _userPassword.text = _userPwd;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_userName && _userPwd) {
        [self loginAction:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 登陆操作
- (IBAction)loginAction:(id)sender
{
    [self closeKeyBoard];

    // 点击按钮，则获取输入框中的值并MD5加密
    if (sender) {
        _userName = _userAccount.text;
        _userPwd = [Utils convert2Md5:_userPassword.text];
    }

    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];

    [Utils showHUD:hud inView:self.view withTitle:@"正在登陆"];

    NSDictionary *infos = @{@"name":_userName, @"password":_userPwd, @"logintype":@"ios"};

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];       // 这里要将url设置为空
    [httpClient postPath:api_url_login parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSData *result = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];

            if ([[jsonData objectForKey:@"msg"] isEqualToString:@"true"]) {
                // 保存用户数据
                [[Config Instance] saveUserNameAndPwd:_userName andPwd:_userPwd];

                // 设置登陆标记
                [[Config Instance] saveIsLogin:YES];
                //                NSLog(@"result:%@", [jsonData objectForKey:@"info"]);
                [[Config Instance] saveUserInfo:[jsonData objectForKey:@"info"]];

                //                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"wenda" bundle:nil];
                //                UIViewController *wendaObj = [mainStoryboard instantiateViewControllerWithIdentifier:@"wenda"];
                //                [self.navigationController pushViewController:wendaObj animated:YES];
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"wenda" bundle:nil];
                self.view.window.rootViewController = [mainStoryboard instantiateInitialViewController];
            } else if ([[jsonData objectForKey:@"msg"] isEqualToString:@"false"]) {
                [Utils ToastNotification:@"用户名或者密码错误" andView:self.view andLoading:NO andIsBottom:YES];
            } else {
                [Utils ToastNotification:@"该登录账户存在安全隐患，请在电脑上登录" andView:self.view andLoading:NO andIsBottom:YES];
            }
        }
        @catch(NSException *exception) {
            [Utils TakeException:exception];
        }

        @finally {
            [hud hide:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils ToastNotification:@"网络连接故障" andView:self.view andLoading:NO andIsBottom:YES];
        [hud hide:YES];
    }];
}

@end