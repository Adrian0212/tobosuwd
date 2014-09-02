//
//  YcKeyBoardView.h
//  KeyBoardAndTextView
//
//  Created by Adrian on 14-9-1.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//
#define kStartLocation 22
#import <UIKit/UIKit.h>
#import "Utils.h"
@class YcKeyBoardView;
@protocol YcKeyBoardViewDelegate <NSObject>

- (void)keyBoardViewHide:(YcKeyBoardView *)keyBoardView textView:(UITextView *)contentView;
@end

@interface YcKeyBoardView : UIView
@property (nonatomic, strong) UITextView                    *textView;
@property (nonatomic, strong) UIButton                      *cancelBtn;
@property (nonatomic, assign) id <YcKeyBoardViewDelegate>   delegate;
@end