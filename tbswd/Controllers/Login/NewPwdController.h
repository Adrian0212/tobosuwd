//
//  GetCodeController.h
//  tbswd
//
//  Created by admin on 14/8/19.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TSRegularExpressionUtils.h"
#import "LoginController.h"
#import "AFNetworking.h"

@interface NewPwdController : BaseUIViewController

@property (weak, nonatomic) IBOutlet UITextField    *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField    *quCode;
@property (weak, nonatomic) IBOutlet UITextField    *password1;
@property (weak, nonatomic) IBOutlet UITextField    *password2;
@property (strong, nonatomic) NSString              *data;   // 验证页面传递的手机号码

- (IBAction)getCode:(UIButton *)sender;
- (IBAction)checkCode:(UIButton *)sender;
- (IBAction)savePwd:(UIButton *)sender;

@end