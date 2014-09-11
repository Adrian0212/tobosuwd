//
//  WriteQueController.m
//  tbswd
//
//  Created by Adrian on 14-8-20.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import "WriteQueController.h"

@interface WriteQueController ()

@end

@implementation WriteQueController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _test1.textContainerInset  = UIEdgeInsetsMake(5,8, 0, 8);
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.minimumLineHeight = 35.f;
////    paragraphStyle.maximumLineHeight = 35.f;
//    
//    UIFont *font = [UIFont fontWithName:@"AmericanTypewriter" size:18.f];
//    _test.font = font;
//    
//    
//    NSString *string = @"This is a test.\nWill I pass?\n日本語のもじもあるEnglish\nEnglish y Español";
//    NSDictionary *attributtes = @{
//                                  NSParagraphStyleAttributeName : paragraphStyle,
//                                  };
//    
////    _test.attributedText = 
//    _test.attributedText = [[NSAttributedString alloc] initWithString:string
//                                                                   attributes:attributtes];
////    _test.text = string;
//    
//    [_test sizeToFit];
     NSLog(@"load");
    
}
-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"did");
    //[self setDefaultThemeBar];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"will");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideWriteQueView:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
