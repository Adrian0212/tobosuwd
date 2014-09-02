//
//  MessageHeader.h
//  tbswd
//
//  Created by admin on 14/8/26.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface MessageHeader : UIView

@property (retain, nonatomic) UILabel       *nameLabel;     // 标题名称
@property (retain, nonatomic) UILabel       *numLabel;      // 消息数目
@property (retain, nonatomic) UIImageView   *arrowImage;    // 箭头图标

@property (assign, nonatomic) BOOL isOpen;                  // 展开标志

/**
 * 设置表区域标题
 *
 *  @param name 名称
 */
- (void)setNameLabelText:(NSString *)name;

/**
 *  设置消息数目
 *
 *  @param number 数目
 */
- (void)setNumLabelText:(NSInteger)number;

@end