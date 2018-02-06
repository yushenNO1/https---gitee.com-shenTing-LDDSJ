//
//  OrderInfoModel.m
//  收银台
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "OrderInfoModel.h"

@implementation OrderInfoModel
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [NSString stringWithFormat:@"%@", value];
    }
    if ([value isKindOfClass:[NSNull class]]) {
        
    }
    [super setValue:value forKey:key];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"count"]) {
        self.count = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"goodId"]) {
        self.goodId = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"price"]) {
        self.price = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"goodName"]) {
        self.name = [NSString stringWithFormat:@"%@", value];
    }
}

+ (id)InfoWithDictionary:(NSDictionary *)dic
{
    return [[OrderInfoModel alloc] initWithDictionary:dic];
}
@end
