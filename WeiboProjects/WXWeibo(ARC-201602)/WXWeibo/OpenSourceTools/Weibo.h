//
//  Weibo.h
//  04-通过代码自定义类
//
//  Created by Mark Lewis on 15-2-27.
//  Copyright (c) 2015年 TechLewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weibo : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL vip;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageName;


- (id)initWithDict:(NSDictionary *)dict;
+ (id)weiboWithDict:(NSDictionary *)dict;

@end
