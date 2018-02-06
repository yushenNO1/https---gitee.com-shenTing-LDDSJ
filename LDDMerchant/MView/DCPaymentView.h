//
//  DCPaymentView.h
//  DCPayAlertDemo
//
//  Created by dawnnnnn on 15/12/9.
//  Copyright © 2015年 dawnnnnn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPaymentView : UIView

@property (nonatomic, copy) NSString *title, *detail;
@property (nonatomic, assign) float amount;
@property (nonatomic, strong) UILabel *titleLabel, *line, *detailLabel, *amountLabel;
@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);
@property (nonatomic,copy) void (^dismissView)(int a);
@property (nonatomic, strong) UITextField *pwdTextField;

- (void)show;

@end
