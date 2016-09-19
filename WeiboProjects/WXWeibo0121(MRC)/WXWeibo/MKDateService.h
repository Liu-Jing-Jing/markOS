//
//  MKDateService.h
//  WXWeibo
//
//  Created by Mark Lewis on 16-5-20.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

typedef void (^RequestFinishedBlock) (id result);

@interface MKDateService : NSObject

+(ASIHTTPRequest *)requestWithURL:(NSString *)urlstring
                           params:(NSMutableDictionary *)params
                       httpMethod:(NSString *)httpMethod
                    completeBlock:(RequestFinishedBlock)block;

@end
