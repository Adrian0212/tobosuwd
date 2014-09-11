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
                [_dbhelper emptyTable:tCategoryTabelName];                  // 清空之前的数据
                NSLog(@"WriteQueController:插入问题分类数据");
                NSArray *categoryArray = jsonData[@"info"];

                for (int i = 0; i < categoryArray.count; i++) {
                    if (![_dbhelper insertDictionary:categoryArray[i] toTable:tCategoryTabelName]) {
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

    NSMutableArray *categoryTopArray = [[NSMutableArray alloc] init]; // 主类别数组

    NSArray *topArray = [_dbhelper queryTable:tCategoryTabelName withArguments:@"FatherID = 0"];

    for (int i = 0; i < topArray.count; i++) {
        NSMutableDictionary *categoryTopDic = [[NSMutableDictionary alloc] init];   // 主类别字典

        [categoryTopDic setObject:[topArray[i] objectForKey:@"ID"] forKey:@"ID"];
        [categoryTopDic setObject:[topArray[i] objectForKey:@"Title"] forKey:@"Title"];

        NSMutableArray *categoryChildArray = [[NSMutableArray alloc] init]; // 子类别数组

        NSString    *argumentsql = [NSString stringWithFormat:@"FatherID = %@", [topArray objectAtIndex:i][@"ID"]];
        NSArray     *childArray = [_dbhelper queryTable:tCategoryTabelName withArguments:argumentsql];

        for (int j = 0; j < childArray.count; j++) {
            NSMutableDictionary *categoryChild = [[NSMutableDictionary alloc] init]; // 子类别字典
            [categoryChild setObject:[childArray[j] objectForKey:@"ID"] forKey:@"ID"];
            [categoryChild setObject:[childArray[j] objectForKey:@"Title"] forKey:@"Title"];

            [categoryChildArray addObject:categoryChild];
        }

        [categoryTopDic setObject:categoryChildArray forKey:@"child"];

        [categoryTopArray addObject:categoryTopDic];
    }

    NSLog(@"%@", categoryTopArray);
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