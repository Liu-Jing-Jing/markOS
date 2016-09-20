//
//  NSString+MKEncodeingAddtions.m
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-15.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//  Version 0.0.1

#import "NSString+MKEncodeingAddtions.h"

@implementation NSString (MKEncodeingAddtions)

- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              CFSTR("!*'();:@&amp;=+$,/?%#[] "),
                                                              kCFStringEncodingUTF8));
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                              (CFStringRef)self,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    return result;
}

@end
