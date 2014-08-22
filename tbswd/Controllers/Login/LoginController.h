//
//  LoginController.h
//  tbswd
//
//  Created by Adrian on 14-8-11.
//  Copyright (c) 2014年 Adrian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "AFNetworking.h"
#import "GCDiscreetNotificationView.h"
#import "Utils.h"
#import "Config.h"

@interface LoginController : BaseUIViewController

@property (nonatomic, retain) GCDiscreetNotificationView    *notificationView;
@property (weak, nonatomic) IBOutlet UITextField            *userAccount;
@property (weak, nonatomic) IBOutlet UITextField            *userPassword;

- (IBAction)loginAction:(id)sender;

@end