//
//  ZjwBankCardVC.m
//  LSK
//
//  Created by 张敬文 on 2017/1/17.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "ZjwBankCardVC.h"
#import "ZjwBankCardCell.h"
#import "ZjwAddBankCardVC.h"
#import "ZjwEditBankVC.h"
#import "ZjwBankCardModel.h"
#import "AFNetworking.h"
#import "NetURL.h"
@interface ZjwBankCardVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *RightArr;
@property (nonatomic, strong) NSArray *bankCardName;
@property (nonatomic, strong) NSArray *bankCardImage;

@end

@implementation ZjwBankCardVC
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [self requestlist];
}

-(NSMutableArray *)RightArr {
    if (!_RightArr) {
        self.RightArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _RightArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡";
    [self configView];
    _bankCardName = @[@"建设银行", @"中国银行", @"农业银行", @"工商银行", @"招商银行", @"交通银行", @"中国邮政", @"中原银行", @"民生银行", @"光大银行", @"兴业银行"];
     _bankCardImage = @[@"jian_pay_ico", @"china_pay_ico", @"long_pay_ico", @"buess_pay_ico", @"zhao_pay_ico", @"jiao_pay_ico", @"youzheng_bank", @"zhongyuan_bank", @"minsheng_bank", @"guangda_bank", @"xingye_bank"];

}

- (void) requestlist {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:bankCardList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.RightArr removeAllObjects];
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSArray * dataArr = responseObject[@"data"][@"list"];
            if (dataArr.count == 0) {
                
            } else {
                for (NSDictionary * tempDic in dataArr) {
                    ZjwBankCardModel * model = [ZjwBankCardModel bankCardWithDictionary:tempDic];
                    [self.RightArr addObject:model];
                }
                [self.tableView reloadData];
            }
        } else {
            //失败
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

- (void) configView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375 * kScreenWidth1, 667 *kScreenHeight1) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1001;
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = 70*kScreenWidth1;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ZjwBankCardCell class] forCellReuseIdentifier:@"bankCard"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Card"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _RightArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     if (indexPath.row == _RightArr.count) {
          UITableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"Card" forIndexPath:indexPath];
          if (![self.view viewWithTag:10086]) {
               
               UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 375, 60)];
               if (!label.text) {
                    label.text = @"(点击此处添加银行卡)";
               }
               label.tag = 10086;
               label.textAlignment = NSTextAlignmentCenter;
               [cell1 addSubview:label];
               
          } else {
               
          }
          cell1.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell1;
          
     }else{
          ZjwBankCardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"bankCard" forIndexPath:indexPath];
          ZjwBankCardModel * model = _RightArr[indexPath.row];
          cell.LeftLabel.text = model.bank;
          cell.NameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
          cell.bankNumLabel.text = model.cardNo;
          int i = 0;
          for (NSString * string in _bankCardName) {
               if ([string isEqualToString:model.bank]) {
                    cell.LeftImageView.image = [UIImage imageNamed:_bankCardImage[i]];
                    break;
               } else {
                    i++;
               }
          }
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell;
     }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     
     if (indexPath.row == _RightArr.count) {
          //添加
          if ([[NSUserDefaults standardUserDefaults] objectForKey:@"name"] != nil) {
               ZjwAddBankCardVC * zjwVC = [[ZjwAddBankCardVC alloc] init];
               [self.navigationController pushViewController:zjwVC animated:YES];
          }else{
               Alert_Show(@"未添加实名认证")
          }
          
     } else {
          ZjwBankCardModel * model = _RightArr[indexPath.row];
          if ([model.bank isEqualToString:@"微信"]) {
               Alert_Show(@"暂不支持微信提现");
          }else{
               NSDictionary* dic =@{@"withDraw":model};
               [[NSNotificationCenter defaultCenter] postNotificationName:@"Draw" object:nil userInfo:dic];
               
               
               [self.navigationController popViewControllerAnimated:YES];
          }
          
     }
     
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 首先修改model
    ZjwBankCardModel * model = _RightArr[indexPath.row];
    [self requestDelete:model.cardId];
    [self.RightArr removeObjectAtIndex:indexPath.row];
    // 之后更新view
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView reloadData];
    
}

- (void) requestDelete:(NSString *)string {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager POST:[NSString stringWithFormat:deleteBankCard, string] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"-----%@", responseObject);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            Alert_Show(@"删除成功");
        } else {
            Alert_Show(@"删除失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"-----%@", error);
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


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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
