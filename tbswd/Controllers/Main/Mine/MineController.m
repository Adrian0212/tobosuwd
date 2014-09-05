//
//  MineController.m
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "MineController.h"

@interface MineController ()

@end

@implementation MineController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBarTitle:@"个人中心"];
    [self setOrangeThemeBar];
    [self hideBackButton];

    // 去除表格顶部间距
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];

    _userId = [[Config Instance] getUserId];
    _userType = [[Config Instance] getUserMark];

    [_userLevelLabel.layer setCornerRadius:2];

    NSDictionary *infos = [[Config Instance] getUserInfo];

    NSString    *score = [infos objectForKey:@"score"];
    NSString    *askcout = [infos objectForKey:@"AskCount"];
    //    NSLog(@"score:%@,askcount:%@",score,askcout);

    // 判断是否存在问答等信息
    if (score && askcout) {
        [self setData2View:infos];
    }

    if ([_userType isEqualToString:@"3"]) {
        // 设置装修公司数据
        [_userIconView0 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [infos objectForKey:@"icon"]]]];                 // 用户头像

        //有公司简称则显示公司简称，否则显示公司全称
        if ([infos objectForKey:@"realname"]) {
            _userNameLabel0.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"realname"]];
        } else {
            _userNameLabel0.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"name"]];
        }
    } else if ([_userType isEqualToString:@"1"]) {
        // 设置业主数据
        [_userIconView1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [infos objectForKey:@"icon"]]]];                 // 用户头像
        _userNameLable1.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"name"]];
    }

    [[Config Instance] saveUserInfo:infos];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setOrangeThemeBar];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// 设置Section间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([_userType isEqualToString:@"1"] && (section == 0)) {
        return 0.01f;
    } else if ([_userType isEqualToString:@"3"] && (section == 1)) {
        return 0.01f;
    }

    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 选中操作
    NSLog(@"选中了第%d组，第%d行", indexPath.section, indexPath.row);
}

// 根据用户类型不同 选择显示不同区域
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;

    switch (section) {
        case 0:

            if ([_userType isEqualToString:@"3"]) {
                rows = 1;
            }

            break;

        case 1:

            if ([_userType isEqualToString:@"1"]) {
                rows = 1;
            }

            break;

        case 2:
            rows = 4;
            break;

        default:
            break;
    }

    return rows;
}

