//
//  QueListCell.h
//  tbswd
//
//  Created by Adrian on 14-8-21.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
@interface QueListCell : UITableViewCell

// @property (strong,nonatomic) EGOImageView *egoImgView;

@property (strong, nonatomic) IBOutlet UIImageView  *userPhoto;
@property (strong, nonatomic) IBOutlet UILabel      *userName;
@property (strong, nonatomic) IBOutlet UILabel      *txt_description;
@property (strong, nonatomic) IBOutlet UIButton     *commentBtn;
@property (strong, nonatomic) IBOutlet UITextView   *txt_Message;
@property (strong, nonatomic) IBOutlet UILabel      *answerName;
@property (strong, nonatomic) IBOutlet UIView       *cellView;

// - (void)commentAction;
@end