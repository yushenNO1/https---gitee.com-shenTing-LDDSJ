//
//  SMSKVC.m
//  WDHMerchant
//
//  Created by 张敬文 on 2017/2/25.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "SMSKVC.h"
#import "UIColor+Addition.h"
#import "NetURL.h"
#import "AFNetworking.h"

#import "QRCodeReaderViewController.h"
#import "CreateQrcodeVC.h"
#define kScreenWidth1  ([UIScreen mainScreen].bounds.size.width / 375)
#define kScreenHeight1  ([UIScreen mainScreen].bounds.size.height / 667)
@interface SMSKVC ()<QRCodeReaderDelegate>

@end

@implementation SMSKVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫码收款";
    self.view.backgroundColor = [UIColor backGray];
    
    UILabel * backLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 140 * kScreenHeight1, 375 * kScreenWidth1, 60 * kScreenHeight1)];
    backLabel1.text = @"请输入收款金额";
    backLabel1.font = [UIFont systemFontOfSize:25];
    backLabel1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:backLabel1];
    
    UITextField *redTf = [[UITextField alloc] initWithFrame:CGRectMake(100 * kScreenWidth1, 230 * kScreenHeight1, 175 * kScreenWidth1, 60 * kScreenHeight1)];
    redTf.font = [UIFont systemFontOfSize:17];
    redTf.layer.cornerRadius = 10;
    redTf.layer.masksToBounds = YES;
    redTf.backgroundColor = [UIColor whiteColor];
    redTf.keyboardType = UIKeyboardTypeDecimalPad;
    redTf.placeholder = @"收款金额";
    redTf.textAlignment = NSTextAlignmentCenter;
    redTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    redTf.tag = 104;
    [self.view addSubview:redTf];
    
    UIButton * redBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    redBtn.frame = CGRectMake(175 / 2 * kScreenWidth1, 450 * kScreenHeight1, 200 * kScreenWidth1, 44 * kScreenHeight1);
    redBtn.layer.cornerRadius = 5;
    redBtn.layer.masksToBounds = YES;
    [redBtn setBackgroundColor:[UIColor colorWithRed:241 / 255.0 green:73 / 255.0 blue:97 / 255.0 alpha:1]];
    [redBtn setTitle:@"点击扫码" forState:UIControlStateNormal];
    [redBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [redBtn addTarget:self action:@selector(handleAction1) forControlEvents:UIControlEventTouchUpInside];
    redBtn.tag = 103;
    [self.view addSubview:redBtn];
}

- (void) handleAction1
{
     UITextField * redTf = [self.view viewWithTag:104];
     if (redTf.text.length == 0) {
          Alert_Show(@"请先输入收款金额")
     } else {
          __block int aaa = 0;
          static QRCodeReaderViewController * reader = nil;
          static dispatch_once_t onceToken;
          dispatch_once(&onceToken, ^{
               reader = [QRCodeReaderViewController new];
               reader.modalPresentationStyle = UIModalPresentationFormSheet;
          });
          reader.delegate = self;
          [reader setCompletionWithBlock:^(NSString * resultAsString) {
               if (resultAsString) {
                    NSLog(@"%@", resultAsString);
                    if (aaa == 0) {
                         if ([resultAsString rangeOfString:@"payCode#"].location !=NSNotFound)
                         {
                              NSArray *array = [resultAsString componentsSeparatedByString:@"#"];
                              NSLog(@"%@", array[1]);
                              [self request:array[1]];
                         }
                         aaa ++;
                    }
               }
          }];
          [self presentViewController:reader animated:YES completion:NULL];
     }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)request:(NSString *)str1 {
    UITextField * redTf = [self.view viewWithTag:104];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     
     
          [manager POST:[NSString stringWithFormat:@"%@/api/v1/life/payCode/scanReceipt?code=%@&payAmount=%@",LSKurl, str1, redTf.text] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSLog(@"%@", responseObject);
               if ([responseObject[@"code"] intValue]== 0){
                    redTf.text = nil;
                    Alert_Show(@"收款成功")
               } else if ([responseObject[@"code"] intValue]== 701){
                    redTf.text = nil;
                    Alert_Show(@"对方可用资金不足, 请让您的亲扫您试试哦")
               } else {
                    redTf.text = nil;
                    Alert_Show(@"收款失败, 请您重新尝试")
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

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
         UITextField * redTf = [self.view viewWithTag:104];
         redTf.text = nil;
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader{
    [self dismissViewControllerAnimated:YES completion:NULL];
     UITextField * redTf = [self.view viewWithTag:104];
     redTf.text = nil;
    [self.navigationController popToViewController:self animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
