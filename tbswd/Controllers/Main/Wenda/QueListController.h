//
//  QueListController.h
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "BaseUIViewController.h"
#import "AFNetworking.h"
#import "Utils.h"
#import "Config.h"
#import "MJRefresh.h"
@interface QueListController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *queListTable;

@end
