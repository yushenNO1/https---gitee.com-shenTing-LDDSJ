//
//  SuppliersOverModel.m
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/14.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "SuppliersOverModel.h"

@implementation SuppliersOverModel
- (id)initWithDictionary:(NSDictionary *)dic{
     self = [super init];
     if (self) {
          [self setValuesForKeysWithDictionary:dic];
     }
     return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
     if ([key isEqualToString:@"goodId"]) {
          self.goodId = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"thumbnail"]) {
          self.thumbnail = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"goodName"]) {
          self.goodName = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"shopPrice"]) {
          self.shopPrice = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"volume"]) {
          self.volume = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"stock"]) {
          self.stock = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"createTime"]) {
          self.createTime = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"status"]) {
          self.status = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"goodImageList"]) {
          self.goodImageList = value;
     }
     if ([key isEqualToString:@"type"]) {
          self.type = [value intValue];
     }
     
}

+ (id)overWithDictionary:(NSDictionary *)dic{
     return [[SuppliersOverModel alloc] initWithDictionary:dic];
}
@end
