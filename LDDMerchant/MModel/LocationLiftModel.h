//
//  LocationLiftModel.h
//  YSApp
//
//  Created by july on 16/11/10.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationLiftModel : NSObject

@property (nonatomic, copy) NSString * distance;
@property (nonatomic, copy) NSString * life_id;
@property (nonatomic, copy) NSString * life_name;
@property (nonatomic, copy) NSString * reback_red;
@property (nonatomic, copy) NSString * sale_count;
@property (nonatomic, copy) NSString * shop_cover;
@property (nonatomic, copy) NSString * shop_id;
@property (nonatomic, copy) NSString * shop_name;
@property (nonatomic, copy) NSString * team_buy_price;
@property (nonatomic, copy) NSString * label;
@property (nonatomic, copy) NSString * longitude;
@property (nonatomic, copy) NSString * life_cover;
@property (nonatomic, copy) NSString * shop_area_string;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)giftWithDictionary:(NSDictionary *)dic;

@end
