//
//  MerchantsVC.m
//  YSApp
//
//  Created by 云盛科技 on 16/9/8.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "MerchantsVC.h"
#import "GoodPurchaseVC.h"
#import "CheckStandVC.h"
#import "QRCodeReaderViewController.h"
#import "CreateQrcodeVC.h"
#import "UIColor+Addition.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ShareGoodsVC.h"
#import "NetURL.h"
#import "MeHistoryVC.h"
#import "EarningsDetailController.h"
#import "projectVC.h"
#import "shopVC.h"
#import "earningsViewController.h"
#import "MerchantTVC.h"
#import "MerchantZVC.h"
#import "MerchantRVC.h"
#import "SYLoginPage.h"
#import "SMSKVC.h"
#import "SKMVC.h"
#import "WSSNameAuthenticationViewController.h"
#import "EarningsDetailController.h"
#import "DetectionVC.h"
#import "SuppliersVC.h"  //申请
#import "SuppliersOverVC.h"  //供应商
#import "LYTManagementVC.h"
#import "AgentShopVC.h"
#import "LYTPurchaseVC.h"
#import "LYTFMDB.h"
#import "LYTAgent.h"
#import "ApplyAgentVC.h"

#import "OrderIncomeVC.h"

#import "LYTRefundManage.h"        //退款管理


@interface MerchantsVC ()<QRCodeReaderDelegate, UITextFieldDelegate, UIActionSheetDelegate>


@property (nonatomic,assign) int QRIS;
//@property(nonatomic,retain)UILabel * shopNameLabel;
@property(nonatomic,copy)NSDictionary *myInfoDic;
@property(nonatomic,copy)NSString *Percentage;
@property(nonatomic,retain)UITextField * moneyCodeTf;
@property(nonatomic,copy)NSString *fundAccount;
@property(nonatomic,copy)NSString *ZRAccount;
@property(nonatomic,copy)NSString *code;
@property (nonatomic, strong) UIView * pickVC;
@property (nonatomic, strong) UIView * SuccessVC;

//验证结果值
@property(nonatomic,copy)NSString *lifeItemName;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *validityDate;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,retain)UILabel * moneyLabel;
@property(nonatomic,copy)NSString * machineStatus;//检测申请状态
@end

@implementation MerchantsVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"index"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self loadMyInfo1];
    
    [self loadMyInfo];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:56 / 255.0 blue:84 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:253 / 255.0 green:56 / 255.0 blue:84 / 255.0 alpha:1.0];
    self.tabBarController.tabBar.hidden = YES;
    [self setNavigationBarConfiguer];
     
     UIImageView *imageView = [self.view viewWithTag:100008];
     
     NSDictionary *shopInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
    
     if ([shopInfo[@"machineStatus"] integerValue] == -1) {
          //未提交过申请
          imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"检测"]];
     }else if ([shopInfo[@"machineStatus"] integerValue] == 0){
          //已提交申请待审批
          imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"检测"]];
     }else if ([shopInfo[@"machineStatus"] integerValue] == 1){
          //审批通过
          imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iOS检测收款"]];
     }else if ([shopInfo[@"machineStatus"] integerValue] == 2){
          //被驳回
          imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"检测"]];
     }
}

- (void)setNavigationBarConfiguer {
    //右侧view上
    UIView * viewBackInNavi=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 35 * kScreenWidth1, 35 * kScreenHeight1)];
    viewBackInNavi.backgroundColor=[UIColor clearColor];
    viewBackInNavi.userInteractionEnabled=YES;
    
    //切换账户按钮
    UIButton *myRightRePaintBtn=[[UIButton alloc]initWithFrame:CGRectMake(17 / 2 * kScreenWidth1, 17 / 2 * kScreenHeight1, 18 * kScreenWidth1, 18 * kScreenHeight1)];
    [myRightRePaintBtn addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    [myRightRePaintBtn setBackgroundColor:[UIColor clearColor]];
    [myRightRePaintBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [myRightRePaintBtn setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    [myRightRePaintBtn setTitle:[NSString stringWithFormat:@" %@",NSLocalizedString(@"local_paintAgain", nil)] forState:UIControlStateNormal];
    myRightRePaintBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [viewBackInNavi addSubview:myRightRePaintBtn];
    
    UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithCustomView:viewBackInNavi];
    //将整个viewBackInNavi右移10
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    negativeSpacer.width =-10 * kScreenWidth1;//负数为右移，正数为左移
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,right, nil];

}


- (void) rightBarButtonItemAction {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要切换账号吗?" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"切换" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {//跳往设置支付密码
        [self qiehuan];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void) qiehuan {
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"index"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
     
     [[LYTFMDB sharedDataBase]deleAllSeachText];
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    SYLoginPage * me = [[SYLoginPage alloc] init];
    UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:me];
    window.rootViewController = naVC;
}

