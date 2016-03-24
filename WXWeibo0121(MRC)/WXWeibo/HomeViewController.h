//
//  HomeViewController.h
//  WXWeibo
//  首页控制器

//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"
@interface HomeViewController : BaseViewController<SinaWeiboRequestDelegate, UITableViewEvenDelegate>
{
    
}

@property (nonatomic, copy) NSString *topWeibiID;
@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;
@property (nonatomic, retain) NSMutableArray *weibos;
@end
