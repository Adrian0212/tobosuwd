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

    _dbhelper = [[DBHelper alloc] init];
    _db = [DBHelper initFMDataBase];

    _placeholder = @"请描述您的问题，尽量清晰简明，以便更好地获得答案。";

    _textView.textColor = [Utils hexStringToColor:@"#999999"];
    // 增加textview内间距 （只适用于iOS7）
    _textView.textContainerInset = UIEdgeInsetsMake(5, 8, 0, 8);

    _textView.delegate = self;

    // 请求问题分类数据（待做定时更新）
    NSDictionary *infos = @{@"MType":@"19"};

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]]; [httpClient postPath:api_url_net parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSString *resultString = operation.responseString;
            NSDictionary *jsonData = [resultString objectFromJSONString];

            if ([jsonData[@"msg"] isEqualToString:@"true"]) {
                [_dbhelper emptyTable:tTopCategoryTabelName];
                [_dbhelper emptyTable:tChildCategoryTabelName];                  // 清空之前的数据
                NSLog(@"WriteQueController:插入问题分类数据");
                NSArray *categoryArray = jsonData[@"info"];
                for (int i = 0; i < categoryArray.count; i++) {
                    if (![_dbhelper insertDictionary:categoryArray[i] toTable:tTopCategoryTabelName]) {
                        NSLog(@"WriteQueController:插入失败");
                        break;
                    }
                }
            }
        }
        @catch(NSException *exception) {
            [Utils TakeException:exception];
        }

        @finally {}
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils ToastNotification:@"网络连接故障" andView:self.view andLoading:NO andIsBottom:YES];
    }];

    if ([_db open]) {
        NSMutableArray  *categoryTopArray = [[NSMutableArray alloc] init]; // 主类别数组
        NSString        *sqlStr = [NSString stringWithFormat:@"select ID, Title from %@ ", tTopCategoryTabelName];
        // 从数据库中获取主类别数组
        FMResultSet *topSet = [_db executeQuery:[sqlStr stringByAppendingString:@"where FatherID = 0"]];

        while ([topSet next]) {
            NSMutableDictionary *categoryTopDic = [[NSMutableDictionary alloc] init];   // 主类别字典

            [categoryTopDic setObject:[topSet objectForColumnName:@"ID"] forKey:@"ID"];
            [categoryTopDic setObject:[topSet objectForColumnName:@"Title"] forKey:@"Title"];

            NSMutableArray *categoryChildArray = [[NSMutableArray alloc] init]; // 子类别数组

            NSString    *argumentsql = [NSString stringWithFormat:@"where FatherID = %@", [topSet objectForColumnName:@"ID"]];
            FMResultSet *childSet = [_db executeQuery:[sqlStr stringByAppendingString:argumentsql]];

            while ([childSet next]) {
                NSMutableDictionary *categoryChildDic = [[NSMutableDictionary alloc] init]; // 子类别字典
                [categoryChildDic setObject:[childSet objectForColumnName:@"ID"] forKey:@"ID"];
                [categoryChildDic setObject:[childSet objectForColumnName:@"Title"]  forKey:@"Title"];
                [categoryChildArray addObject:categoryChildDic];
            }

            [childSet close];

            [categoryTopDic setObject:categoryChildArray forKey:@"childs"];
            [categoryTopArray addObject:categoryTopDic];
        }

        [topSet close];
        [_db close];
        NSLog(@"%@", categoryTopArray);
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"did");
    //[self setDefaultThemeBar];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"will");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideWriteQueView:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
    _number = 25 - [textView.text length];

    if ([textView.text length] == 0) {
        textView.text = _placeholder;
        textView.textColor = [Utils hexStringToColor:@"#999999"];
        [textView endEditing:YES];
    }

    _numLabel.text = [NSString stringWithFormat:@"%d", _number];

    if (_number < 0) {
        _numLabel.textColor = [UIColor redColor];
    } else {
        _numLabel.textColor = [Utils hexStringToColor:@"#666666"];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:_placeholder]) {
        textView.text = @"";
        textView.textColor = [Utils hexStringToColor:@"#333333"];
    }
}

@end