#pragma mark ------------------ 请求 >>> 个人信息 ----------------
- (void)loadMyInfo1 {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,Info] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"个人信息---%@", responseObject);
        responseObject = [PublicToors changeNullInData:responseObject];
        
         [[NSUserDefaults standardUserDefaults] setObject: responseObject[@"data"] forKey:@"infoMy"];
        if ([responseObject[@"code"] intValue]== 0){
            //涉及到个人信息的判断
            NSDictionary * dic = responseObject[@"data"][@"realnameVo"];
            if (dic.count == 0) {
                _code = @"0";
            } else {
                _code = @"1";
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", responseObject[@"data"][@"realnameVo"][@"name"]] forKey:@"name"];
            }
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


#pragma mark ------------------ 请求 >>> 商家信息 ----------------
- (void)loadMyInfo {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,MyInfo] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject[@"data"] options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"null"withString:@"\"LYTChange\""];
        NSData *jsonData1 = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:jsonData1 options:NSJSONReadingMutableContainers error:&err];
        NSLog(@"商家信息-----阿达-----%@",responseObject);
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"MyInfo"];
        _myInfoDic = responseObject;
            self.title = responseObject[@"shopName"];
             _moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", [responseObject[@"fundAccount"] floatValue]];
            self.fundAccount = [NSString stringWithFormat:@"%.2f", [responseObject[@"fundAccount"] floatValue]];
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
/** 状态栏高度 */
#define kStatusBarH CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define kNavigationHeight (kStatusBarH + 44)
-(void)viewDidLoad{
     [super viewDidLoad];
     
     self.navigationController.title = @"量多多商家";
     NSArray *arr = @[@"商品管理", @"订单管理",  @"门店管理",@"退货管理",@"区域代理",@"收款码1111", @"提现"];
     for (int i = 0; i < arr.count; i ++) {
          
          UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
          btn.backgroundColor = [UIColor whiteColor];
          btn.frame = CGRectMake( i%3 * kScreenWidth/3 ,i/3 * 100 + kNavigationHeight+20, kScreenWidth/3, 60);
         
//          if (i > 2 && i <= 5) {
//               btn.frame = CGRectMake(375 / 3 * (i - 3) *kScreenWidth1, kNavigationHeight + 100 * kScreenHeight1, (375/3 - 1) * kScreenWidth1, 100 * kScreenHeight1);
//          } else if (i <= 2) {
//               btn.frame = CGRectMake(375 / 3 * i * kScreenWidth1,kNavigationHeight, (375 / 3 - 1) * kScreenWidth1, 100 * kScreenHeight1);
//          }else if (i > 5 && i <= 8) {
//               btn.frame = CGRectMake(375 / 3 * (i - 6) *kScreenWidth1, kNavigationHeight + 200 * kScreenHeight1, (375/3 - 1) * kScreenWidth1, 100 * kScreenHeight1);
//          } else {
//               btn.frame = CGRectMake(375 / 3 * (i - 9) *kScreenWidth1, kNavigationHeight + 300 * kScreenHeight1, (375/3 - 1) * kScreenWidth1, 100 * kScreenHeight1);
//          }
          btn.tag =100 + i;
          
          [btn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
          //        [btn setBackgroundColor:[UIColor whiteColor]];
          //        [btn setBackgroundImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
          [self.view addSubview:btn];
          
          UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arr[i]]];
          imageView.tag = 100000+i;
         
         imageView.frame = CGRectMake( i%3 * kScreenWidth/3 + 40,i/3 * 100 + kNavigationHeight+20, 50, 60);
         
//          if (i > 2 && i <= 5) {
//               imageView.frame = CGRectMake((375/3*(i- 3) + 30)* kScreenWidth1, kNavigationHeight + 120, (375/3 - 1 - 60) * kScreenWidth1, 64 * kScreenHeight1);
//              if ( i == 5) {
//                  imageView.frame = CGRectMake((375/3*(i- 3) + 30)* kScreenWidth1, kNavigationHeight + 120, (375/3 - 1 - 80) * kScreenWidth1, 64 * kScreenHeight1);
//              }
//          } else if (i <= 2) {
//               imageView.frame = CGRectMake((375/3 * i + 30) * kScreenWidth1, kNavigationHeight + 20, (375/3 - 1 - 60) *kScreenWidth1, 64 * kScreenHeight1);
//          } else if (i > 5 && i <= 8) {
//               imageView.frame = CGRectMake((375/3 * (i - 6) + 30) * kScreenWidth1, kNavigationHeight + 220, (375/3 - 1 - 60) *kScreenWidth1, 64 * kScreenHeight1);
//          } else {
//               imageView.frame = CGRectMake((375/3 * (i - 9) + 30) * kScreenWidth1, kNavigationHeight + 320, (375/3 - 1 - 60) *kScreenWidth1, 64 * kScreenHeight1);
//               //             btn.frame = CGRectMake(375 / 3 * (i - 9) *kScreenWidth1, 578 * kScreenHeight1, (375/3 - 1) * kScreenWidth1, 100 * kScreenHeight1);
//          }
          [self.view addSubview:imageView];
     }

     self.view.backgroundColor = [UIColor whiteColor];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.title = @"量多多";
