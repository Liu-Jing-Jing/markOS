//
//  UIImageView+WebDownload.h
//  Apple Store Demo
//
//  Created by Mark Lewis on 16-8-10.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//  Version 0.0.1

#import <UIKit/UIKit.h>
#define kImageDownloadFinshNotifcation @"ImageDownloadFinshNotifcation"
typedef void (^DownloadFinshBlock)(UIImage *downloadImage);

@interface UIImageView (WebDownload)

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url completionBlock:(DownloadFinshBlock)block;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completionBlock:(DownloadFinshBlock)block;

+ (void)startDownloadingImageWithURL:(NSURL *)imageURL completionBlock:(DownloadFinshBlock)block;
- (void)cancelCurrentImageLoad;
@end
