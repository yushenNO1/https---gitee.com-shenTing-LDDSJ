//
//  DetailContactVC.m
//  采购单
//
//  Created by 张敬文 on 2017/5/27.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "DetailContactVC.h"
#import "AFNetworking.h"
@interface DetailContactVC ()
@property (nonatomic, strong) NSDictionary * dic;
@end

@implementation DetailContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"采购单信息";
    [self request];
    
    // Do any additional setup after loading the view.
}

- (void)request {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:CGDDetail, _orderId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----21234---%@", responseObject);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"0"]) {
            self.dic = responseObject[@"data"];
            [self configView];
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"-------%@", error);
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

- (void)configView
{
    NSArray * ary = @[@"店  铺  名:", @"地        址:", @"订购数量:", @"联系电话:"];
    for (int i = 0; i < 4; i++) {
        UILabel * Label = [[UILabel alloc] init];
        Label.frame = WDH_CGRectMake(10, 74 + i * 65, 100, 60);
        Label.text = ary[i];
        Label.textColor = [UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1];
        Label.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:Label];
        
        
        
        UILabel * lineLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 134 + i * 65, 375, 1)];
        lineLabel.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
        [self.view addSubview:lineLabel];
    }
    
    
    
    UILabel * Label1 = [[UILabel alloc] init];
    Label1.frame = WDH_CGRectMake(110, 74 + 0 * 65, 255, 60);
     if ([_type isEqualToString:@"2"]) {
          Label1.text = [NSString stringWithFormat:@"%@", _dic[@"buyerName"]];
     } else {
          Label1.text = [NSString stringWithFormat:@"%@", _dic[@"sellerName"]];
     }
    
    Label1.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:Label1];
    
    UILabel * Label11 = [[UILabel alloc] init];
    Label11.frame = WDH_CGRectMake(110, 74 + 1 * 65, 255, 60);
     if ([_type isEqualToString:@"2"]) {
          Label11.text = [NSString stringWithFormat:@"%@", _dic[@"buyerAddress"]];
     } else {
          Label11.text = [NSString stringWithFormat:@"%@", _dic[@"sellerAddress"]];
     }
    Label11.numberOfLines = 0;
    Label11.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:Label11];
    
    UILabel * Label12 = [[UILabel alloc] init];
    Label12.frame = WDH_CGRectMake(110, 74 + 2 * 65, 255, 60);
    Label12.font = [UIFont systemFontOfSize:14];
    NSArray * ary1 = _dic[@"lpgList"];
    int a = 0;
    for (NSDictionary * dataDic in ary1) {
        a = a + [dataDic[@"count"] intValue];
    }
    Label12.text = [NSString stringWithFormat:@"%d", a];
    [self.view addSubview:Label12];
    
    UIButton * Btm = [UIButton buttonWithType:UIButtonTypeSystem];
    Btm.frame = WDH_CGRectMake(110, 74 + 3 * 65, 100, 60);
     
     if ([_type isEqualToString:@"2"]) {
          [Btm setTitle:[NSString stringWithFormat:@"%@", _dic[@"buyerMobile"]] forState:UIControlStateNormal];
     } else {
          [Btm setTitle:[NSString stringWithFormat:@"%@", _dic[@"sellerMobile"]] forState:UIControlStateNormal];
     }
    
    [Btm addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btm];
    

    
    
}

- (void) handleAction:(UIButton *) sender
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",sender.titleLabel.text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
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
