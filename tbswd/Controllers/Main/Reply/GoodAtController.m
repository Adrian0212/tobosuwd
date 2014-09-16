//
//  GoodAtController.m
//  tbswd
//
//  Created by Adrian on 14-9-5.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "GoodAtController.h"

@interface GoodAtController ()
{
    NSInteger       _page;
    NSMutableArray  *_dataList;
    // 用于下一个页面传值
    NSString    *_akId;
    NSString    *_nickName;
    // TopScrollView *_topScrollView;
    UIScrollView    *_topScrollview;
    NSMutableArray  *_titleArray;
}
@end

@implementation GoodAtController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.queListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 42 + 1, 320, [UIScreen mainScreen].bounds.size.height - 64 - 42 - 49)];
    [self.view addSubview:self.queListTable];

    self.queListTable.backgroundColor = [UIColor blueColor];
    // _topScrollView = [TopScrollView getInstance];
    // _topScrollView.titleArray = @[@"苹果中国苹果中国苹果中国苹果中国苹果中国", @"iCloud", @"新浪微薄", @"维基百科", @"百度", @"中国雅虎", @"新闻", @"流行"];
    [self getGoodAtData];

    self.automaticallyAdjustsScrollViewInsets = NO;
    // [self.view addSubview:topScrollView];
    // 去除表格分隔线
    self.queListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.queListTable setBackgroundColor:[Utils hexStringToColor:@"#eeeeee"]];
    // 去除表格顶部间距
    self.queListTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320.0f, 5.0f)];

    [self setBarTitle:@"擅长领域"];
    [self.queListTable setDelaysContentTouches:NO];
    [self.queListTable setDelegate:self];
    [self.queListTable setDataSource:self];
    [self showBackButton];

    self.selectTitle = @"全部";
    [self initScroll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    // [self.tabBarController.tabBar setHidden:YES];
    [self showTabBar];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.queListTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    // #warning 自动刷新(一进入程序就下拉刷新)
    [self.queListTable headerBeginRefreshing];

    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.queListTable addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 1;

    [self getTableData:@"header" buttonType:self.selectTitle];

    // 2.2秒后刷新表格UI
    // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), /dispatch_get_main_queue(), ^{
    // 刷新表格
    //  [self.queListTable reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    //  [self.queListTable headerEndRefreshing];
    // });
}

- (void)footerRereshing
{
    _page++;
    [self getTableData:@"footer" buttonType:self.selectTitle];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            // [self.queListTable reloadData];

            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.queListTable footerEndRefreshing];
        });
}

#pragma mark - 数据源方法
#pragma mark 数据行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

