//
//  WDModel.h
//  LSKKApp
//
//  Created by 云盛科技 on 16/4/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WDModel : NSObject
@property (nonatomic, assign) float  amount;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * note;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * cardNo;
@property (nonatomic, copy) NSString * receiverNickName;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)withDrawWithDictionary:(NSDictionary *)dic;
@end
