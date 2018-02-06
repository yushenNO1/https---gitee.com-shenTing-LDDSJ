//
//  LYTPurchaseModel.m
//  WDHMerchant
//
//  Created by shenTing on 2017/5/27.
//  Test Change This
//  博客:http://www.cnblogs.com/yuShen
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "LYTPurchaseModel.h"

@implementation LYTPurchaseModel
- (id)initWithDictionary:(NSDictionary *)dic{
     self = [super init];
     if (self) {
          self.didSelect = @"0";
          self.isChange = @"0";
          self.shopCount = 1;
          [self setValuesForKeysWithDictionary:dic];
     }
     return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
     if ([key isEqualToString:@"cover"]) {
          self.cover = value ;
     }
     if ([key isEqualToString:@"frozenCount"]) {
          self.frozenCount = value ;
     }
     if ([key isEqualToString:@"goodId"]) {
          self.goodId = value;
     }
     if ([key isEqualToString:@"goodsInTrade"]) {
          self.goodsInTrade = value;
     }
     if ([key isEqualToString:@"name"]) {
          self.name = value;
     }
     if ([key isEqualToString:@"price"]) {
          self.price = value ;
     }
     if ([key isEqualToString:@"profile"]) {
          self.profile = value;
     }
     if ([key isEqualToString:@"shopId"]) {
          self.shopId = value;
     }
     if ([key isEqualToString:@"shopName"]) {
          self.shopName = value;
     }
     if ([key isEqualToString:@"address"]) {
          self.address = value;
     }
     if ([key isEqualToString:@"goodsId"]) {
          self.goodsId = value;
     }
     if ([key isEqualToString:@"goodsName"]) {
          self.goodsName = value;
     }
}

+ (id)projectWithDictionary:(NSDictionary *)dic
{
     return [[LYTPurchaseModel alloc] initWithDictionary:dic];
}
@end
