//
//  LYTManagementModel.h
//  满意
//
//  Created by 云盛科技 on 2017/5/26.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYTManagementModel : NSObject
@property (nonatomic, copy) NSString * nameStr;
@property (nonatomic, copy) NSString * dateStr;
@property (nonatomic, copy) NSString * imageStr;
@property (nonatomic, assign) int codeStr;
@property (nonatomic, assign) int idStr;

@property (nonatomic, copy) NSString * goodsType;
@property (nonatomic, copy) NSString * goodsInTrade;
@property (nonatomic, copy) NSString * isShared;
@property (nonatomic, copy) NSString * frozenCount;


- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)projectWithDictionary:(NSDictionary *)dic;
@end
