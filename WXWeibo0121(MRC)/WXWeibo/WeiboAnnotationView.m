//
//  WeiboAnnotationView.m
//  WXWeibo
//
//  Created by Mark Lewis on 16-6-6.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"

@implementation WeiboAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self initView];
    }
    return self;
}



- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil )
    {
        
        [self initView];
    }
    
    return  self;
}

- (void)initView
{
    
    _userImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    _userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _userImage.layer.borderWidth  =1;
    _weiboImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    // 为了填满微博图片视图，但是图片拉伸了，也不好看
    // weiboImage.contentMode = UIViewContentModeScaleAspectFit;
    
    _weiboImage.backgroundColor = [UIColor blackColor];
    _textLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _textLabel.font = [UIFont systemFontOfSize:12.0];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.numberOfLines = 3;
    
    [self addSubview:_weiboImage];
    [self addSubview:_textLabel];
    [self addSubview:_userImage];
    
}


-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    WeiboModel *weibo = nil;
    WeiboAnnotation *weiboAnnotation = self.annotation;
    //确保weiboAnnotation 是WeiboAnnotation类型，才能调用该类方法
    if ([weiboAnnotation isKindOfClass:[weiboAnnotation class]])
    {
        
        weibo = weiboAnnotation.weiboModel;
    }
    
    NSString *thumbnailImage = weibo.thumbnailImage;
    if (thumbnailImage.length > 0 )//带微博图片
    {
        self.image = [UIImage imageNamed:@"nearby_map_photo_bg.png"];
        _weiboImage.frame = CGRectMake(15, 15, 90, 85);
        [_weiboImage setImageWithURL:[NSURL URLWithString:thumbnailImage ]];
        
        _userImage.frame = CGRectMake(70, 70, 30, 30);
        NSString *userURL = weibo.user.profile_image_url;
        [_userImage setImageWithURL:[NSURL URLWithString:userURL ]];
        _textLabel.hidden = YES;
        _weiboImage.hidden = NO;
    }
    else{
        
        self.image = [UIImage imageNamed:@"nearby_map_content.png"];
        
        // 加载用户头像
        _userImage.frame = CGRectMake(20, 20, 45, 45);
        NSString *userURL = weibo.user.profile_image_url;
        [_userImage setImageWithURL:[NSURL URLWithString:userURL ]];
        
        // 微博内容
        _textLabel.frame = CGRectMake(_userImage.right +5, _userImage.top, 110, 45);
        _textLabel.text = weibo.text;
        _textLabel.hidden = NO;
        _weiboImage.hidden = YES;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
 {
    // Drawing code
}
*/

@end
