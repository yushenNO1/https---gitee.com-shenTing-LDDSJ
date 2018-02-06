//
//  GoodsInfoModel.h
//  收银台
//
//  Created by 张敬文 on 2017/5/25.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsInfoModel : NSObject
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString * barCode;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)GoodsInfoWithDictionary:(NSDictionary *)dic;
@end
