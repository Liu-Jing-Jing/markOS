//
//  WeiboAnnotationView.h
//  WXWeibo
//
//  Created by Mark Lewis on 16-6-6.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WeiboAnnotationView : MKAnnotationView

@property (nonatomic, retain) UIImageView *userImage;//用户头像
@property (nonatomic, retain) UIImageView *weiboImage;//微薄图片视图
@property (nonatomic, retain) UILabel     *textLabel;//微薄内容


@end
