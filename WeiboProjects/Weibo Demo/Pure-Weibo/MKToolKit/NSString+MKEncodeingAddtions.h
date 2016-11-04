//
//  NSString+MKEncodeingAddtions.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-15.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MKEncodeingAddtions)

-(NSString *)URLEncodedString;
-(NSString *)URLDecodedString;
@end
