//
//  AppDelegate.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-22.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

/*
                                                __
                                               d888b
                                              888888b
                                              8888888
                                              8888888
                                              8888888
                                   _          8888888
                                 ,d88         8888888
                          ____  d88' _,,      888888'
                         (8888\ 88' d888)     Y8888P
                         ___~~8 ~8  88~___    d8888
  _______            ,8888888        ~ 888888_8888
,8888888888===__    _,d88P~~             ~~Y88888'
88888888888888888888888'                     `88b
8888888888888888888888P                       Y88
 `~888888888888~~~~~ 88                        88
     ~~~~~~~~        88                        88
                     88                        88
                     88                        88
                     88                        88
                     88    ,aa.        ,aa.    88
                     88    d88b        d88b    88
                   ,=88    Y88P        Y88P    88=,
                 ,d88P'     `'   _aa_   `'     `Y88b,     ___
                   88P'         (8888)           `Y88  ad88888b
                   88            ~^^~              88 d88Y~~"Y8b
            _______"Yb._                         _.d8"d8Y      88
 ______,d88888888ba888=,.______________________.,=8888~d88_______88___
 |~~~~~~88P~~~~~~Y88~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
 |      88        88                                                   |
 |      88        88                                                   |
 |      88ba,___,d8P                                                   |
 |       "888888888                                                    |
 |                                                                     |
 |                        W     W                                      |
 |                        W     W                                      |
 |                        W     W                                      |
 |                       W  WWWWWWWWW                                  |
 |                       W      W  W                                   |
 |                       W  W   W  W                                   |
 |                      WW   W W  W          W                         |
 |                     W W   W W W           W                         |
 |                       W     W    W       W W                        |
 |                       W  WWWWWWWW       W  W                        |
 |                       W     WW          W                           |
 |                       W    W  W                                     |
 |                       W    W   W                                    |
 |                       W   W     W                                   |
 |                       W  W       WW                                 |
 |_____________________________________________________________________|
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 */


#import <UIKit/UIKit.h>

@class SinaWeibo;
@class MainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong)SinaWeibo *sinaweibo;
@property (nonatomic, strong) MainViewController *mainCtrl;
+ (NSString *)applicationDocumentsDirectoryFile;
@end