// 请求数据
- (void)loadData
{
    NSDictionary *params1 = @{@"MType":@"20", @"Uid":[_userType stringByAppendingString:_userId]};

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];

    [httpClient postPath:api_url_net parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            NSLog(@"result:%@", result);

            if ([result[@"msg"] isEqualToString:@"true"]) {
                NSDictionary *infos = result[@"info"];

                if ([_userType isEqualToString:@"3"]) {
                    _answerNumLabel0.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"AnswerCount"]];
                    _questionNumLabel0.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"AskCount"]];
                    _adoptRateLabel0.text = [NSString stringWithFormat:@"%@%%", [infos objectForKey:@"AcceptRate"]];
                } else if ([_userType isEqualToString:@"1"]) {
                    _answerNumLabel1.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"AnswerCount"]];
                    _questionNumLabel1.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"AskCount"]];
                    _adoptRateLabel1.text = [NSString stringWithFormat:@"%@%%", [infos objectForKey:@"AcceptRate"]];
                }

                [[Config Instance] saveUserInfo:infos];
            } else {
                [Utils ToastNotification:@"信息异常" andView:self.tableView andLoading:NO andIsBottom:NO];
            }
        }
        @catch(NSException *exception) {
            [Utils TakeException:exception];
        }

        @finally {}
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils ToastNotification:@"网络连接故障" andView:self.tableView andLoading:NO andIsBottom:NO];
    }];

    NSDictionary *params2 = @{@"userid":_userId, @"usertype":_userType};

    [httpClient postPath:api_url_getuserinfo parameters:params2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *infos = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            NSLog(@"result:%@", infos);

            if (infos) {
                if ([_userType isEqualToString:@"3"]) {
                    // 设置装修公司数据
                    _userScoreLabel0.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"score"]];
                    _userRankLabel.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"rank"]];

                    if ([[NSString stringWithFormat:@"%@", [infos objectForKey:@"proof"]] isEqualToString:@"2"]) {
                        // 表示未认证
                        [_userIcon1 setImage:[UIImage imageNamed:@"icon_mine_01_gray.png"]];
                        [_userIcon1Label setText:@"未认证"];
                        [_userIcon1Label setTextColor:[Utils hexStringToColor:@"#aaaaaa"]];
                    } else {
                        [_userIcon1 setImage:[UIImage imageNamed:@"icon_mine_01.png"]];
                        [_userIcon1Label setText:@"已认证"];
                        [_userIcon1Label setTextColor:[Utils hexStringToColor:@"#978fff"]];
                    }

                    if ([[NSString stringWithFormat:@"%@", [infos objectForKey:@"honesty"]] isEqualToString:@"0"]) {
                        // 诚信年份0年
                        [_userIcon2 setImage:[UIImage imageNamed:@"icon_mine_02_gray.png"]];
                        [_userIcon2Label setText:@"0年"];
                        [_userIcon2Label setTextColor:[Utils hexStringToColor:@"#aaaaaa"]];
                    } else {
                        [_userIcon2 setImage:[UIImage imageNamed:@"icon_mine_02.png"]];
                        [_userIcon2Label setText:[NSString stringWithFormat:@"%@年", [infos objectForKey:@"honesty"]]];
                        [_userIcon2Label setTextColor:[Utils hexStringToColor:@"#da3f3f"]];
                    }

                    if ([[NSString stringWithFormat:@"%@", [infos objectForKey:@"isjjb"]] isEqualToString:@"2"]) {
                        // 表示不是家居宝
                        [_userIcon3 setImage:[UIImage imageNamed:@"icon_mine_03_gray.png"]];
                        [_userIcon3Label setTextColor:[Utils hexStringToColor:@"#aaaaaa"]];
                    } else {
                        [_userIcon3 setImage:[UIImage imageNamed:@"icon_mine_03.png"]];
                        [_userIcon3Label setTextColor:[Utils hexStringToColor:@"#3d64a9"]];
                    }

                    if ([[NSString stringWithFormat:@"%@", [infos objectForKey:@"issignedto"]] isEqualToString:@"2"]) {
                        // 表示已签到
                        [_signInButton0 setTitle:@"已签到" forState:UIControlStateNormal];
                        [_signInButton0 setTitleColor:[Utils hexStringToColor:@"#666666"] forState:UIControlStateNormal];
                        [_signInButton0 setBackgroundImage:[UIImage imageNamed:@"btn_mine_checked.png"] forState:UIControlStateNormal];
                        [_signInButton0 setEnabled:NO];
                    } else {
                        [_signInButton0 setTitle:@"签到" forState:UIControlStateNormal];
                        [_signInButton0 setTitleColor:[Utils hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
                        [_signInButton0 setBackgroundImage:[UIImage imageNamed:@"btn_mine_uncheck.png"] forState:UIControlStateNormal];
                        [_signInButton0 setEnabled:YES];
                    }
                } else if ([_userType isEqualToString:@"1"]) {
                    _userLevelLabel.text = [NSString stringWithFormat:@"Lv%@", [infos objectForKey:@"level"]];
                    _userScoreLabel1.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"score"]];

                    if ([[NSString stringWithFormat:@"%@", [infos objectForKey:@"issignedto"]] isEqualToString:@"2"]) {
                        // 表示已签到
                        [_signInButton1 setTitle:@"已签到" forState:UIControlStateNormal];
                        [_signInButton1 setTitleColor:[Utils hexStringToColor:@"#666666"] forState:UIControlStateNormal];
                        [_signInButton1 setBackgroundImage:[UIImage imageNamed:@"btn_mine_checked.png"] forState:UIControlStateNormal];
                        [_signInButton1 setEnabled:NO];
                    } else {
                        [_signInButton1 setTitle:@"每日签到" forState:UIControlStateNormal];
                        [_signInButton1 setTitleColor:[Utils hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
                        [_signInButton1 setBackgroundImage:[UIImage imageNamed:@"btn_mine_uncheck.png"] forState:UIControlStateNormal];
                        [_signInButton1 setEnabled:YES];
                    }

                    // 重新设置名字标签和等级标签的Frame
                    [_userNameLable1 sizeToFit];
                    CGRect rect = [_userNameLable1 frame];
                    [_userNameLable1 setFrame:CGRectMake(100, 17, rect.size.width, 21)];
                    [_userLevelLabel setFrame:CGRectMake(rect.size.width + 105, 21, 30, 14)];
                }

                [[Config Instance] saveUserInfo:infos];
            } else {
                [Utils ToastNotification:@"信息异常" andView:self.view andLoading:NO andIsBottom:NO];
            }
        }
        @catch(NSException *exception) {
            [Utils TakeException:exception];
        }

        @finally {}
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils ToastNotification:@"网络连接故障" andView:self.tableView andLoading:NO andIsBottom:NO];
    }];
}