//     [self loadMyInfo];   //商家信息
//
//     [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
//
//
//    self.view.backgroundColor = [UIColor backGray];
//    [self configView];
//     NSDictionary *shopInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
//     NSLog(@"商家信息-----%@",shopInfo);
//     if ([[shopInfo class] isEqual:[NSNull class]]) {
//          AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//          manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//          manager.requestSerializer = [AFJSONRequestSerializer serializer];
//          manager.responseSerializer = [AFJSONResponseSerializer serializer];
//          [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//          [manager.requestSerializer setValue:@"Basic bW9iaWxlOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
//          NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"];
//          NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PwdID"];
//          [manager POST:[NSString stringWithFormat:loginUrl,login,password] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//               NSString *tokenStr = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
//
//               //                             [[LYTFMDB sharedDataBase]deleAllSeachText];
//               if (responseObject[@"access_token"] != nil) {
//                    [[NSUserDefaults standardUserDefaults]setObject:tokenStr  forKey:@"token"];
//                    [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"LoginID"];
//                    [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"PwdID"];
//               } else {
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
//               }
//          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//          }];
//     }else if (shopInfo==nil){
//          AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//          manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//          manager.requestSerializer = [AFJSONRequestSerializer serializer];
//          manager.responseSerializer = [AFJSONResponseSerializer serializer];
//          [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//          [manager.requestSerializer setValue:@"Basic bW9iaWxlOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
//          NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"];
//          NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PwdID"];
//          [manager POST:[NSString stringWithFormat:loginUrl,login,password] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//               NSString *tokenStr = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
//
//               //                             [[LYTFMDB sharedDataBase]deleAllSeachText];
//               if (responseObject[@"access_token"] != nil) {
//                    [[NSUserDefaults standardUserDefaults]setObject:tokenStr  forKey:@"token"];
//                    [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"LoginID"];
//                    [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"PwdID"];
//               } else {
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
//               }
//          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//          }];
//     }else{
//
//     }
//
//    NSArray *arr = @[@"商品管理", @"manage_shop@3x",  @"buess_zhuanchu@3x", @"buess_tixian",@"商品采购200*200", @"code_pay_password@3x", @"buess_bill@3x", @"收银台200*200",@"检测",@"区域代理200*200", @"供应商"];
//    for (int i = 0; i < arr.count; i ++) {
//
//
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//        btn.backgroundColor = [UIColor whiteColor];
//        if (i > 2 && i <= 5) {
//            btn.frame = CGRectMake(375 / 3 * (i - 3) *kScreenWidth1, 376 * kScreenHeight1, (375/3 - 1) * kScreenWidth1, 100 * kScreenHeight1);
//        } else if (i <= 2) {
//            btn.frame = CGRectMake(375 / 3 * i * kScreenWidth1, 275* kScreenHeight1, (375 / 3 - 1) * kScreenWidth1, 100 * kScreenHeight1);
//        }else if (i > 5 && i <= 8) {
//             btn.frame = CGRectMake(375 / 3 * (i - 6) *kScreenWidth1, 477 * kScreenHeight1, (375/3 - 1) * kScreenWidth1, 100 * kScreenHeight1);
//        } else {
//            btn.frame = CGRectMake(375 / 3 * (i - 9) *kScreenWidth1, 578 * kScreenHeight1, (375/3 - 1) * kScreenWidth1, 100 * kScreenHeight1);
//        }
//        btn.tag =100 + i;
//
//        [btn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
////        [btn setBackgroundColor:[UIColor whiteColor]];
//        //        [btn setBackgroundImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
//        [self.view addSubview:btn];
//
//        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arr[i]]];
//         imageView.tag = 100000+i;
//         if (i == 8) {
//              if ([shopInfo[@"machineStatus"] integerValue] == -1) {
//                   //未提交过申请
//                 imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"检测"]];
//              }else if ([shopInfo[@"machineStatus"] integerValue] == 0){
//                   //已提交申请待审批
//                   imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"检测"]];
//              }else if ([shopInfo[@"machineStatus"] integerValue] == 1){
//                   //审批通过
//                   imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iOS检测收款"]];
//              }else if ([shopInfo[@"machineStatus"] integerValue] == 2){
//                   //被驳回
//                   imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"检测"]];
//              }
//         }
//        if (i > 2 && i <= 5) {
//            imageView.frame = CGRectMake((375/3*(i- 3) + 30)* kScreenWidth1, 392*kScreenHeight1, (375/3 - 1 - 60) * kScreenWidth1, 64 * kScreenHeight1);
//        } else if (i <= 2) {
//            imageView.frame = CGRectMake((375/3 * i + 30) * kScreenWidth1, 292 *kScreenHeight1, (375/3 - 1 - 60) *kScreenWidth1, 64 * kScreenHeight1);
//        } else if (i > 5 && i <= 8) {
//             imageView.frame = CGRectMake((375/3 * (i - 6) + 30) * kScreenWidth1, 492 *kScreenHeight1, (375/3 - 1 - 60) *kScreenWidth1, 64 * kScreenHeight1);
//        } else {
//             imageView.frame = CGRectMake((375/3 * (i - 9) + 30) * kScreenWidth1, 593 *kScreenHeight1, (375/3 - 1 - 60) *kScreenWidth1, 64 * kScreenHeight1);
////             btn.frame = CGRectMake(375 / 3 * (i - 9) *kScreenWidth1, 578 * kScreenHeight1, (375/3 - 1) * kScreenWidth1, 100 * kScreenHeight1);
//        }
//        [self.view addSubview:imageView];
//    }
//}

-(void)configView
{
     
     
    UIImageView * imageView1 = [[UIImageView alloc] init];
    imageView1.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:56 / 255.0 blue:84 / 255.0 alpha:1.0];
    imageView1.frame = CGRectMake(0, 0, 375 * kScreenWidth1, 274 * kScreenHeight1);
    [self.view addSubview:imageView1];
     // 单击的 Recognizer
     UITapGestureRecognizer* singleRecognizer;
     singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap)];
     //点击的次数
     singleRecognizer.numberOfTapsRequired = 1; // 单击
     
     //给self.view添加一个手势监测；
     
     [self.view addGestureRecognizer:singleRecognizer];
     
     
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 * kScreenHeight1, 375 *kScreenWidth1, 160 * kScreenHeight1)];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    self.moneyCodeTf = [[UITextField alloc] initWithFrame:CGRectMake(50 * kScreenWidth1, 25 * kScreenHeight1, 275 * kScreenWidth1, 50 * kScreenHeight1)];
    _moneyCodeTf.backgroundColor = [UIColor whiteColor];
    _moneyCodeTf.delegate = self;
    _moneyCodeTf.layer.cornerRadius = 10;
    _moneyCodeTf.layer.masksToBounds = YES;
    _moneyCodeTf.placeholder = @"请输入消费验证码";
    _moneyCodeTf.textAlignment = NSTextAlignmentCenter;
    _moneyCodeTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [backView addSubview:_moneyCodeTf];
    
    UILabel * bLabel = [[UILabel alloc] initWithFrame:CGRectMake(375 / 2 *kScreenWidth1, 110 *kScreenHeight1, 1 *kScreenWidth1, 40 * kScreenHeight1)];
    bLabel.backgroundColor = [UIColor whiteColor];
    bLabel.alpha =0.7;
    [backView addSubview:bLabel];
    
    UILabel * cLabel = [[UILabel alloc] initWithFrame:CGRectMake(375 / 2 * kScreenWidth1, 101 *kScreenHeight1, 1 * kScreenWidth1, 10 * kScreenHeight1)];
    cLabel.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.4];
    [backView addSubview:cLabel];
    
    UILabel * dLabel = [[UILabel alloc] initWithFrame:CGRectMake(375 / 2 *kScreenWidth1, 150 *kScreenHeight1, 1 * kScreenWidth1, 10 *kScreenHeight1)];
    dLabel.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.4];
    [backView addSubview:dLabel];
    
    UIButton * aBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    aBtn.frame = CGRectMake(0, 101 *kScreenHeight1, 374 / 2 *kScreenWidth1, 59 *kScreenHeight1);
    aBtn.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.4];
    aBtn.tag = 106;
    [aBtn addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:aBtn];
    
    UIButton * bBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    bBtn.frame = CGRectMake((374 / 2 + 1) *kScreenWidth1, 101 *kScreenHeight1, 375 / 2 *kScreenWidth1, 59 *kScreenHeight1);
    bBtn.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.4];
    bBtn.tag = 107;
    [bBtn addTarget:self action:@selector(handleAction1) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:bBtn];
    
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saoyisao"]];
    imageView.frame = CGRectMake(45 * kScreenWidth1, 122 * kScreenHeight1, (375 / 2 - 90) *kScreenWidth1, 16 *kScreenHeight1);
    [backView addSubview:imageView];
    
    UIImageView * imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_code_Record@3x"]];
    imageView2.frame = CGRectMake((375 / 2 + 45) * kScreenWidth1, 122 * kScreenHeight1, (375 / 2 - 90)* kScreenWidth1, 16 *kScreenHeight1);
    [backView addSubview:imageView2];
     
     UILabel * backView1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 224 * kScreenHeight1, 375 * kScreenWidth1, 50 * kScreenHeight1)];
     backView1.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:backView1];
     
     UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(105 * kScreenWidth1, 224 * kScreenHeight1, 80 * kScreenWidth1, 50 * kScreenHeight1)];
