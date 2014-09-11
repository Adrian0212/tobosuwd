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
        shareDataBase = [DBHelper initFMDataBase];
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

+ (FMDatabase *)initFMDataBase
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
            // 获取Documents目录路径
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            // 拼接数据库路径

            NSString *dbFilePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", DATABASE_FILE_NAME]];
            // 创建NSFileManager对象，判断数据库文件是否存在
            NSFileManager *fm = [NSFileManager defaultManager];
            BOOL isExist = [fm fileExistsAtPath:dbFilePath];

            if (!isExist) {
                // 如果Documents中不存在数据库，则拷贝工程里的数据库到Documents下
                NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:DATABASE_FILE_NAME ofType:@"sqlite"];

                if ([fm copyItemAtPath:backupDbPath toPath:dbFilePath error:nil]) {
                    shareDataBase = [FMDatabase databaseWithPath:dbFilePath];
                }
            }
        });
    return shareDataBase;
}

+ (BOOL)isTableExist:(NSString *)tableName
{
    if ([shareDataBase open]) {
        FMResultSet *rs = [shareDataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];

        while ([rs next]) {
            NSInteger count = [rs intForColumn:@"count"];

            if (0 == count) {
                return NO;
            } else {
                return YES;
            }
        }

        [rs close];
        [shareDataBase close];
    }

    return NO;
}

- (BOOL)createTable:(NSString *)tableName withArguments:(NSString *)arguments
{
    NSString *sqlstr = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)", tableName, arguments];

    if ([shareDataBase open]) {
        if (![DBHelper isTableExist:tableName]) {
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