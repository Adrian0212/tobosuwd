//
//  RegisterController.m
//  tbswd
//
//  Created by Adrian on 14-8-11.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "RegisterController.h"

@interface RegisterController () {
    FMDatabase *_db;
    NSArray             *_tabArray;             //三个切换按钮
    UITextField         *_accountTextField;     // 手机号码输入框
    UITextField         *_quCodeTextField;      // 手机验证码输入框
    UITextField         *_pwdTextField;         // 密码输入框
    UITextField         *_nickNameTextField;    // 昵称输入框
    UITextField         *_cityTextField;        // 城市选择框
    UIView              *_view1;
    UIPickerView        *_picker;
    NSMutableArray      *_province; // 1. 省份
    NSMutableDictionary *_city;     // 2. 城市
    NSMutableDictionary *_cityIdDictionary;
    NSString            *_cityId;   // 保存用户当前选中的
}

@end

@implementation RegisterController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _db = [DBHelper initFMDataBase];
    [self loadPickData];
    _tabArray = [NSArray arrayWithObjects:_yezhuBtn, _shejishiBtn, _gongsiBtn, nil];
    [self setTabBorder:_tabArray[0]];
    // 设置scrollview的相关属性
    [self initScrollView];
    //[self insertCity2Db];
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
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(320 * 0, 0, 320, _nibScrollView.frame.size.height)];
    
    UIImage     *image1 = [UIImage imageNamed:@"bg_edit_register.png"];
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:image1];
    
    [imageView1 setFrame:CGRectMake(10, 0, 303, 204)];
    [_view1 addSubview:imageView1];
    
    _accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(57, 0, 246, 41)];
    [_accountTextField setBorderStyle:UITextBorderStyleNone];
    [_accountTextField setFont:defaultFont];
    [_accountTextField setTextColor:[Utils hexStringToColor:defaultTextColor]];
    [_accountTextField setPlaceholder:@"手机号码"];
    [_accountTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_accountTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_accountTextField setReturnKeyType:UIReturnKeyDone];
    
    _quCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(57, 41, 140, 41)];
    [_quCodeTextField setBorderStyle:UITextBorderStyleNone];
    [_quCodeTextField setFont:defaultFont];
    [_quCodeTextField setTextColor:[Utils hexStringToColor:defaultTextColor]];
    [_quCodeTextField setPlaceholder:@"手机验证码"];
    [_quCodeTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(57, 82, 246, 41)];
    [_pwdTextField setBorderStyle:UITextBorderStyleNone];
    [_pwdTextField setFont:defaultFont];
    [_pwdTextField setTextColor:[Utils hexStringToColor:defaultTextColor]];
    [_pwdTextField setPlaceholder:@"密码6位以上"];
    [_pwdTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_pwdTextField setSecureTextEntry:YES];
    
    _nickNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(57, 123, 246, 41)];
    [_nickNameTextField setBorderStyle:UITextBorderStyleNone];
    [_nickNameTextField setFont:defaultFont];
    [_nickNameTextField setTextColor:[Utils hexStringToColor:defaultTextColor]];
    [_nickNameTextField setPlaceholder:@"用户名"];
    [_nickNameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_nickNameTextField setReturnKeyType:UIReturnKeyDone];
    [_nickNameTextField setDelegate:self];
    
    // 城市选择
    _cityTextField = [[UITextField alloc]initWithFrame:CGRectMake(57, 164, 246, 41)];
    [_cityTextField setBorderStyle:UITextBorderStyleNone];
    [_cityTextField setFont:defaultFont];
    [_cityTextField setTextColor:[Utils hexStringToColor:defaultTextColor]];
    [_cityTextField setPlaceholder:@"城市"];
    [_cityTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_cityTextField setTag:4];
    _cityTextField.inputView = _picker;
    // 4.4 增加生日键盘的工具视图
    UIView *accessView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [accessView setBackgroundColor:[UIColor grayColor]];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneBtn setFrame:CGRectMake(10, 2, 80, 40)];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [accessView addSubview:doneBtn];
    [doneBtn addTarget:self action:@selector(doneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_cityTextField setInputAccessoryView:accessView];
    // 获取验证码按钮
    UIButton *getQuCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getQuCodeBtn setFrame:CGRectMake(225, 48, 75, 25)];
    [getQuCodeBtn.titleLabel setFont:quCodeBtnFont];
    [getQuCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getQuCodeBtn setBackgroundImage:[UIImage imageNamed:@"btn_getcode.png"] forState:UIControlStateNormal];
    [getQuCodeBtn.layer setCornerRadius:4.0]; // 设置矩形四个圆角半径
    [getQuCodeBtn addTarget:self action:@selector(getQuCode) forControlEvents:UIControlEventTouchUpInside];
    
    // 注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setFrame:CGRectMake(10, 225, 302, 42)];
    [registerBtn.titleLabel setFont:defaultFont];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_login.png"] forState:UIControlStateNormal];
    [registerBtn.layer setCornerRadius:2.0]; // 设置矩形四个圆角半径
    [registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_view1 addSubview:_accountTextField];
    [_view1 addSubview:_quCodeTextField];
    [_view1 addSubview:_pwdTextField];
    [_view1 addSubview:_nickNameTextField];
    [_view1 addSubview:_cityTextField];
    [_view1 addSubview:getQuCodeBtn];
    [_view1 addSubview:registerBtn];
    
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
    
    [_nibScrollView addSubview:_view1];
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

