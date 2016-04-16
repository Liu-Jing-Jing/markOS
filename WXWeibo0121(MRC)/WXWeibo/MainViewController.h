//
//  MainViewController.h
//  WXWeibo

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
@class AppDelegate;
@interface MainViewController : UITabBarController<SinaWeiboDelegate>
{
    UIView *_tabbarView;
    UIView *badgeView;
}

- (void)hideBadge;
- (void)showTabbar:(BOOL)isShow;
@end
