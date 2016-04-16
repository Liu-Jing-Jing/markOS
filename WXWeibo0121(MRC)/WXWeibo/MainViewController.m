//
//  MainViewController.m
//  WXWeibo

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
@interface MainViewController ()<UINavigationControllerDelegate>
{
    HomeViewController *_home;
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //WeChat RGBColorSpace 0.132811 0.68377 0.102996 1
        self.tabBar.tintColor = [UIColor colorWithRed:0.132811 green:0.68377 blue:0.102996 alpha:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // self.hidesBottomBarWhenPushed = YES;
    [self _initViewController];
    
    // 每60秒请求未读微博数目的接口
    [NSTimer scheduledTimerWithTimeInterval:30
                                     target:self
                                   selector:@selector(timerAction:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTabbar:(BOOL)isShow
{
    if(isShow)
    {
        // self.tabBar.hidden = NO;
        UIView *v = self.tabBar;
        if ([v isKindOfClass:[UITabBar class]] && v.bottom >self.view.bottom)
        {
            
            [UIView animateWithDuration:0.33 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
                
                CGRect frame = v.frame;
                frame.origin.y -= 49.0f;
                v.frame = frame;
                
            }completion:^(BOOL complete){
                // isAnimating = NO;
            }];
            
        }
    }
    else
    {
        // self.tabBar.hidden = YES;
        UIView *v = self.tabBar;
        if ([v isKindOfClass:[UITabBar class]])
        {
            
            [UIView animateWithDuration:0.33 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
                
                CGRect frame = v.frame;
                frame.origin.y += 49.0f;
                v.frame = frame;
                
            }completion:^(BOOL complete){
                // isAnimating = NO;
            }];
            
        }

    }
}

#pragma mark - UI
//初始化子控制器
- (void)_initViewController
{
    _home = [[HomeViewController alloc] init];
    MessageViewController *message = [[MessageViewController alloc] init];
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    // MoreViewController *more = [[MoreViewController alloc] init];
    
    NSArray *views = @[_home,message,discover,profile];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *viewController in views)
    {
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        nav.delegate = self;
        [viewControllers addObject:nav];
        [nav release];
    }
    NSArray *tabNormalBackgroud = @[@"tabbar_home.png",@"tabbar_message_center.png",@"tabbar_discover.png",@"tabbar_profile.png",@"tabbar_more.png"];
    self.viewControllers = viewControllers;
    
    for (int i=0; i < viewControllers.count; i++)
    {
        UIViewController *vc = viewControllers[i];
        vc.tabBarItem.image = [UIImage imageNamed:tabNormalBackgroud[i]];
    }

}

- (void)refreshUnreadView:(NSDictionary *)result
{
    // Unread count
    NSNumber *status = result[@"status"];
    int n = [status intValue];
    if (n>0)
    {
        NSString *badgeValue;
        if (n<100)
        {
            badgeValue = [NSString stringWithFormat:@"%d", n];
        }
        else
        {
            badgeValue = @"99+";
        }
        
        [(UITabBarItem *)self.tabBar.items[0] setBadgeValue:badgeValue];
    }
    else
    {
        [(UITabBarItem *)self.tabBar.items[0] setBadgeValue:nil];
    }
    
}

- (void)hideBadge
{
    [(UITabBarItem *)self.tabBar.items[0] setBadgeValue:nil];
}

#pragma mark - handle data
- (void)loadUnreadData
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegate.sinaweibo;
    [sinaweibo requestWithURL:@"remind/unread_count.json"
                       params:nil
                   httpMethod:@"GET"
                        block:^(NSDictionary *result) {
                            //
                            [self refreshUnreadView:(NSDictionary *)result];
                        }];
    
}


- (void)timerAction:(NSTimer *)timer
{
    [self loadUnreadData];
}
#pragma mark - SinaWeibo delegate
// 登录成功协议方法
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    //保存认证的数据到本地
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_home loadWeiboData];
}

// 注销协议方法
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    //移除认证的数据
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];  // 注意要添加同步代码，可能导致崩溃
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");    
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    // 得到navigation栈中子控制器的个数
    int count = navigationController.viewControllers.count;
    if (count == 2)
    {
        [self showTabbar:NO];
    }
    else if(count == 1)
    {
        [self showTabbar:YES];
    }
}

/*  TabBar动画代码
    for (UIView *v in [self.view subviews])
    {
        if ([v isKindOfClass:[UITabBar class]])
        {
            
            [UIView animateWithDuration:3.4 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
                
                CGRect frame = v.frame;
                frame.origin.y += 49.0f;
                v.frame = frame;
                
            }completion:^(BOOL complete){
                // isAnimating = NO;
            }];
            
        }
        else
        {
            
            // isAnimating = YES;
            
            [UIView animateWithDuration:0.4 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
                
                CGRect frame = v.frame;
                frame.size.height += 49.0f;
                v.frame = frame;
                
            } completion:nil];
        }
    }
    
}
 */
@end
