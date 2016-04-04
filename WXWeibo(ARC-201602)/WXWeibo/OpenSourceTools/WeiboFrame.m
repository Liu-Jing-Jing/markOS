//
//  WeiboFrame.m
//  04-通过代码自定义类
//
//  Created by Mark Lewis on 15-2-28.
//  Copyright (c) 2015年 TechLewis. All rights reserved.
//

#import "WeiboFrame.h"
#import "Weibo.h"

#define kCellBorder 7
#define kVipWH 15
#define kIcon 45
#define kImageW 264
#define kImageH 200

@implementation WeiboFrame

- (void)setWeiboModel:(Weibo *)weiboModel
{
    _weiboModel = weiboModel;
    // 设置subview的属性
    // 头像
    CGFloat iconX = kCellBorder;
    CGFloat iconY = kCellBorder;
    _iconF = CGRectMake(iconX, iconY, kIcon, kIcon);
    
    // 昵称,利用CGRectGetMaxX(self.iconF)获得头像最右边的x值
    CGFloat nameX = CGRectGetMaxX(_iconF) + kCellBorder;
    CGFloat nameY = iconY;
    CGSize nameSize = [_weiboModel.name sizeWithAttributes:@{NSFontAttributeName:kNameFont}];
    _nameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    // vip
    if (_weiboModel.vip)
    {
        CGFloat vipX = CGRectGetMaxX(_nameF) + kCellBorder;
        CGFloat vipY = nameY;
        _vipF = CGRectMake(vipX, vipY, kVipWH, kVipWH);
//        _name.textColor = [UIColor redColor];
    }
    else
    {
//        _name.textColor = [UIColor blackColor];
    }
    
    
    // 时间
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(_nameF) + kCellBorder;
    CGSize timeSize = [_weiboModel.time sizeWithAttributes:@{NSFontAttributeName: kTimeFont}];
    _timeF = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    // 来自
    CGFloat sourceX = CGRectGetMaxX(_timeF) + kCellBorder;
    CGFloat sourceY = timeY;
    NSString *sourceText = [NSString stringWithFormat:@"来自: %@",_weiboModel.source];
    CGSize sourceSize = [sourceText sizeWithAttributes:@{NSFontAttributeName: kSourceFont}];
    _sourceF = CGRectMake(sourceX, sourceY, sourceSize.width, sourceSize.height);
    
    // 内容
    CGFloat contentX = 2*kCellBorder;
    CGFloat contentY = CGRectGetMaxY(_iconF) +kCellBorder;
    CGFloat contentW = [[UIScreen mainScreen] bounds].size.width - 4*kCellBorder; // 获得屏幕宽度，兼容6/6p
    CGSize contentSize = [_weiboModel.content sizeWithFont:kContentFont constrainedToSize:CGSizeMake(contentW, MAXFLOAT)];
    // [_weiboModel.content sizeWithAttributes:@{NSFontAttributeName: kSourceFont}];

    // [_weiboModel.content sizeWithFont:kContentFont constrainedToSize:CGSizeMake(contentW, MAXFLOAT)];
    // [_weiboModel.content sizeWithAttributes:@{NSFontAttributeName: kContentFont}];
    _contentF = CGRectMake(contentX, contentY, contentW, contentSize.height);
    
    // 配图
    if (_weiboModel.imageName)
    { // 有配图
        // 计算frame
        CGFloat imageX = ([[UIScreen mainScreen] bounds].size.width - kImageW)/2;
        CGFloat imageY = CGRectGetMaxY(_contentF) + kCellBorder;
        _imageF = CGRectMake(imageX, imageY,kImageW, kImageH);

        self.cellHeight = CGRectGetMaxY(_imageF) + kCellBorder;
    }
    else
    {// 无配图
        self.cellHeight = CGRectGetMaxY(_contentF) + kCellBorder;
    }
}
@end
