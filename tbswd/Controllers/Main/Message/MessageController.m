//
//  MessageController.m
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "MessageController.h"

@interface MessageController ()

@property (nonatomic, strong) NSMutableDictionary *headers;

@end

@implementation MessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBarTitle:@"消息提醒"];
    [self setOrangeThemeBar];
    [self hideBackButton];

    NSString    *path = [[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
    NSArray     *messageList = [NSArray arrayWithContentsOfFile:path];

    self.headers = [NSMutableDictionary dictionary];

    self.list = messageList;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setOrangeThemeBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MessageHeader   *header = self.headers[@(section)];
    int             count = header.isOpen ?[self.list count] : 0;

    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
        TableSampleIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:TableSampleIdentifier];
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MessageHeader *mh = self.headers[@(section)];

    if (!mh) {
        mh = [[MessageHeader alloc]initWithFrame:CGRectMake(0, 0, 320, 43)];
        NSDictionary *dict = self.list[section];
        [mh setNameLabelText:dict[@"groupname"]];
        [mh setNumLabelText:[dict[@"messages"] count]];
        [mh setTag:section];
        // 为表头UIView增加点击事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(expandGroup:)];
        [mh addGestureRecognizer:tapGesture];

        [self.headers setObject:mh forKey:@(section)];
    }

    return mh;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.list count];
}

- (void)expandGroup:(UITapGestureRecognizer *)gesture
{
    if ([gesture.view isKindOfClass:[MessageHeader class]]) {
        ((MessageHeader *)gesture.view).isOpen = !((MessageHeader *)gesture.view).isOpen;
    }

    [self.tableview reloadData];
}

@end