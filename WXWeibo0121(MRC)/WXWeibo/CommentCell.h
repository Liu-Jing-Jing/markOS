//
//  CommentCell.h
//  WXWeibo

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "CommentModel.h"

@interface CommentCell : UITableViewCell<RTLabelDelegate>
{
    UIImageView *_userImage;
    UILabel     *_nickLabel;
    UILabel     *_timeLabel;
    RTLabel     *_contentLabel;
    UIImageView *_bottomImage;
}

@property (nonatomic, retain) CommentModel *commentModel;
// 计算评论单元格的高度
+ (CGFloat)getCommentHeight:(CommentModel *)commentModel;
@end
