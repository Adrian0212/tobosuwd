//
//  WriteQueController.h
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "BaseUIViewController.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "DBHelper.h"

@interface WriteQueController : BaseUIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel    *numLabel;      // 剩余输入字数
@property (weak, nonatomic) NSString            *placeholder;   // 默认提示语

@property (retain, nonatomic) DBHelper *dbhelper;
@property (retain, nonatomic) FMDatabase *db;

@property  int number;

- (IBAction)hideWriteQueView:(UIButton *)sender;

@end
