//
//  QueListController.m
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "QueListController.h"
#import "QueListCell.h"
@interface QueListController (){
    UIView *_uiview;
    NSInteger _page;
}

@end

@implementation QueListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
       
    
    // 注意：以下几句注册XIB的代码，一定要在viewDidLoad中！
    // 注册XIB文件
    UINib *nib = [UINib nibWithNibName:@"QueListCell" bundle:[NSBundle mainBundle]];
    
    // 获得根视图，并且转换成TableView
   
    // 为tableView注册xib
    [_queListTable registerNib:nib forCellReuseIdentifier:@"queListCell"];
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.queListTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    [self.queListTable headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.queListTable addFooterWithTarget:self action:@selector(footerRereshing)];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page=0;
    [self getTableData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.queListTable reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.queListTable headerEndRefreshing];
    });
}
- (void)footerRereshing
{
    _page++;
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.queListTable reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.queListTable footerEndRefreshing];
    });
}

#pragma mark - 数据源方法
#pragma mark 数据行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
#pragma mark 每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1. 创建一个静态表格标示字符串，定义静态变量时，变量首字母要大写
    static NSString *CellIdentifier = @"queListCell";
    // 2. 从缓存池查找是否有可用的表格行对象
    QueListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // 3. 如果没有找到可重用单元格对象，实例化新的单元格
    //    if (cell == nil) {
    //        NSLog(@"加载单元格 %d", indexPath.row);
    //
    ////        cell = [[BookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //        // 需要从xib中加载单元格视图，自定义视图的xib文件是运行时加载的
    //        // 注意，参数中的nibName不能使用扩展名
    //        // 1) 获取资源包
    //        NSBundle *bundle = [NSBundle mainBundle];
    //        // 2) 取xib中的视图数组
    //        NSArray *array = [bundle loadNibNamed:@"BookCell" owner:nil options:nil];
    //        // 3) 取最末项视图，也就是第一项作为单元格视图
    //        cell = [array lastObject];
    //    }
    
    // 4. 设置单元格内容

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 165.0;
}


-(void)getTableData
{
    NSString *url = [NSString stringWithFormat:@"http://askapi.tobosu.com:8888/IOSApi/askDataApi.aspx"];
   // MBProgressHUD   *hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    //[Utils showHUD:hud inView:self.view withTitle:@"正在加载"];
    
    NSDictionary *infos = @{@"MType":@"10", @"PageIndex":[NSString stringWithFormat:@"%d",_page], @"PageSize":@"10"};
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];       // 这里要将url设置为空
    [httpClient postPath:url parameters:infos success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            NSString *resultString = operation.responseString;
            NSDictionary *arrlist=[resultString objectFromJSONString];
            //            _province=[[NSMutableArray alloc] init];
            //            for (int i=0; i<[arrlist count]; i++)
            //            {
            //                NSDictionary *item=[arrlist objectAtIndex:i];
            //                NSString *provinceid=[item objectForKey:@"provincename"];
            //                [_province addObject:provinceid];
            //            }
            NSLog(@"%@",[arrlist objectForKey:@"list"][0]);
            
        }
        @catch(NSException *exception) {
            [Utils TakeException:exception];
        }
        
        @finally {}
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // _uiview=self.view;
        //[Utils ToastNotification:@"网络连接故障" andView:_uiview andLoading:NO andIsBottom:YES];
        NSLog(@"ERROR====%@",operation);
    }];
    //[hud hide:YES];

}
@end
