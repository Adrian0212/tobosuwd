//
//  GoodAtController.m
//  tbswd
//
//  Created by Adrian on 14-9-5.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import "GoodAtController.h"

@interface GoodAtController ()

@end

@implementation GoodAtController

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
    TopScrollView *topScrollView = [TopScrollView getInstance];
    
    topScrollView.titleArray = @[@"苹果中国", @"iCloud", @"新浪微薄", @"维基百科", @"百度", @"中国雅虎", @"新闻", @"流行"];
    [self.view addSubview:topScrollView];
// [topScrollView initWithTitleButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
