//
//  WriteQueController.m
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "WriteQueController.h"

@interface WriteQueController ()

@end

@implementation WriteQueController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setBarTitle:@"描述你的问题"];
    [self hideBackButton];

    // 设置导航栏按钮
    UIButton *cancelQueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelQueBtn setFrame:CGRectMake(0, 0, 46, 30)];
    [cancelQueBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelQueBtn setTitleColor:[Utils hexStringToColor:@"#ff6600"] forState:UIControlStateNormal];
    [cancelQueBtn.titleLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:15.0]];
    [cancelQueBtn addTarget:self action:@selector(hideWriteQueView:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barLeftBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelQueBtn];
    self.navigationItem.leftBarButtonItem = barLeftBtn;

    UIButton *submitQueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitQueBtn setFrame:CGRectMake(0, 0, 46, 30)];
    [submitQueBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitQueBtn setTitleColor:[Utils hexStringToColor:@"#ff6600"] forState:UIControlStateNormal];
    [submitQueBtn.titleLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:15.0]];
    [submitQueBtn addTarget:self action:@selector(submitQueAction:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barRightBtn = [[UIBarButtonItem alloc] initWithCustomView:submitQueBtn];
    self.navigationItem.rightBarButtonItem = barRightBtn;

    _dbhelper = [[DBHelper alloc] init];
    _db = [DBHelper initFMDataBase];

    // 增加textview内间距 （只适用于iOS7）
    _textView.textContainerInset = UIEdgeInsetsMake(8, 5, 0, 5);
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.delegate = self;

    // 设置默认数据
    _number = TEXTVIEW_WORD_LIMIT;
    _categoryTopArray = [self loadPickerViewData];
    _categoryChildArray = [[_categoryTopArray objectAtIndex:0] objectForKey:@"childs"];

    _topFieldText = [[_categoryTopArray objectAtIndex:0] objectForKey:@"Title"];
    _topID = [[[_categoryTopArray objectAtIndex:0] objectForKey:@"ID"] intValue];
    _topSelctedID = _topID;

    _childFieldText = [[_categoryChildArray objectAtIndex:0] objectForKey:@"Title"];
    _childID = [[[_categoryChildArray objectAtIndex:0] objectForKey:@"ID"] intValue];
    _childSelctedID = _childID;

    // pickerView设置
    _pickerView = [[UIPickerView alloc]init];
    [_pickerView setDataSource:self];
    [_pickerView setDelegate:self];
    [_pickerView setShowsSelectionIndicator:NO];

    [_pickerView setBackgroundColor:[Utils hexStringToColor:@"#eeeeee"]];

    // 设置键盘附属视图
    UIView *accessView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [accessView setBackgroundColor:[UIColor grayColor]];

    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [okButton setFrame:CGRectMake(240, 2, 80, 40)];
    [okButton setTitle:@"完成" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setFrame:CGRectMake(0, 2, 80, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [accessView addSubview:okButton];
    [accessView addSubview:cancelButton];

    [_categoryTopField setInputAccessoryView:accessView];
    [_categoryTopField setInputView:_pickerView];
    [_categoryChildField setInputAccessoryView:accessView];
    [_categoryChildField setInputView:_pickerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)submitQueAction:(UIButton *)sender
{
    if (_number >= TEXTVIEW_WORD_LIMIT - 4) {
        [Utils showToast:@"输入问题的问题字数需大于4" inView:self.view hideAfter:2];
    } else if (![TSRegularExpressionUtils isIncludeChinese:[_textView text]]) {
        [Utils showToast:@"请您输入有实质性内容的问题" inView:self.view hideAfter:2];
    } else if (![TSRegularExpressionUtils isValidText:[_textView text]]) {
        [Utils showToast:@"您输入的字符中包括广告嫌疑\n请核对后再发布！" inView:self.view hideAfter:2];
    } else if (_categoryTopField.text.length <= 0) {
        [Utils showToast:@"请您选择问题分类" inView:self.view hideAfter:2];
    } else {
        [self submitQue];
    }
}

- (void)myTask
{
    sleep(2);
    // UIImageView is a UIKit class, we have to initialize it on the main thread
    __block UIImageView *imageView;
    dispatch_sync(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageNamed:@"hud_checkmark.png"];
            imageView = [[UIImageView alloc] initWithImage:image];
        });
    _HUD.customView = imageView;
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.labelText = @"您的问题已发布，有回答我们会第一时间通知您。";
    // Do something usefull in here instead of sleeping ...
    sleep(2);
}

- (void)submitQue
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];

    [Utils showHUD:hud inView:self.view withTitle:@"正在提交"];

    Config          *config = [Config Instance];
    NSDictionary    *info = @{@"AskTitle":[_textView text], @"AskContent":@"",
                              @"AddUid":[config getUserInfoForKey:@"id"], @"AddTrueName":[config getUserInfoForKey:@"realname"], @"AddUserName":[config getUserInfoForKey:@"name"],
                              @"AddUserType":[config getUserInfoForKey:@"mark"], @"CatalogTopID":[NSNumber numberWithInt:_topID], @"CatalogChildID":[NSNumber numberWithInt:_childID], @"AskCity":[config getUserInfoForKey:@"cityname"], @"AskSimCity":[config getUserInfoForKey:@"cityrefe"], @"AskIP":ASK_IP, @"RefUrl":@""};
    NSDictionary *infos = @{@"MType":@"18", @"Json":[info JSONString]};

    NSLog(@"%@", infos);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]]; [httpClient postPath:api_url_net parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSString *resultString = operation.responseString;
            NSDictionary *jsonData = [resultString objectFromJSONString];
            NSLog(@"%@", resultString);
            NSLog(@"%@", jsonData);

            if ([jsonData[@"msg"] isEqualToString:@"true"]) {
                [self performSegueWithIdentifier:@"goSubmitQue" sender:self];
            } else {
                [Utils showToast:@"网络数据异常，请重新提交" inView:self.view hideAfter:2];
            }
        }
        @catch(NSException *exception) {
            [Utils TakeException:exception];
        }

        @finally {
            [hud hide:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils showToast:@"网络连接故障" inView:self.view hideAfter:2];
        [hud hide:YES];
    }];
}

