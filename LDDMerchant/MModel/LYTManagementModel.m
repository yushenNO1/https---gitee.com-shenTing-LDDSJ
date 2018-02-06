//
//  LYTManagementModel.m
//  满意
//
//  Created by shenTing on 2017/5/26.
//  Test Change This
//  博客:http://www.cnblogs.com/yuShen
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "LYTManagementModel.h"

@implementation LYTManagementModel
- (id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"status"]) {
        self.codeStr = [value intValue];
    }
    if ([key isEqualToString:@"id"]) {
        self.idStr = [value intValue];
    }
    if ([key isEqualToString:@"coverAndUrl"]) {
        self.imageStr = value;
    }
    if ([key isEqualToString:@"updateTime"]) {
        self.dateStr = value;
    }
    if ([key isEqualToString:@"name"]) {
        self.nameStr = value;
    }
     if ([key isEqualToString:@"frozenCount"]) {
          self.frozenCount = value;
     }
     if ([key isEqualToString:@"goodsInTrade"]) {
          self.goodsInTrade = value;
     }
     if ([key isEqualToString:@"goodsType"]) {
          self.goodsType = value;
     }
     if ([key isEqualToString:@"isShared"]) {
          self.isShared = value;
     }
}

+ (id)projectWithDictionary:(NSDictionary *)dic
{
    return [[LYTManagementModel alloc] initWithDictionary:dic];
}
@end
