//
//  UserDataCountModel.h
//  WXWeibo

/*
 id	int64	微博ID
 followers_count	int	粉丝数
 friends_count	int	关注数
 statuses_count	int	微博数
 */
#import "WXBaseModel.h"

@interface UserDataCountModel : WXBaseModel

@property(nonatomic,copy)   NSNumber * weiboId;           //微博id
@property(nonatomic,retain) NSNumber * followers_count;   //粉丝数
@property(nonatomic,retain) NSNumber * friends_count;   //关注数
@property(nonatomic,retain) NSNumber * statuses_count;   //微博数
@end
