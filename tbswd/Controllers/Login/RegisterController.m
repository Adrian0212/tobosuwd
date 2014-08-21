//
//  RegisterController.m
//  tbswd
//
//  Created by Adrian on 14-8-11.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "RegisterController.h"
#import "BaseUIViewController.h"
#import "Utils.h"

@interface RegisterController () {
    NSArray     *_tabArray;
}

@end

@implementation RegisterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBarTitle:@"注册界面"];

    _tabArray = [NSArray arrayWithObjects:_yezhuBtn, _shejishiBtn, _gongsiBtn, nil];
    [self setTabBorder:_tabArray[0]];
    // 设置scrollview的相关属性
    [self initScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 初始化ScrollView
- (void)initScrollView
{
    // 设置 tableScrollView
    // a page is the width of the scroll view
    _nibScrollView.pagingEnabled = YES;
    _nibScrollView.clipsToBounds = NO;
    _nibScrollView.contentSize = CGSizeMake(_nibScrollView.frame.size.width * 3, _nibScrollView.frame.size.height);
    _nibScrollView.showsHorizontalScrollIndicator = NO;
    _nibScrollView.showsVerticalScrollIndicator = NO;
    _nibScrollView.scrollsToTop = NO;
    _nibScrollView.delegate = self;
    _nibScrollView.bounces = NO;
    [_nibScrollView setContentOffset:CGPointMake(0, 0)];
    [self createAllEmptyPagesForScrollView];
}

#pragma mark 创建ScrollView中的内容视图
- (void)createAllEmptyPagesForScrollView
{
    UIFont      *defaultFont = [UIFont fontWithName:@"HiraginoSansGB-W3" size:16.0];
    UIFont      *quCodeBtnFont = [UIFont fontWithName:@"HiraginoSansGB-W3" size:12.0];
    NSString    *defaultTextColor = [NSString stringWithFormat:@"#666666"];

    // 业主注册界面
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(320 * 0, 0, 320, _nibScrollView.frame.size.height)];

    UIImage     *image1 = [UIImage imageNamed:@"bg_edit_register.png"];
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:image1];

    [imageView1 setFrame:CGRectMake(10, 0, 303, 163)];
    [view1 addSubview:imageView1];

    UITextField *accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(57, 0, 246, 41)];
    [accountTextField setBorderStyle:UITextBorderStyleNone];
    [accountTextField setFont:defaultFont];
    [accountTextField setTextColor:[Utils hexStringToColor:defaultTextColor]];
    [accountTextField setPlaceholder:@"手机号码"];
    [accountTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [accountTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [accountTextField setReturnKeyType:UIReturnKeyDone];

    UITextField *quCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(57, 41, 140, 41)];
    [quCodeTextField setBorderStyle:UITextBorderStyleNone];
    [quCodeTextField setFont:defaultFont];
    [quCodeTextField setTextColor:[Utils hexStringToColor:defaultTextColor]];
    [quCodeTextField setPlaceholder:@"手机验证码"];
    [quCodeTextField setClearButtonMode:UITextFieldViewModeWhileEditing];

    UITextField *pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(57, 82, 246, 41)];
    pwdTextField.borderStyle = UITextBorderStyleNone;
    [pwdTextField setBorderStyle:UITextBorderStyleNone];
    [pwdTextField setFont:defaultFont];
    [pwdTextField setTextColor:[Utils hexStringToColor:defaultTextColor]];
    [pwdTextField setPlaceholder:@"密码6位以上"];
    [pwdTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [pwdTextField setSecureTextEntry:YES];

    UITextField *nickNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(57, 123, 246, 41)];
    [nickNameTextField setBorderStyle:UITextBorderStyleNone];
    [nickNameTextField setFont:defaultFont];
    [nickNameTextField setTextColor:[Utils hexStringToColor:defaultTextColor]];
    [nickNameTextField setPlaceholder:@"用户名"];
    [nickNameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [nickNameTextField setReturnKeyType:UIReturnKeyDone];
    [nickNameTextField setDelegate:self];

    // 获取验证码按钮
    UIButton *getQuCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getQuCodeBtn setFrame:CGRectMake(225, 48, 75, 25)];
    [getQuCodeBtn.titleLabel setFont:quCodeBtnFont];
    [getQuCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getQuCodeBtn setBackgroundImage:[UIImage imageNamed:@"btn_getcode.png"] forState:UIControlStateNormal];
    [getQuCodeBtn.layer setCornerRadius:4.0]; // 设置矩形四个圆角半径

    // 注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setFrame:CGRectMake(10, 184, 302, 42)];
    [registerBtn.titleLabel setFont:defaultFont];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_login.png"] forState:UIControlStateNormal];
    [registerBtn.layer setCornerRadius:2.0]; // 设置矩形四个圆角半径
    [registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];

    [view1 addSubview:accountTextField];
    [view1 addSubview:quCodeTextField];
    [view1 addSubview:pwdTextField];
    [view1 addSubview:nickNameTextField];
    [view1 addSubview:getQuCodeBtn];
    [view1 addSubview:registerBtn];

    // 设计师注册页面
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(320 * 1, 0, 320, _nibScrollView.frame.size.height)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    // 分割线
    UILabel *separateLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [separateLine1 setBackgroundColor:[Utils hexStringToColor:@"#cccccc"]];

    UIImage     *registerLogo = [UIImage imageNamed:@"register_logo.png"];
    UIImageView *imageview2 = [[UIImageView alloc] initWithImage:registerLogo];
    [imageview2 setFrame:CGRectMake(70, 60, 182, 73)];

    [view2 addSubview:separateLine1];
    [view2 addSubview:imageview2];

    // 公司注册页面
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(320 * 2, 0, 320, _nibScrollView.frame.size.height)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    // 分割线
    UILabel *separateLine2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [separateLine2 setBackgroundColor:[Utils hexStringToColor:@"#cccccc"]];

    UIImageView *imageview3 = [[UIImageView alloc] initWithImage:registerLogo];
    [imageview3 setFrame:CGRectMake(70, 60, 182, 73)];

    [view3 addSubview:separateLine2];
    [view3 addSubview:imageview3];

    [_nibScrollView addSubview:view1];
    [_nibScrollView addSubview:view2];
    [_nibScrollView addSubview:view3];

    [_nibScrollView setDelaysContentTouches:NO]; // 在scrollview中的touch事件会影响button的效果
    [_nibScrollView setBackgroundColor:[UIColor clearColor]];
    
}