- (IBAction)dismisTitleBar:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 注册按钮提交
- (void)registerAction:(UIButton *)sender
{
    NSString    *mobileNumber = _accountTextField.text;
    NSString    *quCode = _quCodeTextField.text;
    NSString    *pwd = _pwdTextField.text;
    NSString    *userName = _nickNameTextField.text;
    NSString    *cityId = _cityId;
    
    if ([TSRegularExpressionUtils validateMobile:mobileNumber]) {
        if ([TSRegularExpressionUtils validatePassword:pwd]) {
            if ([TSRegularExpressionUtils validateUserName:userName]) {
                NSString        *priUrl = api_url_register;
                AFHTTPClient    *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:priUrl]];        // 这里要将url设置为空
                NSDictionary    *par = @{@"name":userName, @"password":[Utils convert2Md5:pwd], @"cityID":cityId,
                                         @"cellphone":mobileNumber, @"gender":@"0", @"ip":@"0.0.0.0", @"logintype":@"ios", @"phoneyzm":quCode};
                
                [httpClient postPath:priUrl parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     @try
                     {
                         NSString *resultString = operation.responseString;
                         NSDictionary *jsonData = [resultString objectFromJSONString];
                         
                         if ([jsonData objectForKey:@"msg"]) {
                             [self dismissViewControllerAnimated:YES completion:nil];
                         }
                     }
                     @catch(NSException *exception)
                     {
                         [Utils TakeException:exception];
                     }
                     
                     @finally
                     {}
                 }           failure :^(AFHTTPRequestOperation *operation, NSError *error)
                 {
                     [Utils ToastNotification:@"网络连接故障" andView:self.view andLoading:NO andIsBottom:YES];
                 }];
            } else {
                [self alertView:@"请正确填写用户名"];
            }
        } else {
            [self alertView:@"密码不能包含特殊字符"];
        }
    } else {
        [self alertView:@"请正确填写手机号"];
    }
}

/**
 *  获取手机验证码
 */
- (void)getQuCode
{
    NSString *quCode = _accountTextField.text;
    
    if ([TSRegularExpressionUtils validateMobile:_accountTextField.text]) {
        NSString        *priUrl = api_url_registqucode;
        AFHTTPClient    *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:priUrl]];    // 这里要将url设置为空
        NSDictionary    *par = @{@"phone": quCode, @"msgtype":@"1"};
        [httpClient postPath:priUrl parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
            @try
            {
                NSString *resultString = operation.responseString;
                
                // NSLog(@"%@", resultString);
            }
            @catch(NSException *exception)
            {
                [Utils TakeException:exception];
            }
            
            @finally {}
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // NSLog(@"ERROR====%@", operation);
        }];
    } else {
        [self alertView:@"请正确填写手机号"];
    }
}

