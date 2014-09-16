//
//  PullDownView.m
//  tbswd
//
//  Created by admin on 14/9/11.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "PullDownView.h"

@implementation PullDownView

// 隐藏输入框光标
- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

@end