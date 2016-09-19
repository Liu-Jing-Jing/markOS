//
//  UserDataCountModel.m
//  WXWeibo
/*
 id	int64	微博ID
 followers_count	int	粉丝数
 friends_count	int	关注数
 statuses_count	int	微博数
 */

#import "UserDataCountModel.h"

@implementation UserDataCountModel

- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"weiboId":@"id",
                             @"followers_count":@"followers_count",
                             @"friends_count":@"friends_count",
                             @"statuses_count":@"statuses_count"
                             };
    
    return mapAtt;
}

@end
