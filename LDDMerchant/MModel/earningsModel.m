//
//  earningsModel.m
//  YSApp
//
//  Created by 王松松 on 2016/11/10.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "earningsModel.h"

@implementation earningsModel
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
    if ([key isEqualToString:@"count"]) {
        self.count = [value intValue];
    }
    if ([key isEqualToString:@"payAmount"]) {
        self.pay_amount = [value floatValue];
    }
    if ([key isEqualToString:@"consumeDate"]) {
        self.consume_date = [NSString stringWithFormat:@"%@",value];
    }

}

+ (id)withDrWithDictionary:(NSDictionary *)dic{
    return [[earningsModel alloc] initWithDictionary:dic];
}
@end
