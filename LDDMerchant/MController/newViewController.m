//
//  newViewController.m
//  goods
//
//  Created by 王松松 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "UIColor+Addition.h"
#import "lableTableViewCell.h"
#import "newViewController.h"
#import "AFNetworking.h"
#import "NetURL.h"
@interface newViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *arr;
@end

@implementation newViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor backGray];
    self.title =@"新增套餐";
    _arr =@[@"名称",@"价格"];
    [self tableView];
}

-(void)tableView
{
    UITableView *tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0 * kScreenHeight1, self.view.frame.size.width, 180 * kScreenHeight1) style:UITableViewStylePlain];
    tableView.delegate =self;
    tableView.dataSource =self;
    tableView.separatorStyle = NO;
    tableView.rowHeight = 50* kScreenWidth1;
    [tableView registerClass:[lableTableViewCell class] forCellReuseIdentifier:@"cells"];
    [self.view addSubview:tableView];
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 185 * kScreenHeight1, self.view.frame.size.width, 44 * kScreenHeight1);
    [btn setTitle:@"保  存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor AppColor] forState:UIControlStateNormal];
    btn.backgroundColor =[UIColor whiteColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds =YES;
    btn.layer.cornerRadius =5* kScreenWidth1;
    [self.view addSubview:btn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    lableTableViewCell *cellView =[tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cellView.textField.tag = 100 + indexPath.section;
    } else if (indexPath.section == 1) {
        cellView.textField.keyboardType = UIKeyboardTypeDecimalPad;
        cellView.textField.tag = 100 + indexPath.section;
    }
    cellView.leftLabel.text =_arr[indexPath.section];
    [cellView.centerLabel removeFromSuperview];
    cellView.textField.placeholder = @"请在此处输入";
    cellView.selectionStyle =UITableViewCellSelectionStyleNone;
    
    if (_idStr != nil) {
        UITextField * text = [self.view viewWithTag:100];
        text.text = _nameStr;
        UITextField * text1 = [self.view viewWithTag:101];
        text1.text = _priceStr;
    }
    
    [cellView.rightLabel removeFromSuperview];
    return cellView;
}

- (void)btnClick{
    if (_idStr != nil) {
        [self request1];
    } else {
        [self request];

    }
}
#pragma mark ------------------ 请求 >>> 新增套餐 ----------------
- (void)request {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    UITextField * text = [self.view viewWithTag:100];
    UITextField * text1 = [self.view viewWithTag:101];
    NSString *str2 = [text.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:new_Package, str2, [text1.text floatValue]]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
             Alert_show_pushRoot(@"保存成功");
        } else {
            Alert_Show(@"保存失败");
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

#pragma mark ------------------ 请求 >>> 更新套餐 ----------------
- (void)request1 {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    UITextField * text = [self.view viewWithTag:100];
    UITextField * text1 = [self.view viewWithTag:101];
    NSString *str2 = [text.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:update_Package, _idStr, str2, [text1.text floatValue]]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            Alert_show_pushRoot(@"保存成功");
        } else {
            Alert_Show(@"保存失败");
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
