//
//  HomeViewController.m
//  WXWeibo

#import "HomeViewController.h"
#import "MainViewController.h"
#import "WeiboModel.h"
#import "RTLabel.h"
#import "WeiboWebController.h"
#import "MainViewController.h"
#import "DetailViewController.h"
#import "WBLoginViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MJRefresh/MJRefresh.h"
@interface HomeViewController ()
@property (nonatomic, retain) NSArray *weiboData;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Weibo";        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //绑定按钮
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定账号" style:UIBarButtonItemStyleBordered target:self action:@selector(bindAction:)];
    self.navigationItem.rightBarButtonItem = bindItem;
    
    //注销按钮
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction:)];
    self.navigationItem.leftBarButtonItem = logoutItem;
    
    self.tableView.hidden = YES;
    
    //判断是否认证
    if (self.sinaweibo.isAuthValid)
    {
        //加载微博列表数据
        NSLog(@"已经认证");
        self.navigationItem.leftBarButtonItem = logoutItem;
        self.navigationItem.rightBarButtonItem = nil;
        [self loadWeiboData];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = bindItem;
        [self.sinaweibo logIn];
    }
    
    [self setupRefreshView];
//    NSLog(@"HomeVC tableview %p", self.tableView);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(MainViewController *)self.tabBarController showTabbar:YES];
    // turn on DDMenu
    // [[[self appDelegate] menuCtrl] setEnableGesture:YES];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // disable the DDMenu Gesture
    // [[[self appDelegate] menuCtrl] setEnableGesture:NO];
}

#pragma mark - UI
- (void)showNewWeiboCount:(int)count
{
    if(_barView == nil)
    {
        _barView = [UIFactory createImageView:@"timeline_more_button_selected.png"];
        UIImage *image = [_barView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        _barView.image = image;
        _barView.topCapHeight = 5;
        _barView.leftCapWidth = 5;
        _barView.frame = CGRectMake(5, -40, ScreenWidth-10, 40);
        [self.navigationController.navigationBar addSubview:_barView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = 200;
        label.font = [UIFont systemFontOfSize:16];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [_barView addSubview:label];
    }
    
    
    if(count>=0)
    {
        UILabel *label = (UILabel *)[_barView viewWithTag:200];
        label.text = [NSString stringWithFormat:@"%d条新微博", count];
        [label sizeToFit];
        label.origin = CGPointMake((_barView.width-label.width)/2, (_barView.height-label.height)/2);
        
        [UIView animateWithDuration:0.6
                         animations:^{
                             _barView.top = 3;
                         }
                         completion:^(BOOL finished) {
                             if(finished)
                             {
                                 [UIView beginAnimations:nil context:nil];
                                 [UIView setAnimationDelay:1];
                                 [UIView setAnimationDuration:0.6];
                                 _barView.top = -70;
                                 
                                 [UIView commitAnimations];
                             }
                         }];
    }
    
    
    // 播放提示声音
    SystemSoundID  soundID = 0;
    if (soundID == 0)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"wav"];
        NSURL *fileURL = [NSURL URLWithString:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    
    MainViewController *mainController = (MainViewController *)[self tabBarController];
    [mainController hideBadge];
    
    
}

- (void)setupRefreshView
{
    [self.tableView addHeaderWithTarget:self action:@selector(pullDownAction)];
    
    [self.tableView addFooterWithTarget:self action:@selector(pullUpAction)];
}

#pragma mark - load Data
- (void)loadWeiboData
{
    // 显示加载提示
    [super showHUBLoadingTitle:@"Loading..." withDim:YES];
    
    NSString *requestURL = [WBWeiboTool URLAppendingAccessTokenWithQueryPath:URL_HOME_TIMELINE];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    /*
     access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     count	false	int	单页返回的记录条数，最大不超过100，默认为20。
     page	false	int	返回结果的页码，默认为1。
     */
    
    [[MKHTTPTool shareInstance] requestWithURL:requestURL
                                        params:params
                                    httpMethod:@"GET"
                                 completeBlock:^(id result) {
                                     // timeline数据
                                     [self reqestDidFinishWithResult:result];
                                     
                                 }];
}


// 下拉加载最新微博
- (void)pullDownAction
{
    [self pullDownLoadingData];
}

- (void)pullDownLoadingData
{
    if(self.topWeibiID.length == 0)
    {
        NSLog(@"Weibo id is null");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[@"20", self.topWeibiID] forKeys:@[@"count", @"since_id"]];
    NSString *requestURL = [WBWeiboTool URLAppendingAccessTokenWithQueryPath:URL_HOME_TIMELINE];
    /*
     access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     count	false	int	单页返回的记录条数，最大不超过100，默认为20。
     page	false	int	返回结果的页码，默认为1。
     */
    [[MKHTTPTool shareInstance] requestWithURL:requestURL
                                        params:params
                                    httpMethod:@"GET"
                                 completeBlock:^(id result) {
                                     // 下拉请求数据
                                     [self pullDownFinishData:result];
                                     [self.tableView headerEndRefreshing];
                                 }];

}

- (void)pullDownFinishData:(id)result
{
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues)
    {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [newArray addObject:weibo];
    }
    

    [newArray addObjectsFromArray:self.weibos];
    self.weibos = newArray;
    self.tableView.data = _weibos;
    if (newArray.count > 0)
    {
        WeiboModel *topWeibo = newArray[0];
        self.topWeibiID = [topWeibo.weiboId stringValue];
    }
    
    
    // refresh UI
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (int i = 0; i < _weibos.count; i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
        [indexPathArray addObject:path];
    }
    //弹回下拉刷新控件
    [self.tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.2];
    [self.tableView reloadData];
    
    // 显示更新微博的条数
    int updataCount = (int)statues.count;
    NSLog(@"下拉更新, 获得%d条新微博", updataCount);
    [self showNewWeiboCount:updataCount];
    
}

// 上拉调用，协议方法
- (void)pullUpAction;
{
    [self pullUpData];
}

// 上拉加载最新微博
- (void)pullUpData
{
    if(self.lastWeibiID.length == 0)
    {
        NSLog(@"Weibo id is null");
        return;
    }
    
    NSString *requestURL = [WBWeiboTool URLAppendingAccessTokenWithQueryPath:URL_HOME_TIMELINE];
    /*
     access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     count	false	int	单页返回的记录条数，最大不超过100，默认为20。
     page	false	int	返回结果的页码，默认为1。
     */

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[@"20", self.lastWeibiID] forKeys:@[@"count", @"max_id"]];
    
    [[MKHTTPTool shareInstance] requestWithURL:requestURL
                                        params:params
                                    httpMethod:@"GET"
                                 completeBlock:^(id result) {
                                     //上拉刷新请求完成
                                     [self pullUpFinishData:result];
                                     [self.tableView footerEndRefreshing];
                                 }];
}

