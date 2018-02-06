//
//  CheckStandModel.m
//  收银台
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "CheckStandModel.h"

@implementation CheckStandModel
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
    if ([key isEqualToString:@"id"]) {
        self.GoodId = [value integerValue];
    }
    if ([key isEqualToString:@"totalAmount"]) {
        self.totalAmount = [value floatValue];
    }
    if ([key isEqualToString:@"orderName"]) {
        self.orderName = [NSString stringWithFormat:@"%@", value];
    }
}

+ (id)GoodsWithDictionary:(NSDictionary *)dic
{
    return [[CheckStandModel alloc] initWithDictionary:dic];
}
@end
