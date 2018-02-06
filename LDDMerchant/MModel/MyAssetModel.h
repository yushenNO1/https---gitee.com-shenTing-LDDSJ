//
//  MyAssetModel.h
//  YSApp
//
//  Created by 云盛科技 on 16/5/31.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAssetModel : NSObject
@property (nonatomic, strong) NSString *totalAccount;//总资金
@property (nonatomic, strong) NSString *fundAccount;//账户资金
@property (nonatomic, strong) NSString *frozenFunds;//冻结资金
@property (nonatomic, strong) NSString *guarantyAccount;//云积分
@property (nonatomic, strong) NSString *financialAccount;//投资项目
//@property (nonatomic, strong) NSString *area_string;
@property (nonatomic, strong) NSString *area_string;//地区
@property (nonatomic, strong) NSString *avatar;//图片
@property (nonatomic, strong) NSString *nickName;//昵称
@property (nonatomic,strong)NSString *level;
- (id)initWithDictionary:(NSDictionary *)dic;

@end
