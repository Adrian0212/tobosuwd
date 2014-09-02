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

    NSString *userName = [[Config Instance] getUserName];
    //    NSString *userPwd = [[Config Instance] getPwd];

    if (userName) {
        _userAccount.text = userName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 登陆操作
- (IBAction)loginAction:(id)sender
{
    /*
     *  登陆接口:接受参数
     *   1.name  用户名/手机号码
     *   2.password  密码(需MD5加密)
     *   3.isapp 表示为手机app
     */
    //    NSString        *loginURL = [NSString stringWithFormat:@"http://api1.toboshu.net:8888/user/login/OveralLogin"];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];

    [Utils showHUD:hud inView:self.view withTitle:@"正在登陆"];

    NSDictionary *infos = @{@"name":[_userAccount text], @"password":[Utils convert2Md5:[_userPassword text]], @"logintype":@"ios"};

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];       // 这里要将url设置为空
    [httpClient postPath:api_url_login parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSData *result = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];

            if ([[jsonData objectForKey:@"msg"] isEqualToString:@"true"]) {
                // [Utils ToastNotification:@"登陆成功" andView:self.view andLoading:NO andIsBottom:YES];
                //                NSLog(@"登陆成功");
                // 保存用户数据
                [[Config Instance] saveUserNameAndPwd:[_userAccount text] andPwd:[Utils convert2Md5:[_userPassword text]]];
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