//     titleLabel.backgroundColor = [UIColor redColor];
     titleLabel.text = @"商铺通贝:";
//     titleLabel.textColor = [UIColor grayColor];254554
     titleLabel.font = [UIFont systemFontOfSize:15 * kScreenHeight1];
     [self.view addSubview:titleLabel];
     
     self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 224 * kScreenHeight1, 200 * kScreenWidth1, 50 * kScreenHeight1)];
//     _moneyLabel.backgroundColor = [UIColor greenColor];
     _moneyLabel.text = [NSString stringWithFormat:@"¥%@", _fundAccount];
     _moneyLabel.textAlignment = NSTextAlignmentLeft;
     _moneyLabel.textColor = [UIColor colorWithRed:233 / 255.0 green:34 / 255.0 blue:30 / 255.0 alpha:1];
     _moneyLabel.font = [UIFont systemFontOfSize:15 * kScreenHeight1];
     [self.view addSubview:_moneyLabel];
}

- (void)SingleTap {
     [_moneyCodeTf resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
     [super viewDidDisappear:animated];
     [_moneyCodeTf resignFirstResponder];
}

//弹出键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
    _moneyCodeTf.placeholder = @"";
    Btn.tag = 888;
    Btn.frame = CGRectMake(275 * kScreenWidth1, 89 * kScreenHeight1, 50 * kScreenWidth1, 50 * kScreenHeight1);
    Btn.layer.cornerRadius = 10;
    Btn.layer.masksToBounds = YES;
    [Btn setTitle:@"验证" forState:UIControlStateNormal];
    [Btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [Btn setBackgroundColor:[UIColor clearColor]];
    [Btn addTarget:self action:@selector(handleAction4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn];
    
    _moneyCodeTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.view viewWithTag:100].userInteractionEnabled = NO;
    [self.view viewWithTag:101].userInteractionEnabled = NO;
    [self.view viewWithTag:102].userInteractionEnabled = NO;
    [self.view viewWithTag:103].userInteractionEnabled = NO;
    [self.view viewWithTag:104].userInteractionEnabled = NO;
    [self.view viewWithTag:105].userInteractionEnabled = NO;
    [self.view viewWithTag:106].userInteractionEnabled = NO;

    [self.view viewWithTag:107].userInteractionEnabled = NO;
     [self.view viewWithTag:108].userInteractionEnabled = NO;

    return YES;
}

- (void)handleAction4
{
     if ([_moneyCodeTf.text length] < 5) {
          [_moneyCodeTf resignFirstResponder];
     }else{
          [self request:_moneyCodeTf.text];
     }
     _moneyCodeTf.text = @"";
    _moneyCodeTf.placeholder = @"请输入消费验证码";

     [self.view viewWithTag:100].userInteractionEnabled = YES;
     [self.view viewWithTag:101].userInteractionEnabled = YES;
     [self.view viewWithTag:102].userInteractionEnabled = YES;
     [self.view viewWithTag:103].userInteractionEnabled = YES;
     [self.view viewWithTag:104].userInteractionEnabled = YES;
     [self.view viewWithTag:105].userInteractionEnabled = YES;
     [self.view viewWithTag:106].userInteractionEnabled = YES;
     [self.view viewWithTag:107].userInteractionEnabled = YES;
     [self.view viewWithTag:108].userInteractionEnabled = YES;

    [_moneyCodeTf resignFirstResponder];
    [[self.view viewWithTag:888] removeFromSuperview];
     
    //提交验证码信息
     
    
    
}

//输入框询问是否可以取消编辑状态 -- 键盘是否可以回收
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
     _moneyCodeTf.text = @"";
    _moneyCodeTf.placeholder = @"请输入消费验证码";
    [self.view viewWithTag:100].userInteractionEnabled = YES;
    [self.view viewWithTag:101].userInteractionEnabled = YES;
    [self.view viewWithTag:102].userInteractionEnabled = YES;
    [self.view viewWithTag:103].userInteractionEnabled = YES;
    [self.view viewWithTag:104].userInteractionEnabled = YES;
    [self.view viewWithTag:105].userInteractionEnabled = YES;
    [self.view viewWithTag:106].userInteractionEnabled = YES;

    [self.view viewWithTag:107].userInteractionEnabled = YES;
     [self.view viewWithTag:108].userInteractionEnabled = YES;
    [_moneyCodeTf resignFirstResponder];
    [[self.view viewWithTag:888] removeFromSuperview];
    
    return YES;
}

