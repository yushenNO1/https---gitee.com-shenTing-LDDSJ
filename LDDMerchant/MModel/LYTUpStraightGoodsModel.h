//
//  LYTUpStraightGoodsModel.h
//  满意
//
//  Created by 云盛科技 on 2017/5/26.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYTUpStraightGoodsModel : NSObject
@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * goods_name;
@property (nonatomic, copy) NSString * goods_sn;
@property (nonatomic, copy) NSString * original_img;
@property (nonatomic, copy) NSString * shop_price;
- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)GoodWithDictionary:(NSDictionary *)dic;
@end