#pragma mark 每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1. 创建一个静态表格标示字符串，定义静态变量时，变量首字母要大写
    static NSString *CellIdentifier = @"queListCell";
    // 2. 从缓存池查找是否有可用的表格行对象
    QueListCell *cell = (QueListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[QueListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    QueList *quelist = _dataList[indexPath.row];
    cell.userName.text = quelist.AddUserName;
    cell.txt_description.text = quelist.AskTimeSpan;
    // UIFont *font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:15.0];
    cell.txt_Message.text = quelist.AskTitle;

    // 计算txt_message的高度,如果只有一行，高度为31.000000

    //    float   fPadding = 16.0; // 8.0px x 2
    //    CGSize  constraint = CGSizeMake(cell.txt_Message.contentSize.width - fPadding, CGFLOAT_MAX);
    //    CGSize  size = [quelist.AskTitle sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    //    float fHeight = size.height + 16.0;
    //    if (fHeight > 32) {
    //        cell.txt_Message.frame = CGRectMake(10, 63, 280, 62);
    //        // NSLog(@"%f",fHeight);
    //        // NSLog(@"%@",quelist.AskTitle);
    //    } else {
    //        cell.txt_Message.frame = CGRectMake(10, 63, 280, 31);
    //    }
    // 动态调整textview的高度
    CGSize size = [cell.txt_Message sizeThatFits:CGSizeMake(280, FLT_MAX)];
    [cell.txt_Message setFrame:CGRectMake(10, 63, 280, size.height)];

    [cell.userPhoto setImageWithURL:[NSURL URLWithString:quelist.AddHeadLog] placeholderImage:[UIImage imageNamed:@"user_default.png"]];

    // NSLog(@"%@",NSHomeDirectory());
    if ([quelist.AnswerCount isEqual:@"0"]) {
        cell.answerName.text = @"";

        // NSLog(@"%d====",indexPath.row);
        [cell.cellView setFrame:CGRectMake(10, 5, 300, 10 + 40 + 13 + cell.txt_Message.frame.size.height + 6 + 10)];
        // NSLog(@"%@",quelist.AskTitle);
        // NSLog(@"%@",quelist.AnswerCount);
    } else {
        NSString *answerName = [NSString stringWithFormat:@"%@%@%@%@", quelist.LastAnswer, @"等", quelist.AnswerCount, @"人参与回答"];
        cell.answerName.text = answerName;

        CGRect frame = cell.answerName.frame;

        [cell.answerName setFrame:CGRectMake(frame.origin.x, 10 + 40 + 13 + cell.txt_Message.frame.size.height + 6, 280, frame.size.height)];

        [cell.cellView setFrame:CGRectMake(10, 5, 300, 10 + 40 + 13 + cell.txt_Message.frame.size.height + 6 + frame.size.height + 10)];
    }

    CGRect cellFrame = [cell frame];
    cellFrame.origin = CGPointMake(0, 0);
    cellFrame.size.height = cell.cellView.frame.size.height + 10;
    [cell setFrame:cellFrame];

    cell.commentBtn.tag = indexPath.row;
    [cell.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

    return cell.frame.size.height;
}

- (void)getTableData:(NSString *)location buttonType:(NSString *)ButtonType
{
    NSString        *mark = [[Config Instance] getUserMark];
    NSString        *userID = [[Config Instance] getUserId];
    NSString        *uid = [NSString stringWithFormat:@"%@%@", mark, userID];
    NSDictionary    *infos = @{@"MType":@"10", @"PageIndex":[NSString stringWithFormat:@"%d", _page], @"PageSize":@"10", @"Uid":uid, @"UserTags":ButtonType};
    AFHTTPClient    *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];

    [httpClient postPath:api_url_net parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSString *resultString = operation.responseString;
            NSDictionary *arryDict = [resultString objectFromJSONString];

            if ([@"header" isEqual : location]) {
                _dataList = nil;
                // [self.queListTable headerEndRefreshing];
            }

            if (_dataList == nil) {
                _dataList = [NSMutableArray new];
            }

            if ([arryDict objectForKey:@"msg"]) {
                NSArray *arry = [arryDict objectForKey:@"info"];

                for (NSInteger i = 0; i < [arry count]; i++) {
                    QueList *quelist = [[QueList alloc]init];

                    // NSLog(@"%@",[arry[i] objectForKey:@"AkID"] class]);
                    [quelist setAddUserName:[arry[i] objectForKey:@"AddUserName"]];
                    [quelist setAkID:[NSString stringWithFormat:@"%@", [arry[i] objectForKey:@"AkID"]]];
                    [quelist setAddHeadLog:[arry[i] objectForKey:@"AddHeadLog"]];
                    [quelist setAskTitle:[arry[i] objectForKey:@"AskTitle"]];
                    [quelist setAskTimeSpan:[arry[i] objectForKey:@"AskTimeSpan"]];
                    [quelist setAnswerCount:[arry[i] objectForKey:@"AnswerCount"]];
                    [quelist setLastAnswer:[arry[i] objectForKey:@"LastAnswer"]];

                    [_dataList addObject:quelist];
                }
            }
        }
        @catch(NSException *exception)
        {
            [Utils TakeException:exception];
        }

        @finally {
            [self.queListTable reloadData];

            if ([@"header" isEqual : location]) {
                [self.queListTable headerEndRefreshing];
            } else {
                [self.queListTable footerEndRefreshing];
            }
        }
    }

                failure :^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [Utils ToastNotification:@"网络连接故障" andView:self.view andLoading:NO andIsBottom:YES];

        if ([@"header" isEqual : location]) {
            [self.queListTable headerEndRefreshing];
        } else {
            [self.queListTable footerEndRefreshing];
        }
    }];
}