- (void) request:(NSString *)str {
    NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
    //[NSString stringWithFormat:@"%@%@",LSKurl,MerchantsInfo]
    [manager POST:[NSString stringWithFormat:LSKurl@"/api/v1/life/shop/couponActivate?consumePwd=%@", str] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"验证结果%@", responseObject);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            //验证成功
            _lifeItemName = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"lifeItemName"]];
            _nickName = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"nickName"]];
            _orderNo = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"orderNo"]];
            NSArray * ary = responseObject[@"data"][@"goods"];
             float a = 0;
            for (NSDictionary * dic in ary) {
               a = a + [dic[@"price"] floatValue] * [dic[@"count"] intValue];
            }
            _validityDate = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"validityTime"]];
            _price = [NSString stringWithFormat:@"%.2f", a];
            [self successSendView];
        } else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"807"]) {
            Alert_Show(@"消费券不属于本商家");
        } else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"907"]) {
            Alert_Show(@"消费券已使用");
        } else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"908"]) {
            Alert_Show(@"消费券已退款");
        } else {
            Alert_Show(@"验证失败, 请重新尝试");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if ([error code] == -1009) {
              NSString *errorStr = [IsLogin requestErrorCode:[error code]];
              Alert_Show(errorStr)
         } else if ([error code] == -1001) {
              Alert_Show(@"请求超时")
         } else {
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

- (void) successSendView {
    //发送成功
    _pickVC = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375 * kScreenWidth1, 667 * kScreenHeight1)];
    _pickVC.backgroundColor = [UIColor blackColor];
    _pickVC.alpha = 0.5;
    _pickVC.userInteractionEnabled = YES;
    [self.view  addSubview:_pickVC];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewAction2)];
    [_pickVC addGestureRecognizer:tap];
    self.SuccessVC = [[UIView alloc] initWithFrame:CGRectMake(25 * kScreenWidth1, 180 * kScreenHeight1, 325 * kScreenWidth1, 265 * kScreenHeight1)];
    _SuccessVC.tag = 1000300;
    _SuccessVC.backgroundColor = [UIColor whiteColor];
    _SuccessVC.layer.cornerRadius = 5;
    _SuccessVC.layer.masksToBounds = YES;
    UILabel * dLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * kScreenHeight1, 325 * kScreenWidth1, 30 * kScreenHeight1)];
    dLabel.text = @"验证成功";
    dLabel.textAlignment = NSTextAlignmentCenter;
    dLabel.textColor = [UIColor colorWithRed:253 / 255.0 green:56 / 255.0 blue:84 / 255.0 alpha:1.0];
    dLabel.font = [UIFont systemFontOfSize:20];
    [_SuccessVC addSubview:dLabel];
    
    UILabel * eLabel10 = [[UILabel alloc] initWithFrame:CGRectMake(5 * kScreenWidth1, 48 * kScreenHeight1, 315 * kScreenWidth1, 1 * kScreenHeight1)];
    eLabel10.backgroundColor = [UIColor backGray];
    [_SuccessVC addSubview:eLabel10];
    
    
    UILabel * eLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20 * kScreenWidth1, 90 * kScreenHeight1, 300 * kScreenWidth1, 40 * kScreenHeight1)];
    eLabel3.text = [NSString stringWithFormat:@"总计: %.2f", [_price floatValue]];
    eLabel3.textColor = [UIColor blackColor];
    eLabel3.numberOfLines = 0;
    eLabel3.font = [UIFont systemFontOfSize:15];
    [_SuccessVC addSubview:eLabel3];
    
    UILabel * eLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(20 * kScreenWidth1, 50 * kScreenHeight1, 300 * kScreenWidth1, 40 * kScreenHeight1)];
    eLabel4.text = [NSString stringWithFormat:@"用户昵称: %@", _nickName];
    eLabel4.textColor = [UIColor blackColor];
    eLabel4.numberOfLines = 0;
    eLabel4.font = [UIFont systemFontOfSize:15];
    [_SuccessVC addSubview:eLabel4];
    
    UILabel * eLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(20 * kScreenWidth1, 130 * kScreenHeight1, 300 * kScreenWidth1, 40 * kScreenHeight1)];
    eLabel5.text = [NSString stringWithFormat:@"订单号码: %@", _orderNo];
    eLabel5.textColor = [UIColor blackColor];
    eLabel5.numberOfLines = 0;
    eLabel5.font = [UIFont systemFontOfSize:15];
    [_SuccessVC addSubview:eLabel5];
    
    UILabel * eLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(20 * kScreenWidth1, 170 * kScreenHeight1, 300 * kScreenWidth1, 40 * kScreenHeight1)];
    eLabel6.text = [NSString stringWithFormat:@"验证时间: %@", _validityDate];
    eLabel6.textColor = [UIColor blackColor];
    eLabel6.numberOfLines = 0;
    eLabel6.font = [UIFont systemFontOfSize:15];
    [_SuccessVC addSubview:eLabel6];
    
    UIButton * cBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cBtn.frame = CGRectMake(300 * kScreenWidth1, 10 * kScreenHeight1, 15 * kScreenWidth1, 15 * kScreenHeight1);
    [cBtn setBackgroundImage:[UIImage imageNamed:@"X@3x"] forState:UIControlStateNormal];
    [cBtn addTarget:self action:@selector(handleAction2) forControlEvents:UIControlEventTouchUpInside];
    [_SuccessVC addSubview:cBtn];
    
    UIButton * cBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    cBtn1.frame = CGRectMake(225 / 2 * kScreenWidth1, 220 * kScreenHeight1, 100 * kScreenWidth1, 35 * kScreenHeight1);
    cBtn1.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:56 / 255.0 blue:84 / 255.0 alpha:1.0];
    [cBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cBtn1 setTitle:@"确定" forState:UIControlStateNormal];
    cBtn1.titleLabel.font = [UIFont systemFontOfSize:20];
    cBtn1.layer.cornerRadius = 5 * kScreenHeight1;
    cBtn1.layer.masksToBounds = YES;
    [cBtn1 addTarget:self action:@selector(handleAction2) forControlEvents:UIControlEventTouchUpInside];
    [_SuccessVC addSubview:cBtn1];

    
    [self.view addSubview:_SuccessVC];
}

- (void)handleAction2 {
    [self pickerViewAction2];
      [self loadMyInfo];
}

- (void)pickerViewAction2 {  //发送成功弹窗消失
    [[self.view viewWithTag:1000300] removeFromSuperview];
    [_pickVC removeFromSuperview];
      [self loadMyInfo];
}



////点击键盘右下角return按钮触发 -- 经常用来回收键盘,取消编辑状态
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    //回收键盘
//    [self.view viewWithTag:100].userInteractionEnabled = YES;
//    [self.view viewWithTag:101].userInteractionEnabled = YES;
//    [self.view viewWithTag:102].userInteractionEnabled = YES;
//    [self.view viewWithTag:103].userInteractionEnabled = YES;
//    [self.view viewWithTag:104].userInteractionEnabled = YES;
//    [self.view viewWithTag:105].userInteractionEnabled = YES;
//    [self.view viewWithTag:106].userInteractionEnabled = YES;
//    [self.view viewWithTag:107].userInteractionEnabled = YES;
//    [textField resignFirstResponder];
//    return YES;
//}

//验证历史
- (void) handleAction1
{
    MeHistoryVC * eaVC = [[MeHistoryVC alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:eaVC animated:YES];
}

//扫码验证
- (void) handleAction
{
     __block int i = 0;
     static QRCodeReaderViewController * reader = nil;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
          reader = [QRCodeReaderViewController new];
          reader.modalPresentationStyle = UIModalPresentationFormSheet;
     });
     reader.delegate = self;
     [reader setCompletionWithBlock:^(NSString * resultAsString) {
          
          if (i == 0) {
               i ++;
               if (resultAsString) {
                    [self request:resultAsString];
               }
          }
          
     }];
     [self presentViewController:reader animated:YES completion:NULL];
