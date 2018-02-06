//
//  MeHistoryVC.m
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "MeHistoryVC.h"
#import "MeHistoryCell.h"
#import "MeHistoryModel.h"

#import "MeHistory1VC.h"
#import "JF_CalendarView.h"
#import "UIColor+Addition.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "NetURL.h"
@interface MeHistoryVC ()
@property (nonatomic, strong) UILabel * codeNum;
@property (nonatomic, strong) UILabel * projectNum;
//时间选择器
@property (nonatomic, strong) UIView *PickVC;
@property (nonatomic, strong) UIView * aView;
@property (nonatomic, copy) NSString * dateStr;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property(nonatomic,strong) JF_CalendarView *calendarView;
@end

@implementation MeHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证记录";
    [self request];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveValue:) name:@"DatePass" object:nil];
    
    
    self.view.backgroundColor = [UIColor backGray];
    self.tableView.separatorStyle =NO;
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375 * kScreenWidth1, 130 * kScreenHeight1)];
    
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(375 / 2 * kScreenWidth1, 15 * kScreenHeight1, 1 * kScreenWidth1, 60 * kScreenHeight1)];
    aLabel.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:aLabel];
    
    UILabel * bLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90 * kScreenHeight1, 375 * kScreenWidth1, 1 * kScreenHeight1)];
    bLabel.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:bLabel];
    
    UILabel * cLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45 * kScreenHeight1, 375 / 2 * kScreenWidth1, 30 * kScreenHeight1)];
    cLabel.text = @"验证量(张)";
    cLabel.font = [UIFont systemFontOfSize:15];
    cLabel.textAlignment = NSTextAlignmentCenter;
    cLabel.textColor = [UIColor colorWithRed:218 / 255.0 green:68 / 255.0 blue:55 / 255.0 alpha:1];
    [headView addSubview:cLabel];
    
    UILabel * dLabel = [[UILabel alloc] initWithFrame:CGRectMake(375 / 2 * kScreenWidth1, 45 * kScreenHeight1, 375 / 2 * kScreenWidth1, 30 * kScreenHeight1)];
    dLabel.text = @"项目数(个)";
    dLabel.font = [UIFont systemFontOfSize:15];
    dLabel.textAlignment = NSTextAlignmentCenter;
    dLabel.textColor = [UIColor blackColor];
    [headView addSubview:dLabel];
    
    UIButton * Btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    Btn1.frame = CGRectMake(375 / 2 * kScreenWidth1, 0, 375 / 2 * kScreenWidth1, 90 * kScreenHeight1);
    [Btn1 setBackgroundColor:[UIColor clearColor]];
    [Btn1 addTarget:self action:@selector(handleAction2) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:Btn1];
    
    
    self.codeNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 * kScreenHeight1, 375 / 2 * kScreenWidth1, 30 * kScreenHeight1)];
    _codeNum.text = @"**";
    _codeNum.font = [UIFont systemFontOfSize:15];
    _codeNum.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_codeNum];
    
    self.projectNum = [[UILabel alloc] initWithFrame:CGRectMake(375 / 2 * kScreenWidth1, 15 * kScreenHeight1, 375 / 2 * kScreenWidth1, 30 * kScreenHeight1)];
    _projectNum.text = @"**";
    _projectNum.font = [UIFont systemFontOfSize:15];
    _projectNum.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_projectNum];
    
    UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
    Btn.frame = CGRectMake(30 * kScreenWidth1, 95 * kScreenHeight1, 90 * kScreenWidth1, 30 * kScreenHeight1);
    [Btn setTitle:@"今天" forState:UIControlStateNormal];
    [Btn setBackgroundColor:[UIColor colorWithRed:218 / 255.0 green:68 / 255.0 blue:55 / 255.0 alpha:1]];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:Btn];
    
    UIButton * aBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    aBtn.tag = 5555;
    aBtn.frame = CGRectMake(150 * kScreenWidth1, 95 * kScreenHeight1, 90 * kScreenWidth1, 30 * kScreenHeight1);
    [aBtn setTitle:@"其他日期" forState:UIControlStateNormal];
    [aBtn setBackgroundColor:[UIColor colorWithRed:218 / 255.0 green:68 / 255.0 blue:55 / 255.0 alpha:1]];
    [aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aBtn addTarget:self action:@selector(handleAction1) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:aBtn];
    
    self.tableView.tableHeaderView = headView;
    [self.tableView registerClass:[MeHistoryCell class] forCellReuseIdentifier:@"11"];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

