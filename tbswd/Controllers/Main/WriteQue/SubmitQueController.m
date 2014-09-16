//
//  SubmitQueController.m
//  tbswd
//
//  Created by admin on 14/9/15.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "SubmitQueController.h"

@interface SubmitQueController ()

@end

@implementation SubmitQueController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBarTitle:@"提问成功"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回操作
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