// 设置城市选择器
- (void)loadPickData
{
    // 1. 初始化PickerView
    _picker = [[UIPickerView alloc]init];
    // 1.1 设置数据源
    [_picker setDataSource:self];
    // 1.2 设置代理
    [_picker setDelegate:self];
    // 1.4 设置选择指示器
    [_picker setShowsSelectionIndicator:YES];
    
    _city = [NSMutableDictionary dictionary];
    _cityIdDictionary = [NSMutableDictionary dictionary];
    NSString            *plistPath = [[NSBundle mainBundle] pathForResource:@"provinceCity" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
     NSLog(@"%@", data);//直接打印数据。
    _province = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 1; i <= [data count]; i++) {
        NSDictionary    *proDict = [data objectForKey:[NSString stringWithFormat:@"%d", i]];
        NSString        *provinceName = [proDict objectForKey:@"ProvinceName"];
        [_province addObject:provinceName];
        NSArray         *cityArray = [proDict objectForKey:@"city"];
        NSMutableArray  *cityNameMutableArray = [NSMutableArray array];
        
        for (NSInteger i = 0; i < [cityArray count]; i++) {
            NSString    *cityName = cityArray[i][@"name"];
            NSString    *cityId = cityArray[i][@"cityID"];
            [cityNameMutableArray addObject:cityName];
            [_cityIdDictionary setValue:cityId forKey:cityName];
        }
        
        [_city setValue:cityNameMutableArray forKeyPath:provinceName];
    }
    
    // NSLog(@"%@",_city);
}

#pragma mark - 数据源方法
#pragma mark 设置列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

#pragma mark 设置行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _province.count;
    } else {
        return 0;
        NSInteger   rowProvince = [pickerView selectedRowInComponent:0];
        NSString    *provinceName = _province[rowProvince];
        NSArray     *citys = [_city objectForKey:provinceName];
        // NSLog(@"fffffffff%d",citys.count);
        return citys.count;
    }
}

#pragma mark - 代理方法
#pragma mark 设置选择器行的内容的
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    @try {
        if (component == 0) {
            return _province[row];
        } else {
            // 城市
            // 1. 获得省份列选择的行数
            NSInteger rowProvince = [pickerView selectedRowInComponent:0];
            // 2. 获得省份名称
            NSString *provinceName = _province[rowProvince];
            // NSLog(@"aaaaaaaaaa===%@",provinceName);
            // NSLog(@"rrrrrrrrrrrr===%d",row);            // 3. 获得城市的数组
            NSArray *citys = [_city objectForKey:provinceName];
            // NSLog(@"bbbbbbbb=%d", citys.count);
            
            // 4. 返回城市数组中row的字符串内容
            return citys[row];
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"exception=%@", exception);
    }
    
    @finally
    {}
}

#pragma mark 选中行的时候，刷新数据
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        [pickerView reloadComponent:1];
    }
    
    // NSInteger   row1 = [pickerView selectedRowInComponent:0];
    // NSInteger   row2 = [pickerView selectedRowInComponent:1];
    // NSString *provinceName = _province[row1];
    // 3. 获得城市的数组
    // NSArray *citys = _city[provinceName];
}

- (void)doneBtnAction
{
    [_cityTextField endEditing:YES];
    [self textFieldDidEndEditing:_cityTextField];
}

