//
//  MKBaseModel.h
//  Shutterbug
//
//  Created by Mark Lewis on 16-8-12.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//  Version 0.0.1

#import <Foundation/Foundation.h>

@interface MKBaseModel : NSObject<NSCoding>
-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

// - (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串
@end
