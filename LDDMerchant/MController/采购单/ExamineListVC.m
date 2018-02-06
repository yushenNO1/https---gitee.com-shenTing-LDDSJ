//
//  ExamineListVC.m
//  采购单
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "ExamineListVC.h"
#import "ExamineListCell.h"
#import "UIImageView+WebCache.h"
#import "DetailContactVC.h"
#import "AFNetworking.h"
@interface ExamineListVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *ImageArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
//按钮
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIButton *OneBtn;
@property(nonatomic,strong)UIButton *TwoBtn;
@property(nonatomic,strong)UIButton *ThreeBtn;
@property(nonatomic,strong)UIButton *ABtn;
@property(nonatomic,strong)UIButton *BBtn;

@property(nonatomic,strong)UILabel *LineLabel1;
@property(nonatomic,strong)UILabel *LineLabel2;
@property(nonatomic,strong)UILabel *LineLabel3;

@property (nonatomic, copy) NSString * roleType;
@property (nonatomic, copy) NSString * status;
@end

@implementation ExamineListVC
- (void)request {
    [_dataArr removeAllObjects];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:CGDList, _roleType, _status] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----21234---%@", responseObject);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"0"]) {
            NSArray * arr = responseObject[@"data"];
            for (NSDictionary * dic in arr) {
                [self.dataArr addObject:dic];
            }
            
             if (_dataArr.count == 0) {
                  
                  if ([_roleType isEqualToString:@"2"]) {
                       if ([self.view viewWithTag:10086]) {
                            UIImageView * imageView = [self.view viewWithTag:10086];
                            imageView.hidden = YES;
                       }
                  } else {
                       if ([self.view viewWithTag:10086]) {
                            UIImageView * imageView = [self.view viewWithTag:10086];
                            imageView.hidden = NO;
                       } else {
                            UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Artboard 2"]];
                            imageView.tag = 10086;
                            imageView.frame = WDH_CGRectMake(0, 175, 375, 492);
                            [self.view addSubview:imageView];
                       } 
                  }
         
                  
                  
             } else {
                  if ([self.view viewWithTag:10086]) {
                       UIImageView * imageView = [self.view viewWithTag:10086];
                       imageView.hidden = YES;
                  }
             }
             
            [self.tableView reloadData];
        } else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"1003"]) {
             if ([_roleType isEqualToString:@"2"]) {
                  if ([self.view viewWithTag:10086]) {
                       UIImageView * imageView = [self.view viewWithTag:10086];
                       imageView.hidden = YES;
                  }
             }
             [self.tableView reloadData];
             Alert_Show (@"您还不是区域代理, 暂无审批权限")
        } else {
             if ([_roleType isEqualToString:@"2"]) {
                  if ([self.view viewWithTag:10086]) {
                       UIImageView * imageView = [self.view viewWithTag:10086];
                       imageView.hidden = YES;
                  }
             }
             [self.tableView reloadData];
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

- (void)requestCancel:(NSString *)code {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager POST:[NSString stringWithFormat:CGDCancel, code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----成功---%@", responseObject);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"0"]) {
            //成功
            [self request];
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

- (void)requestOk:(NSString *)code
           requst:(NSString *)result {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    
    NSString * advice = @"";
    if ([result isEqualToString:@"1"]) {
        advice = @"pass";
    } else {
        advice = @"refuse";
    }
    
    [manager POST:[NSString stringWithFormat:CGDOk, code, result, advice] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----成功---%@", responseObject);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"0"]) {
            //成功
            [self request];
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


-(NSMutableArray *)ImageArr {
    if (!_ImageArr) {
        self.ImageArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _ImageArr;
}

-(NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _roleType = @"1";
    _status = @"2"; 
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
    [self request];
}

- (void)configView {
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _rightBtn.frame = CGRectMake(375 / 2 * kScreenWidth1, 64 + 5 * kScreenHeight1, 375 / 2 * kScreenWidth1, 50 * kScreenHeight1);
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"待我审批1"] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightBtn addTarget:self action:@selector(handleRight) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_rightBtn];
    
    
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _leftBtn.frame = CGRectMake(0, 64 + 5 * kScreenHeight1, 375 / 2 * kScreenWidth1, 50 * kScreenHeight1);
    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"采购审批1"] forState:UIControlStateNormal];
_leftBtn.backgroundColor = [UIColor whiteColor];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_leftBtn addTarget:self action:@selector(handleLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(375 / 2 * kScreenWidth1, 64 + 15 * kScreenHeight1, 1 * kScreenWidth1, 30 * kScreenHeight1)];
    line.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    [self.view addSubview:line];
    
    UILabel * line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 55 * kScreenHeight1, 375 * kScreenWidth1, 1 * kScreenHeight1)];
    line1.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    [self.view addSubview:line1];
    
    UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 110 * kScreenHeight1, 375 * kScreenWidth1, 1 * kScreenHeight1)];
    line2.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    [self.view addSubview:line2];
    
    
    
    self.OneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _OneBtn.backgroundColor = [UIColor whiteColor];
    _OneBtn.frame = CGRectMake(0, 64 + 60 * kScreenHeight1, 375 / 3 * kScreenWidth1, 50 * kScreenHeight1);
    [_OneBtn setTitle:@"审批通过" forState:UIControlStateNormal];
    
    [_OneBtn setTitleColor:[UIColor colorWithRed:247 / 255.0 green:48 / 255.0 blue:75 / 255.0 alpha:1] forState:UIControlStateNormal];
    _OneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_OneBtn addTarget:self action:@selector(handleOne) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_OneBtn];
    
    self.TwoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _TwoBtn.frame = CGRectMake(375 / 3 * kScreenWidth1, 64 + 60 * kScreenHeight1, 375 / 3 * kScreenWidth1, 50 * kScreenHeight1);
    [_TwoBtn setTitle:@"正在审批" forState:UIControlStateNormal];
    _TwoBtn.backgroundColor = [UIColor whiteColor];
    [_TwoBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
    _TwoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_TwoBtn addTarget:self action:@selector(handleTwo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_TwoBtn];
    
    self.ThreeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _ThreeBtn.frame = CGRectMake(375 / 3 * 2 * kScreenWidth1, 64 + 60 * kScreenHeight1, 375 / 3 * kScreenWidth1, 50 * kScreenHeight1);
    [_ThreeBtn setTitle:@"审批未通过" forState:UIControlStateNormal];
    
    [_ThreeBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
    _ThreeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_ThreeBtn addTarget:self action:@selector(handleThree) forControlEvents:UIControlEventTouchUpInside];
    _ThreeBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_ThreeBtn];
    
    self.ABtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _ABtn.frame = CGRectMake(0, 64 + 60 * kScreenHeight1, 375 / 2 * kScreenWidth1, 50 * kScreenHeight1);
    [_ABtn setTitle:@"待我审批" forState:UIControlStateNormal];
    _ABtn.backgroundColor = [UIColor whiteColor];
    [_ABtn setTitleColor:[UIColor colorWithRed:247 / 255.0 green:48 / 255.0 blue:75 / 255.0 alpha:1] forState:UIControlStateNormal];
    _ABtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_ABtn addTarget:self action:@selector(handleA) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ABtn];
    
    self.BBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _BBtn.frame = CGRectMake(375 / 2 * kScreenWidth1, 64 + 60 * kScreenHeight1, 375 / 2 * kScreenWidth1, 50 * kScreenHeight1);
    [_BBtn setTitle:@"我已审批" forState:UIControlStateNormal];
    _BBtn.backgroundColor = [UIColor whiteColor];
    [_BBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
    _BBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_BBtn addTarget:self action:@selector(handleB) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_BBtn];
    _ABtn.hidden = YES;
    _BBtn.hidden = YES;
    
    self.LineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(375 / 3 * kScreenWidth1, 64 + 70 * kScreenHeight1, 1 * kScreenWidth1, 30 * kScreenHeight1)];
    _LineLabel1.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    [self.view addSubview:_LineLabel1];
    
    self.LineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake((375 / 3 * 2 + 1) * kScreenWidth1, 64 + 70 * kScreenHeight1, 1 * kScreenWidth1, 30 * kScreenHeight1)];
    _LineLabel2.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    [self.view addSubview:_LineLabel2];
    
    self.LineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake((375 / 2 + 1) * kScreenWidth1, 64 + 70 * kScreenHeight1, 1 * kScreenWidth1, 30 * kScreenHeight1)];
    _LineLabel3.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    [self.view addSubview:_LineLabel3];
    
    _LineLabel3.hidden = YES;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 111 * kScreenHeight1, 375 * kScreenWidth1, 492 * kScreenHeight1) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1001;
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = 100 * kScreenHeight1;
    [_tableView registerClass:[ExamineListCell class] forCellReuseIdentifier:@"11"];
    [self.view addSubview:_tableView];
}

