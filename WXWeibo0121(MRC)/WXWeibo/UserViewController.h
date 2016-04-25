//
//  UserViewController.h
//  WXWeibo

#import "BaseViewController.h"
#import "WeiboTableView.h"
#import "UserModel.h"
@interface UserViewController : BaseViewController

@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;
@property (retain, nonatomic) UserModel *userModel;
@property (  copy, nonatomic) NSString *userName;
@end
