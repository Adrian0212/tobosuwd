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

    NSString *path = [[NSBundle mainBundle] pathForResource:@"reply" ofType:@"plist"];
    _list = [NSArray arrayWithContentsOfFile:path];

    // 设置第一个tableHeaderView高度，与下面的一致
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 22.0f)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont  *titleFont = [UIFont fontWithName:@"HiraginoSansGB-W3" size:15.0];
    UIFont  *desFont = [UIFont fontWithName:@"HiraginoSansGB-W3" size:10.0];

    static NSString *cellReplyIdentifier = @"cellReplyIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        cellReplyIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleSubtitle
            reuseIdentifier:cellReplyIdentifier];
    }

    // 获取每行的字典
    NSDictionary *item = [_list[indexPath.section] objectAtIndex:indexPath.row];

    // 设置标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 140, 15)];
    [titleLabel setFont:titleFont];
    [titleLabel setTextColor:[Utils hexStringToColor:@"#333333"]];
    [titleLabel setText:[item objectForKey:@"title"]];
    [cell.contentView addSubview:titleLabel];

    // 设置描述
    UILabel *desLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 30, 140, 10)];
    [desLabel setFont:desFont];
    [desLabel setTextColor:[Utils hexStringToColor:@"#999999"]];
    [desLabel setText:[item objectForKey:@"description"]];
    [cell.contentView addSubview:desLabel];

    // 设置图标
    UIImage *icon = [Utils scaleImage:[UIImage imageNamed:[item objectForKey:@"icon"]] toSize:CGSizeMake(25, 25)];
    [cell.imageView setImage:icon];

    // 显示箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _list.count;
}

@end