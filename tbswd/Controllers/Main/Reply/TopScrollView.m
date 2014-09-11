//
//  TopScrollView.m
//  tbswd
//
//  Created by Adrian on 14-9-9.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "TopScrollView.h" 
#define BUTTONGAP 10
#define CONTENTSIZEX 280

@implementation TopScrollView
@synthesize titleArray;
+ (TopScrollView *)getInstance{
    static TopScrollView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithFrame:CGRectMake(0, 64, CONTENTSIZEX, 42)];
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
        self.bounces=NO;
    }
    return self;
}

- (void)initWithTitleButtons{
    
    float xPos = 10.0f;
    for(int i = 0; i < [self.titleArray count]; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [self.titleArray objectAtIndex:i];
        [button setTag:i + 1];
        if(i == 0){
            button.selected = YES;
        }
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       // [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        
        int buttonWidth = [title sizeWithFont:button.titleLabel.font
                            constrainedToSize:CGSizeMake(150, 10)
                                lineBreakMode:NSLineBreakByClipping].width;
        
        button.frame = CGRectMake(xPos, 9, buttonWidth + BUTTONGAP, 30);
        // [buttonOrignXArray addObject:@(xPos)];
        //按钮的X坐标
        xPos += buttonWidth + BUTTONGAP;

        [self addSubview:button];
        
    }
    //视图的位移
    self.contentSize = CGSizeMake(xPos, 42);
}


@end
