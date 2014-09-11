//
//  DBHelper.m
//  tbswd
//
//  Created by admin on 14/9/9.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "DBHelper.h"

static FMDatabase *shareDataBase = nil;

@implementation DBHelper

- (id)init
{
    self = [super init];

    if (self) {
        shareDataBase = [DBHelper createDataBase];
    }

    return self;
}

/**
 *   创建数据库类的单例对象
 *
 **/
// 这种方法可以达到线程安全，但多次调用时会导致性能显著下降
// + (FMDatabase *)createDataBase
// {
//    // debugMethod();
//    @synchronized(self) {
//        if (shareDataBase == nil) {
//            shareDataBase = [[FMDatabase databaseWithPath:dataBasePath] retain];
//        }
//
//        return shareDataBase;
//    }
// }

+ (FMDatabase *)createDataBase
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];

            // 创建数据库实例，如果路径中不存在"wenda.sqlite"的文件，sqlite会自动创建"wenda.sqlite"
            NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"wenda.sqlite"];
            shareDataBase = [FMDatabase databaseWithPath:dbPath];
            NSLog(@"dbPath:%@", dbPath);
        });
    return shareDataBase;
}

+ (BOOL)isTableExist:(NSString *)tableName
{
    FMResultSet *rs = [shareDataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];

    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"count"];

        if (0 == count) {
            return NO;
        } else {
            return YES;
        }
    }

    return NO;
}

- (BOOL)createTable
{
    if ([shareDataBase open]) {
        NSString *sqlstr = @"CREATE TABLE "tCategoryTabelName " (ID integer, Title text, ReTitle text, FatherID integer, SortPath text, ShowNo integer, IsOpen boolean, Mtype integer, Tuijian boolean, TreeLevel integer,WebTitle text, WebKeyword text, WebDecription text)";

        if (![DBHelper isTableExist:tCategoryTabelName]) {
            [shareDataBase executeUpdate:sqlstr];
        } else {
            return NO;
        }

        [shareDataBase close];
    }

    return YES;
}

- (BOOL)insertDictionary:(NSDictionary *)dictionary toTable:(NSString *)tableName
{
    NSArray *keys = [dictionary allKeys];

    NSMutableString *columns = [NSMutableString stringWithFormat:@""];  // 列名
    NSMutableString *values = [NSMutableString stringWithFormat:@""];   // 值

    for (int i = 0; i < [keys count]; i++) {
        [columns appendString:[NSString stringWithFormat:@"%@,", keys[i]]];

        id value = [dictionary objectForKey:keys[i]];

        if ([value isKindOfClass:[NSString class]]) {
            [values appendString:[NSString stringWithFormat:@"'%@',", value]];
        } else {
            [values appendString:[NSString stringWithFormat:@"%@,", value]];
        }
    }

    NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName,
        [columns substringToIndex:(columns.length - 1)], [values substringToIndex:(values.length - 1)]];

    BOOL flag = NO;

    if ([shareDataBase open]) {
        flag = [shareDataBase executeUpdate:sqlstr];
        [shareDataBase close];
    }

    return flag;
}

- (BOOL)emptyTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];

    BOOL flag = NO;

    if ([shareDataBase open]) {
        flag = [shareDataBase executeUpdate:sqlstr];
        [shareDataBase close];
    }

    return flag;
}

- (NSArray *)queryTable:(NSString *)tableName withArguments:(NSString *)arguments
{
    NSMutableArray *data = [[NSMutableArray alloc] init];               // 总的查询记录

    NSString *sqlstr = [NSString stringWithFormat:@"SELECT * FROM %@ where %@", tableName, arguments];

    if ([shareDataBase open]) {
        FMResultSet *rs = [shareDataBase executeQuery:sqlstr];

        while ([rs next]) {
            NSMutableDictionary *record = [[NSMutableDictionary alloc]init];    // 每一行记录的字典

            for (int i = 0; i < [rs columnCount]; i++) {
                [record setObject:[rs objectForColumnIndex:i] forKey:[rs columnNameForIndex:i]];
            }

            [data addObject:record];
        }

        [rs close];
        [shareDataBase close];
    }

    return data;
}

@end