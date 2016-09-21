//
//  BaseViewController.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-14.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MBProgressHUD/MBProgressHUD+MJ.h"
#import "BaseNavigationController.h"

@interface BaseViewController : UIViewController

@property (nonatomic,assign)BOOL isCancelButton;
@property (nonatomic, retain) MBProgressHUD *hub;
- (SinaWeibo *)sinaweibo;
- (void)showHUBLoadingTitle:(NSString *)title withDim:(BOOL)isDim;
- (void)showHUBLoading;
- (void)hideHUBLoading;
-(void)showHUBComplete:(NSString *)title;
@end
