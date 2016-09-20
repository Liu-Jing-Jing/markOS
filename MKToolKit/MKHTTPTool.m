//
//  MKHTTPTool.m
//  Shutterbug
//
//  Created by Mark Lewis on 16-8-13.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//  Version 0.0.1

#import "MKHTTPTool.h"

@implementation MKHTTPTool

+ (instancetype)shareInstance
{
    static MKHTTPTool *httpTool = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpTool = [[MKHTTPTool alloc] init];
        
    });
    
    return httpTool;
}

- (void)requestWithURL:(NSString *)urlstring
                params:(NSMutableDictionary *)params
            httpMethod:(NSString *)httpMethod
         completeBlock:(RequestFinishedBlock)block
{
    NSURLConnection *connection = nil;
    _finshedBlock = block;
    NSComparisonResult compareRet1 = [httpMethod caseInsensitiveCompare:@"GET"];
    NSComparisonResult compareRet = [httpMethod caseInsensitiveCompare:@"POST"];
    
    if (NSOrderedSame == compareRet1)
    {
        // 拼接url：https://api.weibo.com/2/statuses/timeline_batch.json
        // 如：https://api.weibo.com/2/statuses/timeline_batch.json?access_token=value
        // 处理get请求参数
        NSMutableString *paramsString = [NSMutableString string];
        NSArray *allkeys = [params allKeys];
        for (int i=0 ; i<params.count; i++)
        {
            NSString *key = allkeys[i];
            id value = params[key];
            
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
        
        // GET请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
        [request setTimeoutInterval:60];
        [request setHTTPMethod:@"GET"];
        
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    }
    else if(NSOrderedSame == compareRet)
    {
        // 处理post请求方式
        NSArray *allkeys = [params allKeys];
        NSMutableString *postParams = [NSMutableString stringWithCapacity:params.count];
        
        for (int i = 0; i<params.count; i++)
        {
            NSString *key = [allkeys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            [postParams appendFormat:@"%@=%@",key,value ];
            
            // 最后一个不加&
            if (i < params.count -1 )
            {
                [postParams appendString:@"&"];
            }
            
            /*
             // 判断是否是文件上传
             if ([value isKindOfClass:[NSData class]])
             {
             [request addData:value forKey:key];
             }
             else
             {
             [request addPostValue:value forKey:key];
             }
             */
        }
        
        //POST请求处理
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
        [request setTimeoutInterval:60];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[postParams dataUsingEncoding:NSUTF8StringEncoding]];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    
    // 启动连接
    if(connection) [connection start];
}

#pragma mark - Property
- (NSMutableData *)receiveData
{
    if(_receiveData == nil) _receiveData = [[NSMutableData alloc] init];
    return _receiveData;
}

#pragma mark - delegate
// 多次调用数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"网络请求Response：%@", response);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSURLRequest *originalRequest =connection.originalRequest;
    
    if([originalRequest.HTTPMethod isEqualToString:@"GET"])
    {
        // GET获取信息处理,setCompletionBlock
        NSLog(@"GET--%@网络请求完成", originalRequest.URL);
    }
    else if([originalRequest.HTTPMethod isEqualToString:@"POST"])
    {
        // POST请求处理,setCompletionBlock
        NSLog(@"发起%@请求%@", [originalRequest HTTPMethod], originalRequest.URL);
        
        id obj = [NSJSONSerialization JSONObjectWithData:_receiveData options:0 error:NULL];
        NSLog(@"POST--网络请求完成，Response Data: %@", obj);
    }
    
    float version = (float)[[[UIDevice currentDevice] systemVersion] floatValue];
    id result = nil;
    if (version >= 5.0 && _receiveData != nil)
    {
        result = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableContainers error:nil];
    }
    
    
    if (self.finshedBlock) _finshedBlock(result);
}


/*
 [request setCompletionBlock:^{
 
 NSData *data = request.responseData;
 float version = (float)[[[UIDevice currentDevice] systemVersion] floatValue];
 id result = nil;
 if (version >= 5.0)
 {
 result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 }
 
 
 if (block!=nil)
 {
 block(result);
 }
 }];
 */


@end
