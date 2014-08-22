//
//  QueListCell.m
//  tbswd
//
//  Created by Adrian on 14-8-21.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "QueListCell.h"

@implementation QueListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView setFrame:CGRectMake(10, 10, 60, 60)];
        [imageView setBackgroundColor:[UIColor redColor]];
        
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

- (IBAction)commentAction:(id)sender {
}
@end
