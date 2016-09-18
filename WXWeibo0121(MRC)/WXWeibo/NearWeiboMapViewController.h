//
//  NearWeiboMapViewController.h
//  WXWeibo
//
//  Created by Mark Lewis on 16-6-5.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NearWeiboMapViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,retain)NSArray *data;


@end
