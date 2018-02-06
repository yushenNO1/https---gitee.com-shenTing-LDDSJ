//
//  PaymentsVC.m
//  LSKKApp
//
//  Created by 云盛科技 on 16/3/31.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#define ZCScreenBounds [UIScreen mainScreen].bounds
#define ZCScreenSize [UIScreen mainScreen].bounds.size
#define ZCScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZCScreenHeight [UIScreen mainScreen].bounds.size.height

#import "AFNetworking.h"
#import "UIColor+Addition.h"
#define SCREEN_WIDTH self.view.bounds.size.width-30
#define kScreenWidth1  ([UIScreen mainScreen].bounds.size.width / 375)
#define kScreenHeight1  ([UIScreen mainScreen].bounds.size.height / 667)
#import "PaymentsVC.h"
#import "PaymentsVC1.h"
@interface PaymentsVC ()<UITextFieldDelegate>
{
    NSMutableArray *pwdIndicatorArr;
    UILabel *phoneLabel;
    NSString *pwd;
}
@property (nonatomic, strong) UIView *paymentAlert, *inputView;
@property (nonatomic, strong) UITextField *pwdTextField;

@end

@implementation PaymentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr =@[@"验证身份",@"输入密码",@"确认密码"];
    self.view.backgroundColor = [UIColor backGray];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15 * kScreenWidth1, 100 * kScreenHeight1, SCREEN_WIDTH, 50 * kScreenHeight1)];
    imgView.image = [UIImage imageNamed:@"kuang_password@3x"];
    [self.view addSubview:imgView];
    for (int i = 0; i < 3 ; i ++){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((20+120*i) * kScreenWidth1, 15 * kScreenHeight1, 80 * kScreenWidth1, 20 * kScreenHeight1)];
        label.text = [arr objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:16*kScreenWidth1];
        [imgView addSubview:label];
    }
    phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 *kScreenWidth1, 205 * kScreenHeight1, 200 * kScreenWidth1, 15 * kScreenHeight1)];
    phoneLabel.text = @"请输入6位数的数字密码";
    phoneLabel.textColor = [UIColor grayColor];
    phoneLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:phoneLabel];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame =CGRectMake((self.view.bounds.size.width-250)/2*kScreenWidth1, 330*kScreenHeight1, 250*kScreenWidth1, 44*kScreenHeight1);
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    [self.view addSubview:nextBtn];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor greenColor];
    [nextBtn setBackgroundColor:[UIColor backWhite]];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(120*kScreenWidth1, 400*kScreenHeight1, 120*kScreenWidth1, 15*kScreenHeight1)];
    image.image = [UIImage imageNamed:@"secured-account@3x"];
    [self.view addSubview:image];
    
    _inputView = [[UIView alloc]initWithFrame:CGRectMake(15, 230*kScreenHeight1, (self.view.bounds.size.width-30), 50*kScreenHeight1)];
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.layer.borderWidth = 1.f;
    _inputView.layer.borderColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.].CGColor;
    [self.view addSubview:_inputView];
    
    pwdIndicatorArr = [[NSMutableArray alloc]init];
    _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, _inputView.frame.size.width*kScreenWidth1, _inputView.frame.size.height*kScreenHeight1)];

    _pwdTextField.textColor = [UIColor clearColor];
    _pwdTextField.delegate = self;
    [[_pwdTextField valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_inputView addSubview:_pwdTextField];
    
    CGFloat width = _inputView.bounds.size.width/6;
    for (int i = 0; i < 6; i ++) {
        UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake((width-10)/2.f + i*width, (_inputView.bounds.size.height-10)/2.f, 10, 10)];
        dot.backgroundColor = [UIColor blackColor];
        dot.layer.cornerRadius = 10/2.;
        dot.clipsToBounds = YES;
        dot.hidden = YES;
        [_inputView addSubview:dot];
        [pwdIndicatorArr addObject:dot];
        
        if (i == 6-1) {
            continue;
        }
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, .5f, _inputView.bounds.size.height)];
        line.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.];
        [_inputView addSubview:line];
    }
}

-(void)nextBtnClick:(UIButton *)sender
{
    PaymentsVC1 *vc = [[PaymentsVC1 alloc]init];
    vc.pwdStr = pwd;
    [self.navigationController pushViewController:vc animated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= 6 && string.length) {
         return NO;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    if (![predicate evaluateWithObject:string]) {
        return NO;
    }
    NSString *totalString;
    if (string.length <= 0) {
        if (textField.text.length >= 1)
        {
            totalString = [textField.text substringToIndex:textField.text.length-1];
        }
    }else {
        totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    [self setDotWithCount:totalString.length];
    if (totalString.length == 6) {
        if (_completeHandle) {
            _completeHandle(totalString);
        }
        pwd = totalString;
    }
    return YES;
}
- (void)setDotWithCount:(NSInteger)count {
    for (UILabel *dot in pwdIndicatorArr) {
        dot.hidden = YES;
    }
    for (int i = 0; i< count; i++) {
        ((UILabel*)[pwdIndicatorArr objectAtIndex:i]).hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
