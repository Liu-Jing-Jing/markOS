//
//  BaseTableView.h
//  WXWeibo
//
#import <UIKit/UIKit.h>
@class EGORefreshTableHeaderView;
@class BaseTableView;

@protocol UITableViewEvenDelegate <NSObject>

- (void)pullDown:(BaseTableView *)tableView;
- (void)pullUp:(BaseTableView *)tableView;
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface BaseTableView : UITableView

@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) BOOL isRefreshHeader; // 是否需要下拉效果
@property (nonatomic, assign) id<UITableViewEvenDelegate> eventDelegate;


@property (nonatomic, retain) UIButton *moreButton; //底部的上拉刷新按钮
@property (nonatomic, assign) BOOL isMore; //是否有更多数据（一页的数据全部加载完成）
- (void) doneLoadingTableViewData; // 弹回刷新视图
@end
