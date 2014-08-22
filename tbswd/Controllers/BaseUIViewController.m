//
//  BaseUIViewController.m
//  Connect/Users/adrian/Desktop/oc/tbswd/BaseUIViewController.m
//
//  Created by Adrian on 14-4-1.
//  Copyright (c) 2014年 wengchunjie. All rights reserved.
//

#import "BaseUIViewController.h"

@interface BaseUIViewController ()
{
    UINavigationBar *_navBar;
    UIButton        *_backButton;
}

@end

@implementation BaseUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINavigationBar *navBar = (UINavigationBar *)self.navigationController.navigationBar;
       //self.navigationController.navigationBar.translucent = NO;
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navbar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent=NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    // 除去NavigationBar底部阴影
    [navBar setShadowImage:[[UIImage alloc] init]];

    // 设置导航栏返回按钮
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 0, 22, 19);
    [_backButton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barLeftBtn = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = barLeftBtn;
    [self.navigationController.navigationItem setHidesBackButton:YES];
    // 设置导航栏标题属性
    NSDictionary *titleAttr = [NSDictionary dictionaryWithObjectsAndKeys:
        [UIColor colorWithRed:1.0 green:102.0 / 255 blue:0 alpha:1.0], NSForegroundColorAttributeName,
        [UIFont fontWithName:@"HiraginoSansGB-W3" size:18.0], NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏操作
// 隐藏导航栏
- (void)hideNavigationBar
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

// 显示导航栏
- (void)showNavigationBar
{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

// 隐藏导航栏返回按钮
- (void)hideBackButton
{
    [_backButton setHidden:YES];
}

// 显示导航栏返回按钮
- (void)showBackButton
{
    [_backButton setHidden:NO];
}

// 设置导航栏标题
- (void)setBarTitle:(NSString *)title
{
    [self.navigationItem setTitle:title];
}

// 设置导航栏浅色样式
- (void)setDefaultThemeBar
{
    [_navBar setBackgroundImage:[UIImage imageNamed:@"bg_navbar_white.png"] forBarMetrics:UIBarMetricsDefault];
    // 设置导航栏底部阴影
    [_navBar setShadowImage:[[UIImage alloc] initWithCGImage:[UIImage imageNamed:@"bg_navbar_orange.png"].CGImage]];
    
    // 设置导航栏标题属性
    NSDictionary *titleAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [Utils hexStringToColor:@"#ff6600"], NSForegroundColorAttributeName,
                               [UIFont fontWithName:@"HiraginoSansGB-W3" size:18.0], NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttr];
    
    // 设置状态栏样式为深色，用于浅色背景
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

}

// 设置导航栏橘色样式
- (void)setOrangeThemeBar
{
    [_navBar setBackgroundImage:[UIImage imageNamed:@"bg_navbar_orange.png"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置导航栏标题属性
    NSDictionary *titleAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [Utils hexStringToColor:@"#ffffff"], NSForegroundColorAttributeName,
                               [UIFont fontWithName:@"HiraginoSansGB-W3" size:18.0], NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttr];
    
    // 设置状态栏样式为浅色，用于深色背景
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

// 返回操作
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 关闭软键盘
- (void)closeKeyBoard
{
    [self.view endEditing:YES];
}

#pragma mark 触屏操作
// 手指滑动屏幕时触发
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self closeKeyBoard];
}

/*
 * #pragma mark - Navigation
 *
 *   // In a storyboard-based application, you will often want to do a little preparation before navigation
 *   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 *   // Get the new view controller using [segue destinationViewController].
 *   // Pass the selected object to the new view controller.
 *   }
 */

@end