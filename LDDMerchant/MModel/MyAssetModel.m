//
//  MyAssetModel.m
//  YSApp
//
//  Created by 云盛科技 on 16/5/31.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "MyAssetModel.h"

@implementation MyAssetModel

- (id)initWithDictionary:(NSDictionary *)dic;
{
    self =[super init];
    if (self){
        self.level = dic[@"level"];
        [self setValuesForKeysWithDictionary:dic];
   }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"totalAccount"]) {
        self.totalAccount = value;
    }
    if ([key isEqualToString:@"fundAccount"]) {
        self.fundAccount = value;
    }
    if ([key isEqualToString:@"nickName"]) {
        self.nickName = value;
    }
    if ([key isEqualToString:@"avatar"]) {
        self.avatar = value;
    }
    if ([key isEqualToString:@"area_string"]) {
        self.area_string = value;
    }
    if ([key isEqualToString:@"area_string"]) {
        self.area_string = value;
    }
    if ([key isEqualToString:@"financialAccount"]) {
        self.financialAccount = value;
    }
    if ([key isEqualToString:@"guarantyAccount"]) {
        self.guarantyAccount = value;
    }
    if ([key isEqualToString:@"frozenFunds"]) {
        self.frozenFunds = value;
    }
    
}

@end
