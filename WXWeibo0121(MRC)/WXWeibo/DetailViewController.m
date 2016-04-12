//
//  DetailViewController.m
//  WXWeibo


#import "DetailViewController.h"
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CommentTableView.h"
#import "CommentModel.h"
@interface DetailViewController ()
{
    UIView *headerView;
}
@end

@implementation DetailViewController
- (void)awakeFromNib
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Detail";
    [self.tableView setContentInset:UIEdgeInsetsMake(-55.0f, 0.0f, 0.0f, 0.0f)];
    // self.tableView.delegate = self;
    [self initSubview];
    self.tableView.headerView = [self initViewForHeaderInSection];
    
    [self loadData];
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

- (void)loadData
{
    NSString *weiboID = [_weiboModel.weiboId stringValue];
    if(weiboID.length == 0) return;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:weiboID forKey:@"id"];
    [self.sinaweibo requestWithURL:@"comments/show.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(NSDictionary *result) {
                                 [self loadDataFinished:result];
                             }];
}

- (void)loadDataFinished:(NSDictionary *)result
{
    NSArray *array = [result objectForKey:@"comments"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array)
    {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:dic];
        [comments addObject:commentModel];
        [commentModel release];
    }
    
    self.tableView.data = comments;
    [self.tableView reloadData];
}


- (UIView *)initViewForHeaderInSection
{
    UILabel *_countLabel = [[UILabel alloc] init];
    int reposts = [_weiboModel.repostsCount intValue];
    int comments = [_weiboModel.commentsCount intValue];
    if (reposts>=0 && comments>=0)
    {
        _countLabel.hidden = NO;
        _countLabel.text = [NSString stringWithFormat:@"Reposts:%d  | Comments:%d",reposts, comments];
        _countLabel.font = [UIFont systemFontOfSize:12.0];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = [UIColor lightGrayColor];
        _countLabel.frame  =CGRectMake(0, _weiboView.bottom+20, 80, 20);
        [_countLabel sizeToFit];
        _countLabel.right = _weiboView.right;
    }
    
    // 为下面的小icon计算宽度
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.text = [NSString stringWithFormat:@":Comments:%d", comments];
    commentLabel.font = [UIFont systemFontOfSize:12.0f];
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.textColor = [UIColor lightGrayColor];
    commentLabel.frame  =CGRectMake(0, _weiboView.bottom+20, 80, 20);
    [commentLabel sizeToFit];
    
    
    _countLabel.top = 5;
    UIView *selected_icon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, commentLabel.width-4, 1)];
    selected_icon.backgroundColor = [UIColor blackColor];
    selected_icon.top = _countLabel.bottom+5;
    selected_icon.right = _countLabel.right;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:_countLabel];
    [headerView addSubview:selected_icon];
    // [tableHeaderView addSubview:selected_icon];
    // [tableHeaderView addSubview:_countLabel];
    // tableHeaderView.height += 20;
    
    
    return headerView;
}
#pragma mark - TableView Datasource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return nil;
//}
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
    [_userBarView release];
    [_userImageView release];
    [_nickLabel release];
    [super dealloc];
}
@end
