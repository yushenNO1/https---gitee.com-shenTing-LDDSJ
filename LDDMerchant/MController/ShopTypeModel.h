//
//  ShopTypeModel.h
//  YSApp
//
//  Created by 云盛科技 on 2016/11/16.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopTypeModel : NSObject
@property (nonatomic,copy)NSString *cateId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *icon;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)moreGoodWithDictionary:(NSDictionary *)dic;
@end
