//
//  MKBaseModel.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-23.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKBaseModel : NSObject

- (id)initWithDataDic:(NSDictionary *)data;
- (void)setAttributes:(NSDictionary *)dataDic;
- (NSDictionary *)attributeMapDictionary;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;
@end
