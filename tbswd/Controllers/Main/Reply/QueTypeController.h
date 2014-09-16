//
//  QueTypeController.h
//  tbswd
//
//  Created by Adrian on 14-9-15.
//  Copyright (c) 2014年 tobosu. All rights reserved.
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
@interface QueTypeController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString *source;
@property (strong, nonatomic) IBOutlet UITableView *queListTable;

@end
