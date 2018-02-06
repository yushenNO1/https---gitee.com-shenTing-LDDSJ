//
//  MeHistory1VC.m
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "MeHistory1VC.h"

#import "MeHistoryModel1.h"
#import "MeHistoryCell1.h"
#import "MeHistory2VC.h"
#import "UIColor+Addition.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "NetURL.h"
@interface MeHistory1VC ()
@property (nonatomic, strong) UILabel * codeNum;
@property (nonatomic, strong) UILabel * projectNum;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation MeHistory1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证记录";
    self.view.backgroundColor = [UIColor backGray];
    [self configView];
    self.tableView.separatorStyle =NO;
    [self.tableView registerClass:[MeHistoryCell1 class] forCellReuseIdentifier:@"11"];
    
    [self request];
}

- (void)configView {
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375 * kScreenWidth1, 90 * kScreenHeight1)];
    
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(375 / 2 * kScreenWidth1, 15 * kScreenHeight1, 1 * kScreenWidth1, 60 * kScreenHeight1)];
    aLabel.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:aLabel];
    
    UILabel * bLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 89 * kScreenHeight1, 375 * kScreenWidth1, 1 * kScreenHeight1)];
    bLabel.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:bLabel];
    
    UILabel * cLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45 * kScreenHeight1, 375 / 2 * kScreenWidth1, 30 * kScreenHeight1)];
    cLabel.text = @"验证量(张)";
    cLabel.font = [UIFont systemFontOfSize:15];
    cLabel.textAlignment = NSTextAlignmentCenter;
    cLabel.textColor = [UIColor blackColor];
    [headView addSubview:cLabel];
    
    UILabel * dLabel = [[UILabel alloc] initWithFrame:CGRectMake(375 / 2 * kScreenWidth1, 45 * kScreenHeight1, 375 / 2 * kScreenWidth1, 30 * kScreenHeight1)];
    dLabel.text = @"项目数(个)";
    dLabel.font = [UIFont systemFontOfSize:15];
    dLabel.textAlignment = NSTextAlignmentCenter;
    dLabel.textColor = [UIColor colorWithRed:218 / 255.0 green:68 / 255.0 blue:55 / 255.0 alpha:1];
    [headView addSubview:dLabel];
    
    UIButton * Btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    Btn3.frame = CGRectMake(0 * kScreenWidth1, 0, 375 / 2 * kScreenWidth1, 90 * kScreenHeight1);
    [Btn3 setBackgroundColor:[UIColor clearColor]];
    [Btn3 addTarget:self action:@selector(handleAction5) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:Btn3];
    
    UIButton * Btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    Btn1.frame = CGRectMake(375 / 2 * kScreenHeight1, 0, 375 / 2 * kScreenWidth1, 90 * kScreenHeight1);
    [Btn1 setBackgroundColor:[UIColor clearColor]];
    [Btn1 addTarget:self action:@selector(handleAction2) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:Btn1];
    
    self.codeNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 * kScreenHeight1, 375 / 2 * kScreenWidth1, 30 * kScreenHeight1)];
    _codeNum.text = _codeStr;
    _codeNum.font = [UIFont systemFontOfSize:15];
    _codeNum.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_codeNum];
    
    self.projectNum = [[UILabel alloc] initWithFrame:CGRectMake(375 / 2 * kScreenHeight1, 15 * kScreenWidth1, 375 / 2 * kScreenWidth1, 30 * kScreenHeight1)];
    _projectNum.text = _projectStr;
    _projectNum.font = [UIFont systemFontOfSize:15];
    _projectNum.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_projectNum];
    
    self.tableView.tableHeaderView = headView;

}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

//点击刷新
- (void)handleAction2 {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeHistoryCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"11" forIndexPath:indexPath];
    MeHistoryModel1 * model = self.dataArray[indexPath.section];
    cell.numLabel.text = [NSString stringWithFormat:@"已验证:%d", model.numStr];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.nameStr];
    [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.imageStr]]placeholderImage:[UIImage imageNamed:@"img_11"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", model.priceStr];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", model.dateStr];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //传值
    MeHistory2VC * meVC = [[MeHistory2VC alloc] initWithStyle:UITableViewStylePlain];
    MeHistoryModel1 * model = self.dataArray[indexPath.section];
    meVC.idStr = [NSString stringWithFormat:@"%d", model.idStr];
    meVC.imageStr = model.imageStr;
    meVC.dateStr = _dateStr;
    [self.navigationController pushViewController:meVC animated:YES];
}

//项目数
- (void) handleAction5 {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) request {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/life/shop/couponActivate/records?type=2&count=100&beginTime=%@&endTime=%@",LSKurl, _dateStr, _dateStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _projectNum.text = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"statistics"][@"lifeItemCount"]];
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSArray * dataArr = responseObject[@"data"][@"list"];
            for (NSDictionary * tempDic in dataArr) {
                MeHistoryModel1 * model = [MeHistoryModel1 MerWithDictionary:tempDic];
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
