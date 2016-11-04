//
//  MKImageView.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-14.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//
//  ImageView添加了点击事件，和回调的block

#import <UIKit/UIKit.h>
typedef void(^ImageBlock)(void);

@interface MKImageView : UIImageView

@property (nonatomic, copy) ImageBlock touchBlock;
@end
