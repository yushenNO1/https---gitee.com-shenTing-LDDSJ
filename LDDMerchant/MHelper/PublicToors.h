//
//  PublicToors.h
//  LSK
//
//  Created by 云盛科技 on 2017/3/23.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicToors : NSObject

//验证手机号
+ (BOOL) isMobile:(NSString *)mobileNumbel;

//判断字符串是否为null/nil
+(BOOL)judgeInfoIsNotNull:(id)info;

+(NSDictionary *)changeNullInData:(NSDictionary *)Data;
@end