- (void)setData2View:(NSDictionary *)infos
{
    if ([_userType isEqualToString:@"3"]) {
        // 设置装修公司数据
        [_userIconView0 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [infos objectForKey:@"icon"]]]];                 // 用户头像

        //有公司简称则显示公司简称，否则显示公司全称
        if ([infos objectForKey:@"realname"]) {
            _userNameLabel0.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"realname"]];
        } else {
            _userNameLabel0.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"name"]];
        }

        _userScoreLabel0.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"score"]];
        _userRankLabel.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"rank"]];

        if ([[NSString stringWithFormat:@"%@", [infos objectForKey:@"proof"]] isEqualToString:@"2"]) {
            // 表示未认证
            [_userIcon1 setImage:[UIImage imageNamed:@"icon_mine_01_gray.png"]];
            [_userIcon1Label setText:@"未认证"];
            [_userIcon1Label setTextColor:[Utils hexStringToColor:@"#aaaaaa"]];
        } else {
            [_userIcon1 setImage:[UIImage imageNamed:@"icon_mine_01.png"]];
            [_userIcon1Label setText:@"已认证"];
            [_userIcon1Label setTextColor:[Utils hexStringToColor:@"#978fff"]];
        }

        if ([[NSString stringWithFormat:@"%@", [infos objectForKey:@"honesty"]] isEqualToString:@"0"]) {
            // 诚信年份0年
            [_userIcon2 setImage:[UIImage imageNamed:@"icon_mine_02_gray.png"]];
            [_userIcon2Label setText:@"0年"];
            [_userIcon2Label setTextColor:[Utils hexStringToColor:@"#aaaaaa"]];
        } else {
            [_userIcon2 setImage:[UIImage imageNamed:@"icon_mine_02.png"]];
            [_userIcon2Label setText:[NSString stringWithFormat:@"%@年", [infos objectForKey:@"honesty"]]];
            [_userIcon2Label setTextColor:[Utils hexStringToColor:@"#da3f3f"]];
        }

        if ([[NSString stringWithFormat:@"%@", [infos objectForKey:@"isjjb"]] isEqualToString:@"2"]) {
            // 表示不是家居宝
            [_userIcon3 setImage:[UIImage imageNamed:@"icon_mine_03_gray.png"]];
            [_userIcon3Label setTextColor:[Utils hexStringToColor:@"#aaaaaa"]];
        } else {
            [_userIcon3 setImage:[UIImage imageNamed:@"icon_mine_03.png"]];
            [_userIcon3Label setTextColor:[Utils hexStringToColor:@"#3d64a9"]];
        }

        if ([[NSString stringWithFormat:@"%@", [infos objectForKey:@"issignedto"]] isEqualToString:@"2"]) {
            // 表示已签到
            [_signInButton0 setTitle:@"已签到" forState:UIControlStateNormal];
            [_signInButton0 setTitleColor:[Utils hexStringToColor:@"#666666"] forState:UIControlStateNormal];
            [_signInButton0 setBackgroundImage:[UIImage imageNamed:@"btn_mine_checked.png"] forState:UIControlStateNormal];
            [_signInButton0 setEnabled:NO];
        } else {
            [_signInButton0 setTitle:@"签到" forState:UIControlStateNormal];
            [_signInButton0 setTitleColor:[Utils hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
            [_signInButton0 setBackgroundImage:[UIImage imageNamed:@"btn_mine_uncheck.png"] forState:UIControlStateNormal];
            [_signInButton0 setEnabled:YES];
        }

        _answerNumLabel0.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"AnswerCount"]];
        _questionNumLabel0.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"AskCount"]];
        _adoptRateLabel0.text = [NSString stringWithFormat:@"%@%%", [infos objectForKey:@"AcceptRate"]];
    } else if ([_userType isEqualToString:@"1"]) {
        // 设置业主数据
        [_userIconView1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [infos objectForKey:@"icon"]]]];                 // 用户头像
        _userNameLable1.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"name"]];
        _userLevelLabel.text = [NSString stringWithFormat:@"Lv%@", [infos objectForKey:@"level"]];
        _userScoreLabel1.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"score"]];
        _answerNumLabel1.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"AnswerCount"]];
        _questionNumLabel1.text = [NSString stringWithFormat:@"%@", [infos objectForKey:@"AskCount"]];
        _adoptRateLabel1.text = [NSString stringWithFormat:@"%@%%", [infos objectForKey:@"AcceptRate"]];

        if ([[NSString stringWithFormat:@"%@", [infos objectForKey:@"issignedto"]] isEqualToString:@"2"]) {
            // 表示已签到
            [_signInButton1 setTitle:@"已签到" forState:UIControlStateNormal];
            [_signInButton1 setTitleColor:[Utils hexStringToColor:@"#666666"] forState:UIControlStateNormal];
            [_signInButton1 setBackgroundImage:[UIImage imageNamed:@"btn_mine_checked.png"] forState:UIControlStateNormal];
            [_signInButton1 setEnabled:NO];
        } else {
            [_signInButton1 setTitle:@"每日签到" forState:UIControlStateNormal];
            [_signInButton1 setTitleColor:[Utils hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
            [_signInButton1 setBackgroundImage:[UIImage imageNamed:@"btn_mine_uncheck.png"] forState:UIControlStateNormal];
            [_signInButton1 setEnabled:YES];
        }

        // 重新设置名字标签和等级标签的Frame
        [_userNameLable1 sizeToFit];
        CGRect rect = [_userNameLable1 frame];
        [_userNameLable1 setFrame:CGRectMake(100, 17, rect.size.width, 21)];
        [_userLevelLabel setFrame:CGRectMake(rect.size.width + 105, 21, 30, 14)];
    }
}

