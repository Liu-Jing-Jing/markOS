//
//  AttentionListViewController.h
//  WXWeibo
//
//  Created by Mark Lewis on 16-6-5.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import "BaseViewController.h"

@interface AttentionListViewController : BaseViewController<SinaWeiboRequestDelegate, UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *screen_name;

@end
