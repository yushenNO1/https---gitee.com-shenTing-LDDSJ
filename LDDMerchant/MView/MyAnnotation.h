//
//  MyAnnotation.h
//  LocationMap_demo
//
//  Created by zjw on 15/10/20.
//  Copyright (c) 2015年 蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MyAnnotation : NSObject<MKAnnotation>
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * aTitle;
@property (nonatomic, copy) NSString * aSubTitle;


@end
