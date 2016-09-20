//
//  ImageViewController.h
//  Apple Store Demo
//
//  Created by Mark Lewis on 16-8-10.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebDownload.h"
#define kNavWithStatusBarHeight (self.navigationController.navigationBar.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
@interface ImageViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) NSURL *imageURL; //URL for internet image

@end
