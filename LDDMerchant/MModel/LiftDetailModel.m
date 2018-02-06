//
//  LiftDetailModel.m
//  YSApp
//
//  Created by july on 16/11/10.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "LiftDetailModel.h"

@implementation LiftDetailModel

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (id)giftWithDictionary:(NSDictionary *)dic {
    return [[LiftDetailModel alloc]initWithDictionary:dic];
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"address"]) {
        self.address = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"cover"]) {
        self.cover = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"goodId"]) {
        self.goodId = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"goodName"]) {
        self.goodName = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"mobile"]) {
        self.mobile = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"price"]) {
        self.price = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"profile"]) {
        self.profile = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"shopName"]) {
        self.shopName = value;
    }
    if ([key isEqualToString:@"userName"]) {
        self.userName = value;
    }
    
}

@end
