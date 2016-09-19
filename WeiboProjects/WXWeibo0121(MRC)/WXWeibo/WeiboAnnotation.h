//
//  WeiboAnnotation.h
//  WXWeibo
//
//  Created by Mark Lewis on 16-6-5.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"

@interface WeiboAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic,retain)WeiboModel *weiboModel;

-(id)initWithWeibo:(WeiboModel *)weibo;


@end
