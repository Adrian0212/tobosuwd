//
//  MessageController.h
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "BaseUIViewController.h"
#import "MessageHeader.h"

@interface MessageController : BaseUIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView    *tableview;
@property (strong, nonatomic) NSArray               *list;
@property (assign, nonatomic) BOOL                  isOpen;

@end