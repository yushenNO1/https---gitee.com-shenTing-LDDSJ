//
//  GoodsInfoModel.m
//  收银台
//
//  Created by 张敬文 on 2017/5/25.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "GoodsInfoModel.h"

@implementation GoodsInfoModel
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
        
    }
    if ([value isKindOfClass:[NSNull class]]) {
        
    }
    [super setValue:value forKey:key];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"goodId"]) {
        self.shopId = [value integerValue];
    }
    if ([key isEqualToString:@"price"]) {
        self.price = [value floatValue];
    }
    if ([key isEqualToString:@"goodName"]) {
        self.name = [NSString stringWithFormat:@"%@", value];
    }
}

+ (id)GoodsInfoWithDictionary:(NSDictionary *)dic
{
    return [[GoodsInfoModel alloc] initWithDictionary:dic];
}
@end
