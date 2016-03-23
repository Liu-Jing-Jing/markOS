//
//  Weibo.m
//  04-通过代码自定义类
//
//  Created by Mark Lewis on 15-2-27.
//  Copyright (c) 2015年 TechLewis. All rights reserved.
//

#import "Weibo.h"

@implementation Weibo

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.icon = dict[@"icon"];
        self.name = dict[@"name"];
        self.vip = [dict[@"vip"] boolValue];
        self.time = dict[@"time"];
        self.source = dict[@"source"];
        self.content = dict[@"content"];
        self.imageName = dict[@"image"];
    }
    return self;
}

+ (id)weiboWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
