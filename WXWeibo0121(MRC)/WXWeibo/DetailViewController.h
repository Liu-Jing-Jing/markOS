//
//  DetailViewController.h
//  WXWeibo
//
//  Created by Mark Lewis on 16-3-22.
//  Copyright (c) 2016年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@class WeiboModel;
@class WeiboView;
@interface DetailViewController : BaseViewController
{
    WeiboView *_weiboView;
}

@property (nonatomic, retain) WeiboModel *weiboModel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *userBarView;
@property (retain, nonatomic) IBOutlet UIImageView *userImageView;
@property (retain, nonatomic) IBOutlet UILabel *nickLabel;
@end
