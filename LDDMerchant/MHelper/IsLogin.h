//
//  IsLogin.h
//  LSK
//
//  Created by 云盛科技 on 2017/2/17.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IsLogin : NSObject
{
    int a;
}
+ (void)LoginRequest;
+(NSString *)requestErrorCode:(NSUInteger)code;
@end
