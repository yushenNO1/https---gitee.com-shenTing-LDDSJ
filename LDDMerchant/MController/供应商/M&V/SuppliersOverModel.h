//
//  SuppliersOverModel.h
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/14.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuppliersOverModel : NSObject
@property (nonatomic, copy) NSString * goodId;
@property (nonatomic, copy) NSString * thumbnail;
@property (nonatomic, copy) NSString * goodName;
@property (nonatomic, copy) NSString * shopPrice;
@property (nonatomic, copy) NSString * volume;
@property (nonatomic, copy) NSString * stock;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSArray * goodImageList;


@property (nonatomic, assign) int type;
- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)overWithDictionary:(NSDictionary *)dic;
@end
