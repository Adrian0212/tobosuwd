//
//  MessageController.m
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "MessageController.h"

@interface MessageController ()

@end

@implementation MessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBarTitle:@"消息提醒"];
    [self setOrangeThemeBar];
    [self hideBackButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [self hideBackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