- (void)hideWriteQueView:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark textview delegate
- (void)textViewDidChange:(UITextView *)textView
{
    _number = TEXTVIEW_WORD_LIMIT - [textView.text length];

    if ([textView.text length] == 0) {
        [_placeholder setHidden:NO];
    } else {
        [_placeholder setHidden:YES];
    }

    _numLabel.text = [NSString stringWithFormat:@"%d", _number];

    if (_number < 0) {
        textView.text = [textView.text substringToIndex:TEXTVIEW_WORD_LIMIT];
        _numLabel.text = @"0";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString : text] == YES) {
        [textView resignFirstResponder];

        return NO;
    }

    return YES;
}

#pragma mark pickerview delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_categoryTopArray count];

            break;

        case 1:
            return [_categoryChildArray count];

            break;

        default:
            return 0;

            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[_categoryTopArray objectAtIndex:row] objectForKey:@"Title"];

            break;

        case 1:
            return [[_categoryChildArray objectAtIndex:row] objectForKey:@"Title"];

            break;

        default:
            return nil;

            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            _categoryChildArray = [[_categoryTopArray objectAtIndex:row] objectForKey:@"childs"];
            [_pickerView selectRow:0 inComponent:1 animated:NO];
            [_pickerView reloadComponent:1];

            _topFieldText = [[_categoryTopArray objectAtIndex:row] objectForKey:@"Title"];
            _topSelctedID = [[[_categoryTopArray objectAtIndex:row] objectForKey:@"ID"] intValue];

            _childFieldText = [[_categoryChildArray objectAtIndex:0] objectForKey:@"Title"];
            _childSelctedID = [[[_categoryChildArray objectAtIndex:0] objectForKey:@"ID"] intValue];
            break;

        case 1:
            _childFieldText = [[_categoryChildArray objectAtIndex:row] objectForKey:@"Title"];
            _childSelctedID = [[[_categoryChildArray objectAtIndex:row] objectForKey:@"ID"] intValue];

        default:
            break;
    }
}

