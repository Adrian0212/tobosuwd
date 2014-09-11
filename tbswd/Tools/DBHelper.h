//
//  DBHelper.h
//  tbswd
//
//  Created by admin on 14/9/9.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

#define DATABASE_FILE_NAME      @"wenda"
#define tTopCategoryTabelName   @"TBS_TopCategory"      // 问题主类别表
#define tChildCategoryTabelName @"TBS_ChildCategory"    // 问题子类别表

@interface DBHelper : NSObject

/**
 *  数据库对象单例方法
 *
 *  @return 数据库对象
 */
+ (FMDatabase *)initFMDataBase;

/**
 *
 *  判断数据库中表是否存在
 *
 *
 *  @param tableName 表名
 *
 *  @return 存在YES，不存在NO
 */
+ (BOOL)isTableExist:(NSString *)tableName;

/**
 *  创建表
 *
 *  @param tableName 表名
 *  @param arguments 参数
 *
 *  @return 成功YES，失败NO
 */
- (BOOL)createTable:(NSString *)tableName withArguments:(NSString *)arguments;

/**
 *  将数据字典的数据插入表中
 *
 *  Tips:字典中key的值与表中列表名需要一致
 *
 *  @param dictionary 数据字典
 *  @param tableName  表名
 *
 *  @return 成功YES，失败NO
 */
- (BOOL)insertDictionary:(NSDictionary *)dictionary toTable:(NSString *)tableName;

/**
 *  清空表的所有数据
 *
 *  @param tableName 表名
 *
 *  @return 成功YES，失败NO
 */
- (BOOL)emptyTable:(NSString *)tableName;

/**
 *  根据条件查询数据，返回记录数组
 *
 *  @param tableName 表名
 *  @param arguments 条件
 *
 *  @return 记录数组
 */
- (NSArray *)queryTable:(NSString *)tableName withArguments:(NSString *)arguments;

@end