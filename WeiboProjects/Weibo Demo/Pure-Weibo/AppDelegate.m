//
//  AppDelegate.m
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-22.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//


#import "AppDelegate.h"
#import "MainViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "SinaWeibo.h"
#import "Define.h"

@implementation AppDelegate


//初始化微博对象
- (void)_initSinaWeibo
{
    _sinaweibo = [[SinaWeibo alloc] initWithAppKey:WBAppKey appSecret:WBAppSecret appRedirectURI:WBRedirectUrl andDelegate:_mainCtrl];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        _sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        _sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        _sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    _mainCtrl = [[MainViewController alloc] init];
        //初始化左右菜单
    //LeftViewController *leftCtrl = [[LeftViewController alloc] init];
    //RightViewController *rightCtrl = [[RightViewController alloc] init];
    

    //_menuCtrl = [[DDMenuController alloc] initWithRootViewController:_mainCtrl];
    //_menuCtrl.leftViewController = leftCtrl;
    //_menuCtrl.rightViewController = rightCtrl;
    
    //初始化微博对象
    [self _initSinaWeibo];
    
    self.window.rootViewController = _mainCtrl;
    return YES;
}


+ (NSString *)applicationDocumentsDirectoryFile
{
    // 修改第一个参数可以获得Library路径，和Caches文件夹路径
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
	return documentDirectory;
}
@end
