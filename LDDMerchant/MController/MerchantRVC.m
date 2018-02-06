//
//  MerchantRVC.m
//  YSApp
//
//  Created by 张敬文 on 2017/1/4.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "MerchantRVC.h"
#import "UIColor+Addition.h"
#import "NetURL.h"
#import "AFNetworking.h"

#import "DCPaymentView.h"
#import "SYVerificationMobileController.h"
#define kScreenWidth1  ([UIScreen mainScreen].bounds.size.width / 375)
#define kScreenHeight1  ([UIScreen mainScreen].bounds.size.height / 667)
@interface MerchantRVC ()
@property (nonatomic, copy) NSString * str;
@property (nonatomic, copy) NSString * fundAccount;
@end

@implementation MerchantRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转入到商家资金";
    self.view.backgroundColor = [UIColor backGray];
    
    UILabel * backLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 10 * kScreenHeight1, 375 * kScreenWidth1, 60 * kScreenHeight1)];
    backLabel1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backLabel1];
    
    UILabel * labe1l = [[UILabel alloc] initWithFrame:CGRectMake(20 * kScreenWidth1, 64 + 10 * kScreenHeight1, 80 * kScreenWidth1, 60 * kScreenHeight1)];
    labe1l.text = @"转入金额:";
    labe1l.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:labe1l];
    
    UITextField *redTf = [[UITextField alloc] initWithFrame:CGRectMake(105 * kScreenWidth1, 64 + 10 * kScreenHeight1, 250 * kScreenWidth1, 60 * kScreenHeight1)];
    redTf.font = [UIFont systemFontOfSize:15];
    redTf.placeholder = [NSString stringWithFormat:@"本次最多可转入%@", _fundAccount];
    redTf.tag = 104;
     NSDictionary *shopInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
     _fundAccount = [NSString stringWithFormat:@"%.2f", [shopInfo[@"fundAccount"] floatValue]];
     redTf.placeholder = [NSString stringWithFormat:@"本次最多可转入%@", _fundAccount];
    [self.view addSubview:redTf];
    
    UIButton * redBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    redBtn.frame = CGRectMake(175 / 2 * kScreenWidth1, 160 * kScreenHeight1, 200 * kScreenWidth1, 44 * kScreenHeight1);
    redBtn.layer.cornerRadius = 5;
    redBtn.layer.masksToBounds = YES;
    [redBtn setBackgroundColor:[UIColor colorWithRed:241 / 255.0 green:73 / 255.0 blue:97 / 255.0 alpha:1]];
    [redBtn setTitle:@"确认转入" forState:UIControlStateNormal];
    [redBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [redBtn addTarget:self action:@selector(handleAction1) forControlEvents:UIControlEventTouchUpInside];
    redBtn.tag = 103;
    [self.view addSubview:redBtn];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadMyInfo1];
}

#pragma mark ------------------ 请求 >>> 个人信息 ----------------
- (void)loadMyInfo1 {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,MyInfo] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] intValue]== 0){
             [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"] forKey:@"MyInfo"];
        } else {
            
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

- (void)handleAction1 {
    UITextField * redTf = [self.view viewWithTag:104];
    float v = [redTf.text floatValue];
    if (v != 0) {
        DCPaymentView *payAlert = [[DCPaymentView alloc]init];
        payAlert.title = @"请输入支付密码";
        payAlert.detail = @"转入金额";
        payAlert.amount = v;
        [payAlert show];
        payAlert.completeHandle = ^(NSString *inputPwd) {
            _str = [NSString stringWithFormat:@"%@", inputPwd];
            [self request];
        };
        payAlert.dismissView = ^(int dissmiss){
            
        };
    } else {
        Alert_Show(@"请填写您的转入金额");
    }
    
}

- (void) request {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    UITextField * redTf = [self.view viewWithTag:104];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/life/shop/transfer/toShop?payPassword=%@&amount=%@",LSKurl, _str, redTf.text] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"code"] integerValue] == 0)
        {
            NSLog(@"转出jine%@", responseObject);
            Alert_Show(@"转入成功");
            float a = [_fundAccount floatValue] - [redTf.text floatValue];
            _fundAccount = [NSString stringWithFormat:@"%.2f", a];
            redTf.placeholder = [NSString stringWithFormat:@"本次最多可转入%@", _fundAccount];
            redTf.text = @"";
             [self loadMyInfo1];
        }else if([responseObject[@"code"] integerValue] == 701){
            Alert_Show(@"可用资金不足");
            
        }else if([responseObject[@"code"] integerValue] == 300302){
            Alert_Show(@"参数错误");
            
        }else if([responseObject[@"code"] integerValue] == 713 || [responseObject[@"code"] integerValue] == 708){
            Alert_Show(@"支付密码错误");
            
        }else if([responseObject[@"code"] integerValue] == 716){
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"您尚未设置支付密码, 请前往设置支付密码!" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {//跳往设置支付密码
                SYVerificationMobileController * payVC = [[SYVerificationMobileController alloc] init];
                payVC.discriminatePage = 6;
                [self.navigationController pushViewController:payVC animated:YES];
            }];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];

            
        }else if([responseObject[@"code"] integerValue] == 734){
            Alert_Show(@"您尚未注册商店");
        }else if([responseObject[@"code"] integerValue] == 728){
            Alert_Show(@"商家未激活");
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
