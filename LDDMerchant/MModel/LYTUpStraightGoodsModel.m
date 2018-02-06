//
//  LYTUpStraightGoodsModel.m
//  满意
//
//  Created by shenTing on 2017/5/26.
//  Test Change This
//  博客:http://www.cnblogs.com/yuShen
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "LYTUpStraightGoodsModel.h"

@implementation LYTUpStraightGoodsModel
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
    return [[LYTUpStraightGoodsModel alloc] initWithDictionary:dic];
}
@end
