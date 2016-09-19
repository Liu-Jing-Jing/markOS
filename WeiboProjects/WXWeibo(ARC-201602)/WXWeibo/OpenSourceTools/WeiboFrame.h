//
//  WeiboFrame.h
//  04-通过代码自定义类
//
//  Created by Mark Lewis on 15-2-28.
//  Copyright (c) 2015年 TechLewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kNameFont [UIFont systemFontOfSize:15]
#define kTimeFont [UIFont systemFontOfSize:15]
#define kSourceFont [UIFont systemFontOfSize:15]
#define kContentFont [UIFont systemFontOfSize:15]
@class Weibo;
//WeiboFrameo包含模型, 利用模型数据来计算frame
@interface WeiboFrame : NSObject

@property (nonatomic, strong) Weibo *weiboModel;

@property (nonatomic, assign) CGRect iconF;
@property (nonatomic, assign) CGRect nameF;
@property (nonatomic, assign) CGRect vipF;
@property (nonatomic, assign) CGRect timeF;
@property (nonatomic, assign) CGRect sourceF;
@property (nonatomic, assign) CGRect contentF;
@property (nonatomic, assign) CGRect imageF;

@property (nonatomic, assign) CGFloat cellHeight;
@end

