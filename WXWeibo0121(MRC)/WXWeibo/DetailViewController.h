//
//  DetailViewController.h
//  WXWeibo


#import "BaseViewController.h"

@class WeiboModel;
@class WeiboView;
@class CommentTableView;
@class MKImageView;

@interface DetailViewController : BaseViewController
{
    WeiboView *_weiboView;
    NSMutableArray *_comments;
}

@property (nonatomic, retain) WeiboModel *weiboModel;
@property (nonatomic, retain) IBOutlet CommentTableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *userBarView;
@property (retain, nonatomic) IBOutlet MKImageView *userImageView;
@property (retain, nonatomic) IBOutlet UILabel *nickLabel;
@property (nonatomic, retain) NSString *lastCommentID;

@end
