//
//  CommnetDetailController.m
//  tbswd
//
//  Created by Adrian on 14-8-29.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "CommnetDetailController.h"
#define kWinSize [UIScreen mainScreen].bounds.size
#import "YcKeyBoardView.h"
@interface CommnetDetailController () <YcKeyBoardViewDelegate>
{
    NSString    *_addUid;
    NSString    *_askTitle;
    NSString    *_askStatus;
    NSString    *_askCatalogChild; // 先使用子类标签，如子类为空再使用父类
    NSString    *_askCatalogTop;
    NSString    *_addTimeSpan;
    UITableView *_answerTable;
    
    NSMutableArray  *_dataList;
    NSInteger       _page;
    MBProgressHUD   *_hud;
}
@property (nonatomic, strong) YcKeyBoardView    *key;
@property (nonatomic, assign) CGFloat           keyBoardHeight;
@property (nonatomic, assign) CGRect            originalKey;
@property (nonatomic, assign) CGRect            originalText;
@end

@implementation CommnetDetailController
@synthesize akId;
@synthesize nickName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _page = 1;
    [self setBarTitle:[NSString stringWithFormat:@"%@%@", nickName, @"的提问"]];
    [self getTopData:akId];
    // [Utils ToastNotification:@"网络连接故障" andView:self.tabBarController.tabBar andLoading:NO andIsBottom:YES];

    [_submitBtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    // 锁住屏幕
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Utils showHUD:_hud inView:self.view withTitle:@"正在加载"];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_answerTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    // #warning 自动刷新(一进入程序就下拉刷新)
    [_answerTable headerBeginRefreshing];

    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_answerTable addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 1;

    [self getAnswerData:akId LocationFresh:@"header"];

    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [_answerTable reloadData];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [_answerTable headerEndRefreshing];
        });
}

- (void)footerRereshing
{
    _page++;
    [self getAnswerData:akId LocationFresh:@"footer"];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [_answerTable reloadData];

            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [_answerTable footerEndRefreshing];
        });
}

- (void)getTopData:(NSString *)askID
{
    NSDictionary    *infos = @{@"MType":@"11", @"Id":askID};
    AFHTTPClient    *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];

    [httpClient postPath:api_url_net parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        @try
        {
            NSString *resultString = operation.responseString;
            NSDictionary *arryDict = [resultString objectFromJSONString];

            if ([arryDict objectForKey:@"msg"]) {
                NSDictionary *arry = [arryDict objectForKey:@"info"];
                _addUid = [arry objectForKey:@"AddUid"];
                _askTitle = [arry objectForKey:@"AskTitle"];
                _askStatus = [arry objectForKey:@"AskStatus"];
                _askCatalogChild = [arry objectForKey:@"AskCatalogChild"];
                _askCatalogTop = [arry objectForKey:@"AskCatalogTop"];
                _addTimeSpan = [arry objectForKey:@"AddTimeSpan"];
                [self initElement];
            }
        }
        @catch(NSException *exception)
        {
            [Utils TakeException:exception];
        }

        @finally {
            [_hud hide:YES];
        }
    }

                failure :^(AFHTTPRequestOperation *operation, NSError *error)
    {
        // [Utils ToastNotification:@"网络连接故障" andView:self.BaseUIViewController. andLoading:NO andIsBottom:NO];
        [_hud hide:YES];
    }];
}

/**
 *  获得回答列表数据
 *
 *  @param askID 提问ID
 */
