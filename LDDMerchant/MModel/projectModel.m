//
//  projectModel.m
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "projectModel.h"

@implementation projectModel
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
     if ([key isEqualToString:@"isOwner"]) {
          self.isOwner = value;
     }
}

+ (id)projectWithDictionary:(NSDictionary *)dic
{
    return [[projectModel alloc] initWithDictionary:dic];
}
@end
