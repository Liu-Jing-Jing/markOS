//
//  DetailViewController.h
//  WXWeibo


#import "BaseViewController.h"

@class WeiboModel;
@class WeiboView;
@class CommentTableView;
@class MKImageView;

@interface DetailViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *comments; //note
@property (nonatomic, retain) NSString *lastCommentID;

@property (nonatomic, strong) WeiboView *weiboView; //note
@property (nonatomic, retain) WeiboModel *weiboModel;

@property (nonatomic, retain) IBOutlet CommentTableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *userBarView;
@property (retain, nonatomic) IBOutlet MKImageView *userImageView;
@property (retain, nonatomic) IBOutlet UILabel *nickLabel;
@end
