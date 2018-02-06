//
//  LYTPurchaseModel.h
//  WDHMerchant
//
//  Created by 云盛科技 on 2017/5/27.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYTPurchaseModel : NSObject
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * frozenCount;
@property (nonatomic, copy) NSString * goodId;
@property (nonatomic, copy) NSString * goodsInTrade;
@property (nonatomic, copy) NSString * profile;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * shopId;
@property (nonatomic, copy) NSString * shopName;


@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * goodsId;
@property (nonatomic, copy) NSString * goodsName;

@property (nonatomic, copy) NSString * didSelect;
@property (nonatomic, copy) NSString * isChange;
@property (nonatomic, assign) NSInteger  shopCount;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)projectWithDictionary:(NSDictionary *)dic;
@end
