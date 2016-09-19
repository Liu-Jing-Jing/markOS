//
//  WeiboCell.h
//  04-通过代码自定义类
//
//  Created by Mark Lewis on 15-2-27.
//  Copyright (c) 2015年 TechLewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboFrame;//WeiboFrameo包含模型, 利用模型数据来计算frame

@interface WeiboCell : UITableViewCell

@property (nonatomic, strong) WeiboFrame *weiboFrame;

@end
