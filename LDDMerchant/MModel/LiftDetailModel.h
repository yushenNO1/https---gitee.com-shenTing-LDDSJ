//
//  LiftDetailModel.h
//  YSApp
//
//  Created by july on 16/11/10.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiftDetailModel : NSObject
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * goodId;
@property (nonatomic, copy) NSString * goodName;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * profile;
@property (nonatomic, copy) NSString * shopName;
@property (nonatomic, copy) NSString * userName;



- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)giftWithDictionary:(NSDictionary *)dic;


@end
