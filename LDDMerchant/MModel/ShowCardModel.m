//
//  ShowCardModel.m
//  LSKKApp
//
//  Created by 云盛科技 on 16/4/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "ShowCardModel.h"

@implementation ShowCardModel
- (id)initWithDictionary:(NSDictionary *)dic
{
    self =[super init];
    if (self)
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"cardId"]) {
        self.cardId = [NSString stringWithFormat:@"%@", value];
    } else if([key isEqualToString:@"userId"]) {
        self.userId = [NSString stringWithFormat:@"%@", value];
    }
}

@end
