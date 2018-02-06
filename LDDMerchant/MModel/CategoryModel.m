//
//  CategoryModel.m
//  YSApp
//
//  Created by 王松松 on 2016/11/11.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel
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
    
    
}
- (void)setValue:(id)value forKey:(NSString *)key{
    
}
+ (id)withDrWithDictionary:(NSDictionary *)dic{
    return [[CategoryModel alloc] initWithDictionary:dic];
}
@end
