//
//  Comment.h
//  tbswd
//
//  Created by Adrian on 14-9-1.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property (strong, nonatomic) NSString  *answerID;
@property (strong, nonatomic) NSString  *answerUserName;
@property (strong, nonatomic) NSString  *answerHeadLog;

@property (strong, nonatomic) NSString  *userType;
@property (strong, nonatomic) NSString  *cityName;
@property (strong, nonatomic) NSString  *answerCount;
@property (strong, nonatomic) NSString  *acceptRate;

@property (strong, nonatomic) NSString *answerInfo;

@property (strong, nonatomic) NSString  *answerTimeSpan;
@property (strong, nonatomic) NSString  *agreeCount;
@property (strong, nonatomic) NSString  *replyCount;

@end