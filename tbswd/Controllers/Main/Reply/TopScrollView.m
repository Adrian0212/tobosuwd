//
//  TopScrollView.m
//  tbswd
//
//  Created by Adrian on 14-9-5.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "TopScrollView.h"


#define CONTENTSIZEX 280
@implementation TopScrollView
@synthesize titleArray;


+(TopScrollView *)getInstance
{
    static TopScrollView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithFrame:CGRectMake(0, 20, CONTENTSIZEX, 44)];
    });
    return instance;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.buttonOrignXArray = [[NSMutableArray alloc] init];
        self.buttonWithArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)initWithButtons
{
    float xStart=10.0f;
    for (int i = 0; i<titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [titleArray objectAtIndex:i];
        [button setTag:i+1];
        if (i==0) {
            button.selected = YES;
        }
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectNameButton) forControlEvents:UIControlEventTouchUpInside];
        
       
    }
}

@end
