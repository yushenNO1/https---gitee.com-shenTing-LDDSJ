//
//  IsLogin.m
//  LSK
//
//  Created by 云盛科技 on 2017/2/17.
//  Copyright © 2017年 云盛科技. All rights reserved.
//
static int aaa = 2;
#import "IsLogin.h"
#import "AFNetworking.h"
@implementation IsLogin
+ (void)LoginRequest{
     //弃用
}

+(NSString *)requestErrorCode:(NSUInteger)code{
     if (code == -1009) {
          return @"接网络链接失败,请检查网络";
     }else if (code == -1001){
          return @"请求超时";
     }else if (code == 500){
          return @"服务器忙!请稍后再试";
     }else if (code == 502){
          return @"服务正在维护中";
     }else if (code == 401 || code == 403){
          return @"登不上";
     }
     return @"服务器忙!请稍后再试";
}


@end