//今天
- (void) handleAction {
    UIButton * Btn = [self.view viewWithTag:5555];
    [Btn setTitle:@"其他日期" forState:UIControlStateNormal];
    [self request];
}

//其他日期
- (void) handleAction1 {
    _PickVC = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375* kScreenWidth1, 667* kScreenHeight1)];
    _PickVC.backgroundColor = [UIColor blackColor];
    _PickVC.alpha = 0.5;
    _PickVC.userInteractionEnabled = YES;
    [self.view  addSubview:_PickVC];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleAction4)];
    [_PickVC addGestureRecognizer:tap];

    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing=0;
    self.calendarView=[[JF_CalendarView alloc]initWithFrame:CGRectMake(75 / 2 * kScreenWidth1, 100* kScreenHeight1, 300* kScreenWidth1, 340* kScreenHeight1) collectionViewLayout:layout];
    _calendarView.tag = 1050;
    [self.view addSubview:self.calendarView];
}

#pragma mark ------------------ 取消弹出视图 ----------------
- (void)handleAction4 { //
    [_calendarView removeFromSuperview];
    //_aView.tag = 102;
    [_PickVC removeFromSuperview];
}

- (void)receiveValue:(NSNotification* )notifi{
    NSLog(@"通知输出值%@",notifi.userInfo[@"date"]);
    if ([[NSString stringWithFormat:@"%@", notifi.userInfo[@"date"]] isEqualToString:@"0000000"]) {
        [_PickVC removeFromSuperview];
        //没有选取日期
    } else {
        //选取日期
        UIButton * Btn = [self.view viewWithTag:5555];
        [Btn setTitle:[NSString stringWithFormat:@"%@", notifi.userInfo[@"date"]] forState:UIControlStateNormal];
        [self request1:[NSString stringWithFormat:@"%@", notifi.userInfo[@"date"]]];
        
        [_PickVC removeFromSuperview];
        [self.tableView reloadData];
    }
}
//项目数
- (void) handleAction2 {
    //传值验证量和项目数
    MeHistory1VC * meVC = [[MeHistory1VC alloc] initWithStyle:UITableViewStylePlain];
    meVC.codeStr = _codeNum.text;
    meVC.projectStr = _projectNum.text;
    meVC.dateStr = _dateStr;
    [self.navigationController pushViewController:meVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"11" forIndexPath:indexPath];
    MeHistoryModel * model = self.dataArray[indexPath.section];
    cell.codeLabel.text = [NSString stringWithFormat:@"%@", model.codeStr];
    cell.dateLabel.text = [NSString stringWithFormat:@"金额:%.2f", [model.fundStr floatValue]];
    cell.acciLabel.text = [NSString stringWithFormat:@"积分:%.2f", [model.accStr floatValue]];
    cell.nameLabel.text = [NSString stringWithFormat:@"名称:%@", model.nameStr];
    cell.priceLabel.text = [NSString stringWithFormat:@"日期:%@", model.dateStr];
    [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:model.cover]placeholderImage:[UIImage imageNamed:@"img_11"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击
    
}

//其他日期数据请求
- (void) request1:(NSString *)str {
    [_dataArray removeAllObjects];
    _dateStr = str;
    NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:@"/api/v1/life/shop/couponActivate/records?beginTime=%@&endTime=%@&count=100",str,str]]);
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:@"/api/v1/life/shop/couponActivate/records?type=1&beginTime=%@&endTime=%@&count=100",str,str]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@参数错误", responseObject);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            _codeNum.text = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"statistics"][@"couponCount"]];
            _projectNum.text = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"statistics"][@"lifeItemCount"]];
            NSArray * dataArr = responseObject[@"data"][@"list"];
            for (NSDictionary * tempDic in dataArr) {
                MeHistoryModel * model = [MeHistoryModel MeWithDictionary:tempDic];
                [self.dataArray addObject:model];
            }
            
            [self.tableView reloadData];
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

- (void) request {
    [_dataArray removeAllObjects];
    _dateStr = @"";
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,@"/api/v1/life/shop/couponActivate/records?type=1&count=100"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@参数错误", responseObject);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            _codeNum.text = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"statistics"][@"couponCount"]];
            _projectNum.text = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"statistics"][@"lifeItemCount"]];
            NSArray * dataArr = responseObject[@"data"][@"list"];
            for (NSDictionary * tempDic in dataArr) {
                MeHistoryModel * model = [MeHistoryModel MeWithDictionary:tempDic];
                [self.dataArray addObject:model];
            }
            
            [self.tableView reloadData];
        } else {
            //参数错误
            NSLog(@"参数错误");
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
