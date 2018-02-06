//
//  OrderInfoModel.h
//  收银台
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfoModel : NSObject
@property (nonatomic, copy) NSString * count;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * goodId;
@property (nonatomic, copy) NSString * priceZ;
- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)InfoWithDictionary:(NSDictionary *)dic;
@end
