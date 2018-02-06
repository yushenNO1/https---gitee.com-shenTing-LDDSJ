//
//  GoodaModel.h
//  YSApp
//
//  Created by 王松松 on 2016/11/10.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodaModel : NSObject
@property (nonatomic, copy) NSString * life_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * profile;
@property (nonatomic, copy) NSString * category_id;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * team_buy_price;
@property (nonatomic, copy) NSString * reback_red;
@property (nonatomic, copy) NSString * meal_ids;
@property (nonatomic, copy) NSString * validity_period;
@property (nonatomic, copy) NSString * consume_start_time;
@property (nonatomic, copy) NSString * consume_end_time;
@property (nonatomic, copy) NSString * purchase_note;
@property (nonatomic, copy) NSString * label;
@property (nonatomic, assign) BOOL saveAndOnline;



- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)withDrWithDictionary:(NSDictionary *)dic;


@end
