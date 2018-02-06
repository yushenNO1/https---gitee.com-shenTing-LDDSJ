//
//  AddModel.m
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/17.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "AddModel.h"

@implementation AddModel
- (id)initWithDictionary:(NSDictionary *)dic{
     self = [super init];
     if (self) {
          [self setValuesForKeysWithDictionary:dic];
     }
     return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
     if ([key isEqualToString:@"name"]) {
          self.name = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"price"]) {
          self.price = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"stock"]) {
          self.stock = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"mAccount"]) {
          self.mAccount = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"orders"]) {
          self.orders = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"deduction"]) {
          self.deduction = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"fen"]) {
          self.fen = [NSString stringWithFormat:@"%.2f", [value doubleValue]/100];
     }
     if ([key isEqualToString:@"type"]) {
          self.type =  [value intValue];
     }
}

+ (id)addWithDictionary:(NSDictionary *)dic{
     return [[AddModel alloc] initWithDictionary:dic];
}

@end
