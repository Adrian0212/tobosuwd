//
//  QueList.h
//  tbswd
//
//  Created by Adrian on 14-8-26.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueList : NSObject

@property (strong, nonatomic) NSString  *AkID;
@property (strong, nonatomic) NSString  *AddUserName;
@property (strong, nonatomic) NSString  *AddHeadLog;
@property (strong, nonatomic) NSString  *AskTitle;
@property (strong, nonatomic) NSString  *AskTimeSpan;
@property (strong, nonatomic) NSString  *AnswerCount;
@property (strong, nonatomic) NSString  *LastAnswer;

@property (strong, nonatomic) UIImage *cacheImage;

@end