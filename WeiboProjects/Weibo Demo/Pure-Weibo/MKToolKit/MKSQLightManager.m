//
//  MKSQLightManager.m
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-16.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import "MKSQLightManager.h"

@implementation MKSQLightManager

static MKSQLightManager *manager = nil;
+ (MKSQLightManager *)shareManagerWithCreateTextTableName:(NSString *)tableName andCellNames:(NSArray *)names
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MKSQLightManager alloc] init];
        //方法只执行一次
        NSLog(@"数据库地址: %@", [manager applicationDocumentsDirectoryFile]);
        [manager createDatabaseTableIfNeeded:tableName andHeaderNames:names];
    });
    return manager;
}

+ (MKSQLightManager *)shareManager
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (manager && [fm fileExistsAtPath:[manager applicationDocumentsDirectoryFile]])
    {
        // 数据库文件路径存在
        return manager;
    }
    else
    {
        return nil;
    }
}


- (void)createDatabaseTableIfNeeded:(NSString *)tableName andHeaderNames:(NSArray *)names
{
    NSString *writeTablePath = [self applicationDocumentsDirectoryFile];
    
    // NSLog(@"数据库地址: %@", writeTablePath);
    
    //打开数据库:
    //第一个参数 是数据库文件的完整路径
    //第二个参数 数据库DB对象
    if(sqlite3_open([writeTablePath UTF8String], &db) != SQLITE_OK)
    {
        // fail
        sqlite3_close(db);
        NSAssert(NO, NSLocalizedString(@"Error_Desc", @"打开数据库失败"));
    }
    else
    {
        char *err;
        NSMutableString *createSQL = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, ", tableName, names[0]];
        
        for (int i=1; i<names.count; i++)
        {
            [createSQL appendFormat:@"%@ TEXT", names[i]];
            
            if(i <names.count-1)
            {
                // 不是最后一个元素
                [createSQL appendString:@", "];
            }
            else
            {
                [createSQL appendString:@")"];
            }
        }
        

        
        
        // SQL语句执行操作
        //第一个参数 数据库db对象
        //第二个参数 SQL语句
        //第三四个参数 回调函数、回调函数需要的参数
        //第五个参数 是一个char *类型的错误信息
        if(sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK)
        {
            // fail
            sqlite3_close(db);
            NSAssert(NO, NSLocalizedString(@"Error_Desc", @"SQL语句执行失败"));
            NSAssert1(NO, @"建表失败, 错误信息: %s", err);
        }
        //
        sqlite3_close(db);
    }
    
}

- (int)insert:(id)model toTable:(NSString *)tableName andHeaderNames:(NSArray *)names
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    
    //1.打开数据库
    if(sqlite3_open([path UTF8String], &db) != SQLITE_OK)
    {
        // fail
        sqlite3_close(db);
        NSAssert(NO, NSLocalizedString(@"Error_Desc", @"打开数据库失败"));
    }
    else
    {   // 第二步预处理
        // ? 代表占位符
        NSMutableString *insertSQL = [NSMutableString stringWithFormat:@"INSERT OR REPLACE INTO %@ (", tableName];
        NSMutableString *sqlLastPart = [NSMutableString stringWithString:@" VALUES("];
        for (int i=0; i<names.count; i++)
        {
            [insertSQL appendFormat:@"%@", names[i]];
            [sqlLastPart appendString:@"?"];
            if(i <names.count-1)
            {
                // 不是最后一个元素
                [insertSQL appendString:@", "];
                [sqlLastPart appendString:@", "];
            }
            else
            {
                [insertSQL appendString:@")"];
                [sqlLastPart appendString:@")"];
            }
        }

        [insertSQL appendString:sqlLastPart];
        // @"INSERT OR REPLACE INTO StudentName (idNum , name) VALUES(?, ?)";
        sqlite3_stmt *statement; // 这是一个语句对象, 预处理需要这个对象执行操作
        
        if(sqlite3_prepare_v2(db, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            // 第三步绑定操作
            for (int i=0; i<names.count; i++)
            {
                NSString *bindParam = nil;
                SEL getSel = NSSelectorFromString(names[i]);
                if([model respondsToSelector:getSel])
                {
                    NSMethodSignature *signature = nil;
                    signature = [model methodSignatureForSelector:getSel];
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    [invocation setTarget:model];
                    [invocation setSelector:getSel];
                    __autoreleasing NSObject *valueObj = nil;
                    [invocation invoke];
                    [invocation getReturnValue:&valueObj];
                    
                    
                    // bindParam = (NSString *)[model performSelector:sel withObject:nil];
                    bindParam = (NSString *)valueObj;
                }
                
                sqlite3_bind_text(statement, i+1, [bindParam UTF8String], -1, NULL);

            }
            // sqlite3_bind_text(statement, 2, [model.name UTF8String], -1, NULL);
            
            // 第四部执行语句
            if(sqlite3_step(statement) != SQLITE_DONE)
            {
                NSAssert(NO, @"插入数据失败");
            }
            
            // 第五步执行成功，释放资源
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return 0; // SQLITE_OK
        }
    }
    
    return SQLITE_ERROR;
}

