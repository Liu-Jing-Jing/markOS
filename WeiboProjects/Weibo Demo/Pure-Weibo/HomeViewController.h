//
//  HomeViewController.h
//  WXWeibo
//  首页控制器


#import "BaseViewController.h"
#import "WeiboTableView.h"
#import "UIFactory.h"

@interface HomeViewController : BaseViewController

@property (nonatomic, strong) NSString *topWeibiID;
@property (nonatomic, strong) NSString *lastWeibiID;
@property (nonatomic, strong) NSMutableArray *weibos;
@property (nonatomic, strong) ThemeImageView *barView; //note
@property (nonatomic, strong) IBOutlet WeiboTableView *tableView;

- (void)loadWeiboData;
@end