- (void)commentAction:(UIButton *)sender
{
    // NSLog(@"%d", sender.tag);
    QueList *ql = _dataList[sender.tag];

    _akId = ql.AkID;
    _nickName = ql.AddUserName;
    [self performSegueWithIdentifier:@"wenda_goodat_commentdetial" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *controller = [segue destinationViewController];

    [controller setValue:_akId forKey:@"akId"];
    [controller setValue:_nickName forKey:@"nickName"];
}

#pragma mark 获得用户的擅长领域

- (void)getGoodAtData
{
    NSString        *uid = [NSString stringWithFormat:@"%@%@", [[Config Instance] getUserMark], [[Config Instance] getUserId]];
    NSDictionary    *infos = @{@"MType":@"21", @"Uid":uid};
    AFHTTPClient    *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];

    [httpClient postPath:api_url_net parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSString *resultString = operation.responseString;
            NSDictionary *arryDict = [resultString objectFromJSONString];

            if ([arryDict objectForKey:@"msg"]) {
                _titleArray = [NSMutableArray array];
                [_titleArray addObject:@"全部"];

                for (int i = 0; i < [[arryDict objectForKey:@"info"] count]; i++) {
                    [_titleArray addObject:[[[arryDict objectForKey:@"info"] objectAtIndex:i] objectForKey:@"TagTitle"]];
                }

                // _topScrollView.titleArray=titleArray;
                [self setupRefresh];
                [self initWithTitleButtons];
            }
        }
        @catch(NSException *exception)
        {
            [Utils TakeException:exception];
        }

        @finally {}
    }

                failure :^(AFHTTPRequestOperation *operation, NSError *error) {
        [Utils ToastNotification:@"网络连接故障" andView:self.view andLoading:NO andIsBottom:YES];
    }];
}

#pragma mark 头上的scrollview
- (void)initScroll
{
    _topScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CONTENTSIZEX, 42)];
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 42)];
    [self.view addSubview:viewTop];
    [viewTop addSubview:_topScrollview];

    // scrollview下面的灰色下划线
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 64 + 42, 320, 1)];
    lb.backgroundColor = [Utils hexStringToColor:@"#cccccc"];
    [self.view addSubview:lb];

    // scrollview上面的设置按钮
    UIButton    *settingBt = [UIButton buttonWithType:UIButtonTypeCustom];
    UIFont      *font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:14.0];
    [settingBt.titleLabel setFont:font];
    [settingBt setFrame:CGRectMake(275, 2, 40, 42)];
    [settingBt setTitle:@"| 设置" forState:UIControlStateNormal];
    [settingBt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [viewTop addSubview:settingBt];

    _topScrollview.delegate = self;
    _topScrollview.backgroundColor = [UIColor clearColor];
    _topScrollview.pagingEnabled = NO;
    _topScrollview.showsHorizontalScrollIndicator = NO;
    _topScrollview.showsVerticalScrollIndicator = NO;
    _topScrollview.bounces = NO;
}

- (void)initWithTitleButtons
{
    UIFont  *font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:14.0];
    float   xPos = 10.0f;

    for (NSInteger i = 0; i < [_titleArray count]; i++) {
        UIButton    *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString    *title = [_titleArray objectAtIndex:i];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[Utils hexStringToColor:@"#999999"] forState:UIControlStateNormal];
        [button.titleLabel setFont:font];
        [button setTag:i + 100];

        if (i == 0) {
            button.backgroundColor = [Utils hexStringToColor:@"#fc6620"];
            [button.layer setCornerRadius:4.0]; // 设置矩形四个圆角半径
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _userSelectedButtonTag = 100;
            self.selectTitle = @"全部";
            [self selectQueType:button];
        }

        [button addTarget:self action:@selector(selectQueType:) forControlEvents:UIControlEventTouchUpInside];

        int buttonWidth = [title sizeWithFont:button.titleLabel.font
            constrainedToSize   :CGSizeMake(150, 10)
            lineBreakMode       :NSLineBreakByClipping].width;

        button.frame = CGRectMake(xPos, 9, buttonWidth + BUTTONGAP, 25);
        // [buttonOrignXArray addObject:@(xPos)];
        //按钮的X坐标
        xPos += buttonWidth + BUTTONGAP;

        [_topScrollview addSubview:button];
    }

    // 视图的位移
    _topScrollview.contentSize = CGSizeMake(xPos, 42);
}

- (void)selectQueType:(UIButton *)sender
{
    if (sender.tag != self.userSelectedButtonTag) {
        // 设置点击后的样式
        sender.backgroundColor = [Utils hexStringToColor:@"#fc6620"];
        [sender.layer setCornerRadius:4.0]; // 设置矩形四个圆角半径
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        // 还原上一个点击过得按钮
        UIButton *tempBt = (UIButton *)[self.view viewWithTag:self.userSelectedButtonTag];
        tempBt.backgroundColor = [UIColor clearColor];
        [tempBt setTitleColor:[Utils hexStringToColor:@"#999999"] forState:UIControlStateNormal];
        self.userSelectedButtonTag = sender.tag;

        // 获得点击的擅长领域数据
        self.selectTitle = sender.titleLabel.text;
        [self setupRefresh];
    }
}

@end