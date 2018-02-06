//
//  PaymentsViewController.m
//  LSKKApp
//
//  Created by 云盛科技 on 16/3/31.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#define SCREEN_WIDTH self.view.bounds.size.width-30

#import "AFNetworking.h"
#import "PaymentsViewController.h"
#import "PaymentsVC.h"
#import "UIColor+Addition.h"
#import "NetURL.h"


#define kScreenWidth1  ([UIScreen mainScreen].bounds.size.width / 375)
#define kScreenHeight1  ([UIScreen mainScreen].bounds.size.height / 667)
@interface PaymentsViewController ()
{
    UILabel *phoneLabel;
    NSString * mobile;
    NSString * code;
    UITextField *text;
    NSTimer *timer;
    int _time;
    NSString *error_code;
  
}

@property(nonatomic,copy)NSString *phoneID;
@end

@implementation PaymentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付设置";
    NSArray *arr =@[@"验证身份",@"输入密码",@"确认密码"];
    self.view.backgroundColor = [UIColor backGray];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*kScreenWidth1, 100*kScreenHeight1, SCREEN_WIDTH*kScreenWidth1, 50*kScreenHeight1)];
    imgView.image = [UIImage imageNamed:@"kuang_1@3x"];
    [self.view addSubview:imgView];
    for (int i = 0; i < 3 ; i ++){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((20+120*i)*kScreenWidth1, 15*kScreenHeight1, 80*kScreenWidth1, 20*kScreenHeight1)];
        label.font = [UIFont systemFontOfSize:16*kScreenWidth1];
        label.text = [arr objectAtIndex:i];
        [imgView addSubview:label];
    }
    [self create];
}

- (void)create
{
     NSDictionary *shopInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
     mobile = shopInfo[@"mobile"];
     
    phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*kScreenWidth1, 205*kScreenHeight1, 250*kScreenWidth1, 15*kScreenHeight1)];
    phoneLabel.textColor = [UIColor grayColor];
    phoneLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:phoneLabel];
    
     
     
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20 * kScreenWidth1, 74 * kScreenHeight1, 300 * kScreenWidth1, 20 * kScreenHeight1)];
    label.font = [UIFont systemFontOfSize:12];
    label.tag = 123456;
    [self.view addSubview:label];
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(15*kScreenWidth1, 230*kScreenHeight1, SCREEN_WIDTH*kScreenWidth1, 50*kScreenHeight1)];
    [self.view addSubview:textView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10*kScreenWidth1, 10*kScreenHeight1, 25*kScreenWidth1, 30*kScreenHeight1);
    [textView addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"Safety-verification@3x"] forState:UIControlStateNormal];
    
    text = [[UITextField alloc]initWithFrame:CGRectMake(40*kScreenWidth1, 10*kScreenHeight1, 190*kScreenWidth1, 30*kScreenHeight1)];
    text.placeholder = @"请输入手机验证码";
    text.borderStyle = UITextBorderStyleRoundedRect;
    [textView addSubview:text];
    [text addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *validationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    validationBtn.frame = CGRectMake((CGRectGetMaxX(text.frame)+5), 17*kScreenHeight1, 110*kScreenWidth1, 15*kScreenHeight1);
    validationBtn.tag =100;
    [validationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [textView addSubview:validationBtn];
    validationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    validationBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [validationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [validationBtn addTarget:self action:@selector(getValidation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake((self.view.bounds.size.width-250)/2, 330*kScreenHeight1, 250, 44*kScreenHeight1);
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    [self.view addSubview:nextBtn];
    [nextBtn setBackgroundColor:[UIColor backWhite]];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(120*kScreenWidth1, 400*kScreenHeight1, 120*kScreenWidth1, 15*kScreenHeight1)];
    image.image = [UIImage imageNamed:@"secured-account@3x"];
    [self.view addSubview:image];
}
-(void)getValidation:(UIButton *)sender
{
    sender.enabled = NO;
    if (phoneLabel == nil){
        Alert_Show(@"您还没有绑定的手机号,快去绑定吧!");
    }else{
        
        [self request];
        [self timerStart];
    }
}

-(void)nextBtnClick:(UIButton *)sender
{
    if (text.text.length == 0)
    {
        Alert_Show(@"请输入验证码!");
    }else
    {
        [self request1];
    }
}
-(void)textFiledChange:(UITextField *)sender
{
    code = sender.text;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark ------------ 倒计时 60 秒 -----------
-(void)timerStart{
    _time = 60;
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    [btn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_time] forState:UIControlStateNormal];
    btn.enabled = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerBegin) userInfo:nil repeats:YES];
}
-(void)timerBegin{
    _time --;
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    [btn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_time] forState:UIControlStateNormal];
    if (_time <= 0){
        [timer invalidate];
        btn.enabled = YES;
        [btn setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
    }
}
#pragma mark 
#pragma mark ------------ 请求 >>> 获取验证码 -----------
- (void)request {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:ZFPwd_Code, mobile]] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取验证码----%@",responseObject);
        NSString *originTel = mobile;
        NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        
        phoneLabel.text = [NSString stringWithFormat:@"已将验证码发送至%@手机", tel];
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
#pragma mark ------------ 请求 >>> 验证验证码 -----------
- (void) request1 {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"X-Auth-Token"];
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:ZF_Phone_Code, mobile, code]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"error_code"] intValue] == 0){
            error_code = responseObject[@"error_code"];
            PaymentsVC *vc = [[PaymentsVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(error_code == 0)
        {
            Alert_Show(@"您输入的验证码错误,请重新输入!");
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