// 城市选择框中显示选择的城市
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _cityTextField) {
        NSInteger row1 = [_picker selectedRowInComponent:0];
        
        NSInteger row2 = [_picker selectedRowInComponent:1];
        
        NSString *provinceName = _province[row1];
        // 3. 获得城市的数组
        NSArray *citys = _city[provinceName];
        
        NSString *textString = [[NSString alloc] initWithFormat:@"%@  %@", provinceName, citys[row2]];
        textField.text = textString;
        
        // NSLog(@"%@",[_cityId objectForKey:citys[row2]]);
        _cityId = [_cityIdDictionary objectForKey:citys[row2]];
    }
}

- (void)alertView:(NSString *)content
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alertView show];
}

// -(void)insertProvince2Db
// {
//
//    //获得省份shuju
//    NSString *priUrl=@"http://api.tobosu.com/basic/basic_info/getProvince";
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:priUrl]];       // 这里要将url设置为空
//    [httpClient postPath:priUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        @try{
//            NSString *resultString = operation.responseString;
//            NSArray *array=[resultString objectFromJSONString];
//            NSLog(@"%@",[array objectAtIndex:1]);
//            for (NSInteger i=0; i<array.count; i++) {
//                NSString *provinceID=[[array objectAtIndex:i] objectForKey:@"provinceid"];
//                NSString *provinceName = [[array objectAtIndex:i] objectForKey:@"provincename"];
//                NSString *largeID = [[array objectAtIndex:i] objectForKey:@"largeid"];
//
//                NSString *sql = [NSString stringWithFormat:@"insert into TBS_Province(ProvinceID,ProvinceName,LargeID) values('%@','%@','%@')",provinceID,provinceName,largeID];
//                [[DBHelper createDataBase] executeUpdate:sql];
//
//            }
//
//        }
//        @catch(NSException *exception){
//            [Utils TakeException:exception];
//        }
//
//        @finally {}
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        // _uiview=self.view;
//        //[Utils ToastNotification:@"网络连接故障" andView:_uiview andLoading:NO andIsBottom:YES];
//        NSLog(@"ERROR====%@",operation);
//    }];
//
// }

//-(void)insertCity2Db
//{
//
//    //获得省份shuju
//    NSString *priUrl=@"http://api.tobosu.com/basic/basic_info/cityall";
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:priUrl]];       // 这里要将url设置为空
//    [httpClient postPath:priUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        @try{
//            NSString *resultString = operation.responseString;
//            NSDictionary *arrayDic=[resultString objectFromJSONString];
//            NSLog(@"%@",[arrayDic objectForKey:@"1"]);
//
//            NSArray* arr = [arrayDic allKeys];
//
//            if ([_db open])
//            {
//                for(NSString* key in arr)
//                {
//                    NSLog(@"%@",[arrayDic objectForKey:key]);
//                    NSString *provinceID = [[arrayDic objectForKey:key] objectForKey:@"ProvinceID"];
//                    NSString *cityName = [[arrayDic objectForKey:key] objectForKey:@"CityName"];
//                    NSString *simpName = [[arrayDic objectForKey:key] objectForKey:@"simpname"];
//                    NSString *citySimpName = [[arrayDic objectForKey:key] objectForKey:@"CitySimpName"];
//                    NSString *isOpen = [[arrayDic objectForKey:key] objectForKey:@"IsOpen"];
//                    NSString *sql = [NSString stringWithFormat:@"insert into TBS_City(ProvinceID,CityID,CityName,SimpName,CitySimpName,IsOpen) values('%@','%@','%@','%@','%@','%@')",provinceID,key,cityName,simpName,citySimpName,isOpen];
//                    //[[DBHelper initFMDataBase] executeUpdate:sql];
//
//                    NSLog(@"%hhd",[ _db executeUpdate:sql]);
//
//                }
//                [_db close];
//            }
//
//
//
//        }
//        @catch(NSException *exception){
//            [Utils TakeException:exception];
//        }
//
//        @finally {}
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        // _uiview=self.view;
//        //[Utils ToastNotification:@"网络连接故障" andView:_uiview andLoading:NO andIsBottom:YES];
//        NSLog(@"ERROR====%@",operation);
//    }];
//    
//}

@end