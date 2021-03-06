//
//  RegisterController.h
//  tbswd
//
//  Created by Adrian on -8-11.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "Utils.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "TSRegularExpressionUtils.h"
#import "DBHelper.h"
@interface RegisterController : BaseUIViewController <UIScrollViewDelegate, UITextFieldDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{}

@property (weak, nonatomic) IBOutlet UIButton       *yezhuBtn;
@property (weak, nonatomic) IBOutlet UIButton       *shejishiBtn;
@property (weak, nonatomic) IBOutlet UIButton       *gongsiBtn;
@property (weak, nonatomic) IBOutlet UIScrollView   *nibScrollView;

- (IBAction)tabButtonAction:(UIButton *)sender;
- (IBAction)dismisTitleBar:(id)sender;

@end