//     UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                        initWithTitle:@"请选择"
//                                        delegate:self
//                                        cancelButtonTitle:@"取消"
//                                        destructiveButtonTitle:nil
//                                        otherButtonTitles:@"扫码验证", @"扫码收款",nil];
//     actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//     [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if (buttonIndex == 0) {
         
     } else if (buttonIndex == 1) {
          if ([_code intValue] == 0) {
               UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"尚未进行实名认证" preferredStyle:(UIAlertControllerStyleAlert)];
               UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {//跳往设置支付密码
                    WSSNameAuthenticationViewController * wVC = [[WSSNameAuthenticationViewController alloc] init];
                    [self.navigationController pushViewController:wVC animated:YES];
               }];
               UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
               [alertVC addAction:cancelAction];
               [alertVC addAction:okAction];
               [self presentViewController:alertVC animated:YES completion:nil];
          } else {
               SMSKVC * smVC = [[SMSKVC alloc] init];
               [self.navigationController pushViewController:smVC animated:YES];
          }
     }
}

//商家账单
-(void)billBtnClick
{
    EarningsDetailController * eaVC = [[EarningsDetailController alloc]init];
    eaVC.type = @"1";
    [self.navigationController pushViewController:eaVC animated:YES];
}
//扫码收款 收款码 发红包
-(void)btnClick:(UIButton *)sender{
    


     NSDictionary *shopInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
    _fundAccount = shopInfo[@"fund"];
     if (sender.tag == 100){
         //商品管理
         SuppliersOverVC * vc = [[SuppliersOverVC alloc] init];
         vc.millId = [NSString stringWithFormat:@"%@", shopInfo[@"id"]];
         [self.navigationController pushViewController:vc animated:YES];
     }else if (sender.tag == 101){
         //订单管理
         OrderIncomeVC * zjwVC = [[OrderIncomeVC alloc] init];
         [self.navigationController pushViewController:zjwVC animated:YES];
     }else if (sender.tag == 102){
         //门店管理
         shopVC * shopV = [[shopVC alloc] init];
         [self.navigationController pushViewController:shopV animated:YES];
     }else if (sender.tag == 103){
         //退货管理
         LYTRefundManage *vc = [[LYTRefundManage alloc]init];
         [self.navigationController pushViewController:vc animated:YES];
     }else if (sender.tag == 104){
         //代理入驻
         [self requestShopAgentDetail];
     }else if (sender.tag == 105){
         //收款吗
         SKMVC * smVC = [[SKMVC alloc] init];
         [self.navigationController pushViewController:smVC animated:YES];
     }else{
         //提现
//         if ([_code intValue] == 0) {
//             UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"尚未进行实名认证" preferredStyle:(UIAlertControllerStyleAlert)];
//             UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {//跳往设置支付密码
//                 WSSNameAuthenticationViewController * wVC = [[WSSNameAuthenticationViewController alloc] init];
//                 [self.navigationController pushViewController:wVC animated:YES];
//             }];
//             UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
//             [alertVC addAction:cancelAction];
//             [alertVC addAction:okAction];
//             [self presentViewController:alertVC animated:YES completion:nil];
//         } else {
             MerchantTVC *red = [[MerchantTVC alloc]init];
             red.fundCount = _fundAccount;
             [self.navigationController pushViewController:red animated:YES];
//         }
         

     }
}
-(void)requestShopAgentDetail{
     NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
     //[NSString stringWithFormat:@"%@%@",LSKurl,MerchantsInfo]
     [manager GET:[NSString stringWithFormat:LSKurl@"/api/v1/life/agent/detail"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"代理商入驻详情------%@", responseObject);
          //代理入驻
          if ([[responseObject[@"data"] class] isEqual:[NSNull class]]) {
               //申请代理
               ApplyAgentVC * vc = [[ApplyAgentVC alloc]init];
               [self.navigationController pushViewController:vc animated:YES];
          }else if (responseObject[@"data"]==nil){
               //申请代理
               ApplyAgentVC * vc = [[ApplyAgentVC alloc]init];
               [self.navigationController pushViewController:vc animated:YES];
          }else{
               if ([responseObject[@"data"][@"status"]intValue] == 0) {
                    Alert_Show(@"代理信息审批中!")
               }else if ([responseObject[@"data"][@"status"]intValue] == 1){
//                    AgentShopVC * vc = [[AgentShopVC alloc]init];
//                    [self.navigationController pushViewController:vc animated:YES];
                   Alert_Show(@"代理申请已通过,后续功能陆续开放中")
               }else if ([responseObject[@"data"][@"status"]intValue] == 2){
                    LYTAgent *vc = [[LYTAgent alloc]init];
                    vc.typeCode = 1;
                    [self.navigationController pushViewController:vc animated:YES];
               }else if ([responseObject[@"data"][@"status"]intValue] == 3){
                    Alert_Show(@"代理申请被禁用!")
               }else if ([responseObject[@"data"][@"status"]intValue] == 4){
                    //申请代理
                    ApplyAgentVC * vc = [[ApplyAgentVC alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
               }
          }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"代理商入驻详情------%@", error);
     }];
}
////扫码收款 收款码 发红包
//-(void)btnClick:(UIButton *)sender{
//
//     NSDictionary *shopInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
//     NSLog(@"商家信息-----%@",shopInfo);
//     if ([[shopInfo class] isEqual:[NSNull class]]) {
//          AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//          manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//          manager.requestSerializer = [AFJSONRequestSerializer serializer];
//          manager.responseSerializer = [AFJSONResponseSerializer serializer];
//          [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//          [manager.requestSerializer setValue:@"Basic bW9iaWxlOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
//          NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"];
//          NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PwdID"];
//          [manager POST:[NSString stringWithFormat:loginUrl,login,password] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//               NSString *tokenStr = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
//
//               //                             [[LYTFMDB sharedDataBase]deleAllSeachText];
//               if (responseObject[@"access_token"] != nil) {
//                    [[NSUserDefaults standardUserDefaults]setObject:tokenStr  forKey:@"token"];
//                    [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"LoginID"];
//                    [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"PwdID"];
//               } else {
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
//               }
//          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//          }];
//     }else if (shopInfo==nil){
//          AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//          manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//          manager.requestSerializer = [AFJSONRequestSerializer serializer];
//          manager.responseSerializer = [AFJSONResponseSerializer serializer];
//          [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//          [manager.requestSerializer setValue:@"Basic bW9iaWxlOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
//          NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"];
//          NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PwdID"];
//          [manager POST:[NSString stringWithFormat:loginUrl,login,password] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//               NSString *tokenStr = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
//
//               //                             [[LYTFMDB sharedDataBase]deleAllSeachText];
//               if (responseObject[@"access_token"] != nil) {
//                    [[NSUserDefaults standardUserDefaults]setObject:tokenStr  forKey:@"token"];
//                    [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"LoginID"];
//                    [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"PwdID"];
//               } else {
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
//               }
//          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//          }];
//     }else{
//
//     }
//    if (sender.tag == 100)
//    {
//        //项目管理
//        projectVC * eaVC = [[projectVC alloc]initWithStyle:UITableViewStylePlain];
//        [self.navigationController pushViewController:eaVC animated:YES];
//    }
//    else if (sender.tag == 101)
//    {
//        //门店管理
//        shopVC * shopV = [[shopVC alloc] init];
//        [self.navigationController pushViewController:shopV animated:YES];
//
//    }
//    else if (sender.tag == 102)
//    {
//        if ([_code intValue] == 0) {
//            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"尚未进行实名认证" preferredStyle:(UIAlertControllerStyleAlert)];
//            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {//跳往设置支付密码
//                WSSNameAuthenticationViewController * wVC = [[WSSNameAuthenticationViewController alloc] init];
//                [self.navigationController pushViewController:wVC animated:YES];
//            }];
//            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
//            [alertVC addAction:cancelAction];
//            [alertVC addAction:okAction];
//            [self presentViewController:alertVC animated:YES completion:nil];
//        } else {
//            //转出
//            MerchantZVC *red = [[MerchantZVC alloc]init];
//            [self.navigationController pushViewController:red animated:YES];
//        }
//
//
//    }
//    else if (sender.tag == 103)
//    {
//        if ([_code intValue] == 0) {
//            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"尚未进行实名认证" preferredStyle:(UIAlertControllerStyleAlert)];
//            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {//跳往设置支付密码
//                WSSNameAuthenticationViewController * wVC = [[WSSNameAuthenticationViewController alloc] init];
//                [self.navigationController pushViewController:wVC animated:YES];
//            }];
//            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
//            [alertVC addAction:cancelAction];
//            [alertVC addAction:okAction];
//            [self presentViewController:alertVC animated:YES completion:nil];
//        } else {
//            MerchantTVC *red = [[MerchantTVC alloc]init];
//            red.fundCount = _fundAccount;
//            [self.navigationController pushViewController:red animated:YES];
//        }
//    }
//    else if (sender.tag == 105) {
//         if ([_code intValue] == 0) {
//              UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"尚未进行实名认证" preferredStyle:(UIAlertControllerStyleAlert)];
//              UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {//跳往设置支付密码
//                   WSSNameAuthenticationViewController * wVC = [[WSSNameAuthenticationViewController alloc] init];
//                   [self.navigationController pushViewController:wVC animated:YES];
//              }];
//              UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
//              [alertVC addAction:cancelAction];
//              [alertVC addAction:okAction];
//              [self presentViewController:alertVC animated:YES completion:nil];
//         } else {
//              //收款吗
//              SKMVC * smVC = [[SKMVC alloc] init];
//              [self.navigationController pushViewController:smVC animated:YES];
//         }
//    }
//    else if (sender.tag == 106)
//    {
//
//         //账单
//          EarningsDetailController * eaVC = [[EarningsDetailController alloc] init];
//          [self.navigationController pushViewController:eaVC animated:YES];
//
//    }
//    else if (sender.tag == 108)
//    {
//         //检测点
//         if ([shopInfo[@"machineStatus"] integerValue] == -1) {
//              //未提交过申请
//              [self requestJianCeAD];
//         }else if ([shopInfo[@"machineStatus"] integerValue] == 0){
//              //已提交申请待审批
//              Alert_Show(@"审批中,请稍后...")
//         }else if ([shopInfo[@"machineStatus"] integerValue] == 1){
//              //审批通过
//              DetectionVC * eaVC = [[DetectionVC alloc] init];
//              [self.navigationController pushViewController:eaVC animated:YES];
//         }else if ([shopInfo[@"machineStatus"] integerValue] == 2){
//              //被驳回
//              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"检测申请" message:@"你申请的检测入驻被驳回,是否继续提交申请" preferredStyle:UIAlertControllerStyleAlert];
//              UIAlertAction *DissAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
//              UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                   [self requestJianCeAD];
//              }];
//              [alert addAction:DissAction];
//              [alert addAction:OKAction];
//              [self presentViewController:alert animated:YES completion:nil];
//         }
//
//    } else if (sender.tag == 109)
//    {
//         NSLog(@"最后一个按钮");
//         if ([[shopInfo[@"agent"] class] isEqual:[NSNull class]]) {
//              //申请代理
//              ApplyAgentVC * vc = [[ApplyAgentVC alloc]init];
//              [self.navigationController pushViewController:vc animated:YES];
//         }else if (shopInfo[@"agent"]==nil){
//              //申请代理
//              ApplyAgentVC * vc = [[ApplyAgentVC alloc]init];
//              [self.navigationController pushViewController:vc animated:YES];
//         }else{
//              if ([shopInfo[@"agent"][@"status"]intValue] == 0) {
//                   Alert_Show(@"代理信息审批中!")
//              }else if ([shopInfo[@"agent"][@"status"]intValue] == 1){
//                   AgentShopVC * vc = [[AgentShopVC alloc]init];
//                   [self.navigationController pushViewController:vc animated:YES];
//              }else if ([shopInfo[@"agent"][@"status"]intValue] == 2){
//                   LYTAgent *vc = [[LYTAgent alloc]init];
//                   vc.typeCode = 1;
//                   [self.navigationController pushViewController:vc animated:YES];
//              }else if ([shopInfo[@"agent"][@"status"]intValue] == 3){
//                   Alert_Show(@"代理申请被禁用!")
//              }else if ([shopInfo[@"agent"][@"status"]intValue] == 4){
//                   //申请代理
//                   ApplyAgentVC * vc = [[ApplyAgentVC alloc]init];
//                   [self.navigationController pushViewController:vc animated:YES];
//              }
//         }
//
//
//
//    }else if (sender.tag == 104)
//    {
//         //采购
//         GoodPurchaseVC * zjwVC = [[GoodPurchaseVC alloc] init];
//         [self.navigationController pushViewController:zjwVC animated:YES];
//
//         NSLog(@"最后一个按钮121");
//
//    }else if (sender.tag == 107)
//    {
//         NSLog(@"最后一个按钮121");
//         //收银台
//         CheckStandVC * vc = [[CheckStandVC alloc] init];
//         [self.navigationController pushViewController:vc animated:YES];
//    }else if (sender.tag == 110)
//    {
//
//         if ([[shopInfo[@"mill"] class] isEqual:[NSNull class]]) {
//              SuppliersVC * vc = [[SuppliersVC alloc] init];
//              vc.type = @"1";
//              [self.navigationController pushViewController:vc animated:YES];
//         }else if (shopInfo[@"mill"]==nil){
//              SuppliersVC * vc = [[SuppliersVC alloc] init];
//              vc.type = @"1";
//              [self.navigationController pushViewController:vc animated:YES];
//         }else{
//              if ([shopInfo[@"mill"][@"status"]intValue] == 0) {
//                   Alert_Show(@"申请供应商审批中!")
//              }else if ([shopInfo[@"mill"][@"status"]intValue] == 1){
//                   SuppliersOverVC * vc = [[SuppliersOverVC alloc] init];
//                   vc.millId = [NSString stringWithFormat:@"%@", shopInfo[@"mill"][@"id"]];
//                   [self.navigationController pushViewController:vc animated:YES];
//              }else if ([shopInfo[@"mill"][@"status"]intValue] == 2){
//                   SuppliersVC * vc = [[SuppliersVC alloc] init];
//                   vc.type = @"2";
//                   vc.dic = shopInfo[@"mill"];
//                   [self.navigationController pushViewController:vc animated:YES];
//              }else if ([shopInfo[@"mill"][@"status"]intValue] == 3){
//                   Alert_Show(@"申请供应商被禁用!")
//              }
//         }
//    }
//}
/*
 **注释 : 检测申请说明
 **日期 : 5.17
 ** LYTCreated
 */
