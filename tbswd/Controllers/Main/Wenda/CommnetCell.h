//
//  CommnetCell.h
//  tbswd
//
//  Created by Adrian on 14-9-1.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
@interface CommnetCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView  *userPhoto;
@property (strong, nonatomic) IBOutlet UILabel      *userName;
@property (strong, nonatomic) IBOutlet UILabel      *otherInfo;     // 个人信息
@property (strong, nonatomic) IBOutlet UITextView   *txt_Message;   // 问题解答

@property (strong, nonatomic) IBOutlet UILabel  *answerTimeSpan;
@property (strong, nonatomic) IBOutlet UIButton *jubaoBtn;
@property (strong, nonatomic) IBOutlet UIButton *zanchengBtn;
@property (strong, nonatomic) IBOutlet UILabel  *zanchengLb;
@end