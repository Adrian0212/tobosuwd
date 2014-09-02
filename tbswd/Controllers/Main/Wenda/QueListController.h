//
//  QueListController.h
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "BaseUIViewController.h"
#import "Utils.h"
#import "Config.h"
#import "MJRefresh.h"
#import "JSONkit.h"
#import "QueList.h"
#import "QueListCell.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "CommnetDetailController.h"
@interface QueListController : BaseUIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *queListTable;

@end