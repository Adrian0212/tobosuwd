//
//  MineController.h
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AFNetworking.h"
#import "Config.h"

@interface MineController : BaseTableViewController

@property (retain, nonatomic) NSString  *userId;        // 用户id
@property (retain, nonatomic) NSString  *userType;      // 用户type

@property (retain, nonatomic) UIButton *settingButton;  // 设置按钮

@property (retain, nonatomic) NSCondition *itlock;      // 用于同步加锁操作

// 装修公司
@property (weak, nonatomic) IBOutlet UIImageView    *userIconView0;     // 用户头像
@property (weak, nonatomic) IBOutlet UILabel        *userNameLabel0;    // 用户昵称
@property (weak, nonatomic) IBOutlet UILabel        *userScoreLabel0;   // 用户积分
@property (weak, nonatomic) IBOutlet UILabel        *userRankLabel;     // 用户排名
@property (weak, nonatomic) IBOutlet UIImageView    *userIcon1;         // 认证图标
@property (weak, nonatomic) IBOutlet UILabel        *userIcon1Label;    // 认证说明
@property (weak, nonatomic) IBOutlet UIImageView    *userIcon2;         // 诚信图标
@property (weak, nonatomic) IBOutlet UILabel        *userIcon2Label;    // 诚信说明
@property (weak, nonatomic) IBOutlet UIImageView    *userIcon3;         // 家居宝图标
@property (weak, nonatomic) IBOutlet UILabel        *userIcon3Label;    // 家居宝说明
@property (weak, nonatomic) IBOutlet UILabel        *answerNumLabel0;   // 回答数量
@property (weak, nonatomic) IBOutlet UILabel        *questionNumLabel0; // 提问数量
@property (weak, nonatomic) IBOutlet UILabel        *adoptRateLabel0;   // 采纳率
@property (weak, nonatomic) IBOutlet UIButton       *signInButton0;     // 签到按钮

// 业主
@property (weak, nonatomic) IBOutlet UIImageView    *userIconView1;     // 用户头像
@property (weak, nonatomic) IBOutlet UILabel        *userNameLable1;    // 用户昵称
@property (weak, nonatomic) IBOutlet UILabel        *userLevelLabel;    // 用户等级
@property (weak, nonatomic) IBOutlet UILabel        *userScoreLabel1;   // 用户积分
@property (weak, nonatomic) IBOutlet UILabel        *answerNumLabel1;   // 回答数量
@property (weak, nonatomic) IBOutlet UILabel        *questionNumLabel1; // 提问数量
@property (weak, nonatomic) IBOutlet UILabel        *adoptRateLabel1;   // 采纳率
@property (weak, nonatomic) IBOutlet UIButton       *signInButton1;     // 签到按钮

// 签到操作
- (IBAction)signInAction:(UIButton *)sender;

@end