//
//  LYTShareVC.h
//  LSK
//
//  Created by 云盛科技 on 2017/1/12.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYTShareVC : UIViewController
+(void)shareImage:(NSString *)img Title:(NSString *)str content:(NSString *)content AndUrl:(NSString *)url;
@end
