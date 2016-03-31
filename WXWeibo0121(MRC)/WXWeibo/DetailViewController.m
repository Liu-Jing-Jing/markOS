//
//  DetailViewController.m
//  WXWeibo


#import "DetailViewController.h"
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
@interface DetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Detail";
    [self.tableView setContentInset:UIEdgeInsetsMake(-55.0f, 0.0f, 0.0f, 0.0f)];
    [self initSubview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI
- (void)initSubview
{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    // 用户基本信息栏：头像，昵称等
    // 使用Xib画
    self.userImageView.layer.cornerRadius = 21;
    self.userImageView.layer.masksToBounds = YES;
    [self.userImageView setImageWithURL:[NSURL URLWithString:_weiboModel.user.profile_image_url]];
    
    // 昵称
    self.nickLabel.text = _weiboModel.user.screen_name;
    self.userBarView.frame = CGRectMake(0, 0, ScreenWidth, 60);
    [tableHeaderView addSubview:self.userBarView];
    // tableHeaderView.height += 60; //userBarView的高度为60
    
    
    // create WeiboView------------------
    float h = [WeiboView getWeiboViewHeight:self.weiboModel isRepost:NO isDetail:YES];
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(10, _userBarView.bottom+10, ScreenWidth-20, h)];
    _weiboView.isDetail = YES; // important 这里写的表示创建时调整子视图的大小
    _weiboView.weiboModel = _weiboModel;
    [tableHeaderView addSubview:_weiboView];
    tableHeaderView.height += (h+100);
    
    
    self.tableView.tableHeaderView = tableHeaderView;
    [tableHeaderView release];
    
}

#pragma mark - TableView Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_userBarView release];
    [_userImageView release];
    [_nickLabel release];
    [super dealloc];
}
@end
