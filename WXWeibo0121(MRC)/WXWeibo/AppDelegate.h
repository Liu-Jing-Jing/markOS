//
//  AppDelegate.h
//  WXWeibo


#import <UIKit/UIKit.h>
#import "DDMenuController.h"
@class SinaWeibo;
@class MainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)SinaWeibo *sinaweibo;
@property(nonatomic,retain)MainViewController *mainCtrl;
@property (nonatomic, retain) DDMenuController *menuCtrl;

@end
