//
//  shopMapVC.m
//  YSApp
//
//  Created by 张敬文 on 2016/11/16.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "shopMapVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"
#define kScreenWidth1  ([UIScreen mainScreen].bounds.size.width / 375)
#define kScreenHeight1  ([UIScreen mainScreen].bounds.size.height / 667)
@interface shopMapVC ()<CLLocationManagerDelegate, UISearchBarDelegate>
@property (nonatomic, retain) CLLocationManager * locationManager;
@property (nonatomic, retain) MKMapView * mapView;
@end

@implementation shopMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家地图";
    [self location];
    //布局地图
    [self layoutMapView];
    //布局buttons
    [self layoutButtons];
    // Do any additional setup after loading the view.
}

- (void)location
{
    //1.创建定位对象
    self.locationManager = [[CLLocationManager alloc] init];
    //2.获取授权
    [_locationManager requestAlwaysAuthorization];
    //3.设置精确度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //4.设置米数
    _locationManager.distanceFilter = 5.0f;
    //5.设置代理
    _locationManager.delegate = self;
    //6.开始定位
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    //获取位置
    CLLocation * location = locations[0];
    //获取位置信息
    CLLocationCoordinate2D coor = location.coordinate;
    NSLog(@"longitude:%f latitude:%f %f %f", coor.longitude, coor.latitude, location.altitude, location.speed);
    //地理编译(码)
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //获取位置标示对象
        MKPlacemark * mark = placemarks[0];
        NSLog(@"%@", mark.addressDictionary);
        NSMutableString * address = [NSMutableString string];
        for (NSString * key in mark.addressDictionary) {
            [address appendFormat:@"%@ : %@ \n", key, [mark.addressDictionary valueForKey:key]];
        }
        NSLog(@"%@", address);
        //创建大头针
        MyAnnotation * ann = [[MyAnnotation alloc] init];
        //设置大头针的位置
        ann.coordinate = coor;
        //设置title
        ann.aTitle = @"我的位置";
        //设置位置
        ann.coordinate = coor;
        //设置地图显示的范围
        MKCoordinateRegion region;
        //设置显示精确度
        region.span.latitudeDelta = 0.0001;
        region.span.longitudeDelta = 0.0001;
        //设置显示的中心
        region.center = coor;
        [_mapView setRegion:region];
        //在地图上添加大头针
        [_mapView addAnnotation:ann];
        
        
        
    }];
}

#pragma mark-
#pragma mark- 地图
- (void)layoutMapView
{
    //1.创建地图对象
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //2.配置属性
    //显示用户当前位置
    _mapView.showsUserLocation = YES;
    //设置跟踪
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    //设置地图类型
    _mapView.mapType = MKMapTypeHybridFlyover;
    //3.添加父视图
    [self.view addSubview:_mapView];
    
}

#pragma mark-
#pragma mark- 布局button
- (void)layoutButtons
{
    //定位公司位置
    UIButton * companyBt = [UIButton buttonWithType:UIButtonTypeSystem];
    //title
//    [companyBt setTitle:@"点击定位到商家店铺" forState:UIControlStateNormal];
    [companyBt addTarget:self action:@selector(getCompanyLocation:) forControlEvents:UIControlEventTouchUpInside];
    companyBt.backgroundColor = [UIColor whiteColor];
    //frame
    companyBt.frame = CGRectMake(305 * kScreenWidth1, 85 * kScreenHeight1, 50 * kScreenWidth1, 50 * kScreenHeight1);
    companyBt.layer.cornerRadius = 5;
    companyBt.layer.masksToBounds = YES;
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"postion@3x"]];
    imageView.frame = CGRectMake(0, 0, 25 * kScreenWidth1, 30 * kScreenHeight1);
    imageView.center = companyBt.center;
    companyBt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [companyBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    companyBt.center = CGPointMake(375 / 2, 667 / 2);
    [self.view addSubview:companyBt];
    [self.view addSubview:imageView];
}

- (void)getCompanyLocation:(UIButton *)sender
{
    //创建公司位置
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([_WStr floatValue], [_JStr floatValue]);
    //创建大头针
    MyAnnotation * ann = [[MyAnnotation alloc] init];
    //设置大头针的位置
    ann.coordinate = coor;
    //设置title
    ann.aTitle = _shopName;
    //设置位置
    ann.coordinate = coor;
    //设置地图显示的范围
    MKCoordinateRegion region;
    //设置显示精确度
    region.span.latitudeDelta = 0.0001;
    region.span.longitudeDelta = 0.0001;
    //设置显示的中心
    region.center = coor;
    [_mapView setRegion:region];
    //在地图上添加大头针
    [_mapView addAnnotation:ann];
}
- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
     MKPinAnnotationView *pinView = nil;
     if(annotation != _mapView.userLocation)
     {
          static NSString *defaultPinID = @"com.invasivecode.pin";
          pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
          if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                            initWithAnnotation:annotation reuseIdentifier:defaultPinID] ;
          pinView.pinColor = MKPinAnnotationColorRed;
          pinView.canShowCallout = YES;
          pinView.animatesDrop = YES;
     }
     else {
          [_mapView.userLocation setTitle:@"欧陆经典"];
          [_mapView.userLocation setSubtitle:@"vsp"];
     }
     return pinView;
}
- (void)didReceiveMemoryWarning {
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
