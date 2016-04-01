//
//  MessageViewController.m
//  WXWeibo

#import "MessageViewController.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
@interface MessageViewController ()<SinaWeiboRequestDelegate>
@property(retain, nonatomic) NSArray *friendsData;
@property(retain, nonatomic) NSMutableArray *userImagesData;
@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.rowHeight = 70.0;
    self.userImagesData = [NSMutableArray array];
    //判断是否认证
    if (self.sinaweibo.isAuthValid) {
        //加载微博列表数据
        NSLog(@"已经认证");
        [self loadWeiboData];
        
    }
}


#pragma mark - load Data
- (void)loadWeiboData {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[@"170", @"MarkLewis"]
                                                                     forKeys:@[@"count", @"screen_name"]];
    [self.sinaweibo requestWithURL:@"friendships/friends.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
}


#pragma mark - SinaWeiboRequest delegate
//网络加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"网络加载失败:%@",error);
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    // 获得用户的关注列表
    NSLog(@"网络加载完成");
    NSArray *users = [result objectForKey:@"users"];
    NSMutableArray *usersList = [NSMutableArray array];
    for (NSDictionary *userDic in users)
    {
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        [usersList addObject:user];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImageWithURL:[NSURL URLWithString:user.profile_image_url]];
        [self.userImagesData addObject:imageView];
        [user release];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"FriendListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify] autorelease];
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
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:friends.profile_image_url]];
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

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
