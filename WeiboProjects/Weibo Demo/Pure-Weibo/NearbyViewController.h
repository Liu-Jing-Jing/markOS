//
//  NearbyViewController.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-5-8.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

typedef void (^SelectDoneBlock)(NSDictionary *);

@interface NearbyViewController : BaseViewController<UITableViewDataSource, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic)NSArray *data;
@property (copy,nonatomic)SelectDoneBlock selectBlock;
@end
