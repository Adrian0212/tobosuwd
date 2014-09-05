//
//  SettingController.m
//  tbswd
//
//  Created by admin on 14/9/1.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "SettingController.h"

@interface SettingController ()

@end

@implementation SettingController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView      *footerView = [[UIView alloc]initWithFrame:CGRectMake(12, 0, 296, 42)];
    UIButton    *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutButton setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [logoutButton setFrame:CGRectMake(0, 0, 296, 42)];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"btn_logout.png"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(loginout:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutButton];
    [self.tableView setTableFooterView:footerView];
    [self.tableView setDelaysContentTouches:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar];
    [self setBarTitle:@"设置"];
    [self setDefaultThemeBar];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self showTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// 设置Section间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 18.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 选中操作
    NSLog(@"选中了第%d组，第%d行", indexPath.section, indexPath.row);
}

- (void)loginout:(UIButton *)sender
{
    // In iOS8, UIAlertController replaces UIAlertView.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出登陆"
            message:@"您确定要退出当前帐号吗？" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction   *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
        UIAlertAction   *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[Config Instance] removeUserPwd];
                [[Config Instance] removeUserInfo];
                [[Config Instance] saveIsLogin:NO];
                UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                self.view.window.rootViewController = [loginStoryboard instantiateInitialViewController];
            }];

        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
#else
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出登陆" message:@"您确定要退出当前帐号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
#endif
}

#pragma marks -- UIAlertViewDelegate --
// 根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[Config Instance] removeUserPwd];
        [[Config Instance] removeUserInfo];
        [[Config Instance] saveIsLogin:NO];
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.view.window.rootViewController = [loginStoryboard instantiateInitialViewController];
    }
}

@end