#pragma mark 获得回答列表数据
- (void)getAnswerData:(NSString *)askID LocationFresh:(NSString *)location
{
    NSDictionary    *infos = @{@"MType":@"12", @"Id":askID, @"PageIndex":[NSString stringWithFormat:@"%d", _page], @"PageSize":@"10"};
    AFHTTPClient    *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];

    [httpClient postPath:api_url_net parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        @try
        {
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
                    Comment *ct = [[Comment alloc]init];
                    [ct setAnswerID:[NSString stringWithFormat:@"%@", [arry[i] objectForKey:@"AnswerID"]]];
                    [ct setAnswerUserName:[arry[i] objectForKey:@"AnswerUserName"]];
                    [ct setAnswerHeadLog:[arry[i] objectForKey:@"AnswerHeadLog"]];
                    [ct setAnswerInfo:[arry[i] objectForKey:@"AnswerInfo"]];
                    [ct setUserType:[arry[i] objectForKey:@"UserType"]];
                    [ct setCityName:[arry[i] objectForKey:@"CityName"]];
                    [ct setAnswerCount:[arry[i] objectForKey:@"AnswerCount"]];
                    [ct setAcceptRate:[arry[i] objectForKey:@"AcceptRate"]];
                    [ct setReplyCount:[arry[i] objectForKey:@"ReplyCount"]];
                    [ct setAgreeCount:[arry[i] objectForKey:@"AgreeCount"]];
                    [ct setAnswerTimeSpan:[arry[i] objectForKey:@"AnswerTimeSpan"]];
                    [_dataList addObject:ct];
                }
            }

                   }
        @catch(NSException *exception)
        {
            [Utils TakeException:exception];
        }

        @finally {
             [_answerTable reloadData];

        }
    }

                failure :^(AFHTTPRequestOperation *operation, NSError *error)
    {
        // [Utils ToastNotification:@"网络连接故障" andView:self.BaseUIViewController. andLoading:NO andIsBottom:NO];
    }];
}

