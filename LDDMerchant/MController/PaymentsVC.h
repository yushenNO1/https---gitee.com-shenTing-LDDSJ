//
//  PaymentsVC.h
//  LSKKApp
//
//  Created by 云盛科技 on 16/3/31.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentsVC : UIViewController

@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

@end
