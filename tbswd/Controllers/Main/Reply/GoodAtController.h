//
//  GoodAtController.h
//  tbswd
//
//  Created by Adrian on 14-9-5.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TopScrollView.h"
#import "Utils.h"
#import "Config.h"
#import "MJRefresh.h"
#import "JSONkit.h"
#import "QueList.h"
#import "QueListCell.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "CommnetDetailController.h"
@interface GoodAtController : BaseUIViewController<UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *queListTable;

@end
