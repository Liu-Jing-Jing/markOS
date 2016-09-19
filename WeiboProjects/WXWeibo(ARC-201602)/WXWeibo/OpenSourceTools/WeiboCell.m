//
//  WeiboCell.m
//  04-通过代码自定义类
//
//  Created by Mark Lewis on 15-2-27.
//  Copyright (c) 2015年 TechLewis. All rights reserved.
//

#import "WeiboCell.h"
#import "WeiboFrame.h"
#import "Weibo.h"

@interface WeiboCell ()
{
    UIImageView *_icon;
    // 昵称
    UILabel *_name;
    // vip
    UIImageView *_vip;
    // 时间
    UILabel *_time;
    // 来自
    UILabel *_source;
    // 内容
    UILabel *_content;
    // 配图
    UIImageView *_image;
}

@end
@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // 添加子控件
        // 头像
        UIImageView *icon = [[UIImageView alloc] init];
        [self.contentView addSubview:icon];
        _icon = icon;
        
        // 昵称
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:name];
        _name = name;
        
        // vip
        UIImageView *vip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip.png"]];
        [self.contentView addSubview:vip];
        _vip = vip;
        
        // 时间
        UILabel *time = [[UILabel alloc] init];
        time.font = [UIFont systemFontOfSize:13];
        time.textColor = [UIColor grayColor];
        [self.contentView addSubview:time];
        _time = time;
        
        // 来自
        UILabel *source = [[UILabel alloc] init];
        source.textColor = [UIColor grayColor];
        source.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:source];
        _source = source;
        
        
        // 内容
        UILabel *content = [[UILabel alloc] init];
        content.numberOfLines = 0; // 不限制行数
        [self.contentView addSubview:content];
        _content = content;
        
        // 配图
        UIImageView *image = [[UIImageView alloc] init];
        [self.contentView addSubview:image];
        _image = image;
    
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return self;
}



- (void)setWeiboFrame:(WeiboFrame *)weiboFrame
{
    _weiboFrame = weiboFrame;

    // 设置数据
    [self settingData];
    
    // 设置子控件的frame
    [self settingSubviewFrame];
    
}

- (void)settingSubviewFrame
{
    Weibo *weiboModel = _weiboFrame.weiboModel;

    // 设置subview的属性
    // 头像
    _icon.frame = _weiboFrame.iconF;
    
    // 昵称,利用CGRectGetMaxX(self.icon.frame)获得头像最右边的x值
    _name.frame = _weiboFrame.nameF;
    
    // vip
    if (weiboModel.vip)
    {
        _vip.frame = _weiboFrame.vipF;
        _name.textColor = [UIColor redColor];
    }
    else
    {
        _name.textColor = [UIColor blackColor];
    }

    
    // 时间
    _time.frame = _weiboFrame.timeF;
    
    // 来自
    _source.frame = _weiboFrame.sourceF;

    // 内容
    _content.frame = _weiboFrame.contentF;
    
    // 配图
    if (weiboModel.imageName)
    { // 有配图
        // 计算frame
        _image.frame = _weiboFrame.imageF;
    }

}

- (void)settingData
{
    Weibo *weiboModel = _weiboFrame.weiboModel;

    _icon.image = [UIImage imageNamed:weiboModel.icon];
    _name.text = weiboModel.name;
    _vip.hidden = !weiboModel.vip;
    _time.text = weiboModel.time;
    _source.text = [NSString stringWithFormat:@"来自: %@",weiboModel.source];
    _content.text = weiboModel.content;
    
    if (weiboModel.imageName)
    {
        _image.hidden = NO;
        _image.image = [UIImage imageNamed:weiboModel.imageName];
    }
    else
    {
        _image.hidden = YES;
    }
    
//    NSLog(@"%@", _source.text);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
//    NSLog(@"%@", [self.superview class]);
}



@end
