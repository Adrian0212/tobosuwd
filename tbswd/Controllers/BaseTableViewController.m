//
//  BaseTableViewController.m
//  tbswd
//
//  Created by admin on 14/8/27.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _navBar = (UINavigationBar *)self.navigationController.navigationBar;
    _baseTabBarController = (BaseTabBarController *)self.tabBarController;

    // 设置导航栏浅色样式
    [self setDefaultThemeBar];

    // 在iOS7中，设置导航栏不透明并解决内容会下移的问题
    [_navBar setTranslucent:NO];
    [self setExtendedLayoutIncludesOpaqueBars:YES];

    // 设置导航栏返回按钮
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 0, 22, 19);
    [_backButton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barLeftBtn = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = barLeftBtn;
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
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

#pragma mark - 标签栏操作
// 隐藏TabBar
- (void)hideTabBar
{
    [_baseTabBarController.tabBar setHidden:YES];
    [_baseTabBarController hideCenterButton];
}

// 显示TabBar
- (void)showTabBar
{
    [_baseTabBarController.tabBar setHidden:NO];
    [_baseTabBarController showCenterButton];
}

// #pragma mark - Table view data source
//
// - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
// {
//    // Return the number of sections.
//    return 0;
// }
//
// - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
// {
//    // Return the number of rows in the section.
//    return 0;
// }

/*
 *   - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 *    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 *
 *    // Configure the cell...
 *
 *    return cell;
 *   }
 */

/*
 *   // Override to support conditional editing of the table view.
 *   - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 *    // Return NO if you do not want the specified item to be editable.
 *    return YES;
 *   }
 */

/*
 *   // Override to support editing the table view.
 *   - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 *    if (editingStyle == UITableViewCellEditingStyleDelete) {
 *        // Delete the row from the data source
 *        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 *    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 *        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 *    }
 *   }
 */

/*
 *   // Override to support rearranging the table view.
 *   - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 *   }
 */

/*
 *   // Override to support conditional rearranging of the table view.
 *   - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 *    // Return NO if you do not want the item to be re-orderable.
 *    return YES;
 *   }
 */

/*
 * #pragma mark - Navigation
 *
 *   // In a storyboard-based application, you will often want to do a little preparation before navigation
 *   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 *    // Get the new view controller using [segue destinationViewController].
 *    // Pass the selected object to the new view controller.
 *   }
 */

@end