-(void)requestJianCeAD{
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     [manager POST:[NSString stringWithFormat:@"%@/App/NewsPort/articleList/type/2/sk/2ab99a6af22365686e97992df974d5c2",LSKurl1] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"responseObject,检测申请说明---%@",responseObject);
          UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height+64)];
          backView.tag = 11999;
          backView.alpha = 0.7;
          backView.backgroundColor = [UIColor grayColor];
          [self.view addSubview:backView];
          
          UIView *registVipView = [[UIView alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 110*kScreenHeight1, self.view.bounds.size.width-20*kScreenWidth1, 500*kScreenHeight1)];
          registVipView.tag = 1199;
          registVipView.layer.cornerRadius = 5;
          registVipView.layer.masksToBounds = YES;
          registVipView.backgroundColor = [UIColor whiteColor];
          [self.view addSubview:registVipView];
          
          UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-40*kScreenWidth1, 10*kScreenHeight1, 80*kScreenWidth1, 20*kScreenHeight1)];
          titleLabel.text = @"入驻详情";
          titleLabel.textAlignment = NSTextAlignmentCenter;
          titleLabel.font = [UIFont systemFontOfSize:16];
          [registVipView addSubview:titleLabel];
          
          NSArray *arr = responseObject[@"ad_list"];
          
          if ([arr count] > 0) {
               UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(10, 40, registVipView.frame.size.width-20, registVipView.frame.size.height- 110)];
               [registVipView addSubview:web];
               [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:arr[0][@"url"]]]];
          }
          
          
          
          UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
          payBtn.frame = CGRectMake(40*kScreenWidth1, 450*kScreenHeight1, 80*kScreenWidth1, 30*kScreenHeight1);
          payBtn.tag = 9999;
          [payBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
          [payBtn setTitle:@"确认入驻" forState:UIControlStateNormal];
          [payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
          payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
          payBtn.layer.masksToBounds = YES;
          payBtn.layer.cornerRadius = 3;
          [payBtn.layer setBorderWidth:1];
          [payBtn.layer setBorderColor:[UIColor grayColor].CGColor];
          [registVipView addSubview:payBtn];
          
          UIButton *missBtn = [UIButton buttonWithType:UIButtonTypeCustom];
          missBtn.frame = CGRectMake(registVipView.frame.size.width-120*kScreenWidth1, 450*kScreenHeight1, 80*kScreenWidth1, 30*kScreenHeight1);
          [missBtn setTitle:@"取消" forState:UIControlStateNormal];
          [missBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
          missBtn.tag = 9998;
          missBtn.titleLabel.font = [UIFont systemFontOfSize:14];
          missBtn.layer.masksToBounds = YES;
          missBtn.layer.cornerRadius = 3;
          [missBtn.layer setBorderWidth:1];
          [missBtn.layer setBorderColor:[UIColor grayColor].CGColor];
          [missBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
          [registVipView addSubview:missBtn];
          
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"responseObject,检测申请说明失败---%@",error);
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
-(void)requestsavePayCode{
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     [manager POST:[NSString stringWithFormat:@"%@/api/v1/life/payCode/savePayCode",LSKurl] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"responseObject,查询开通状态---%@",responseObject);
          [self loadMyInfo];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"responseObject,查询开通状态失败---%@",error);
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

-(void)payBtnClick:(UIButton *)sender{
     UIView *view = [self.view viewWithTag:1199];
     [view removeFromSuperview];
     UIView *view1 = [self.view viewWithTag:11999];
     [view1 removeFromSuperview];
     if (sender.tag == 9999) {
          [self requestsavePayCode];
     }
     
}

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
         
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popToViewController:self animated:YES];

}

- (void)QRCodeWithContent:(NSString *)content {
    CreateQrcodeVC *vc = [[CreateQrcodeVC alloc]init];
    vc.content = content;
    vc.tit = @"收款";
    vc.type = @"1";
    vc.Percentage = _Percentage;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


@end
