//
//  TopScrollView.h
//  tbswd
//
//  Created by Adrian on 14-9-5.
//  Copyright (c) 2014年 tobosu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopScrollView : UIScrollView<UIScrollViewDelegate>{
    NSInteger userSelectedButtonTag;
    NSInteger scrollViewSelectedId;
}
@property (strong,nonatomic) NSArray *titleArray;
@property(strong,nonatomic) NSMutableArray *buttonWithArray;
@property(strong,nonatomic) NSMutableArray *buttonOrignXArray;



+(TopScrollView *)getInstance;
@end
