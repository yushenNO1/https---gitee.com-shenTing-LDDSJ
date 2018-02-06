//
//  ShopTypeModel.m
//  YSApp
//
//  Created by 云盛科技 on 2016/11/16.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "ShopTypeModel.h"

@implementation ShopTypeModel
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"cateId"]) {
        self.cateId = value;
    }
    if ([key isEqualToString:@"name"]) {
        self.name = value;
    }
    if ([key isEqualToString:@"icon"]) {
        self.icon = value;
    }
    
}

+ (id)moreGoodWithDictionary:(NSDictionary *)dic
{
    return [[ShopTypeModel alloc] initWithDictionary:dic];
}

@end
