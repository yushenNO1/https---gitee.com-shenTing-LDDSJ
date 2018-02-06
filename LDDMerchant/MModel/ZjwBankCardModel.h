//
//  ZjwBankCardModel.h
//  LSK
//
//  Created by 张敬文 on 2017/1/20.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZjwBankCardModel : NSObject
@property (nonatomic, copy) NSString * bank;
@property (nonatomic, copy) NSString * cardNo;
@property (nonatomic, copy) NSString * cardType;
@property (nonatomic, copy) NSString * cardId;
@property (nonatomic, copy) NSString * name;
- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)bankCardWithDictionary:(NSDictionary *)dic;
@end
