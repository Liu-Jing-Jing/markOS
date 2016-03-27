//
//  BaseViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController

- (SinaWeibo *)sinaweibo;


// 加载提示
@property (nonatomic, retain) MBProgressHUD *hub;
- (void)showHUBLoadingTitle:(NSString *)title withDim:(BOOL)isDim;
- (void)showHUBLoading;
- (void)hideHUBLoading;
@end
