//
//  FreightModel.h
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/15.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreightModel : NSObject
@property (nonatomic, copy) NSString * transport_id;
@property (nonatomic, copy) NSString * number;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * addNumber;
@property (nonatomic, copy) NSString * addPrice;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * Cid;
@property (nonatomic, strong) NSArray * customTransportAreaList;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)freWithDictionary:(NSDictionary *)dic;
@end
