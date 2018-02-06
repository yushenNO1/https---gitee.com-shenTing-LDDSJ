//
//  SYPayPasswordVC.m
//  MainPage
//
//  Created by 云盛科技 on 2017/1/14.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "SYModifyPasswordVC.h"
#import "SYLoginPage.h"
#import "AFNetworking.h"
#import "NetURL.h"
#import "SYVerificationMobileController.h"
@interface SYModifyPasswordVC ()

@property (nonatomic, strong) UITextField *newsPswText;
@property (nonatomic, strong) UITextField *confirmPswText;

@property (nonatomic, strong) UIButton *securityCode;
@property (nonatomic, strong) UIButton *againCode;
@property (nonatomic, strong) UIButton *attention;

@end

@implementation SYModifyPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.discriminatePage == 5) {
        self.title = @"登录密码";
    }else if (self.discriminatePage == 6){
        self.title = @"支付密码";
    }else{
        self.title = @"重置密码";
    }
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self passwordConfig];
}
-(void)dissMissBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)passwordConfig{
    if (_type == 1) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.bounds.size.width-60, 30, 50, 25);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(dissMissBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *newPsw = [[UILabel alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 100*kScreenHeight1, 80*kScreenWidth1, 25*kScreenHeight1)];
    newPsw.text = @"新密码";
    [self.view addSubview:newPsw];
    
    UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 125*kScreenHeight1, 250*kScreenWidth1, 1*kScreenHeight1)];
    grayLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayLine];
    
    UILabel *confirmPsw = [[UILabel alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 150*kScreenHeight1, 80*kScreenWidth1, 25*kScreenHeight1)];
    confirmPsw.text = @"确认密码";
    [self.view addSubview:confirmPsw];
    
    UIView *grayLine2 = [[UIView alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 175*kScreenHeight1, 250*kScreenWidth1, 1*kScreenHeight1)];
    grayLine2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayLine2];
    
    UITextField *newPswText = [[UITextField alloc]initWithFrame:CGRectMake(130*kScreenWidth1, 100*kScreenHeight1, 120*kScreenWidth1, 25*kScreenHeight1)];
    _newsPswText = newPswText;
    newPswText.secureTextEntry = YES;
    newPswText.placeholder = @"请输入新密码";
    newPswText.font = [UIFont systemFontOfSize:15*kScreenHeight1];
    [newPswText addTarget:self action:@selector(newPswTextClick) forControlEvents:UIControlEventEditingDidEnd];
    [self.view addSubview:newPswText];
    
    UITextField *confirmPswText = [[UITextField alloc]initWithFrame:CGRectMake(130*kScreenWidth1, 150*kScreenHeight1, 120*kScreenWidth1, 25*kScreenHeight1)];
    _confirmPswText = confirmPswText;
    confirmPswText.secureTextEntry = YES;
    confirmPswText.font = [UIFont systemFontOfSize:14*kScreenHeight1];
    confirmPswText.placeholder = @"请再次输入密码";
    [confirmPswText addTarget:self action:@selector(confirmPswClicked) forControlEvents:UIControlEventEditingDidEnd];
    [self.view addSubview:confirmPswText];
    
    UIButton *attention = [UIButton buttonWithType:UIButtonTypeCustom];
    _attention = attention;
    attention.frame = CGRectMake(50*kScreenWidth1,270*kScreenHeight1, 375-100*kScreenWidth1, 40*kScreenHeight1);
    attention.layer.cornerRadius = 5;
    attention.layer.masksToBounds = YES;
    [attention setTitle:@"保存密码" forState: UIControlStateNormal];
    attention.backgroundColor = [UIColor colorWithRed:222/255.0 green:28/255.0 blue:30/255.0 alpha:1];
    [attention addTarget:self action:@selector(attentionClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:attention];
}
//保存密码按钮
- (void)attentionClicked{
    if (_newsPswText.text.length == 0 || _confirmPswText.text.length == 0) {
        Alert_Show(@"密码不能为空")
    }else if(![_newsPswText.text isEqualToString:_confirmPswText.text]){
        Alert_Show(@"两次密码不一致请重新输入");
    }else if(_newsPswText.text.length != 6 || _confirmPswText.text.length != 6){
        Alert_Show(@"支付密码必须是6位")
    }else{
        if (self.discriminatePage == 5) {
            [self RequestLoginedUpdatePassword];
        }else if (self.discriminatePage == 6){
            [self RequestModifyPayPassword];
        }else{
            [self RequestSettingNewPassword];
        }
    }
}
//密码
- (void)newPswTextClick{
    
}

- (void)confirmPswClicked{
    
}
#pragma mark
#pragma mark ------------- 请求 >>> 未登录忘记登陆密码 -----------
- (void)RequestSettingNewPassword{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSLog(@"lianjie%@",[NSString stringWithFormat:@"%@/api/v1/user/passwordUpdateNotLogin?mobile=%@&password=%@",LSKurl,self.mobileText,_confirmPswText.text]);
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/user/passwordUpdateNotLogin?mobile=%@&password=%@",LSKurl,self.mobileText,_confirmPswText.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"未登录设置新密码%@",responseObject);
        if ([responseObject[@"code"] intValue ] == 0){
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"请牢记您的密码,重新登录!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
                if (_type == 1) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                }
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else if([responseObject[@"data"] isEqualToString:@""]){
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"手机号还未注册,请先注册!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
//                _newsPswText.text = nil;
//                _confirmPswText.text = nil;
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"不能与之前的密码一致,请重新输入!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
                _newsPswText.text = nil;
                _confirmPswText.text = nil;
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
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
                                  
                             }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
                        }];
                   }
              }
         }
    }];
}
#pragma mark
#pragma mark -------------- 请求 >>> 已经登录修改登陆密码 ---------
- (void)RequestLoginedUpdatePassword{
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    NSLog(@"str!!!%@",str);

    NSLog(@"yijing修改登陆密码...%@",[NSString stringWithFormat:@"%@/us/user/updatePassword/%@",LSKurl,_confirmPswText.text]);
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/user/updatePassword/%@",LSKurl,_confirmPswText.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"修改登陆密码请求%@",responseObject);
        if ([responseObject[@"code"]integerValue] == 0) {
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"请牢记您的登录密码!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
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
#pragma mark -------------- 请求 >>> 修改支付密码 ----------
- (void)RequestModifyPayPassword{
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];

    NSLog(@"修改支付密码%@",[NSString stringWithFormat:@"%@/us/user/updateAccountPassword/%@",LSKurl,_confirmPswText.text]);
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/user/updateAccountPassword?password=%@",LSKurl,_confirmPswText.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"修改支付密码%@",responseObject);
        if ([responseObject[@"code"]integerValue] == 0) {
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置成功" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