// 上拉加载完成
- (void)pullUpFinishData:(id)result
{
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues)
    {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [newArray addObject:weibo];
    }
    
    // 更新last ID
    if (newArray.count > 0)
    {
        WeiboModel *lastWeibo = [newArray lastObject];
        self.lastWeibiID = [lastWeibo.weiboId stringValue];
        
        // 去掉重复的微博
        [newArray removeObjectAtIndex:0];
    }
    [self.weibos addObjectsFromArray:newArray];

    
    if(statues.count<20)
    {
        self.tableView.isMore = NO;
    }
    else
    {
        self.tableView.isMore = YES;
    }
    // refresh UI
    self.tableView.data = self.weibos;
    [self.tableView reloadData];

}

#pragma mark - SinaWeiboRequest delegate
//网络加载失败
//- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
//{
//    NSLog(@"网络加载失败:%@",error);
//}


//网络加载完成
//- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
//{
//    
//    /*
//     // 获得用户的关注列表
//     NSLog(@"网络加载完成");
//     NSArray *users = [result objectForKey:@"users"];
//     NSMutableArray *usersList = [NSMutableArray array];
//     for (NSDictionary *userDic in users)
//     {
//     UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
//     [usersList addObject:user];
//     [user release];
//     }
//     
//     for (UserModel *user in usersList)
//     {
//     NSLog(@"%@", user.screen_name);
//     }
//     
//     */
//}

- (void)reqestDidFinishWithResult:(id)result
{
    // 隐藏HUB，显示table view
    [super hideHUBLoading];
    self.tableView.hidden = NO;
    
    
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues)
    {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
    }
    
    self.weibos = weibos;
    self.tableView.data = weibos;
    if(weibos.count > 0)
    {
        WeiboModel *topWeibo = weibos[0];
        self.topWeibiID = [topWeibo.weiboId stringValue];
        
        WeiboModel *lastWeibo = [weibos lastObject];
        self.lastWeibiID = [lastWeibo.weiboId stringValue];
    }
    
    
    // refresh
    [self.tableView reloadData];
    //    NSLog(@"data:\n%@",weibos);
}

#pragma mark - actions
- (void)bindAction:(UIBarButtonItem *)buttonItem
{
    [self.sinaweibo logIn];
//    
//    WBLoginViewController *loginVC = [[WBLoginViewController alloc] init];
//    BaseNavigationController *baseNVC = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
//    [self presentViewController:baseNVC animated:YES completion:NULL];
}

- (void)logoutAction:(UIBarButtonItem *)buttonItem
{
    [self.sinaweibo logOut];
    //[WBAccountTool logoutAccount];
}

#pragma mark - Memery Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /*
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kRTLabelLinkdidSelectNotification
                                                  object:nil];
     */
}

#pragma mark - 去掉TableViewseparatorInset的线段偏移量
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,6,0,6)];
    }
    
    // if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    // {
    //    [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,6,0,6)];
    //}
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,6,0,6)];
    }
    
    //if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    //{
    //    [cell setLayoutMargins:UIEdgeInsetsMake(0,6,0,6)];
    //}
}


#pragma mark - 下拉刷新的委托TableView even delegate method
//- (void)pullDown:(BaseTableView *)tableView
//{
//    // NSLog(@"pull down");
//    // 请求网络数据
//    [self pullDownLoadingData];
//    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
//}




- (void)LinkdidSelectWithURLString:(NSURL *)url
{
    WeiboWebController *vc  =[[WeiboWebController alloc] init];
    vc.urlString = url;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    NSString *absoluteString = [url absoluteString];
    
    if ([absoluteString hasPrefix:@"user"])
    {
        // @用户
        NSString *linkString = [url host];
        linkString = [linkString URLDecodedString];
        //NSLog(@"用户：%@", linkString);
    }
    else if ([absoluteString hasPrefix:@"topic"])
    {
        // 话题
        NSString *linkString = [url host];
        linkString = [linkString URLDecodedString];
        //NSLog(@"话题：%@", linkString);
        
    }
    else if ([absoluteString hasPrefix:@"http"])
    {
        // 网页超链接
        //NSLog(@"%@", [absoluteString URLDecodedString]);
        
        // [self LinkdidSelectWithURLString:url];
    }
    
}
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tableView becomeFirstResponder];
}
@end
