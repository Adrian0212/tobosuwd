//
//  MessageHeader.m
//  tbswd
//
//  Created by admin on 14/8/26.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "MessageHeader.h"

@implementation MessageHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        UIFont  *nameFont = [UIFont fontWithName:@"HiraginoSansGB-W3" size:15.0];
        UIFont  *numFont = [UIFont fontWithName:@"Arial" size:11.0];

        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 15, frame.size.width, frame.size.height)];
        [_nameLabel setFont:nameFont];
        [_nameLabel  sizeToFit];

        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.size.width + 20, 14, 16, 16)];
        _numLabel.text = @"1";

        [_numLabel setFont:numFont];
        [_numLabel setTextColor:[UIColor whiteColor]];
        [_numLabel setTextAlignment:NSTextAlignmentCenter];
        [_numLabel setBackgroundColor:[Utils hexStringToColor:@"#fa3a1a"]];
        [_numLabel.layer setCornerRadius:8.0f];
        [_numLabel setClipsToBounds:YES];

        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
        [_arrowImage setFrame:CGRectMake(296, 20, 8, 4.5)];

        [self setBackgroundColor:[Utils hexStringToColor:@"#dddddd"]];
        [self.layer setBorderWidth:0.3f];
        [self.layer setBorderColor:[Utils hexStringToColor:@"#cccccc"].CGColor];
        [self addSubview:_numLabel];
        [self addSubview:_nameLabel];
        [self addSubview:_arrowImage];
    }

    return self;
}

- (void)setNameLabelText:(NSString *)name
{
    [_nameLabel setText:name];
    [_nameLabel sizeToFit];
    // 重新设置数字标签的位置
    [_numLabel setFrame:CGRectMake(_nameLabel.frame.size.width + 20, 14, 16, 16)];
}

- (void)setNumLabelText:(NSInteger)number
{
    if (number) {
        [_numLabel setHidden:NO];
        [_numLabel setText:[NSString stringWithFormat:@"%d", number]];
    } else {
        [_numLabel setHidden:YES];
    }
}

- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    [UIView beginAnimations:nil context:nil];
    _arrowImage.transform = CGAffineTransformMakeRotation(_isOpen ? M_PI : 0);
    [UIView commitAnimations];
}

@end