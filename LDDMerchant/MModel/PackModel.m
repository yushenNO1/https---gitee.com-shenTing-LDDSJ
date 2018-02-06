//
//  PackModel.m
//  YSApp
//
//  Created by 王松松 on 2016/11/12.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "PackModel.h"

@implementation PackModel
- (id)initWithFrameWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _idStr = [[dic objectForKey:@"id"] intValue];
        _priceStr = [[dic objectForKey:@"price"] floatValue];
        _nameStr = [dic objectForKey:@"name"];
        _coverStr  = [dic objectForKey:@"cover"];
        _profileStr = [dic objectForKey:@"profile"];
    }
    return self;
}
@end
