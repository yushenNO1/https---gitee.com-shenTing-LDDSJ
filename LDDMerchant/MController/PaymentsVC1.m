//
//  PaymentsVC1.m
//  LSKKApp
//
//  Created by 云盛科技 on 16/3/31.
//  Copyright © 2016年 云盛科技. All rights reserved.
//
// 屏幕bounds
#define ZCScreenBounds [UIScreen mainScreen].bounds
// 屏幕的size
#define ZCScreenSize [UIScreen mainScreen].bounds.size
// 屏幕的宽度
#define ZCScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕的高度
#define ZCScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth1  ([UIScreen mainScreen].bounds.size.width / 375)
#define kScreenHeight1  ([UIScreen mainScreen].bounds.size.height / 667)

#define SCREEN_WIDTH self.view.bounds.size.width-30
#import "PaymentsVC1.h"
#import "AFNetworking.h"
#import "UIColor+Addition.h"
#import "NetURL.h"



@interface PaymentsVC1 ()<UITextFieldDelegate>
{
    NSMutableArray *pwdIndicatorArr;
    
    UILabel *phoneLabel;
    
    NSString *pwd;
    
}
@property (nonatomic, strong) UIView *paymentAlert, *inputView;
@property (nonatomic, strong) UITextField *pwdTextField;
@end

@implementation PaymentsVC1

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self loadMyInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr =@[@"验证身份",@"输入密码",@"确认密码"];
    self.view.backgroundColor = [UIColor backGray];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*kScreenWidth1, 100*kScreenHeight1, SCREEN_WIDTH, 50*kScreenHeight1)];
    imgView.image = [UIImage imageNamed:@"kuang_3@3x"];
    [self.view addSubview:imgView];
    
    for (int i = 0; i < 3 ; i ++)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((20+120*i)*kScreenWidth1, 15*kScreenHeight1, 80*kScreenWidth1, 20*kScreenHeight1)];
        label.text = [arr objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:16*kScreenWidth1];
        [imgView addSubview:label];
    }
    phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*kScreenWidth1, 205*kScreenHeight1, 200*kScreenWidth1, 15*kScreenHeight1)];
    phoneLabel.text = @"请再次输入6位数的数字密码";
    phoneLabel.textColor = [UIColor grayColor];
    phoneLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:phoneLabel];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame =  CGRectMake((self.view.bounds.size.width-250)/2*kScreenWidth1, 330*kScreenHeight1, 250*kScreenWidth1, 44*kScreenHeight1);
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    [self.view addSubview:nextBtn];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor greenColor];
    [nextBtn setBackgroundColor:[UIColor backWhite]];
    [nextBtn setTitle:@"确认修改" forState:UIControlStateNormal];
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
    _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, _inputView.frame.size.width, _inputView.frame.size.height)];
    
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
-(void)nextBtnClick:(UIButton *)sender{
    if ([self.pwdStr isEqualToString: pwd]){
        [self request1];
    }else{
        Alert_Show(@"失败");
    }
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
    }
    else {
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
#pragma mark
#pragma mark ------------ 请求 >>> 获取个人信息 ----------
- (void)loadMyInfo {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"X-Auth-Token"];
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,MyInfo] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue] == 0){
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"] forKey:@"MyInfo"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if ([error code] == -1009) {
              NSString *errorStr = [IsLogin requestErrorCode:[error code]];
              Alert_Show(errorStr)
         }else if ([error code] == -1001) {
              Alert_Show(@"请求超时")
         }else{
              if([[error localizedDescription] rangeOfString:@"("].location !=NSNotFound){
                   NSArray *arr = [[error localizedDescription] componentsSeparatedByString:@"("];
                   NSArray *arr1 = [arr[1] componentsSeparatedByString:@")"];
                   if ([arr1[0] integerValue] == 500) {
                        Alert_Show(@"服务器忙,请稍后再试")
                   }else if ([arr1[0] integerValue] == 401){
                        
                        Alert_Show(@"网络请求错误, 请重试")
                        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
                        manager.requestSerializer = [AFJSONRequestSerializer serializer];
                        manager.responseSerializer = [AFJSONResponseSerializer serializer];
                        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                        [manager.requestSerializer setValue:@"Basic bW9iaWxlOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
                        NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"];
                        NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PwdID"];
                        [manager POST:[NSString stringWithFormat:loginUrl,login,password] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             NSString *tokenStr = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
                             
                             //                             [[LYTFMDB sharedDataBase]deleAllSeachText];
                             if (responseObject[@"access_token"] != nil) {
                                  [[NSUserDefaults standardUserDefaults]setObject:tokenStr  forKey:@"token"];
                                  [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"LoginID"];
                                  [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"PwdID"];
                             } else {
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
                             }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                        }];
                   }
              }
         }
    }];
}
#pragma mark
#pragma mark ------------ 请求 >>> 设置支付密码 ----------
- (void) request1 {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"X-Auth-Token"];
    [manager POST:[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:@"zfmajk",pwd]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"error_code"]intValue] == 0)
        {
            Alert_show_pushRoot(@"密码设置成功");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if ([error code] == -1009) {
              NSString *errorStr = [IsLogin requestErrorCode:[error code]];
              Alert_Show(errorStr)
         }else if ([error code] == -1001) {
              Alert_Show(@"请求超时")
         }else{
              if([[error localizedDescription] rangeOfString:@"("].location !=NSNotFound){
                   NSArray *arr = [[error localizedDescription] componentsSeparatedByString:@"("];
                   NSArray *arr1 = [arr[1] componentsSeparatedByString:@")"];
                   if ([arr1[0] integerValue] == 500) {
                        Alert_Show(@"服务器忙,请稍后再试")
                   }else if ([arr1[0] integerValue] == 401){
                        
                        Alert_Show(@"网络请求错误, 请重试")
                        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
                        manager.requestSerializer = [AFJSONRequestSerializer serializer];
                        manager.responseSerializer = [AFJSONResponseSerializer serializer];
                        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                        [manager.requestSerializer setValue:@"Basic bW9iaWxlOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
                        NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"];
                        NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PwdID"];
                        [manager POST:[NSString stringWithFormat:loginUrl,login,password] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             NSString *tokenStr = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
                             
                             //                             [[LYTFMDB sharedDataBase]deleAllSeachText];
                             if (responseObject[@"access_token"] != nil) {
                                  [[NSUserDefaults standardUserDefaults]setObject:tokenStr  forKey:@"token"];
                                  [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"LoginID"];
                                  [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"PwdID"];
                             } else {
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
                             }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                        }];
                   }
              }
         }
    }];
}



@end
