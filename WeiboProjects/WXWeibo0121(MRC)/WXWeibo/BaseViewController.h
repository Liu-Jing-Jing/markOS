//
//  BaseViewController.h
//  WXWeibo
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@interface BaseViewController : UIViewController

- (SinaWeibo *)sinaweibo;


@property (nonatomic,assign)BOOL isCancelButton;
// 加载提示
@property (nonatomic, retain) MBProgressHUD *hub;
- (void)showHUBLoadingTitle:(NSString *)title withDim:(BOOL)isDim;
- (void)showHUBLoading;
- (void)hideHUBLoading;
-(void)showHUBComplete:(NSString *)title;
- (AppDelegate *)appDelegate;
@end
