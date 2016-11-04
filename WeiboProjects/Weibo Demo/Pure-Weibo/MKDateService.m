//
//  MKDateService.m
//  WXWeibo
//
//  Created by Mark Lewis on 16-5-20.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import "MKDateService.h"
#import "WXHLGlobalUICommon.h"
@implementation MKDateService

#define BASE_URL @"https://api.weibo.com/2/"

/*
+(ASIHTTPRequest *)requestWithURL:(NSString *)urlstring
                           params:(NSMutableDictionary *)params
                       httpMethod:(NSString *)httpMethod
                    completeBlock:(RequestFinishedBlock)block
{
    
    
    // 取得认证信息
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
    
    // 拼接url
    // 如：https://api.weibo.com/2/statuses/timeline_batch.json?access_token=value
    urlstring = [BASE_URL stringByAppendingFormat:@"%@?access_token=%@",urlstring,accessToken];
    
    // 处理get请求参数
    NSComparisonResult compareRet1 = [httpMethod caseInsensitiveCompare:@"GET"];
    
    if (NSOrderedSame == compareRet1)
    {
        NSMutableString *paramsString = [NSMutableString string];
        NSArray *allkeys = [params allKeys];
        for (int i=0 ; i<params.count; i++)
        {
            
            NSString *key = [allkeys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            [paramsString appendFormat:@"%@=%@",key,value ];
            
            if (i < params.count -1 )
            {
                
                [paramsString appendString:@"&"];
            }
        }
        
        if (paramsString.length >0)
        {
            
            urlstring = [urlstring stringByAppendingFormat:@"&%@",paramsString];
        }
        
    }
    
    NSURL *url = [NSURL URLWithString:urlstring];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    // 设置超时事件
    [request setTimeOutSeconds:60];
    [request setRequestMethod:httpMethod];
    
    
    // 处理post请求方式
    // 忽略请求方法的大小写
    NSComparisonResult compareRet = [httpMethod caseInsensitiveCompare:@"POST"];
    
    if (NSOrderedSame == compareRet)
    {
        NSArray *allkeys = [params allKeys];
        
        for (int i = 0; i<params.count; i++)
        {
            NSString *key = [allkeys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            // 判断是否是文件上传
            if ([value isKindOfClass:[NSData class]])
            {
                
                [request addData:value forKey:key];
            }
            else
            {
                [request addPostValue:value forKey:key];
            }
        }
    }
    
    
    [request setCompletionBlock:^{
        
        NSData *data = request.responseData;
        float version = (float)WXHLOSVersion();
        id result = nil;
        if (version >= 5.0)
        {
            result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
        }
        else
        {
            result = [data objectFromJSONData];
        }
        
        
        if (block!=nil)
        {
            block(result);
        }
    }];
    
    [request startAsynchronous];
    
    return nil;
    
}
 */

@end
