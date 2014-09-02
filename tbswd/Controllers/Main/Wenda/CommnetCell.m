//
//  CommnetCell.m
//  tbswd
//
//  Created by Adrian on 14-9-1.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "CommnetCell.h"

@implementation CommnetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        _userPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 40, 40)];
        [self.contentView addSubview:_userPhoto];

        _userName = [[UILabel alloc]initWithFrame:CGRectMake(60, 13, 260, 26)];
        _userName.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        [_userName setNumberOfLines:2];
        [_userName setTextColor:[Utils hexStringToColor:@"#333333"]];
        [_userName setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:12.0]];
        [self.contentView addSubview:_userName];

        _otherInfo = [[UILabel alloc]initWithFrame:CGRectMake(60, _userName.frame.size.height + _userName.frame.origin.y + 3, 260, 12)];
        [_otherInfo setTextColor:[Utils hexStringToColor:@"#999999"]];
        [_otherInfo setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:10.0]];
        [self.contentView addSubview:_otherInfo];

        _txt_Message = [[UITextView alloc]initWithFrame:CGRectMake(10, 63, 300, 31)];
        [_txt_Message setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:15.0]];
        [_txt_Message setEditable:NO];
        [_txt_Message setScrollEnabled:NO];
        [self.contentView addSubview:_txt_Message];

        _answerTimeSpan = [[UILabel alloc]initWithFrame:CGRectMake(13, _txt_Message.frame.size.height + _txt_Message.frame.origin.y + 15, 300, 12)];
        [_answerTimeSpan setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:12.0]];
        [_answerTimeSpan setTextColor:[Utils hexStringToColor:@"#666666"]];
        [self.contentView addSubview:_answerTimeSpan];

        _jubaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jubaoBtn setImage:[UIImage imageNamed:@"jb.png"] forState:UIControlStateNormal];
        [_jubaoBtn setTitle:@"举报" forState:UIControlStateNormal];
        [_jubaoBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_jubaoBtn.titleLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:12.0]];
        [_jubaoBtn setTitleColor:[Utils hexStringToColor:@"#666666"] forState:UIControlStateNormal];
        [_jubaoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
        [self.contentView addSubview:_jubaoBtn];

        _zanchengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zanchengBtn setImage:[UIImage imageNamed:@"zc.png"] forState:UIControlStateNormal];
        [_zanchengBtn setTitle:@"赞成" forState:UIControlStateNormal];
        [_zanchengBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_zanchengBtn.titleLabel setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:12.0]];
        [_zanchengBtn setTitleColor:[Utils hexStringToColor:@"#666666"] forState:UIControlStateNormal];
        [_zanchengBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
        [self.contentView addSubview:_zanchengBtn];

        _zanchengLb = [[UILabel alloc]init];
        [_zanchengLb setTextColor:[Utils hexStringToColor:@"#ff6600"]];
        [_zanchengLb setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:12.0]];
        [_zanchengLb setText:@"(0)"];
        [_zanchengLb sizeToFit];
        [self.contentView addSubview:_zanchengLb];
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

@end