// 签到操作
- (IBAction)signInAction:(UIButton *)sender
{
    NSDictionary *params = @{@"userid":_userId, @"usertype":_userType};

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];

    [httpClient postPath:api_url_signedto parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSString *result = [operation.responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            Boolean flag = NO; // 是否签到

            if ([result isEqualToString:@"1"]) {
                int score = [[[Config Instance] getUserScore]intValue];
                score += 2;

                if ([_userType isEqualToString:@"3"]) {
                    [_userScoreLabel0 setText:[NSString stringWithFormat:@"%d", score]];
                } else if ([_userType isEqualToString:@"1"]) {
                    [_userScoreLabel1 setText:[NSString stringWithFormat:@"%d", score]];
                }

                [[Config Instance] setUserScore:score];
                flag = YES;
            } else if ([result isEqualToString:@"3"]) {
                [Utils ToastNotification:@"您已经签到过啦" andView:self.tableView andLoading:NO andIsBottom:NO];
                flag = YES;
            }

            if (flag) {
                [sender setTitle:@"已签到" forState:UIControlStateNormal];
                [sender setTitleColor:[Utils hexStringToColor:@"#666666"] forState:UIControlStateNormal];
                [sender setBackgroundImage:[UIImage imageNamed:@"btn_mine_checked.png"] forState:UIControlStateNormal];
                [sender setEnabled:NO];
                NSLog(@"签到了！");
            }
        }
        @catch(NSException *exception) {
            [Utils TakeException:exception];
        }

        @finally {}
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils ToastNotification:@"网络连接故障" andView:self.tableView andLoading:NO andIsBottom:NO];
    }];
}

@end