// 初始化各个控件
#pragma mark 初始化头部各个控件
- (void)initElement
{
    UIFont      *font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:15.0];
    UITextView  *askTitleTv = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, 290, 31)];

    [askTitleTv setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:15.0]];
    [askTitleTv setEditable:NO];
    [askTitleTv setScrollEnabled:NO];
    [askTitleTv setBackgroundColor:[Utils hexStringToColor:@"#eeeeee"]];
    askTitleTv.text = _askTitle;

    // 问题标题
    // 计算txt_message的高度,如果只有一行，高度为31.000000
    float   fPadding = 16.0; // 8.0px x 2
    CGSize  constraint = CGSizeMake(askTitleTv.contentSize.width - fPadding, CGFLOAT_MAX);
    CGSize  size = [_askTitle sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float   fHeight = size.height + 16.0;

    if (fHeight > 32) {
        askTitleTv.frame = CGRectMake(15, 10, 290, 62);
    } else {
        askTitleTv.frame = CGRectMake(15, 10, 280, 31);
    }

    [_topView addSubview:askTitleTv];

    // 状态，已解决---未解决
    UILabel *_askCatalogLb;

    if (nil != _askCatalogChild) {
        CGFloat titleH = askTitleTv.frame.size.height;
        _askCatalogLb = [[UILabel alloc] initWithFrame:CGRectMake(21, 15 + titleH, 290, 12)];
        [_askCatalogLb setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:12.0]];
        [_askCatalogLb setTextColor:[Utils hexStringToColor:@"#999999"]];
        _askCatalogLb.text = [NSString stringWithFormat:@"%@%@", @"分类:  ", _askCatalogChild];
    } else {
        _askCatalogLb.text = _askCatalogTop;
    }

    [_topView addSubview:_askCatalogLb];

    // 分类
    UILabel *askStatusLb = [[UILabel alloc] initWithFrame:CGRectMake(21, _askCatalogLb.frame.origin.y + _askCatalogLb.frame.size.height + 8, 290, 12)];
    [askStatusLb setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:12.0]];
    [askStatusLb setTextColor:[Utils hexStringToColor:@"#ff6600"]];
    askStatusLb.text = _askStatus;
    [_topView addSubview:askStatusLb];

    // 提问时间
    UILabel *addTimeSpanLb = [[UILabel alloc] initWithFrame:CGRectMake(21, askStatusLb.frame.origin.y + askStatusLb.frame.size.height + 8, 290, 12)];
    [addTimeSpanLb setFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:12.0]];
    [addTimeSpanLb setTextColor:[Utils hexStringToColor:@"#999999"]];
    addTimeSpanLb.text = _addTimeSpan;
    [_topView addSubview:addTimeSpanLb];
    [self.view addSubview:_topView];

    // 从新计算_topview的高度
    CGFloat tableVy = addTimeSpanLb.frame.origin.y + addTimeSpanLb.frame.size.height + 10.0;
    CGRect  temp = _topView.frame;
    temp.size.height = tableVy;
    _topView.frame = temp;

    CGFloat tablviewH = [[UIScreen mainScreen] bounds].size.height - 64 - 50 - _topView.frame.size.height;
    _answerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, _topView.frame.size.height + 64, 320, tablviewH) style:UITableViewStylePlain];
    // [_answerTable setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_answerTable];

    [_answerTable setDelegate:self];
    [_answerTable setDataSource:self];
    [self setupRefresh];
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
    static NSString *CellIdentifier = @"commentCell";
    // 2. 从缓存池查找是否有可用的表格行对象
    CommnetCell *cell = (CommnetCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[CommnetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if ([_dataList count] > 0) {
        Comment *ct = _dataList[indexPath.row];
        cell.userName.text = ct.answerUserName;
        // cell.userName.text = @"石家庄城市人家装饰工程有限公司石家庄城市人家装饰工程有限公司石家庄城市人家装饰工程有限公司";
        [cell.userPhoto setImageWithURL:[NSURL URLWithString:ct.answerHeadLog] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
        cell.otherInfo.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@%@", ct.userType, @" | ", ct.cityName, @"| 回答数: ", ct.answerCount, @"| 采纳率: ", ct.acceptRate, @"%"];

        cell.txt_Message.text = ct.answerInfo;
        // textView高度自适应
        CGSize size = [cell.txt_Message sizeThatFits:CGSizeMake(300, FLT_MAX)];
        [cell.txt_Message setFrame:CGRectMake(10, 63, 300, size.height)];

        cell.answerTimeSpan.text = ct.answerTimeSpan;
        // 重新计算answerTimeSpan的Y坐标值
        CGRect temp = cell.answerTimeSpan.frame;
        temp.origin.y = cell.txt_Message.frame.size.height + cell.txt_Message.frame.origin.y;
        cell.answerTimeSpan.frame = temp;

        // 举报按钮
        CGRect jbRect = CGRectMake(180, temp.origin.y, 40, 12);
        cell.jubaoBtn.frame = jbRect;
        // 赞成按钮
        CGRect zcRect = CGRectMake(230, temp.origin.y, 50, 12);
        cell.zanchengBtn.frame = zcRect;
        CGRect zcLbRect = CGRectMake(230 + cell.zanchengBtn.frame.size.width, temp.origin.y, 60, 12);
        cell.zanchengLb.frame = zcLbRect;

        CGRect cellFrame = [cell frame];
        cellFrame.origin = CGPointMake(0, 0);
        cellFrame.size.height = 63 + cell.txt_Message.frame.size.height + 30;

        // NSLog(@"%f",cell.contentView.frame.size.height);
        [cell setFrame:cellFrame];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

    return cell.frame.size.height;
}

#pragma mark 显示回复输入框
- (void)addBtn:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    if (self.key == nil) {
        self.key = [[YcKeyBoardView alloc]initWithFrame:CGRectMake(0, kWinSize.height - 44, kWinSize.width, 44)];
    }

    self.key.delegate = self;
    [self.key.textView becomeFirstResponder];
    self.key.textView.returnKeyType = UIReturnKeySend;
    [self.view addSubview:self.key];
}

- (void)keyboardShow:(NSNotification *)note
{
    CGRect  keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;

    self.keyBoardHeight = deltaY;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.key.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

- (void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.key.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.key.textView.text = @"";
        [self.key removeFromSuperview];
    }];
}

- (void)keyBoardViewHide:(YcKeyBoardView *)keyBoardView textView:(UITextView *)contentView
{
    // [contentView resignFirstResponder];
    // 接口请求
    // NSLog(@"%@",self.key.textView.text);
    // 该判断用于联想输入
    if (self.key.textView.text.length > 25) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入提示" message:@"字数不得超过25哦!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else if ([self.key.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入提示" message:@"回答不能为空哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        [self submitAnswerData:self.key.textView.text HideKeyBoard:contentView];
       // [contentView resignFirstResponder];
    }
}
//提交回答
- (void)submitAnswerData:(NSString *)answerInfo HideKeyBoard:(UITextView *)contentView
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setValue:akId forKey:@"AskID"];
    [json setValue:_addUid forKey:@"AskUid"];
    [json setValue:answerInfo forKey:@"AnswerInfo"];
    
    [json setValue:[[Config Instance] getDict:@"UserInfo" ValueByKey:@"id"] forKey:@"AnswerUid"];
    
    [json setValue:[[Config Instance] getDict:@"UserInfo" ValueByKey:@"name"] forKey:@"AnswerUserName"];
    
    [json setValue:[[Config Instance] getDict:@"UserInfo" ValueByKey:@"realname"] forKey:@"AnswerTrueName"];
    
    [json setValue:[[Config Instance] getDict:@"UserInfo" ValueByKey:@"mark"] forKey:@"UserType"];
    
    [json setValue:[[Config Instance] getDict:@"UserInfo" ValueByKey:@"cityname"] forKey:@"CityName"];
    
    [json setValue:[[Config Instance] getDict:@"UserInfo" ValueByKey:@"cityrefe"] forKey:@"CitySName"];
    NSString *homeUrl;
    
    if ([[[Config Instance] getDict:@"UserInfo" ValueByKey:@"mark"] isEqualToString:@"1"]) {
        
        homeUrl = [NSString stringWithFormat:@"%@%@%@%@%@",@"http://",[[Config Instance] getDict:@"UserInfo" ValueByKey:@"cityrefe"], @".tobosu.com/home/",[[Config Instance] getDict:@"UserInfo" ValueByKey:@"id"],@"-index.html"];
    }
    if ([[[Config Instance] getDict:@"UserInfo" ValueByKey:@"mark"] isEqualToString:@"2"]) {
        
        homeUrl = [NSString stringWithFormat:@"%@%@%@%@%@",@"http://",[[Config Instance] getDict:@"UserInfo" ValueByKey:@"cityrefe"], @"tobosu.com/designer/",[[Config Instance] getDict:@"UserInfo" ValueByKey:@"id"],@"/"];
    }
    if ([[[Config Instance] getDict:@"UserInfo" ValueByKey:@"mark"] isEqualToString:@"3"]) {
        
        homeUrl = [NSString stringWithFormat:@"%@%@%@%@%@",@"http://",[[Config Instance] getDict:@"UserInfo" ValueByKey:@"cityrefe"], @".tobosu.com/member/",[[Config Instance] getDict:@"UserInfo" ValueByKey:@"id"],@"/"];
    }
    [json setValue:homeUrl forKey:@"HomeUrl"];
    [json setValue:[[Config Instance] getDict:@"UserInfo" ValueByKey:@"icon"]  forKey:@"HeadLog"];
    
    
    NSDictionary    *infos = @{@"MType":@"15", @"Json":[json JSONString]};
    AFHTTPClient    *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];

    [httpClient postPath:api_url_net parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject){
        @try{
            NSString *resultString = operation.responseString;
            NSLog(@"%@",resultString);
            [_answerTable headerBeginRefreshing];
            [contentView resignFirstResponder];
        }
        @catch(NSException *exception){
            
            [Utils TakeException:exception];
        }
        @finally {}
    }

    failure :^(AFHTTPRequestOperation *operation, NSError *error){
        // [Utils ToastNotification:@"网络连接故障" andView:self.BaseUIViewController. andLoading:NO andIsBottom:NO];
    }];
}

@end