//
//  MKWebImageCacheTool.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-16.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//  Version 0.0.1

#import <Foundation/Foundation.h>
@interface MKWebImageCacheTool : NSObject

@property (nonatomic, strong) NSString *imageURL; //note
@property (nonatomic, strong) NSString *path; //note

+ (void)saveImageWithURL:(NSString *)url imageData:(NSData *)data;
+ (NSData *)searchLocalDataWithURL:(NSString *)url;
+ (NSString *)applicationCacheDirectoryFile;
@end
