//
//  ReplyController.h
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "BaseUIViewController.h"

@interface ReplyController : BaseUIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end