#pragma mark 设置头上的按钮的边框和字体颜色
- (void)setTabBorder:(UIButton *)btName
{
    for (UIButton *button in _tabArray) {
        [button.layer setBorderWidth:0.0];
        [button setTitleColor:[Utils hexStringToColor:@"#666666"] forState:UIControlStateNormal];
    }

    [btName.layer setCornerRadius:4.0];                                         // 设置矩形四个圆角半径
    [btName.layer setBorderWidth:1.0];                                          // 边框宽度
    [btName.layer setBorderColor:[Utils hexStringToColor:@"#ff6600"].CGColor];  // 边框颜色
    [btName setTitleColor:[Utils hexStringToColor:@"#ff6600"] forState:UIControlStateNormal];
}

#pragma mark ScrollView委托函数
// scrollview滑动结束时执行的函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.nibScrollView.frame.size.width;
    int     page = floor((self.nibScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self setTabBorder:_tabArray[page]];
    [self closeKeyBoard];
}

// scrollview当滑动进行时执行的函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{}

#pragma mark TextField委托函数
// 按下键盘return键时执行
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self closeKeyBoard];
    return YES;
}

//三个按钮之间的切换
- (IBAction)tabButtonAction:(UIButton *)sender
{
    [_nibScrollView setContentOffset:CGPointMake(320 * sender.tag, 0) animated:YES];
    [self setTabBorder:_tabArray[sender.tag]];
    [self closeKeyBoard];
}



- (void)registerAction:(UIButton *)sender
{
    NSLog(@"注册");
}

@end