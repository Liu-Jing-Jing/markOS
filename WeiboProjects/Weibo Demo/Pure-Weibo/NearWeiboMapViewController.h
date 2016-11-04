//
//  NearWeiboMapViewController.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-5-8.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//


#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NearWeiboMapViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,retain)NSArray *data;


@end
