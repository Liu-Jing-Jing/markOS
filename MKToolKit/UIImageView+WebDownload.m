//
//  UIImageView+WebDownload.m
//  Apple Store Demo
//
//  Created by Mark Lewis on 16-8-10.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//  Version 0.0.1


#import "UIImageView+WebDownload.h"
#import "MKWebImageCacheTool.h"

static NSURLSessionDownloadTask *task;


@implementation UIImageView (WebDownload)
- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self downloadingImageWithURL:url andPlacehoder:placeholder completionBlock:NULL];
}

- (void)setImageWithURL:(NSURL *)url completionBlock:(DownloadFinshBlock)block
{
    [self downloadingImageWithURL:url andPlacehoder:nil completionBlock:block];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completionBlock:(DownloadFinshBlock)block
{
    [self downloadingImageWithURL:url andPlacehoder:placeholder completionBlock:block];
}

- (void)cancelCurrentImageLoad
{
    if(task)
    {
        [task suspend];
    }
}

- (void)downloadingImageWithURL:(NSURL *)imageURL andPlacehoder:(UIImage *)placeholder completionBlock:(DownloadFinshBlock)block
{
    // 先清空原有的图片
    if(placeholder == nil)
    {
        self.image = nil;
    }
    else
    {
        if([self.image isEqual:placeholder]) self.image = nil;
    }
    
    if(imageURL)
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
        // 3种，默认，后台，还有这个暂时的
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        // 实例化Session必须要NSURLSessionConfiguration
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSTimer *taskTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                              target:self
                                                            selector:@selector(cancelCurrentImageLoad)
                                                            userInfo:nil
                                                             repeats:NO];
        [taskTimer tolerance];
        //[taskTimer fire];
        
        // #warning 查找数据库，是否存在imageURL主键的数据
        NSData *imageData = [MKWebImageCacheTool searchLocalDataWithURL:request.URL.absoluteString];
        if(imageData != nil)
        {
            UIImage *image = [UIImage imageWithData:imageData];
            self.image = image;
            // if(block != NULL) block(image);
            return;
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                  completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                      // this handler is not executing on the main queue, so we can't do UI directly here
                                                      
                                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                      if(!error)
                                                      {
                                                          // 没有错误
                                                          if ([request.URL isEqual:imageURL])
                                                          {
                                                              // 确认现在下载的是地址和传入的参数一致，减少资源浪费
                                                              // UIImage可以在非mainQueue中执行操作，不是UI操作就可以保证线程安全
                                                              NSData *imageData = [NSData dataWithContentsOfURL:location];
                                                              UIImage *downloadedImage = [UIImage imageWithData:imageData];
                                                              
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  // 在主线程上执行UI操作
                                                                  self.image = downloadedImage;
                                                                  if(block != NULL) block(downloadedImage);
                                                              
                                                                  // 保存下载的数据到数据库
                                                                  [MKWebImageCacheTool saveImageWithURL:request.URL.absoluteString imageData:imageData];
                                                              
                                                                  
                                                                  // POST Notification
                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:kImageDownloadFinshNotifcation object:nil];
                                                              });
                                                          }
                                                      }
                                                  }];
        
        // don't forget that all NSURLSession tasks start out suspended!
        [task resume]; // start task
    }
}

+ (void)startDownloadingImageWithURL:(NSURL *)imageURL completionBlock:(DownloadFinshBlock)block
{
    
    if (imageURL)
    {
        // [self.spinner startAnimating];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
        
        // another configuration option is backgroundSessionConfiguration (multitasking API required though)
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        // create the session without specifying a queue to run completion handler on (thus, not main queue)
        // we also don't specify a delegate (since completion handler is all we need)
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                                                            // this handler is not executing on the main queue, so we can't do UI directly here
                                                            if (!error)
                                                            {
                                                                if ([request.URL isEqual:imageURL])
                                                                {
                                                                    // UIImage is an exception to the "can't do UI here"
                                                                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                                                                    // but calling "self.image =" is definitely not an exception to that!
                                                                    // so we must dispatch this back to the main queue
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        // returnImage = image;
                                                                        block(image);
                                                                    });
                                                                }
                                                            }
                                                        }];
        [task resume]; // don't forget that all NSURLSession tasks start out suspended!
    }
}

@end
