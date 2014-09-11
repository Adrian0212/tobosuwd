//
//  TopScrollView.h
//  tbswd
//
//  Created by Adrian on 14-9-9.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, retain) NSArray *titleArray;




+ (TopScrollView *)getInstance;

//加载顶部标题
- (void)initWithTitleButtons;

- (void)setButtonSelect;

- (void)setScrollViewContentOffset;

@end
