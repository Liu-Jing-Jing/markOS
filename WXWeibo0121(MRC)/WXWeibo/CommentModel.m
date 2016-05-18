//
//  CommentModel.m
//  WXWeibo

#import "CommentModel.h"
/*
 created_at	string	评论创建时间
 id	int64	评论的ID
 text	string	评论的内容
 source	string	评论的来源
 user	object	评论作者的用户信息字段 详细
 mid	string	评论的MID
 idstr	string	字符串型的评论ID
 status	object	评论的微博信息字段 详细
 reply_comment	object	评论来源评论，当本评论属于对另一评论的回复时返回此字段
 */

@implementation CommentModel
- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"created_at":@"created_at",
                             @"commentID":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"user":@"user",
                             @"mid":@"mid",
                             @"idstr":@"idstr",
                             @"status":@"status",
                             @"reply_comment":@"reply_comment"
                             };
    
    return mapAtt;
}


- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    NSDictionary *statusDic = [dataDic objectForKey:@"status"];
    
    UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
    WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statusDic];
    
    self.user = [user autorelease];
    self.weibo = [weibo autorelease];
}


@end
