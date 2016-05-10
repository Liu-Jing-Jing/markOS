//
//  UserViewController.m
//  WXWeibo

#import "UserViewController.h"
#import "UserInfoView.h"
#import "UserDataCountModel.h"
#import "WeiboModel.h"
#import "UIFactory.h"
#import "MainViewController.h"
#import <UIKit/UIKit.h>

@interface UserViewController ()<UITableViewEvenDelegate>
{
    UserInfoView    *_userInfo;
    NSMutableArray  *_requests;
}

@end

@implementation UserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"User Profile";
    // Go home button
    UIButton *homeButton = [UIFactory createButtonWithBackground:@"tabbar_home.png" backgroundHighlighted:@"tabbar_home.png"];
    homeButton.frame = CGRectMake(0, 0, 30, 30);
    [homeButton addTarget:self action:@selector(goHomeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = [homeItem autorelease];
    
    _requests = [[NSMutableArray alloc] init];
    
    // self.userName = self.userModel.screen_name;
    //self.tableView.height +=49;
    //[self.tabBarController.tabBar setHidden:YES]; // Bug
    for(UIView *subView in self.tabBarController.view.subviews)
    {
        // NSLog(@"%@", [subView class]);
        // UITransitionView
        if ([subView isKindOfClass:NSClassFromString(@"UITransitionView")])
        {
            subView.height+=49;
        }
        
    }
    //UIView *view = [self.tabBarController.view.subviews firstObject];
    //view.height +=50;
    
    _userInfo = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    // self.tableView.tableHeaderView = _userInfo;
    // 等有数据了才能显示这个头视图
    
    // 在Navigation Bar上加上一个快速返回首页的按钮
    
    self.tableView.eventDelegate = self;
    self.tableView.hidden = YES;
    // load data
    [self loadUserData];
    // 显示加载提示
    [super showHUBLoadingTitle:@"Loading..." withDim:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // [self.tabBarController.tabBar setHidden:NO];
    // cancel requests for network
    for (SinaWeiboRequest *request in _requests)
    {
        [request disconnect];
    }
}

#pragma mark - Data
- (void)loadUserData
{
    if(self.userName.length==0)
    {
        NSLog(@"Error: 用户名为空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    SinaWeiboRequest *request;
    request = [self.sinaweibo requestWithURL:@"users/show.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result) {
                                 [self loadUserDataFinished:result];
                             }];
    
    [_requests addObject:request];
}


- (void)loadUserDataFinished:(NSDictionary *)result
{
    // NSLog(@"%@", result);
    // 数据错误，粉丝和关注人数都为0
    
    UserModel *userModel = [[UserModel alloc] initWithDataDic:result];
    _userInfo.userModel = userModel;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:userModel.idstr forKey:@"uids"];
    
    SinaWeiboRequest *request2;
    request2 = [self.sinaweibo requestWithURL:@"users/counts.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result) {
                                 [self loadCountDataFinished:result];
                                 [self loadWeiboData];
                             }];
    
    [_requests addObject:request2];
    
}

- (void)loadCountDataFinished:(NSArray *)result
{
    UserDataCountModel *countModel = [[UserDataCountModel alloc] initWithDataDic:[result firstObject]];
    _userInfo.fansCount         = [countModel.followers_count longValue];
    _userInfo.followingCount    = [countModel.friends_count longValue];
    _userInfo.weibosCount       = [countModel.statuses_count longValue];
    [self refreshUI];
}


- (void)loadWeiboData
{
    // 加载Weibo
    if(self.userName.length==0)
    {
        NSLog(@"Error: 用户名为空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:_userInfo.userModel.screen_name forKey:@"screen_name"];
    [params setObject:@"30" forKey:@"count"];
    
    SinaWeiboRequest *request3;
    request3 = [self.sinaweibo requestWithURL:@"statuses/user_timeline.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result) {
                                 [self loadWeiboDataFinished:result];
                             }];
    [_requests addObject:request3];
}

- (void)loadWeiboDataFinished:(NSDictionary *)result
{
    NSArray *statuses = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
    
    for (NSDictionary *dic in statuses)
    {
        //WeiboModel
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:dic];
        [weibos addObject:weiboModel];
        [weiboModel release];
    }
    
    
    if(weibos.count < 20)
    {
        self.tableView.isMore = NO;
    }
    else
    {
        self.tableView.isMore = YES;
    }
    
    self.tableView.data = weibos;
    [self.tableView reloadData];
}


#pragma mark - UI
- (void)refreshUI
{
    // 完成加载
    [super hideHUBLoading];
    self.tableView.hidden = NO;
    // 加载下来完整数据再显示头部视图
    self.tableView.tableHeaderView = _userInfo;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma maek - BaseTableView EvenDelegate
- (void)pullDown:(BaseTableView *)tableView
{
    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2];
}

- (void)pullUp:(BaseTableView *)tableView
{
    // 模拟调用reload方法
    [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:2];
}

#pragma mark - 回到根控制器
// GO Home Action
- (void)goHomeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc
{
    [_tableView release];
    [super dealloc];
}
@end
