//
//  WDModel.m
//  LSKKApp
//
//  Created by 云盛科技 on 16/4/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "WDModel.h"

@implementation WDModel
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
    if ([key isEqualToString:@"amount"]) {
        self.amount = [value intValue];
    }
    if ([key isEqualToString:@"receiverMobile"]) {
        self.cardNo = [NSString stringWithFormat:@"%@", value];
    }
}

+ (id)withDrawWithDictionary:(NSDictionary *)dic{
    return [[WDModel alloc] initWithDictionary:dic];
}
@end
