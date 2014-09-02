//
//  QueListCell.m
//  tbswd
//
//  Created by Adrian on 14-8-21.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "QueListCell.h"

@implementation QueListCell

#pragma mark - 重新调整UITalbleViewCell中的控件布局
- (void)layoutSubviews
{
    // 千万不要忘记super layoutSubViews
    [super layoutSubviews];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        _cellView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, 300, 165)];
        [_cellView setBackgroundColor:[UIColor whiteColor]];
        [_cellView.layer setBorderWidth:1.0f];
        [_cellView.layer setBorderColor:[Utils hexStringToColor:@"#cccccc"].CGColor];
        _userPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        [_userPhoto.layer setBorderWidth:1.0];                                          // 边框宽度
        [_userPhoto.layer setBorderColor:[Utils hexStringToColor:@"#999999"].CGColor];  // 边框颜色
        [_cellView addSubview:_userPhoto];

        _userName = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 154, 20)];
        _userName.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        [_userName setNumberOfLines:1];
        [_userName setTextColor:[Utils hexStringToColor:@"#ff6600"]];
        [_cellView addSubview:_userName];

        _txt_description = [[UILabel alloc]initWithFrame:CGRectMake(60, 34, 170, 20)];
        [_txt_description setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:11.0]];
        [_txt_description setTextColor:[Utils hexStringToColor:@"#999999"]];
        [_cellView addSubview:_txt_description];

        _commentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_commentBtn setFrame:CGRectMake(225, 20, 60, 25)];
        [_commentBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_commentBtn setTitle:@"我来回答" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[Utils hexStringToColor:@"#7bc19a"] forState:UIControlStateNormal];
        [_commentBtn.layer setCornerRadius:4.0];                                            // 设置矩形四个圆角半径
        [_commentBtn.layer setBorderWidth:1.0];                                             // 边框宽度
        [_commentBtn.layer setBorderColor:[Utils hexStringToColor:@"#7bc19a"].CGColor];     // 边框颜色

        // [_commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        [_cellView addSubview:_commentBtn];

        _txt_Message = [[UITextView alloc]initWithFrame:CGRectMake(10, 63, 280, 31)];
        [_txt_Message setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:15.0]];
        [_txt_Message setEditable:NO];
        [_txt_Message setScrollEnabled:NO];
        [_cellView addSubview:_txt_Message];
        // [self.txt_Message sizeToFit];

        _answerName = [[UILabel alloc]initWithFrame:CGRectMake(10, 137, 265, 12)];
        [_answerName setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:11.0]];
        [_answerName setTextColor:[Utils hexStringToColor:@"#999999"]];
        [_answerName setTextAlignment:NSTextAlignmentRight];
        _answerName.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        [_answerName setNumberOfLines:1];
        [_cellView addSubview:_answerName];

        [self.contentView addSubview:_cellView];
        [self.contentView setBackgroundColor:[Utils hexStringToColor:@"#eeeeee"]];
    }

    for (UIView *currentView in self.subviews) {
        if ([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }

    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// - (void)commentAction
// {
//    NSLog(@"fjakslfjklasjfkasjf;");
// }
@end