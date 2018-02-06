//
//  WithdrawVC.m
//  LSKKApp
//
//  Created by 云盛科技 on 16/4/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "WithdrawVC.h"
#import "WDModel.h"
#import "WDVCCell.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "NetURL.h"



@interface WithdrawVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _offset;
}
@property (nonatomic, retain) NSDictionary * dic;
@property(nonatomic,retain)UITableView *transferTable;
@property (nonatomic, retain) NSMutableArray *dataArray; //存放数据

@end

@implementation WithdrawVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _offset = 0;
    [self configTable];
    [self request];
    self.transferTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(handle)];
}
-(void)handle{
    _offset += 10;
    [self request];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

-(void)endRefresh{
    [self.transferTable.header endRefreshing];
    [self.transferTable.footer endRefreshing];
}
//解析数据,封装Model对象
- (void)parserHearderData:(NSDictionary *)data{
    self.dic = data;
    NSDictionary * dic1 = _dic[@"data"];
    NSArray * dataArr = dic1[@"list"];
    for (NSDictionary * tempDic in dataArr) {
        WDModel * wdm = [WDModel withDrawWithDictionary:tempDic];
        [self.dataArray addObject:wdm];
    }
    [self.transferTable.footer endRefreshing];
    [self.transferTable reloadData];
}
#pragma mark
#pragma mark ------------- tableView ------------
- (void)configTable{
    _transferTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _transferTable.delegate = self;
    _transferTable.dataSource = self;
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375 * kScreenWidth1, 30 * kScreenHeight1)];
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kScreenWidth1, 5 * kScreenHeight1, 100 * kScreenWidth1, 20 * kScreenHeight1)];
    aLabel.text = @"提现日期";
    [aView addSubview:aLabel];
    UILabel * bLabel = [[UILabel alloc] initWithFrame:CGRectMake(125 * kScreenWidth1, 5 * kScreenHeight1, 150 * kScreenWidth1, 20 * kScreenHeight1)];
    bLabel.text = @"提现卡号";
    [aView addSubview:bLabel];
    UILabel * cLabel = [[UILabel alloc] initWithFrame:CGRectMake(285 * kScreenWidth1, 5 * kScreenHeight1, 100 * kScreenWidth1, 20 * kScreenHeight1)];
    cLabel.text = @"提现金额";
    [aView addSubview:cLabel];
    _transferTable.tableHeaderView = aView;
    _transferTable.rowHeight =60;
    [_transferTable registerClass:[WDVCCell class] forCellReuseIdentifier:@"WDVCCell"];
    [self.view addSubview: _transferTable];
}
#pragma mark
#pragma mark ------------- tableView的代理 ------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WDModel * model = self.dataArray[indexPath.row];
    WDVCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDVCCell" forIndexPath:indexPath];
    cell.wdm = model;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark
#pragma mark ------------- 请求 >>> 提现记录 ------------
- (void) request {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:WRecordURL,_offset]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"提现记录%@", responseObject);
        [self parserHearderData:responseObject];
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