- (void)okButtonAction
{
    _categoryTopField.text = _topFieldText;
    _categoryChildField.text = _childFieldText;
    _topID = _topSelctedID;
    _childID = _childSelctedID;

    NSLog(@"%d,%d", _topID, _childID);
    [_categoryTopField endEditing:YES];
    [_categoryChildField endEditing:YES];
}

- (void)cancelButtonAction
{
    NSLog(@"%d,%d", _topID, _childID);
    [_categoryTopField endEditing:YES];
    [_categoryChildField endEditing:YES];
}

// 请求问题分类数据（待做定时更新）
- (void)updateCategoryData
{
    NSDictionary *infos = @{@"MType":@"19"};

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]]; [httpClient postPath:api_url_net parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSString *resultString = operation.responseString;
            NSDictionary *jsonData = [resultString objectFromJSONString];

            if ([jsonData[@"msg"] isEqualToString:@"true"]) {
                // 清空之前的数据
                [_dbhelper emptyTable:tTopCategoryTabelName];
                [_dbhelper emptyTable:tChildCategoryTabelName];
                NSLog(@"WriteQueController:插入问题分类数据");
                NSArray *categoryArray = jsonData[@"info"];

                for (int i = 0; i < categoryArray.count; i++) {
                    NSNumber *fatherID = [categoryArray[i] objectForKey:@"FatherID"];

                    if ([fatherID intValue] == 0) {
                        [_dbhelper insertDictionary:categoryArray[i] toTable:tTopCategoryTabelName];
                    } else {
                        [_dbhelper insertDictionary:categoryArray[i] toTable:tChildCategoryTabelName];
                    }
                }
            }
        }
        @catch(NSException *exception) {
            [Utils TakeException:exception];
        }

        @finally {}
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils showToast:@"网络连接故障" inView:self.view hideAfter:2];
    }];
}

// 从数据库中获得类别数据
- (NSArray *)loadPickerViewData
{
    if ([_db open]) {
        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];     // 主类别数组

        NSString *topSqlStr = [NSString stringWithFormat:@"select ID, Title from %@ ", tTopCategoryTabelName];

        // 从数据库中获取主类别数组
        FMResultSet *topSet = [_db executeQuery:topSqlStr];

        while ([topSet next]) {
            NSMutableDictionary *categoryTopDic = [[NSMutableDictionary alloc] init];       // 主类别字典

            [categoryTopDic setObject:[topSet objectForColumnName:@"ID"] forKey:@"ID"];
            [categoryTopDic setObject:[topSet objectForColumnName:@"Title"] forKey:@"Title"];

            NSMutableArray *childArray = [[NSMutableArray alloc] init];     // 子类别数组

            NSString *childSqlStr = [NSString stringWithFormat:@"select ID, Title from %@ where FatherID = %@", tChildCategoryTabelName, [topSet objectForColumnName:@"ID"]];

            FMResultSet *childSet = [_db executeQuery:childSqlStr];

            while ([childSet next]) {
                NSMutableDictionary *categoryChildDic = [[NSMutableDictionary alloc] init];     // 子类别字典
                [categoryChildDic setObject:[childSet objectForColumnName:@"ID"] forKey:@"ID"];
                [categoryChildDic setObject:[childSet objectForColumnName:@"Title"]  forKey:@"Title"];
                [childArray addObject:categoryChildDic];
            }

            [childSet close];

            [categoryTopDic setObject:childArray forKey:@"childs"];
            [categoryArray addObject:categoryTopDic];
        }

        [topSet close];
        [_db close];
        return categoryArray;
    }

    return nil;
}

#pragma mark - MBProgressHUD Delegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD was hidded
    [_HUD removeFromSuperview];
    _HUD = nil;
}

@end
