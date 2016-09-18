//
//  WeiboAnnotation.m
//  WXWeibo
//
//  Created by Mark Lewis on 16-6-5.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

-(id)initWithWeibo:(WeiboModel *)weibo
{
    self = [super init];
    
    if (self != nil)
    {
        self.weiboModel = weibo;
    }
    
    return self;
}


-(void)setWeiboModel:(WeiboModel *)weiboModel
{
    
    if (_weiboModel != weiboModel)
    {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
    }
    
    // null -- >NSNull
    NSDictionary *geo = weiboModel.geo;
    // 加判断更严谨一些
    if ([geo isKindOfClass:[NSDictionary class] ])
    {
        
        NSArray *coord = [geo objectForKey:@"coordinates"];
        if (coord.count == 2) // 防止数组越界异常
        {
            
            float lat = [[coord objectAtIndex:0]floatValue];
            float lon = [[coord objectAtIndex:1]floatValue];
            _coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
    }
    
}

@end
