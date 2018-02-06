//
//  ZjwBankCardModel.m
//  LSK
//
//  Created by 张敬文 on 2017/1/20.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "ZjwBankCardModel.h"

@implementation ZjwBankCardModel
- (id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"bank"]) {
        self.bank = value;
    }
    if ([key isEqualToString:@"cardNo"]) {
        self.cardNo = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"cardType"]) {
        self.cardType = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"id"]) {
        self.cardId = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"name"]) {
        self.name = [NSString stringWithFormat:@"%@", value];
    }
}

+ (id)bankCardWithDictionary:(NSDictionary *)dic{
    return [[ZjwBankCardModel alloc] initWithDictionary:dic];
}
@end
