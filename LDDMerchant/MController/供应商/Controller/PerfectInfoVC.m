//
//  PerfectInfoVC.m
//  供应商
//
//  Created by 张敬文 on 2017/8/5.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "PerfectInfoVC.h"
#import "CloverText.h"
#import "AFNetworking.h"
#import "OverVC.h"
@interface PerfectInfoVC ()
@property (nonatomic, strong) CloverText * textField_1;
@property (nonatomic, strong) CloverText * textField_2;
@property (nonatomic, strong) CloverText * textField_3;
@end

@implementation PerfectInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

     
    self.view.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    self.title = @"填写资料";
    [self configView];
    // Do any additional setup after loading the view.
//     UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
//     
//     [self.tableView addGestureRecognizer:myTap];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifikation:) name:UIKeyboardWillChangeFrameNotification object:nil];
     //     UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
     //
     //     [self.tableView addGestureRecognizer:myTap];
}
//
//- (void)scrollTap:(id)sender {
//     [self.view endEditing:YES];
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.view endEditing:YES];
}

-(void)notifikation:(NSNotification *)sender
{
     CGRect rect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
     self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, rect.origin.y);
     NSLog(@"键盘大小------%@",sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
}

//- (void)scrollTap:(id)sender {
//     [self.view endEditing:YES];
//}

- (void) configView
{
    UILabel * titleLabel_1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(15, 74, 300, 30)];
    titleLabel_1.text = @"简介";
    titleLabel_1.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
    titleLabel_1.font = [UIFont systemFontOfSize:15* kScreenHeight1];
    [self.view addSubview:titleLabel_1];
    
    self.textField_1 = [[CloverText alloc]initWithFrame:WDH_CGRectMake(10, 104, 355, 100) placeholder:@"请填写简介"];
    _textField_1.font = [UIFont systemFontOfSize:15* kScreenHeight1];
    _textField_1.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
    _textField_1.layer.borderWidth = 1.0f;
    [self.view addSubview:_textField_1];
    
    UILabel * titleLabel_2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(15, 214, 300, 30)];
    titleLabel_2.text = @"视频播放链接";
    titleLabel_2.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
    titleLabel_2.font = [UIFont systemFontOfSize:15* kScreenHeight1];
    [self.view addSubview:titleLabel_2];
    
    self.textField_3 = [[CloverText alloc]initWithFrame:WDH_CGRectMake(10, 244, 355, 120) placeholder:@"请填写视频url"];
    _textField_3.font = [UIFont systemFontOfSize:15* kScreenHeight1];
    _textField_3.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
    _textField_3.layer.borderWidth = 1.0f;
    [self.view addSubview:_textField_3];
    
//    UIButton * Btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    Btn1.frame = CGRectMake(10, 244, 355, 120);
//    Btn1.backgroundColor = [UIColor whiteColor];
//    Btn1.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
//    Btn1.layer.borderWidth = 1.0f;
//    [self.view addSubview:Btn1];
//    [Btn1 addTarget:self action:@selector(handleAdd) forControlEvents:UIControlEventTouchUpInside];
//    
    UILabel * titleLabel_3 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(15, 374, 300, 30)];
    titleLabel_3.text = @"拓展限额";
    titleLabel_3.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
    titleLabel_3.font = [UIFont systemFontOfSize:15* kScreenHeight1];
    [self.view addSubview:titleLabel_3];
    
    self.textField_2 = [[CloverText alloc]initWithFrame:WDH_CGRectMake(10, 404, 355, 40) placeholder:@"请填写拓展限额"];
    _textField_2.font = [UIFont systemFontOfSize:15* kScreenHeight1];
    _textField_2.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
    _textField_2.layer.borderWidth = 1.0f;
    _textField_2.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:_textField_2];
    
     if ([_type isEqualToString:@"2"]) {
          _textField_1.text = [NSString stringWithFormat:@"%@", _dic[@"content"]];
          _textField_3.text = [NSString stringWithFormat:@"%@", _dic[@"url"]];
          _textField_2.text = [NSString stringWithFormat:@"%@", _dic[@"largeOrderLimit"]];
     }
    
    UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
    Btn.frame = WDH_CGRectMake(20, 597, 335, 50);
     Btn.tag = 2000;
    Btn.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:74 / 255.0 blue:91 / 255.0 alpha:1];
    [Btn setTitle:@"立即申请" forState:UIControlStateNormal];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Btn.layer.cornerRadius = 5;
    Btn.layer.masksToBounds = YES;
    Btn.titleLabel.font = [UIFont systemFontOfSize:20* kScreenHeight1];
    [self.view addSubview:Btn];
    [Btn addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void) handleAction {
     UIButton * Btn = [self.view viewWithTag:2000];
     Btn.userInteractionEnabled = NO;
     
     NSString * Str1 = [_textField_1.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSString * Str2 = [_textField_3.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSString * Str3 = [NSString stringWithFormat:@"%.2f", [_textField_2.text floatValue]];
     
     if (Str1.length != 0 || Str2.length != 0 || Str3.length != 0) {
          NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
          AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
          manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
          manager.requestSerializer = [AFJSONRequestSerializer serializer];
          manager.responseSerializer = [AFJSONResponseSerializer serializer];
          [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
          [manager POST:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:GYSPerfectInfo,Str1,Str2,Str3]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSLog(@"%@请求数据", responseObject);
               if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
                    Btn.userInteractionEnabled = YES;
                    OverVC * zjwVC = [[OverVC alloc] init];
                    [self.navigationController pushViewController:zjwVC animated:YES];
               } else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"1027"]) {
                    Btn.userInteractionEnabled = YES;
                    NSString * str = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
                    Alert_Show(str)
               } else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"734"]) {
                    Btn.userInteractionEnabled = YES;
                    NSString * str = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
                    Alert_Show(str)
               } else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"732"]) {
                    Btn.userInteractionEnabled = YES;
                    NSString * str = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
                    Alert_Show(str)
               } else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"1023"]) {
                    Btn.userInteractionEnabled = YES;
                    NSString * str = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
                    Alert_Show(str)
               } else {
                    Btn.userInteractionEnabled = YES;
                    NSString * str = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
                    Alert_Show(str)
               }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               Btn.userInteractionEnabled = YES;
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

     } else {
          Alert_Show(@"供应商信息填写不完整, 请补充后再进行提交")
     }
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
