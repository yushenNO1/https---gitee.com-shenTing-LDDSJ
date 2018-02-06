//
//  SYForgetPswVC.m
//  MainPage
//
//  Created by 云盛科技 on 2017/1/15.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "SYForgetPswVC.h"
#import "SYModifyPasswordVC.h"
#import "AFNetworking.h"
#import "NetURL.h"
@interface SYForgetPswVC ()
{
    NSTimer *timer;
}
@property (nonatomic, strong) UITextField *moboleText;
@property (nonatomic, strong) UITextField *passwordText;

@property(nonatomic,assign) int time;

@property (nonatomic, strong) UIButton *securityCode;
@property (nonatomic, strong) UIButton *againCode;
@property (nonatomic, strong) UIButton *attention;
@end

@implementation SYForgetPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self forgetPswConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self setNavigationBarConfiguer];
}

- (void)setNavigationBarConfiguer {
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LOGO"] style:(UIBarButtonItemStylePlain) target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)dissMissBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)forgetPswConfig{
    
    if (_type == 1) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.bounds.size.width-60, 30, 50, 25);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(dissMissBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    UILabel *mobile = [[UILabel alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 100*kScreenHeight1, 80*kScreenWidth1, 25*kScreenHeight1)];
    mobile.text = @"手机号";
    [self.view addSubview:mobile];
    
    UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 125*kScreenHeight1, 250*kScreenWidth1, 1*kScreenHeight1)];
    grayLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayLine];
    
    UILabel *password = [[UILabel alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 150*kScreenHeight1, 80*kScreenWidth1, 25*kScreenHeight1)];
    password.text = @"验证码";
    [self.view addSubview:password];
    
    UIView *grayLine2 = [[UIView alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 175*kScreenHeight1, 250*kScreenWidth1, 1*kScreenHeight1)];
    grayLine2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayLine2];
    
    UITextField *moboleText = [[UITextField alloc]initWithFrame:CGRectMake(130*kScreenWidth1, 100*kScreenHeight1, 120*kScreenWidth1, 25*kScreenHeight1)];
    _moboleText = moboleText;
    moboleText.placeholder = @"请输入手机号";
    moboleText.keyboardType = UIKeyboardTypeNumberPad;
    moboleText.font = [UIFont systemFontOfSize:15*kScreenHeight1];
    [moboleText addTarget:self action:@selector(moboletfClick:) forControlEvents:UIControlEventEditingDidEnd];
    [self.view addSubview:moboleText];
    
    UIButton *securityCode = [UIButton buttonWithType:UIButtonTypeCustom];
    _securityCode = securityCode;
    securityCode.frame = CGRectMake(260*kScreenWidth1, 100*kScreenHeight1, 80*kScreenWidth1, 25*kScreenHeight1);
    [securityCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [securityCode setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    securityCode.titleLabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
    [securityCode addTarget:self action:@selector(securityCodeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:securityCode];
    
    UITextField *passwordText = [[UITextField alloc]initWithFrame:CGRectMake(130*kScreenWidth1, 150*kScreenHeight1, 120*kScreenWidth1, 25*kScreenHeight1)];
    _passwordText = passwordText;
    passwordText.font = [UIFont systemFontOfSize:14*kScreenHeight1];
    passwordText.placeholder = @"请输入验证码";
    passwordText.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:passwordText];
    
    UIButton *againCode = [UIButton buttonWithType:UIButtonTypeCustom];
    _againCode = againCode;
    [againCode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    againCode.frame = CGRectMake(250*kScreenWidth1, 150*kScreenHeight1, 90*kScreenWidth1, 25*kScreenHeight1);
    againCode.titleLabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
    [againCode addTarget:self action:@selector(againCodeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:againCode];
    
    UIButton *attention = [UIButton buttonWithType:UIButtonTypeCustom];
    _attention = attention;
    [attention setTitle:@"验证" forState: UIControlStateNormal];
    attention.frame = CGRectMake(50*kScreenWidth1,270*kScreenHeight1, 375-100*kScreenWidth1, 40*kScreenHeight1);
    attention.layer.cornerRadius = 5;
    attention.layer.masksToBounds = YES;
    attention.backgroundColor = [UIColor colorWithRed:222/255.0 green:28/255.0 blue:30/255.0 alpha:1];
    [attention addTarget:self action:@selector(attentionClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:attention];
    
}
//手机号输入框监听手机号是否正确
- (void)moboletfClick:(UITextField *)sender{
    [self isMobile:sender.text];
}
//验证码确定按钮
- (void)attentionClicked{
    if (self.moboleText.text.length == 0){
        Alert_Show(@"请输入您的手机号码");
    } else if (self.passwordText.text.length == 0){
        Alert_Show(@"请输入您的验证码");
    } else{
        [self RequestVVerificationCode];
        //SYModifyPasswordVC *newPwd = [[SYModifyPasswordVC alloc]init];
        //[self.navigationController pushViewController:newPwd animated:YES];
    }
}
//获取验证码按钮
- (void)securityCodeClicked{
    if ([self isMobile:self.moboleText.text]) {
        [self RequestSendVerificationCode];
    }
}
//再次获取验证码
- (void)againCodeClicked{
    if ([self isMobile:self.moboleText.text]) {
        [self RequestSendVerificationCode];
        self.againCode.enabled = NO;
        [self timerStart];
    }
}
#pragma mark
#pragma mark ------------------ 定时器 ----------------
-(void)timerStart{
    _time = 60;
    [_againCode setTitle:[NSString stringWithFormat:@"重新获取(%d)",_time] forState:UIControlStateNormal];
    _securityCode.enabled = NO;
    _againCode.enabled = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerBegin) userInfo:nil repeats:YES];
}
-(void)timerBegin{
    _time --;
    [_againCode setTitle:[NSString stringWithFormat:@"重新获取(%d)",_time] forState:UIControlStateNormal];
    if (_time <= 0){
        [timer invalidate];
        timer = nil;
        _againCode.enabled = YES;
        _securityCode.enabled = NO;
        [_againCode setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
    [_againCode setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
    _againCode.enabled = YES;
    _passwordText.text = nil;
}

#pragma mark
#pragma mark ----------- 请求验证手机号
- (void)requestVerificationPhone{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@",self.moboleText.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"验证手机号请求%@",responseObject);
        if ([responseObject[@"error_code"] intValue] == 0 ){
            Alert_Show(@"此手机号还没注册,请先注册");
        }else{
            self.securityCode.enabled = NO;
            self.securityCode.hidden = YES;
            [self timerStart];
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
#pragma mark ----------- 请求 >>> 发送验证码
- (void)RequestSendVerificationCode {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/sms/sendCode?type=2&mobile=%@",LSKurl,self.moboleText.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"验证码%@",responseObject);
        if ([responseObject[@"code"]integerValue] == 0) {
            self.securityCode.enabled = NO;
            self.securityCode.hidden = YES;
            [self timerStart];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送验证码请求失败%@",error);
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
                             ;
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
#pragma mark -------- 请求 >>> 验证验证码
- (void)RequestVVerificationCode {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/sms/checkCode?type=2&mobile=%@&code=%@",LSKurl,self.moboleText.text,self.passwordText.text] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"1验证验证码%@",responseObject);
        if ([responseObject[@"code"] intValue]==0){
            if (_type == 1) {
                SYModifyPasswordVC *newPwd = [[SYModifyPasswordVC alloc]init];
                newPwd.mobileText = self.moboleText.text;
                [self presentViewController:newPwd animated:YES completion:nil];
            }else{
                SYModifyPasswordVC *newPwd = [[SYModifyPasswordVC alloc]init];
                newPwd.mobileText = self.moboleText.text;
                [self.navigationController pushViewController:newPwd animated:YES];
            }
            
            
        }else if ([responseObject[@"code"] intValue] == 300302){
            ///if ([responseObject[@"mobile"] isEqualToString:@"Actived"]){
                //Alert_Show(@"该验证码已过期,请重新获取!");
           // }else{
                Alert_Show(@"验证码错误!")
            //}
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
//验证手机号
- (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if ([mobileNumbel length] == 0){
        self.securityCode.enabled = YES;
        Alert_Show(@"电话号码为空,请输入您的电话号码");
        return NO;
    }else if (([regextestmobile evaluateWithObject:mobileNumbel]
               || [regextestcm evaluateWithObject:mobileNumbel]
               || [regextestct evaluateWithObject:mobileNumbel]
               || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }else{
        self.securityCode.enabled = YES;
        Alert_Show(@"请输入正确的手机号!");
        return NO;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
