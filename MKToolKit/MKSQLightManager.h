//
//  MKSQLightManager.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-16.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKEntityModel.h"
#import <sqlite3.h>
#define kFileName (@"MKDatabase.sqlite")

@interface MKSQLightManager : NSObject
{
    sqlite3 *db; //sqliteDB
}

+ (MKSQLightManager *)shareManager;
+ (MKSQLightManager *)shareManagerWithCreateTextTableName:(NSString *)tableName andCellNames:(NSArray *)names;
// - (int)insert:(id)model;
- (int)insert:(id)model toTable:(NSString *)tableName andHeaderNames:(NSArray *)names;
- (id)searchWithPrimaryKey:(id)model fromTable:(NSString *)tableName andHeaderNames:(NSArray *)names;


@end
