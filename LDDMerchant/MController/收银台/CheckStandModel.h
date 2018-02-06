//
//  CheckStandModel.h
//  收银台
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckStandModel : NSObject
@property (nonatomic, assign) NSInteger GoodId;
@property (nonatomic, copy) NSString * orderName;
@property (nonatomic, assign) float totalAmount;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)GoodsWithDictionary:(NSDictionary *)dic;
@end
