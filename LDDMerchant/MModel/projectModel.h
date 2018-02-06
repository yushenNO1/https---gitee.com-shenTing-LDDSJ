//
//  projectModel.h
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface projectModel : NSObject
@property (nonatomic, copy) NSString * nameStr;
@property (nonatomic, copy) NSString * dateStr;
@property (nonatomic, copy) NSString * imageStr;
@property (nonatomic, assign) int codeStr;
@property (nonatomic, assign) int idStr;

@property (nonatomic, copy) NSString * isShared;
@property (nonatomic, copy) NSString * goodsType;
@property (nonatomic, copy) NSString * frozenCount;
@property (nonatomic, copy) NSString * goodsInTrade;
@property (nonatomic, copy) NSString * isOwner;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)projectWithDictionary:(NSDictionary *)dic;
@end
