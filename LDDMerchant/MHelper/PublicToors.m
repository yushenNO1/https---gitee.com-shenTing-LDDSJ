//
//  PublicToors.m
//  LSK
//
//  Created by 云盛科技 on 2017/3/23.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "PublicToors.h"

@implementation PublicToors



//验证手机号
+ (BOOL) isMobile:(NSString *)mobileNumbel{
    
    
    NSString * all = @"^[1][3,4,5,7,8][0-9]{9}$";
    
    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", all];
    if ([mobileNumbel length] == 0){
        return NO;
    }else if ([regextestct evaluateWithObject:mobileNumbel]) {
        return YES;
    }else{
        return NO;
    }
}

+(NSDictionary *)changeNullInData:(NSDictionary *)Data{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    str = [str stringByReplacingOccurrencesOfString:@"null"withString:@"\"LYTChange\""];
    NSData *jsonData1 = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary * responseObject = [NSJSONSerialization JSONObjectWithData:jsonData1 options:NSJSONReadingMutableContainers error:&err];
    //    NSLog(@"asdas两个字典---%@-------%@",Data,responseObject);
    return responseObject;
}


+(BOOL)judgeInfoIsNotNull:(id)info{
    if ([[info class] isEqual:[NSNull class]]) {
        return NO;
    }else if (info==nil){
        return NO;
    }else{
        return YES;
    }
}

@end
