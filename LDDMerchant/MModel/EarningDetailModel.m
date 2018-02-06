//
//  EarningDetailModel.m
//  LSKKApp
//
//  Created by 云盛科技 on 16/4/6.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "EarningDetailModel.h"

@implementation EarningDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"amount"]) {
        self.amount = [NSString stringWithFormat:@"%@",value];
    } else if ([key isEqualToString:@"profitType"]) {
        self.type = [NSString stringWithFormat:@"%@",value];
    }
    else if ([key isEqualToString:@"createTime"]) {
        self.createTime = [NSString stringWithFormat:@"%@",value];
    }
    else if ([key isEqualToString:@"week"]) {
        self.week = [NSString stringWithFormat:@"%@",value];
    }
}



@end
