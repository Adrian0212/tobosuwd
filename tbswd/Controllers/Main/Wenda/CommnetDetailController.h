//
//  CommnetDetailController.h
//  tbswd
//
//  Created by Adrian on 14-8-29.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "BaseUIViewController.h"
#import "AFNetworking.h"
#import "JSONkit.h"
#import "Utils.h"
#import "CommnetCell.h"
#import "Comment.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"
@interface CommnetDetailController : BaseUIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString          *akId;
@property (strong, nonatomic) NSString          *nickName;
@property (strong, nonatomic) IBOutlet UIView   *topView;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

@end