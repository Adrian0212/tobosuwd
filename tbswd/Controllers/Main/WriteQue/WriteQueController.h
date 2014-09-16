//
//  WriteQueController.h
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TSRegularExpressionUtils.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "DBHelper.h"
#import "MBProgressHUD.h"
#import "Config.h"

#define TEXTVIEW_WORD_LIMIT 25
#define ASK_IP              @"0.0.0.0"

@interface WriteQueController : BaseUIViewController <UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel    *numLabel;      // 剩余输入字数
//@property (weak, nonatomic) NSString            *placeholder;   // 默认提示语
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@property (retain, nonatomic) DBHelper      *dbhelper;
@property (retain, nonatomic) FMDatabase    *db;

@property (retain, nonatomic) NSArray   *categoryTopArray;
@property (retain, nonatomic) NSArray   *categoryChildArray;

@property (weak, nonatomic) IBOutlet UITextField    *categoryTopField;
@property (weak, nonatomic) IBOutlet UITextField    *categoryChildField;

@property (weak, nonatomic) NSString    *topFieldText;
@property (weak, nonatomic) NSString    *childFieldText;

@property (retain, nonatomic) UIPickerView *pickerView;

@property  int number;  // 剩余字数
// pickerview选择的ID
@property int   topSelctedID;
@property int   childSelctedID;
// 按下确定后最终的ID
@property int   topID;
@property int   childID;

@property(retain, nonatomic) MBProgressHUD *HUD;

- (void)submitQueAction:(UIButton *)sender;
- (void)hideWriteQueView:(UIButton *)sender;

@end
