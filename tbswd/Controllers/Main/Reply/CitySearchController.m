//
//  CitySearchController.m
//  tbswd
//
//  Created by Adrian on 14-9-16.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "CitySearchController.h"

@interface CitySearchController () {
    FMDatabase      *_db;
    NSMutableSet    *_keyset;//城市首字母
    NSMutableArray  *_cityArry;
    NSMutableDictionary *_words;
    NSMutableArray *_sections;
}

@end

@implementation CitySearchController

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
    _db = [DBHelper initFMDataBase];
    [self getCityDict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView数据源方法
#pragma mark 分组 Section 表示表格的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sections count];
}

#pragma mark 每个分组中显示的数据量
// 指定每个分组中的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *wordsInsection = [_words objectForKey:[_sections objectAtIndex:section]];
    return [wordsInsection count];
}

#pragma mark 每个分组中显示的数据内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"TableViewCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier];
    }
    // 指定单元格的文字
    [cell.textLabel setText:[self wordAtIndexPath:indexPath]];

    return cell;
}

#pragma mark 分组的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sections objectAtIndex:section];
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _sections;
}
-(NSString *)wordAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *wordsInSection=[_words objectForKey:[_sections objectAtIndex:indexPath.section]];
    
    return [wordsInSection objectAtIndex:indexPath.row];
    
}

- (void)getCityDict
{
    if ([_db open]) {
        FMResultSet *fm;
        NSString    *sql = [NSString stringWithFormat:@"SELECT SimpName,CitySimpName FROM TBS_City where CityID > 0"];
        fm = [_db executeQuery:sql];
        _cityArry = [NSMutableArray array];
        _keyset = [NSMutableSet new];

        while ([fm next]) {
            NSString        *simpName = [fm stringForColumn:@"SimpName"];
            NSString        *citySimpName = [fm stringForColumn:@"CitySimpName"];
            NSString        *first = [[citySimpName substringToIndex:1] uppercaseString];
            NSDictionary    *dict = @{@"SimpName":simpName, @"CitySimpName":citySimpName};
            [_keyset addObject:first];
            [_cityArry addObject:dict];
        }

        [fm close];
    }

    [_db close];
    _words = [NSMutableDictionary dictionary];
    NSEnumerator *enm = [_keyset objectEnumerator];
    id key;
    while (key=[enm nextObject]) {
        NSMutableArray *citynameArray = [NSMutableArray array];
        for (NSInteger i=0; i<_cityArry.count; i++) {
            NSString *simpName = [[_cityArry objectAtIndex:i] objectForKey:@"SimpName"];
            NSString *citySimpName = [[_cityArry objectAtIndex:i] objectForKey:@"CitySimpName"];
            NSString *first = [[citySimpName substringToIndex:1] uppercaseString];

            if ([key isEqualToString:first]) {
                [citynameArray addObject:simpName];
            }
        }
        [_words setObject:citynameArray forKey:key];
    }
    _sections=[[NSMutableArray alloc] initWithArray:[[_words allKeys]sortedArrayUsingSelector:@selector(compare:)]];

}

@end