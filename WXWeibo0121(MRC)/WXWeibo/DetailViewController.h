//
//  DetailViewController.h
//  WXWeibo


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
