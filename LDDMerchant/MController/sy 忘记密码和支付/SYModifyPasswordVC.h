//
//  SYPayPasswordVC.h
//  MainPage
//
//  Created by 云盛科技 on 2017/1/14.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYModifyPasswordVC : UIViewController

/** 区别页面 */
@property (nonatomic, assign) NSInteger discriminatePage;
/** 手机号 */
@property (nonatomic, strong) NSString *mobileText;

@property(nonatomic,assign)int type;
@end
