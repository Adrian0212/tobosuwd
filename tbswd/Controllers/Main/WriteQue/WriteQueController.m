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
    [self performSegueWithIdentifier:@"QueController" sender:self];
    // Do any additional setup after loading the view.
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
