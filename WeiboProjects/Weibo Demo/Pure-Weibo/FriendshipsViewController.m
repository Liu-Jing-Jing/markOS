//
//  FriendshipsViewController.m
//  WXWeibo
//
//  Created by Mark Lewis on 16-6-3.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import "FriendshipsViewController.h"
#import "BaseTableView.h"
@interface FriendshipsViewController ()

@end

@implementation FriendshipsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NSLog(@"self.tableView.scrollEnabled=%d",self.tableView.scrollEnabled);
    
    
    self.data = [NSMutableArray array];
    
    // self.tableView.eventDelegate = self;
    self.tableView.hidden = YES;
    [super showHUBLoadingTitle:@"Loading..." withDim:YES];
    
    
    if (self.shipType == Fans)
    {
        
        self.title = @"粉丝数";
        [self loadData:[WBWeiboTool URLAppendingAccessTokenWithQueryPath:URL_FOLLOWERS]];
    }
    
    else if(self.shipType == Attention)
    {
        
        self.title = @"关注数";
        [self loadData:[WBWeiboTool URLAppendingAccessTokenWithQueryPath:URL_FRIENDS]];
        
    }
    
}

-(void)loadData:(NSString *)url
{
    
    if (self.userId.length == 0)
    {
        
        NSLog(@"用户名id为空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userId forKey:@"uid"];
    //    NSLog(@"[LBB]userid = %@",self.userId);
    
    
    //返回结果的游标，下一页用返回值里的next_cursor，上一页用previous_cursor，默认为0。
    
    if (self.cursor.length >0)
    {
        
        [params setObject:self.cursor forKey:@"cursor"];
    }
    
    /*
    [WXHLDateService requestWithURL:url
                             params:params
                         httpMethod:@"GET"
                      completeBlock:^(id result) {
                          
                          //                NSLog(@"[LBB]result = %@",result);
                          [self loadDataFinish:result ];
                          
                      }];
     
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
    
    [[MKHTTPTool shareInstance] requestWithURL:url
                                        params:params
                                    httpMethod:@"GET"
                                 completeBlock:^(id result) {
                                        //
                                     [self loadDataFinish:result];
                                 }];
}


-(void)loadDataFinish:(NSDictionary *)result
{
    
    
    //    NSLog(@"[LBB1]result = %@",result);
    
    [super hideHUBLoading];
    NSArray *userArray = [result objectForKey:@"users"];
    
    /*
     *  [
     ["用户1","用户2","用户3"],
     
     ["用户1","用户2","用户3"],
     
     ["用户1","用户2"],
     
     ["用户1","用户2","用户3"],
     
     ...
     
     []
     
     
     ];
     */
    
    
    NSMutableArray *array2D = nil;
    
    
    for (int i =0; i<userArray.count; i++)
    {
        
        array2D = [self.data lastObject];//最后一个数组
        
        // p判断最后一个数组是否是3个，如果是3个的话就创建下一个数组
        if (array2D.count == 3 || array2D == nil)
        {
            
            array2D = [NSMutableArray arrayWithCapacity:3];
            [self.data addObject:array2D];
        }
        
        NSDictionary *userDic = userArray[i];
        UserModel *userModel = [[UserModel alloc]initWithDataDic:userDic];
        [array2D addObject:userModel];
        
    }
    
    //   刷新UI
    if (userArray.count <40) {
        
        self.tableView.isMore = NO;
    }
    else{
        
        self.tableView.isMore = YES;
        
    }
    self.tableView.hidden = NO;
    self.tableView.data = self.data;
    [self.tableView reloadData];//刷新数据
    
    
    //收起下拉
    if (self.cursor == nil ) {
        
        [self.tableView doneLoadingTableViewData];
    }
    
    
    //纪录下一页游标
    self.cursor = [[result objectForKey:@"next_cursor"]stringValue];
}


//下拉事件
-(void)pullDown:(BaseTableView *)tableView
{
    
    //刷新第一页
    
    self.cursor = nil;
    [self.data removeAllObjects];
    
    if (self.shipType == Fans) {
        [self loadData:URL_FOLLOWERS];
    }
    else if(self.shipType == Attention){
        
        [self loadData:URL_FRIENDS];
    }
    
}
//上拉事件
-(void)pullUp:(BaseTableView *)tableView{
    
    if (self.shipType == Fans) {
        [self loadData:URL_FOLLOWERS];
    }
    else if(self.shipType == Attention){
        
        [self loadData:URL_FRIENDS];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
