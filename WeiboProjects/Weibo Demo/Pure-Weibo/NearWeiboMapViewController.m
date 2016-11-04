//
//  NearWeiboMapViewController.m
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-5-8.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//


#import "NearWeiboMapViewController.h"
#import "MKDateService.h"
#import "WeiboModel.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"

@interface NearWeiboMapViewController ()

@end

@implementation NearWeiboMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CLLocationManager *locationMangager = [[CLLocationManager alloc]init];
    [locationMangager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    locationMangager.delegate = self;
    [locationMangager startUpdatingLocation];
    
    //    _mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44)];
    //    _mapView.delegate=self;
    //    _mapView.showsUserLocation=YES;
    //    [self.view addSubview:_mapView];
}


-(void)loadNearWeiboData:(NSString *)lon latitude:(NSString *)lat
{
    /*
     access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
     lat	true	float	纬度。有效范围：-90.0到+90.0，+表示北纬。
     long	true	float	经度。有效范围：-180.0到+180.0，+表示东经。
     range	false	int	搜索范围，单位米，默认2000米，最大11132米。
     starttime	false	int	开始时间，Unix时间戳。
     endtime	false	int	结束时间，Unix时间戳。
     sort	false	int	排序方式。默认为0，按时间排序；为1时按与中心点距离进行排序。
     count	false	int	单页返回的记录条数，最大为50，默认为20。
     page	false	int	返回结果的页码，默认为1。
     base_app	false	int	是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
     offset	false	int	传入的经纬度是否是纠偏过，0：没纠偏、1：纠偏过，默认为0。
     */
    
    NSString *requestURL = [WBWeiboTool URLAppendingAccessTokenWithQueryPath:URL_NEARBY_TIMELINE];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:lon,@"long",lat,@"lat", nil];
    
    [[MKHTTPTool shareInstance] requestWithURL:requestURL
                                        params:params
                                    httpMethod:@"GET"
                                 completeBlock:^(id result) {
                                     [self loadDataFinish:result];
                                 }];
    
}


-(void)loadDataFinish:(NSDictionary *)result
{
    
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (int i =0 ; i<statues.count ; i ++)
    {
        
        NSDictionary *dic = [statues objectAtIndex:i];
        WeiboModel *weibo = [[WeiboModel alloc]initWithDataDic:dic];
        [weibos addObject:weibo];
        
        // 创建Anatation对象添加到地图上
        WeiboAnnotation *weiboAnnotation = [[WeiboAnnotation alloc]initWithWeibo:weibo];
        [self.mapView performSelector:@selector(addAnnotation:) withObject:weiboAnnotation afterDelay:i*0.1];
        
        [self.mapView addAnnotation:weiboAnnotation];
    }
    
}

#pragma mark -- CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    
    // 设置地图的显示区域，要复习BUG
    MKCoordinateSpan span = {0.1,0.1};
    MKCoordinateRegion region = {coordinate,span};
    // 设置区域范围大小
    [self.mapView setRegion:region animated:YES];
    
    if (self.data == nil)
    {
        
        NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude ];
        NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude ];
        // NSLog(@"[LBB]lon = %@,lat = %@",lon,lat);
        [self loadNearWeiboData:lon latitude:lat];
    }
}

#pragma mark -- MKAnnotationView delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class] ])
    {
        return nil;
    }
    else
    {
        
        static NSString *identity = @"WeiboAnnotationView";
        WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identity];
        
        if (annotationView == nil)
        {
            annotationView = [[WeiboAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identity];
        }
        
        return annotationView;
    }
    
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
    //    0.7---1.2
    //    1.2---1
    
    for (UIView *annotationView in views)
    {
        CGAffineTransform transform = annotationView.transform;
        annotationView.transform = CGAffineTransformScale(transform, 0.7, 0.7);
        annotationView.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            // 动画1
            
            annotationView.transform = CGAffineTransformScale(transform, 1.2, 1.2);
            annotationView.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            // 动画2
            [UIView animateWithDuration:0.3 animations:^{
                
                annotationView.transform = CGAffineTransformIdentity;
                
            }];
        }];
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
 {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
