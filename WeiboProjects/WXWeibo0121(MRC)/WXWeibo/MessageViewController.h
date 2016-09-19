//
//  MessageViewController.h
//  WXWeibo
//  消息首页控制器

#import "BaseViewController.h"
#import "WeiboTableView.h"

@interface MessageViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