- (void)handleRight {
    _OneBtn.hidden = YES;
    _TwoBtn.hidden = YES;
    _ThreeBtn.hidden = YES;
    _ABtn.hidden = NO;
    _BBtn.hidden = NO;
    _LineLabel3.hidden = NO;
    _LineLabel1.hidden = YES;
    _LineLabel2.hidden = YES;
    _roleType = @"2";
    _status = @"1";
    [self request];
    [_ABtn setTitleColor:[UIColor colorWithRed:247 / 255.0 green:48 / 255.0 blue:75 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_BBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"采购审批2"] forState:UIControlStateNormal];
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"待我审批2"] forState:UIControlStateNormal];
}

- (void)handleLeft {
    _OneBtn.hidden = NO;
    _TwoBtn.hidden = NO;
    _ThreeBtn.hidden = NO;
    _ABtn.hidden = YES;
    _BBtn.hidden = YES;
    _LineLabel3.hidden = YES;
    _LineLabel1.hidden = NO;
    _LineLabel2.hidden = NO;
    _roleType = @"1";
    _status = @"2";
    [self request];
    [_OneBtn setTitleColor:[UIColor colorWithRed:247 / 255.0 green:48 / 255.0 blue:75 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_TwoBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_ThreeBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"采购审批1"] forState:UIControlStateNormal];
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"待我审批1"] forState:UIControlStateNormal];
}

