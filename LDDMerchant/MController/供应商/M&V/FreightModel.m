//
//  FreightModel.m
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/15.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "FreightModel.h"

@implementation FreightModel
- (id)initWithDictionary:(NSDictionary *)dic{
     self = [super init];
     if (self) {
          [self setValuesForKeysWithDictionary:dic];
     }
     return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
     if ([key isEqualToString:@"transport_id"]) {
          self.transport_id = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"number"]) {
          self.number = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"price"]) {
          self.price = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"addNumber"]) {
          self.addNumber = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"addPrice"]) {
          self.addPrice = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"customTransportAreaList"]) {
          self.customTransportAreaList = value;
     }
     if ([key isEqualToString:@"text"]) {
          self.text = [NSString stringWithFormat:@"%@", value];
     }
     if ([key isEqualToString:@"Cid"]) {
          self.Cid = [NSString stringWithFormat:@"%@", value];
     }
}

+ (id)freWithDictionary:(NSDictionary *)dic{
     return [[FreightModel alloc] initWithDictionary:dic];
}
@end
