//
//  ReplyController.m
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "ReplyController.h"

@interface ReplyController ()

@end

@implementation ReplyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBarTitle:@"等你回答"];
    [self setOrangeThemeBar];
    [self hideBackButton];

    // 设置第一个tableHeaderView高度，与下面的一致
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 22.0f)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end