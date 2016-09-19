//
//  ProfileViewController.m
//  WXWeibo

#import "ProfileViewController.h"
#import "ProfileInfoView.h"
#import "UserDataCountModel.h"
#import "UserModel.h"

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    NSArray *_data;
    NSArray *_detailDescs;
    int mode;

    
    //
    ProfileInfoView *_userInfo;
}

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
    }
    return self;
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"More Settings";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
    }
    
    cell.textLabel.text = _data[indexPath.row];
    if(indexPath.row == 1)
    {
        if (mode ==1 || mode ==2)
        {
            if(mode == 1)
            {
                cell.detailTextLabel.text = @"Large Mode";
            }
            else if(mode == 2)
            {
                cell.detailTextLabel.text = @"Small Mode";
            }
        }
    }
    return cell;
}

/* refresh detail text
 if(indexPath.row == 1)
 {
     mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowserMode];
     if (mode ==1 || mode ==2)
     {
        if(mode == 1)
        {
            cell.detailTextLabel.text = @"Large Mode";
        }
        else if(mode == 2)
        {
        cell.detailTextLabel.text = @"Small Mode";
        }
     }
 }

 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        UIActionSheet *alertSwitch = [[UIActionSheet alloc] initWithTitle:@"Change Image Mode"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:@"test(大图模式会消耗更多流量)"
                                                         otherButtonTitles:@"Large Image", @"Small Image", @"Auto Mode", nil];
        alertSwitch.tag = 201;
        [alertSwitch showInView:self.view];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 201) // 切换图片浏览模式的actionSheet
    {
        UITableViewCell *modeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if(buttonIndex == 1) // 大图浏览模式
        {
            mode = kLargeBrowserMode;
            modeCell.detailTextLabel.text = @"Large Mode";
        }
        else if(buttonIndex == 2) // 小图浏览模式
        {
            mode = kSmallBrowserMode;
            modeCell.detailTextLabel.text = @"Small Mode";
        }
        // reload tableView
        NSLog(@"%d", [[NSUserDefaults standardUserDefaults] integerForKey:kBrowserMode]);
        // 发送刷新微博列表的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNotification object:nil];
        // NSLog(@"%d", buttonIndex);
        
        if(buttonIndex==1 || buttonIndex==2)[[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kBrowserMode];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
}

#pragma mark- Controller Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _data = @[@"Theme", @"Image Mode"];
    // mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowserMode];
    // if(mode!=1 || mode!=2) mode = kLargeBrowserMode; // 默认为小图浏览模式
    
    _userInfo = [[ProfileInfoView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    // self.tableView.tableHeaderView = _userInfo;
    // 等有数据了才能显示这个头视图
    
    // 在Navigation Bar上加上一个快速返回首页的按钮
    
    // self.tableView.eventDelegate = self;
    self.tableView.hidden = YES;
    // load data
    [self loadUserData];
    // 显示加载提示
    [super showHUBLoadingTitle:@"Loading..." withDim:YES];
    
}

#pragma mark - Data
#pragma mark - Data
- (void)loadUserData
{

    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"MarkLewis" forKey:@"screen_name"];
    SinaWeiboRequest *request;
    request = [self.sinaweibo requestWithURL:@"users/show.json"
                                      params:params
                                  httpMethod:@"GET"
                                       block:^(id result) {
                                           [self loadUserDataFinished:result];
                                       }];

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
                                        }];
}

- (void)loadCountDataFinished:(NSArray *)result
{
    UserDataCountModel *countModel = [[UserDataCountModel alloc] initWithDataDic:[result firstObject]];
    _userInfo.fansCount         = [countModel.followers_count longValue];
    _userInfo.followingCount    = [countModel.friends_count longValue];
    _userInfo.weibosCount       = [countModel.statuses_count longValue];
    [self refreshUI];
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

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
