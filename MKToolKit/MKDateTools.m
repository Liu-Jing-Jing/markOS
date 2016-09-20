//
//  MKDateTools.m
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-16.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//  Version 0.0.1

#import "MKDateTools.h"

@implementation MKDateTools

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];

	return str;
}

//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)weiboDateFomateString:(NSString *)datestring
{
    NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
    NSDate *createDate = [self dateFromFomate:datestring formate:formate];
    NSString *text = [self stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}
@end
