//
//  GoodModel.m
//  YSApp
//
//  Created by 云盛科技 on 16/5/20.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "GoodModel.h"

@implementation GoodModel


- (id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"goods_id"]) {
        self.goods_id = value;
    }
    if ([key isEqualToString:@"goods_name"]) {
        self.goods_name = value;
    }
    if ([key isEqualToString:@"goods_sn"]) {
        self.goods_sn = value;
    }
    if ([key isEqualToString:@"original_img"]) {
        self.original_img = value;
    }
    if ([key isEqualToString:@"shop_price"]) {
        self.shop_price = value;
    }
}

+ (id)GoodWithDictionary:(NSDictionary *)dic
{
    return [[GoodModel alloc] initWithDictionary:dic];
}

@end
