//
//  proFitModel.h
//  满意
//
//  Created by 云盛科技 on 2017/1/13.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface proFitModel : NSObject
@property (nonatomic, copy) NSString * typeText;
@property (nonatomic, copy) NSString * showText;
@property (nonatomic, assign) BOOL isProfit;
@property (nonatomic, assign) NSInteger  typeId;
- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)proFitModelWithDictionary:(NSDictionary *)dic;
@end
