//
//  CreateQrcodeVC.m
//  YSApp
//
//  Created by 云盛科技 on 16/9/8.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "CreateQrcodeVC.h"
#import "UIImage+QRCode.h"
#import "AFNetworking.h"
#import "NetURL.h"

@interface CreateQrcodeVC ()
{
    UIView *qrView;
    UIImageView *imag;
    NSString *qrContent;
    int threadID;
    NSTimer *timer;
    NSDictionary *myInfo;
}
@end

@implementation CreateQrcodeVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
    timer = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    myInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
    
    self.title = self.tit;
    threadID = 50;
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:backImg];
    backImg.image = [UIImage imageNamed:@"gradient_backgroud"];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(10*kScreenWidth , 200*kScreenHeight, self.view.bounds.size.width-20*kScreenWidth, self.view.bounds.size.height-250*kScreenHeight)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 20;
    whiteView.layer.masksToBounds = YES;
    [self.view addSubview:whiteView];
    
    imag = [[UIImageView alloc]initWithFrame:CGRectMake(40*kScreenWidth, 80*kScreenHeight, whiteView.frame.size.width-80*kScreenWidth  , whiteView.frame.size.width-80*kScreenWidth)];
    
    [whiteView addSubview:imag];
    
    if ([self.tit isEqualToString:@"付款"])
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imag.frame.origin.x, imag.frame.origin.y+10+whiteView.frame.size.width-80*kScreenWidth, whiteView.frame.size.width-80*kScreenWidth, 18)];
        label.text = @"每分钟自动更新,建议当面使用";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [whiteView addSubview:label];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];

    }
    else
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imag.frame.origin.x, imag.frame.origin.y+10+whiteView.frame.size.width-80*kScreenWidth, whiteView.frame.size.width-80*kScreenWidth, 18)];
        label.text = [NSString stringWithFormat:@"收取金额  %@  云豆",_content];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [whiteView addSubview:label];
    }
    [self requestQr];
}
-(void)run
{
    threadID --;
    if (threadID <= 0)
    {
        [self requestQr];
        threadID = 50;
    }
}
//获取二维码
-(void)requestQr
{
    NSLog(@"获取二维码----%@",[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:@"/v1/api/payCode/getPayCode?codeType=%@",_type]]);
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"X-Auth-Token"];
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:@"/v1/api/payCode/getPayCode?codeType=%@",_type]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"1123----%@",responseObject[@"payCode"]);
        if ([responseObject[@"error_code"] intValue ] == 0)
        {
            if ([self.tit isEqualToString:@"付款"])
            {
                qrContent = [NSString stringWithFormat:@"payCode&%@&%@",responseObject[@"payCode"],myInfo[@"mobile"]];
            }else
            {
                qrContent = [NSString stringWithFormat:@"payCode&%@&%@&%@",responseObject[@"payCode"],_content,_Percentage];
            }
            
            NSLog(@"qrContent---%@",qrContent);
            imag.image = [UIImage qrImageWithContent:qrContent logo:[UIImage imageNamed:@"Logo2@3x"] size:200 red:38 green:38 blue:38];
        }
        
        NSLog(@"responseObject----$%@",responseObject);
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
