//
//  MeHistoryModel1.m
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "MeHistoryModel1.h"

@implementation MeHistoryModel1
- (id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"teamBuyPrice"]) {
        self.priceStr = [value floatValue];
    }
    if ([key isEqualToString:@"count"]) {
        self.numStr = [value intValue];
    }
    if ([key isEqualToString:@"onlineTime"]) {
        self.dateStr = value;
    }
    if ([key isEqualToString:@"name"]) {
        self.nameStr = value;
    }
    if ([key isEqualToString:@"cover"]) {
        self.imageStr = value;
    }
    if ([key isEqualToString:@"lifeId"]) {
        self.idStr = [value intValue];
    }
}

+ (id)MerWithDictionary:(NSDictionary *)dic
{
    return [[MeHistoryModel1 alloc] initWithDictionary:dic];
}
@end
