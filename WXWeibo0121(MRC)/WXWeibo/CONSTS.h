//
//  CONSTS.h
//  WXWeibo

#ifndef WXWeibo_CONSTS_h
#define WXWeibo_CONSTS_h

#endif

//weibo OAuthu2.0
#define kAppKey @"2855665223"
#define kAppSecret @"74ef9ea560a8b59da91dc5edeaaf9dd0"
#define kAppRedirectURI @"https://api.weibo.com/oauth2/default.html"


//颜色
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


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


//---------------URL----------------
#define URL_POIS @"place/nearby/pois.json"
#define URL_HOME_TIMELINE @""
#define URL_COMMENT
#define URL_UPDATE
#define URL_UPLOAD
#define URL_USER_SHOW
#define URL_TIMELINE
#define URL_FOLLOWERS       @"friendships/followers.json"//粉丝列表
#define URL_FRIENDS         @"friendships/friends.json"//关注列表