- (id)searchWithPrimaryKey:(id)model fromTable:(NSString *)tableName andHeaderNames:(NSArray *)names
{
    // 查询数据一共六个步骤
    NSString *writeTablePath = [self applicationDocumentsDirectoryFile];
    //NSLog(@"数据库地址: %@", writeTablePath);
    
    //1.打开数据库
    if(sqlite3_open([writeTablePath UTF8String], &db) != SQLITE_OK)
    {
        // fail
        sqlite3_close(db);
        NSAssert(NO, NSLocalizedString(@"Error_Desc", @"打开数据库失败"));
    }
    else
    {   // 第二步预处理
        // ? 代表占位符
        
        NSMutableString *paramsWithComma = [NSMutableString string];
        
        for (int i=0; i<names.count; i++)
        {
            if(i <names.count-1)
            {
                // 不是最后一个元素
                [paramsWithComma appendFormat:@"%@, ", names[i]];
            }
            else
            {
                [paramsWithComma appendString:names[i]];
            }
        }
        
        NSMutableString *qSQL = [NSMutableString stringWithFormat:@"SELECT %@ FROM %@", paramsWithComma, tableName];
        [qSQL appendFormat:@" WHERE %@=?", [names firstObject]];
        // NSString *qSQL = @"SELECT idNum , name FROM StudentName Where idNum = ?";
        sqlite3_stmt *statement; // 这是一个语句对象, 预处理需要这个对象执行操作
        
        //第一个参数 数据库db对象
        //第二个参数 SQL语句
        //第三个参数 执行SQL语句的长度,
        //第四个参数 语句对象statement
        //第五个参数 没有执行的语句部分
        if(sqlite3_prepare_v2(db, [qSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            // 预处理成功，开始查询操作
            // NSString *idNum = model.idNum;
            
            //第三步.绑定操作，介绍SQL中？占位符是什么
            
            //第一个参数 statement语句对象
            //第二个参数 参数开始执行的序号
            //第三个参数 我要绑定的参数
            //第四个参数 绑定的字符串长度，-1代表全部执行
            //第五个参数 函数指针， NULL
            
            NSString *bindParam = nil;
            SEL getSel = NSSelectorFromString(names[0]);
            if([model respondsToSelector:getSel])
            {
                NSMethodSignature *signature = nil;
                signature = [model methodSignatureForSelector:getSel];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                [invocation setTarget:model];
                [invocation setSelector:getSel];
                __autoreleasing NSObject *valueObj = nil;
                [invocation invoke];
                [invocation getReturnValue:&valueObj];
                
                
                // bindParam = (NSString *)[model performSelector:sel withObject:nil];
                bindParam = (NSString *)valueObj;
            }

            sqlite3_bind_text(statement, 1, [bindParam UTF8String], -1, NULL);
            
            //第一个参数 statement语句对象
            //变量结果
            // statement对象包装了SQL语句和绑定好的参数，然后函数开始执行这个statement
            if(sqlite3_step(statement) == SQLITE_ROW) //SQLITE_ROW代表查出来，Row存在
            {   // 变量结果
                // 遍历到要查询的ROW时，开始提取操作(第五步)
                // 提取值的函数
                //第一个参数 statement语句对象
                //第二个参数 这个字段的索引(指的是Select查询语句写的顺序，第81行idNum写在了前面)
                
                // NSLog(@"%@", [model class]);
                id result = [[[model class] alloc] init];

                for (int i=0; i<names.count; i++)
                {
                    char *value = (char *)sqlite3_column_text(statement, i);
                    NSString *valueStr = [NSString stringWithUTF8String:value];
                    
                    // 使用setter的SEL给model赋值
                    // Model中每个Property的setter方法的SEL
                    SEL setterSel = [self getSetterSelWithAttibuteName:names[i]];
                    if ([result respondsToSelector:setterSel])
                    {
                        [result performSelectorOnMainThread:setterSel
                                                 withObject:valueStr
                                              waitUntilDone:[NSThread isMainThread]];
                    }
                }
                //char *primaryValue = (char *)sqlite3_column_text(statement, 0);
                //char *name = (char *)sqlite3_column_text(statement, 1);
                
                // 赋值操作
                //StudentModel *result = [[StudentModel alloc] init];
                //result.idNum = [NSString stringWithUTF8String:idNum];
                //result.name = [NSString stringWithUTF8String:name];
                
                // 操作成功之后要进行资源释放
                sqlite3_finalize(statement);
                sqlite3_close(db);
                return result;
            }
            
            //end--prepare_V3
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        // NSAssert(NO, NSLocalizedString(@"Error_Desc", @"预处理操作失败"));
    }
    
    return nil;
}

-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName
{
	NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
	NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
	return NSSelectorFromString(setterSelStr);
}


- (NSString *)applicationDocumentsDirectoryFile
{
    // 修改第一个参数可以获得Library路径，和Caches文件夹路径
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:kFileName];
    
	return filePath;
}
@end
