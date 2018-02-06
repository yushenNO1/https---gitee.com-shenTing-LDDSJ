//
//  proFitModel.m
//  满意
//
//  Created by 云盛科技 on 2017/1/13.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "proFitModel.h"

@implementation proFitModel
- (id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"content"]) {
        self.typeText = value;
    }
    if ([key isEqualToString:@"key"]) {
        self.typeId = [value integerValue];
    }
    if ([key isEqualToString:@"title"]) {
        self.showText = value;
    }
    if ([key isEqualToString:@"isProfit"]) {
        self.isProfit = [value boolValue];
    }
    
}

+ (id)proFitModelWithDictionary:(NSDictionary *)dic
{
    return [[proFitModel alloc] initWithDictionary:dic];
}
@end
