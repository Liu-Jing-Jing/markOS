//
//  MKWebImageCacheTool.m
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-16.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import "MKWebImageCacheTool.h"
#import "MKSQLightManager.h"
#define kTableName @"WebImageTable"


@implementation MKWebImageCacheTool


+ (void)saveImageWithURL:(NSString *)url imageData:(NSData *)data
{
    // 首先创建数据库
    [MKSQLightManager shareManagerWithCreateTextTableName:kTableName andCellNames:@[@"imageURL", @"path"]];
    
    //NSString *nowDataStr = [MKDateTools stringFromFomate:[NSDate date] formate:@"YYYY_MM_dd_HH:mm:ss"];
    //nowDataStr = [nowDataStr stringByAppendingString:@" CachedImage.png"];
    // NSString *imageFilePath = [[self applicationCacheDirectoryFile] stringByAppendingPathComponent:nowDataStr];

    NSString *path = [NSString stringWithFormat:@"%@/%@.png", [self applicationCacheDirectoryFile], [[NSProcessInfo processInfo] globallyUniqueString]];
    // 然后保存数据
    [data writeToFile:path atomically:YES];
    
    
    // 保存这条记录到数据库
    MKWebImageCacheTool *insertModel = [[MKWebImageCacheTool alloc] init];
    insertModel.imageURL = url;
    insertModel.path = path;
    [[MKSQLightManager shareManager] insert:insertModel toTable:kTableName andHeaderNames:@[@"imageURL", @"path"]];
}


+ (NSData *)searchLocalDataWithURL:(NSString *)url
{
    MKWebImageCacheTool *searchModel = [[MKWebImageCacheTool alloc] init];
    searchModel.imageURL = url;
    
    // 查询记录
    MKWebImageCacheTool *result = [[MKSQLightManager shareManager] searchWithPrimaryKey:searchModel
                                                fromTable:kTableName
                                           andHeaderNames:@[@"imageURL", @"path"]];
    return [NSData dataWithContentsOfFile:result.path];
}



+ (NSString *)applicationCacheDirectoryFile
{
    // 修改第一个参数可以获得Library路径，和Caches文件夹路径
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // NSString *filePath = [documentDirectory stringByAppendingString:@"/MKImageCache"];
	return documentDirectory;
}
@end
