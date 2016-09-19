//
//  HomeViewController.h
//  WXWeibo
//  首页控制器


#import "BaseViewController.h"
#import "WeiboTableView.h"
#import "UIFactory.h"

@interface HomeViewController : BaseViewController<SinaWeiboRequestDelegate, UITableViewEvenDelegate>
{
    ThemeImageView *_barView;
}

@property (nonatomic, copy) NSString *topWeibiID;
@property (nonatomic, copy) NSString *lastWeibiID;
@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;
@property (nonatomic, retain) NSMutableArray *weibos;

- (void)loadWeiboData;
@end
