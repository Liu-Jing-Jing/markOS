//
//  CommentCell.h
//  WXWeibo

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "CommentModel.h"

@interface CommentCell : UITableViewCell<RTLabelDelegate>

@property (nonatomic, retain) CommentModel *commentModel;
// 计算评论单元格的高度
+ (CGFloat)getCommentHeight:(CommentModel *)commentModel;
@end
