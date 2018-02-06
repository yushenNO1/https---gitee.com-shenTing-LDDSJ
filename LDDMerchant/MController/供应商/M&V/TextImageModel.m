//
//  TextImageModel.m
//  供应商
//
//  Created by 张敬文 on 2017/8/4.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "TextImageModel.h"

@implementation TextImageModel
- (id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"text"]) {
        self.text = [NSString stringWithFormat:@"%@", value];
    }
    if ([key isEqualToString:@"image"]) {
        self.image = value;
    }
    if ([key isEqualToString:@"type"]) {
        self.type = [NSString stringWithFormat:@"%@", value];
    }
     if ([key isEqualToString:@"imageCode"]) {
          self.imageCode = [NSString stringWithFormat:@"%@", value];
     }
    
}

+ (id)textWithDictionary:(NSDictionary *)dic{
    return [[TextImageModel alloc] initWithDictionary:dic];
}
@end
