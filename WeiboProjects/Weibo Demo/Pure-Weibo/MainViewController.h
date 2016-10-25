//
//  MainViewController.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-14.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
@class AppDelegate;
@interface MainViewController : UITabBarController<SinaWeiboDelegate>

@property (nonatomic, strong) UIView *tabbarView; //note
@property (nonatomic, strong) UIView *badgeView; //note
- (void)hideBadge;
- (void)showTabbar:(BOOL)isShow;
@end
