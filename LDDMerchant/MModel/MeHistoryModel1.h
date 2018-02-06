//
//  MeHistoryModel1.h
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeHistoryModel1 : NSObject
@property (nonatomic, assign) float priceStr;
@property (nonatomic, copy) NSString * nameStr;
@property (nonatomic, copy) NSString * dateStr;
@property (nonatomic, copy) NSString * imageStr;
@property (nonatomic, assign) int numStr;
@property (nonatomic, assign) int idStr;


- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)MerWithDictionary:(NSDictionary *)dic;
@end
