//
//  MessageViewController.m
//  WXWeibo

#import "MessageViewController.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"


@interface MessageViewController ()

@property(nonatomic, strong) NSArray *friendsData;
@property(nonatomic, strong) NSMutableArray *userImagesData;
@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.rowHeight = 70.0;
    self.userImagesData = [NSMutableArray array];
    //判断是否认证
    if ([WBAccountTool account])
    {
        //加载微博列表数据
        NSLog(@"已经认证");
        [self loadWeiboData];
        
    }
}


#pragma mark - load Data
- (void)loadWeiboData
{
    /*
     access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
     uid	false	int64	需要查询的用户UID。
     screen_name	false	string	需要查询的用户昵称。
     count	false	int	单页返回的记录条数，默认为50，最大不超过200。
     cursor	false	int	返回结果的游标，下一页用返回值里的next_cursor，上一页用previous_cursor，默认为0。
     trim_status	false	int	返回值中user字段中的status字段开关，0：返回完整status字段、1：status字段仅返回status_id，默认为1。
     注意事项
     参数uid与screen_name二者必选其一，且只能选其一；
     接口升级后：uid与screen_name只能为当前授权用户；
     只返回同样授权本应用的用户，非授权用户将不返回；
     例如一次调用count是50，但其中授权本应用的用户只有10条，则实际只返回10条；
     使用官方移动SDK调用，多返回30%的非同样授权本应用的用户，总上限为500；
     */
    
    NSString *requestURL = [WBWeiboTool URLAppendingAccessTokenWithQueryPath:URL_FRIENDS];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[@"100", @([WBAccountTool account].uid)] forKeys:@[@"count", @"uid"]];
    
    [[MKHTTPTool shareInstance] requestWithURL:requestURL
                                        params:params
                                    httpMethod:@"GET"
                                 completeBlock:^(id result) {
                                     [self requestDidFinishLoadingWithResult:result];
                                 }];
}


#pragma mark - SinaWeiboRequest delegate
//网络加载失败


//网络加载完成
- (void)requestDidFinishLoadingWithResult:(id)result
{
    
    // 获得用户的关注列表
    NSLog(@"网络加载完成");
    NSArray *users = [result objectForKey:@"users"];
    NSMutableArray *usersList = [NSMutableArray array];
    for (NSDictionary *userDic in users)
    {
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        [usersList addObject:user];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url]];
        [self.userImagesData addObject:imageView];

    }
    
    self.friendsData = usersList;
    [self.tableView reloadData];
    
    
    /*
     // 获得用户的关注列表
     for (UserModel *user in usersList)
     {
        NSLog(@"%@", user.screen_name);
     }
     */
}

#pragma mark - TableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"FriendListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    // Data Model
    UserModel *friends = self.friendsData[indexPath.row];
    UIImageView *userImage = self.userImagesData[indexPath.row];
    
    // setup UI
    // cell.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    // cell.imageView.layer.shadowOpacity = 0.8;
    // cell.imageView.layer.shadowRadius = 4.0f;
    // cell.imageView.layer.shadowOffset = CGSizeMake(4, 4);
    // cell.imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.imageView.bounds].CGPath;
    
    cell.imageView.layer.cornerRadius = 24;  //圆弧半径
    cell.imageView.layer.masksToBounds = YES; //隐藏圆角区域
    cell.imageView.backgroundColor = [UIColor clearColor];
    cell.imageView.layer.borderWidth = .1;
    cell.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:friends.profile_image_url]];
    cell.imageView.frame = CGRectMake(5, 15, 40, 40);
    cell.imageView.image = userImage.image;
    cell.textLabel.text = friends.screen_name;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.text = friends.description;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)loadAtWeiboData
{
    
    [super showHUBLoadingTitle:@"Loading" withDim:YES];
    
    
//    [MKDateService requestWithURL:@"statuses/mentions.json" params:nil httpMethod:@"GET" completeBlock:^(id result)
//    {
//        
//        [self loadAtWeiboDataFinish:result];
//        
//    }];
    
}


-(void)loadAtWeiboDataFinish:(NSDictionary *)result
{

    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    
    for (NSDictionary *statuesDic in statues)
    {
        
        WeiboModel *weibo = [[WeiboModel alloc]initWithDataDic:statuesDic];
        [weibos addObject:weibo];
    }
    
    //    刷新UI
    [super hideHUBLoading];
    // _weiboTable.hidden = NO;
    // _weiboTable.data = weibos;
    // [_weiboTable reloadData];
    
}

#pragma mark -- UITableViewEventDelegate
- (void)pullDown:(BaseTableView *)tableView
{
    
}
- (void)pullUp:(BaseTableView *)tableView
{
    
}

//- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}



#pragma mark - Viewcontroller Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Message";
    }
    
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
