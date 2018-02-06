//
//  MeHistoryModel.m
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "MeHistoryModel.h"

@implementation MeHistoryModel
- (id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"orderNo"]) {
        self.codeStr = value;
    }
    if ([key isEqualToString:@"fundAmount"]) {
        self.fundStr = value;
    }
    if ([key isEqualToString:@"accPointsAmount"]) {
        self.accStr = value;
    }
    if ([key isEqualToString:@"price"]) {
        self.priceStr = [NSString stringWithFormat:@"%.2f", [value floatValue]];
    }
    if ([key isEqualToString:@"validityDate"]) {
        self.dateStr = value;
    }
    if ([key isEqualToString:@"lifeItemName"]) {
        self.nameStr = value;
    }
    if ([key isEqualToString:@"cover"]) {
        self.cover = value;
    }
}

+ (id)MeWithDictionary:(NSDictionary *)dic
{
    return [[MeHistoryModel alloc] initWithDictionary:dic];
}
@end
