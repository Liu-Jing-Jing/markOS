//
//  NearbyViewController.m
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-14.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import "NearbyViewController.h"
#import "UIImageView+WebCache.h"
#import "Define.h"

@interface NearbyViewController ()<CLLocationManagerDelegate>

@end

@implementation NearbyViewController

#pragma mark -- UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    
    
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    // NSLog(@"%@", dic.allKeys);
    
    NSString *title = [dic objectForKey:@"title"];
    NSString *address = [dic objectForKey:@"address"];
    NSString *icon = [dic objectForKey:@"icon"];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = address;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    if (![icon isKindOfClass:[NSNull class]])
    {
        UIImage *placeholder = [UIImage imageNamed:@"page_image_loading.png"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:icon]
                          placeholderImage:placeholder];
        // [cell.imageView setImageWithURL:[NSURL URLWithString:icon]placeholderImage:[UIImage imageNamed:@"page_image_loading.png" ]];
    }
    
    cell.imageView.backgroundColor = [UIColor clearColor];
    cell.imageView.layer.cornerRadius = 30;  //圆弧半径
    cell.imageView.layer.borderWidth = 5;
    cell.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    cell.imageView.layer.masksToBounds = YES;
    // cell.imageView.size = CGSizeMake(40, 40);
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectBlock != nil)
    {
        
        NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
        // NSLog(@"[LBB]dic = %@",dic);
        _selectBlock(dic);
        // Block_release(_selectBlock);//因为_selectBlock(dic)只调用一次，所以可以调完释放
        _selectBlock = nil;
    }
    // 键盘消失了
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -- UI
-(void)refreshUI
{
    
    self.tableView.hidden = NO;
    [super hideHUBLoading];
    
    [self.tableView reloadData];
    
}

#pragma mark -- data
-(void)loadNearbyDataFinish:(NSDictionary *)result
{
    
    NSArray *pois = [NSArray array];
    if([result respondsToSelector:@selector(objectForKey:)]) pois = [result objectForKey:@"pois"];
    self.data = pois;
    [self refreshUI];
}


#pragma mark -- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    [manager stopUpdatingLocation];
    if (self.data == nil)
    {
        
        float longitude = newLocation.coordinate.longitude;
        float latitude = newLocation.coordinate.latitude;
        
        NSString *longstring = [NSString stringWithFormat:@"%f",longitude ];
        NSString *latitudestring = [NSString stringWithFormat:@"%f",latitude ];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:longstring, @"long", latitudestring,@"lat", nil];
        
        /*
         access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
         lat	true	float	纬度，有效范围：-90.0到+90.0，+表示北纬。
         long	true	float	经度，有效范围：-180.0到+180.0，+表示东经。
         */
        NSString *requestURL = [WBWeiboTool URLAppendingAccessTokenWithQueryPath:URL_POIS];
        
        [[MKHTTPTool shareInstance] requestWithURL:requestURL
                                            params:params
                                        httpMethod:@"GET"
                                     completeBlock:^(id result) {
                                         [self loadNearbyDataFinish:result];
                                     }];

    }    
}


#pragma mark VC Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        // self.isCancelButton = YES;
        self.isCancelButton = YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"My Place";
    
    self.tableView.hidden = YES;
    [super showHUBLoadingTitle:@"Loading..." withDim:YES];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager startUpdatingLocation];
    
    [self.tableView setRowHeight:60];

    /*
     testcase测试位置使用的
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"114.4",@"long",@"30.5",@"lat", @"1000",@"range", nil];
    
    
    [self.sinaweibo requestWithURL:@"place/nearby/pois.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result){
                                 [self loadNearbyDataFinish:result];
                             }];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
