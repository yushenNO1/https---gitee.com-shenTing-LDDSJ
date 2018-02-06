//
//  LocationLiftModel.m
//  YSApp
//
//  Created by july on 16/11/10.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "LocationLiftModel.h"

@implementation LocationLiftModel



- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {

        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (id)giftWithDictionary:(NSDictionary *)dic {
    return [[LocationLiftModel alloc]initWithDictionary:dic];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"lifeId"]) {
        self.life_id = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"cloudOffset"]) {
        self.reback_red = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"saleCount"]) {
        self.sale_count = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"shopId"]) {
        self.shop_id = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"teamBuyPrice"]) {
        self.team_buy_price = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"shopAreaString"]) {
        self.shop_area_string = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"lifeCover"]) {
        self.life_cover = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"lifeName"]) {
        self.life_name = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"shopName"]) {
        self.shop_name = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"distanceString"]) {
        self.distance = [NSString stringWithFormat:@"%@", value];
    }
    
}


@end
