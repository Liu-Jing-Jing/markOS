//
//  UIButton+WebCache.h
//  WXWeibo

#import <UIKit/UIKit.h>
#import "SDWebImageManagerDelegate.h"

@interface UIButton (WebCache)<SDWebImageManagerDelegate>

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)cancelCurrentImageLoad;

@end