- (void)handleOne {
    _roleType = @"1";
    _status = @"2";
    [self request];
    [_OneBtn setTitleColor:[UIColor colorWithRed:247 / 255.0 green:48 / 255.0 blue:75 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_TwoBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_ThreeBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
}

- (void)handleTwo {
    _roleType = @"1";
    _status = @"1";
    [self request];
    [_TwoBtn setTitleColor:[UIColor colorWithRed:247 / 255.0 green:48 / 255.0 blue:75 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_OneBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_ThreeBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
}

- (void)handleThree {
    _roleType = @"1";
    _status = @"3";
    [self request];
    [_ThreeBtn setTitleColor:[UIColor colorWithRed:247 / 255.0 green:48 / 255.0 blue:75 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_TwoBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_OneBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
}

- (void)handleA {
    _roleType = @"2";
    _status = @"1";
    [self request];
    [_ABtn setTitleColor:[UIColor colorWithRed:247 / 255.0 green:48 / 255.0 blue:75 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_BBtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
}

- (void)handleB {
    _roleType = @"2";
    _status = @"2";
    [self request];
    [_BBtn setTitleColor:[UIColor colorWithRed:247 / 255.0 green:48 / 255.0 blue:75 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_ABtn setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
}

- (void)handleCancel:(UIButton *) sender {
    //取消订单
    [self requestCancel:[NSString stringWithFormat:@"%ld", sender.tag]];
}

- (void)handleRefuse:(UIButton *)sender
{
    [self requestOk:[NSString stringWithFormat:@"%ld", sender.tag] requst:@"0"];
}

- (void)handleOK:(UIButton *)sender
{
    [self requestOk:[NSString stringWithFormat:@"%ld", sender.tag] requst:@"1"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_roleType isEqualToString:@"2"]) {
         DetailContactVC * detail = [[DetailContactVC alloc] init];
         NSDictionary * dic = _dataArr[indexPath.section];
         detail.type = @"2";
         detail.orderId = [NSString stringWithFormat:@"%@", dic[@"orderId"]];
         [self.navigationController pushViewController:detail animated:YES];
    } else {
         DetailContactVC * detail = [[DetailContactVC alloc] init];
         NSDictionary * dic = _dataArr[indexPath.section];
         detail.type = @"1";
         detail.orderId = [NSString stringWithFormat:@"%@", dic[@"orderId"]];
         [self.navigationController pushViewController:detail animated:YES];
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary * dic = _dataArr[section];
    NSArray * Ary = dic[@"lpgList"];
    return Ary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExamineListCell * zjwCell = [tableView dequeueReusableCellWithIdentifier:@"11" forIndexPath:indexPath];
    NSDictionary * dic = _dataArr[indexPath.section];
    NSArray * ary = dic[@"lpgList"];
    NSDictionary * dataDic = ary[indexPath.row];
    if ([_status isEqualToString:@"3"]) {
        zjwCell.ImageView.hidden = NO;
    } else {
        zjwCell.ImageView.hidden = YES;
    }
     [zjwCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    zjwCell.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    zjwCell.orderId = [NSString stringWithFormat:@"%@", dataDic[@"orderId"]];
    zjwCell.TopLabel.text = [NSString stringWithFormat:@"%@", dataDic[@"goodName"]];
    zjwCell.DownLabel.text = [NSString stringWithFormat:@"¥%.2f", [dataDic[@"price"] floatValue]];
    zjwCell.rightLabel.text = [NSString stringWithFormat:@"x%@", dataDic[@"count"]];
    [zjwCell.leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"cover"]]] placeholderImage:[UIImage imageNamed:@""]];
    return zjwCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    

    
    UIView * backView = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 0, 375, 55)];
    UILabel * label2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 0, 375, 5)];
    label2.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    [backView addSubview:label2];
    backView.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:WDH_CGRectMake(15, 20, 20, 20)];
    imageView.image = [UIImage imageNamed:@"商店"];
    [backView addSubview:imageView];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(45, 15, 200, 30)];
    NSDictionary * dic = _dataArr[section];
     
     if ([_roleType isEqualToString:@"1"]) {
          titleLabel.text = [NSString stringWithFormat:@"%@", dic[@"sellerName"]];
     } else {
          titleLabel.text = [NSString stringWithFormat:@"%@", dic[@"buyerName"]];
     }
     
    
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1];
    [backView addSubview:titleLabel];
    UILabel * label = [[UILabel alloc] initWithFrame:WDH_CGRectMake(250, 15, 105, 30)];
     label.textAlignment = 2;
    label.font = [UIFont systemFontOfSize:13];
    if ([_status isEqualToString:@"1"]) {
        label.text = @"正在审批";
    } else if ([_status isEqualToString:@"2"]) {
        label.text = @"审批通过";
    } else if ([_status isEqualToString:@"3"]) {
        label.text = @"审批不通过";
    }
     [backView addSubview:label];
    return backView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary * dic = _dataArr[section];
    UIView * backView = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 0, 375, 80)];
    backView.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 29, 375, 1)];
    label.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    [backView addSubview:label];
    
    NSArray * ary = dic[@"lpgList"];
    NSInteger a = 0;
    for (NSDictionary * dic in ary) {
        a = a + [dic[@"count"] integerValue];
    }
    
    UILabel * countLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 0, 355, 29)];
    countLabel.textAlignment = 2;
    countLabel.textColor = [UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1];
    countLabel.font = [UIFont systemFontOfSize:12];
    NSString * creat = [NSString stringWithFormat:@"%.2f", [dic[@"totalAmount"] floatValue]];
    NSString * showLabel = [NSString stringWithFormat:@"共计%ld件商品  合计: %@", a, [NSString stringWithFormat:@"%.2f", [dic[@"totalAmount"] doubleValue]]];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:showLabel];
    
    NSRange range = [showLabel rangeOfString:creat];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:15]
     
                          range:NSMakeRange(range.location, range.length)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorWithRed:20 / 255.0 green:20 / 255.0 blue:20 / 255.0 alpha:1]
     
                          range:NSMakeRange(range.location, range.length)];
    
    countLabel.attributedText = AttributedStr;
    
    [backView addSubview:countLabel];
    if ([_roleType isEqualToString:@"1"]) {
        if ([_status isEqualToString:@"1"]) {
            UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
            Btn.frame = WDH_CGRectMake(280, 35, 80, 25);
            [Btn setTitle:@"取消订单" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor colorWithRed:247 / 255.0 green:48 / 255.0 blue:75 / 255.0 alpha:1] forState:UIControlStateNormal];
            Btn.layer.cornerRadius = 25 / 2;
            Btn.layer.masksToBounds = YES;
            Btn.layer.borderWidth = 1.0f;
            Btn.layer.borderColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1].CGColor;
            Btn.tag = [dic[@"orderId"] integerValue];
            [Btn addTarget:self action:@selector(handleCancel:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:Btn];
        } else {
            
        }
        
    } else {
        
        if ([_status isEqualToString:@"1"]) {
            UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
            Btn.frame = WDH_CGRectMake(280, 35, 80, 25);
            [Btn setTitle:@"通过审批" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor colorWithRed:247 / 255.0 green:48 / 255.0 blue:75 / 255.0 alpha:1] forState:UIControlStateNormal];
            Btn.layer.cornerRadius = 25 / 2;
            Btn.layer.masksToBounds = YES;
            Btn.layer.borderWidth = 1.0f;
            Btn.layer.borderColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1].CGColor;
            Btn.tag = [dic[@"orderId"] integerValue];
            [Btn addTarget:self action:@selector(handleOK:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:Btn];
            
            UIButton * Btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
            Btn1.frame = WDH_CGRectMake(190, 35, 80, 25);
            [Btn1 setTitle:@"否决审批" forState:UIControlStateNormal];
            [Btn1 setTitleColor:[UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1] forState:UIControlStateNormal];
            Btn1.layer.cornerRadius = 25 / 2;
            Btn1.layer.masksToBounds = YES;
            Btn1.layer.borderWidth = 1.0f;
            Btn1.layer.borderColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1].CGColor;
            Btn1.tag = [dic[@"orderId"] integerValue];
            [Btn1 addTarget:self action:@selector(handleRefuse:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:Btn1];

        } else {
    
        }
        
        
    }
    return backView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55* kScreenHeight1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if ([_roleType isEqualToString:@"1"]) {
        if ([_status isEqualToString:@"1"]) {
            
            
        } else {
            return 29 * kScreenHeight1;
        }
    } else {
        
        if ([_status isEqualToString:@"1"]) {
            
            
        } else {
            return 29* kScreenHeight1;
        }
        
        
    }

    
    return 80;
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
