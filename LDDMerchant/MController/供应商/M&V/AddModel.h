//
//  AddModel.h
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/17.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddModel : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * stock;
@property (nonatomic, copy) NSString * mAccount;
@property (nonatomic, copy) NSString * orders;
@property (nonatomic, copy) NSString * deduction;
@property (nonatomic, copy) NSString * fen;
@property (nonatomic, assign) int type;
- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)addWithDictionary:(NSDictionary *)dic;
@end
