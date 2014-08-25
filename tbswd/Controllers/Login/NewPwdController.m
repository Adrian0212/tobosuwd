//
//  GetCodeController.m
//  tbswd
//
//  Created by admin on 14/8/19.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "NewPwdController.h"

@interface NewPwdController () {
    AFHTTPClient *_httpclient;
}

@end

@implementation NewPwdController
@synthesize data;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBarTitle:@"忘记密码"];
    _httpclient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCode:(UIButton *)sender
{
    NSDictionary *infos = @{@"phone":[_phoneNum text]};

    [_httpclient postPath:api_url_getcode parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSData *result = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
            //            NSLog(@"result:%@", jsonData);
            NSString *msg = [jsonData objectForKey:@"msg"];
            NSString *info = [jsonData objectForKey:@"info"];
            [Utils ToastNotification:info andView:self.view andLoading:NO andIsBottom:YES];

            if ([msg isEqualToString:@"true"]) {
                // 验证码获取成功
            } else {
                // 验证码获取失败
            }
        }
        @catch(NSException *exception) {
            [Utils TakeException:exception];
        }

        @finally {}
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils ToastNotification:@"网络连接故障" andView:self.view andLoading:NO andIsBottom:YES];
    }];
}

- (IBAction)checkCode:(UIButton *)sender
{
    NSDictionary *infos = @{@"phone":[_phoneNum text], @"code":[_quCode text]};

    [_httpclient postPath:api_url_checkcode parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSData *result = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
            //             NSLog(@"result:%@", jsonData);
            NSString *msg = [jsonData objectForKey:@"msg"];
            NSString *info = [jsonData objectForKey:@"info"];

            if ([msg isEqualToString:@"true"]) {
                // 验证码正确
                [self performSegueWithIdentifier:@"goSavePwd" sender:self];
            } else {
                // 验证码错误
                [Utils ToastNotification:info andView:self.view andLoading:NO andIsBottom:YES];
            }
        }
        @catch(NSException *exception) {
            [Utils TakeException:exception];
        }

        @finally {}
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils ToastNotification:@"网络连接故障" andView:self.view andLoading:NO andIsBottom:YES];
    }];
}

- (IBAction)savePwd:(UIButton *)sender
{
    NSString    *pwd1 = [_password1 text];
    NSString    *pwd2 = [_password2 text];

    if ([pwd1 length] < 6) {
        [Utils ToastNotification:@"请输入6个字符以上的密码" andView:self.view andLoading:NO andIsBottom:YES];
    } else if (![TSRegularExpressionUtils validatePassword:pwd1]) {
        [Utils ToastNotification:@"密码内请不要设置特殊字符" andView:self.view andLoading:NO andIsBottom:YES];
    } else if (![pwd1 isEqualToString:pwd2]) {
        [Utils ToastNotification:@"确认密码与密码字段不匹配" andView:self.view andLoading:NO andIsBottom:YES];
    } else {
        NSDictionary *infos = @{@"phone":data, @"pwd":[Utils convert2Md5:pwd1]};

        [_httpclient postPath:api_url_savepwd parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject) {
            @try {
                NSData *result = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
                // NSLog(@"result:%@", jsonData);
                NSString *msg = [jsonData objectForKey:@"msg"];
                NSString *info = [jsonData objectForKey:@"info"];

                if ([msg isEqualToString:@"true"]) {
                    // 密码修改成功

                    UIViewController *target = nil;

                    // 遍历，选择将要跳转的页面
                    for (UIViewController * controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[LoginController class]]) {
                            target = controller;
                        }
                    }

                    if (target) {
                        [self.navigationController popToViewController:target animated:YES]; // 跳转
                    }

                    [Utils ToastNotification:@"密码修改成功" andView:target.view andLoading:NO andIsBottom:YES];
                } else {
                    // 密码修改失败
                    [Utils ToastNotification:info andView:self.view andLoading:NO andIsBottom:YES];
                }
            }
            @catch(NSException *exception) {
                [Utils TakeException:exception];
            }

            @finally {}
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Utils ToastNotification:@"网络连接故障" andView:self.view andLoading:NO andIsBottom:YES];
        }];
    }
}

// Storyboard通过Segue传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString            *msg = [_phoneNum text];
    UIViewController    *send = segue.destinationViewController;

    // 将值透过Storyboard Segue传递
    [send setValue:msg forKey:@"data"];
}

@end