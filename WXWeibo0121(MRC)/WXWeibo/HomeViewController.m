//
//  HomeViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "HomeViewController.h"
#import "WeiboModel.h"
#import "RTLabel.h"
#import "WeiboWebController.h"
#import "NSString+URLEncoding.h"
#import "EGOTableViewPullRefresh/EGORefreshTableHeaderView.h"
@interface HomeViewController ()<RTLabelDelegate>

@property (nonatomic, retain) NSArray *weiboData;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Weibo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reLabelLinkdidSelect:)
//                                                 name:kRTLabelLinkdidSelectNotification
//                                               object:nil];
    //绑定按钮
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定账号" style:UIBarButtonItemStyleBordered target:self action:@selector(bindAction:)];
    self.navigationItem.rightBarButtonItem = [bindItem autorelease];
    
    //注销按钮
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction:)];
    self.navigationItem.leftBarButtonItem = [logoutItem autorelease];
    
    
    self.tableView.eventDelegate = self;
    
    
    //判断是否认证
    if (self.sinaweibo.isAuthValid) {
        //加载微博列表数据
        NSLog(@"已经认证");
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        [self loadWeiboData];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = logoutItem;
        self.navigationItem.rightBarButtonItem = bindItem;
    }
    
//    NSLog(@"HomeVC tableview %p", self.tableView);
}

#pragma mark - load Data
- (void)loadWeiboData {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
}

// 下拉加载最新微博
- (void)pullDownLoadingData
{
    if(self.topWeibiID.length == 0)
    {
        NSLog(@"Weibo id is null");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[@"20", self.topWeibiID] forKeys:@[@"count", @"since_id"]];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result) {
                                 [self pullDownFinishData:result];
                             }];
}

- (void)pullDownFinishData:(id)result
{
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [newArray addObject:weibo];
        [weibo release];
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
    int updataCount = statues.count;
    NSLog(@"下拉更新, 获得%d条新微博", updataCount);
}

#pragma mark - SinaWeiboRequest delegate
//网络加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"网络加载失败:%@",error);
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {

    
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    self.weibos = weibos;
    self.tableView.data = weibos;
    if(weibos.count > 0)
    {
        WeiboModel *topWeibo = weibos[0];
        self.topWeibiID = [topWeibo.weiboId stringValue];
    }
    
    // refresh
    [self.tableView reloadData];
//    NSLog(@"data:\n%@",weibos);
    
    
    /*
     // 获得用户的关注列表
     NSLog(@"网络加载完成");
     NSArray *users = [result objectForKey:@"users"];
     NSMutableArray *usersList = [NSMutableArray array];
     for (NSDictionary *userDic in users)
     {
     UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
     [usersList addObject:user];
     [user release];
     }
     
     for (UserModel *user in usersList)
     {
     NSLog(@"%@", user.screen_name);
     }
     
     */
}


#pragma mark - actions
- (void)bindAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logIn];
}

- (void)logoutAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logOut];
}

#pragma mark - Memery Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_tableView release];
    [_tableView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    
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

#pragma mark - 下拉刷新的委托
#pragma mark - TableView even delegate method
- (void)pullDown:(BaseTableView *)tableView
{
    // NSLog(@"pull down");
    // 请求网络数据
    [self pullDownLoadingData];
    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
}

- (void)puuUp:(BaseTableView *)tableView
{
    
}
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)LinkdidSelectWithURLString:(NSURL *)url
{
    WeiboWebController *vc  =[[WeiboWebController alloc] init];
    vc.urlString = url;
    [self.navigationController pushViewController:vc animated:YES];
}


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

@end
