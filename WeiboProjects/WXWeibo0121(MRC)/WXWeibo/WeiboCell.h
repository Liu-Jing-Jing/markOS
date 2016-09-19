//
//  WeiboCell.h
//  WXWeibo
//  自定义微博cell

#import <UIKit/UIKit.h>

@class WeiboModel;
@class WeiboView;
@class MKImageView;

@interface WeiboCell : UITableViewCell
{
    MKImageView     *_userImage;    //用户头像视图
    UILabel         *_nickLabel;    //昵称
    UILabel         *_repostCountLabel; //转发数
    UILabel         *_commentLabel;     //回复数
    UILabel         *_sourceLabel;      //发布来源
    UILabel         *_createLabel;      //发布时间
    UILabel         *_countLabel;       //评论和转发数量
}

//微博数据模型对象
@property(nonatomic,retain)WeiboModel *weiboModel;
//微博视图
@property(nonatomic,retain)WeiboView *weiboView;

@end
