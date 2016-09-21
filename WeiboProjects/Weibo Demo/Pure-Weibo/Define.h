//
//  Define.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-23.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//
// 自定义Log
#ifdef DEBUG
#define WBLog(...) NSLog(__VA_ARGS__)
#else
#define WBLog(...)
#endif


#ifndef Pure_Weibo_Define_h
#define Pure_Weibo_Define_h

// 判断是否为ios7
#define ios7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
// 是否是4寸iPhone
#define is4Inch ([UIScreen mainScreen].bounds.size.height == 568)
// 获得RGB颜色
#define WBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 获得RGB a颜色
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


/*授权 账号相关*/
#define WBAppKey                @"2976507745"
#define WBAppSecret             @"5c6ee830403084f78424aacf7f9e1fbf"
#define WBRedirectUrl           @"https://api.weibo.com/oauth2/default.html"

// 微博开放平台接口URL
#define URL_AUTHORIZE           @"https://api.weibo.com/oauth2/authorize"
#define URL_GET_ACCESS_TOKEN    @"https://api.weibo.com/oauth2/access_token"
#define URL_HOME_TIMELINE       @"https://api.weibo.com/2/statuses/home_timeline.json"
#define URL_UNREAD_COUNT        @"https://rm.api.weibo.com/2/remind/unread_count.json"
#define URL_UPDATE              @"https://api.weibo.com/2/statuses/update.json"
#define URL_UPLOAD              @"https://upload.api.weibo.com/2/statuses/upload.json"
#define URL_POIS                @"https://api.weibo.com/2/place/nearby/pois.json"
#define URL_COMMENT             @"https://api.weibo.com/2/comments/show.json"
#define URL_STATUES_COUNT       @"https://api.weibo.com/2/statuses/count.json" // 获得指定微博的评论和转发数
#define URL_USER_SHOW           @"https://api.weibo.com/2/users/show.json"     // 获得指定用户资料
#define URL_USERS_COUNT         @"https://api.weibo.com/2/users/counts.json"   // 获得指定用户的关注，粉丝数
#define URL_FOLLOWERS           @"https://api.weibo.com/2/friendships/followers.json"//粉丝列表
#define URL_FRIENDS             @"https://api.weibo.com/2/friendships/friends.json"//关注列表
#define URL_NEARBY_TIMELINE     @"https://api.weibo.com/2/place/nearby_timeline.json" //获取某个位置周边的动态
#define URL_MENTIONS_IDS        @"https://api.weibo.com/2/statuses/mentions/ids.json"
#define URL_STATUS_MENTIONS     @"https://api.weibo.com/2/statuses/mentions.json" // 获取最新的提到登录用户的微博列表，即@我的微博


//font color keys
#define kNavigationBarTitleLabel @"kNavigationBarTitleLabel"
#define kThemeListLabel          @"kThemeListLabel"
// Notification通知----------
#define kRTLabelLinkdidSelectNotification @"kRTLableLinkdidSelectNotification"
#define kReloadWeiboTableNotification @"kReloadWeiboTable"
// UserDefault Keys
#define kThemeName @"kThemeName"
#define kBrowserMode @"kBrowserMode"
#define kLargeBrowserMode 1 // 大图浏览模式
#define kSmallBrowserMode 2 // 小图浏览模式
#endif
