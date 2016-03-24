//
//  BaseTableView.h
//  WXWeibo
//
//  Created by Mark Lewis on 16-3-5.
//  Copyright (c) 2016年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGORefreshTableHeaderView;
@class BaseTableView;

@protocol UITableViewEvenDelegate <NSObject>

- (void)pullDown:(BaseTableView *)tableView;
- (void)puuUp:(BaseTableView *)tableView;
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface BaseTableView : UITableView

@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) BOOL isRefreshHeader; // 是否需要下拉效果
@property (nonatomic, assign) id<UITableViewEvenDelegate> eventDelegate;
- (void) doneLoadingTableViewData; // 弹回刷新视图
@end
