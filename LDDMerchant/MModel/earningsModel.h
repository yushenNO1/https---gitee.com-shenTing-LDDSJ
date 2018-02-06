//
//  earningsModel.h
//  YSApp
//
//  Created by 王松松 on 2016/11/10.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface earningsModel : NSObject
@property (nonatomic, assign) int  count;
@property (nonatomic, assign) float pay_amount;
@property (nonatomic, copy) NSString * consume_date;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)withDrWithDictionary:(NSDictionary *)dic;

@end
