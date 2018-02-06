//
//  earningsViewController.m
//  goods
//
//  Created by 王松松 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//
#import "AFNetworking.h"
#import "NetURL.h"
#import "earningsModel.h"
#import "EarningsCell.h"
#import "UIColor+Addition.h"
#import "earningsViewController.h"
@interface earningsViewController ()<UITableViewDelegate,UITableViewDataSource, UIActionSheetDelegate>
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableViewSmall;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) NSMutableArray *earningArr;
@property (nonatomic, strong) UITableView * prover;
@end
@implementation earningsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title =@"收益记录";
    [self requestFinancialGains:@"1"];
    [self table];
}

//懒加载数组
-(NSMutableArray *)earningArr {
    if (!_earningArr) {
        self.earningArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _earningArr;
}

- (void)table
{
    _tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = 60;
    _tableView.backgroundColor =[UIColor backGray];
    [_tableView registerClass:[EarningsCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160 * kScreenHeight1)];
    view.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = view;
    
    _btn =[UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame =CGRectMake((375 / 2 - 100) / 2 * kScreenWidth1, 15 * kScreenHeight1, 100 * kScreenWidth1, 40 * kScreenHeight1);
    [_btn setTitle:@"今天" forState:UIControlStateNormal];
    [_btn setBackgroundColor:[UIColor colorWithRed:237 / 255.0 green:207 / 255.0 blue:85 / 255.0 alpha:1]];
    _btn.layer.masksToBounds =YES;
    _btn.layer.cornerRadius = 5;
    [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_btn];
    
//    UILabel *label2 =[[UILabel alloc]initWithFrame:CGRectMake(375 / 2 * kScreenWidth1, 120 * kScreenHeight1, 375 / 2 * kScreenWidth1, 44 * kScreenHeight1)];
//    label2.text =@"全部项目";
//    label2.textAlignment = NSTextAlignmentCenter;
//    label2.textColor = [UIColor blackColor];
//    [view addSubview:label2];
    
    _label3 =[[UILabel alloc]initWithFrame:CGRectMake(0, 60 * kScreenHeight1, 375 / 2 * kScreenWidth1, 50 * kScreenHeight1)];
    _label3.text =@"**";
    _label3.font = [UIFont systemFontOfSize:20];
    _label3.textAlignment = NSTextAlignmentCenter;
    _label3.textColor = [UIColor redColor];
    _label3.tag =333;
    [view addSubview:_label3];
    
    _label4 =[[UILabel alloc]initWithFrame:CGRectMake(375 / 2 * kScreenWidth1, 60 * kScreenHeight1, 375 / 2 * kScreenWidth1, 50 * kScreenHeight1)];
    _label4.text =@"**";
    _label4.font = [UIFont systemFontOfSize:20];
    _label4.textAlignment = NSTextAlignmentCenter;
    _label4.textColor = [UIColor redColor];
    _label4.tag =444;
    [view addSubview:_label4];
    
    UILabel *label6 =[[UILabel alloc]initWithFrame:CGRectMake(375 / 2 * kScreenWidth1, 10 * kScreenHeight1, 375 / 2 * kScreenWidth1, 50 * kScreenHeight1)];
    label6.text =@"全部收益";
    label6.textAlignment = NSTextAlignmentCenter;
    label6.textColor = [UIColor blackColor];
    [view addSubview:label6];
    
    UILabel *label7 =[[UILabel alloc]initWithFrame:CGRectMake(0 * kScreenWidth1, 110 * kScreenHeight1, 375 / 3 * kScreenWidth1, 50 * kScreenHeight1)];
    label7.text =@"验券量";
    label7.font = [UIFont systemFontOfSize:15];
    label7.textAlignment = NSTextAlignmentCenter;
    label7.textColor = [UIColor blackColor];
    [view addSubview:label7];

    UILabel *label8 =[[UILabel alloc]initWithFrame:CGRectMake(375 / 3 * kScreenWidth1, 110 * kScreenHeight1, 375 / 3 * kScreenWidth1, 50 * kScreenHeight1)];
    label8.text =@"日期";
    label8.font = [UIFont systemFontOfSize:15];
    label8.textAlignment = NSTextAlignmentCenter;
    label8.textColor = [UIColor blackColor];
    [view addSubview:label8];
    
    UILabel *label9 =[[UILabel alloc]initWithFrame:CGRectMake(375 / 3 * 2 * kScreenWidth1, 110 * kScreenHeight1, 375 / 3 * kScreenWidth1, 50 * kScreenHeight1)];
    label9.text =@"全部金额";
    label9.font = [UIFont systemFontOfSize:15];
    label9.textAlignment = NSTextAlignmentCenter;
    label9.textColor = [UIColor blackColor];
    [view addSubview:label9];

    
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return _earningArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EarningsCell *cellView=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cellView.backgroundColor =[UIColor lightGrayColor];
    earningsModel *model = _earningArr[indexPath.section];
    cellView.leftLabel.text = [NSString stringWithFormat:@"%d", model.count];
    cellView.rightLabel.text = [NSString stringWithFormat:@"%@", model.consume_date];
    cellView.dateLabel.text = [NSString stringWithFormat:@"%.2f", model.pay_amount];
//    cellView.selectionStyle =UITableViewCellSelectionStyleNone;
    return cellView;
}

#pragma mark ------------------ 请求 >>> 收益记录 ----------------
- (void)requestFinancialGains:(NSString *) dateStr {
    [self.earningArr removeAllObjects];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    NSString * UrlStr = [NSString stringWithFormat:@"%@%@",LSKurl,@"/api/v1/life/shop/profit/records"];
    if ([dateStr isEqualToString:@"1"]) {
        UrlStr = [NSString stringWithFormat:@"%@%@?dayNum=%@",LSKurl,@"/api/v1/life/shop/profit/records", dateStr];
    } else {
        UrlStr = [NSString stringWithFormat:@"%@%@?dayNum=%@",LSKurl,@"/api/v1/life/shop/profit/records", dateStr];
    }
    [manager GET:UrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"收益请求接口%@", UrlStr);
        NSLog(@"----$$$$$收益记录responseObject%@",responseObject);
        
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSDictionary * ary = responseObject[@"data"];
            NSDictionary * dic = ary[@"statistics"];
            _label3.text = [NSString stringWithFormat:@"%.2f", [dic[@"count"] floatValue]];
            _label4.text = [NSString stringWithFormat:@"%.2f",[dic[@"payAmount"] floatValue]];
            
            for (NSDictionary *dic1 in ary[@"list"]){
                earningsModel *model = [earningsModel withDrWithDictionary:dic1];
                [self.earningArr addObject:model];
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

- (void)btnClick
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择时间段"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"今天", @"最近一周", @"最近一月", @"最近三月",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [_btn setTitle:@"今天" forState:UIControlStateNormal];
        [self requestFinancialGains:@"1"];
    } else if (buttonIndex == 1) {
        [_btn setTitle:@"最近一周" forState:UIControlStateNormal];
        [self requestFinancialGains:@"7"];
    } else if (buttonIndex == 2) {
        [_btn setTitle:@"最近一月" forState:UIControlStateNormal];
        [self requestFinancialGains:@"30"];
    } else if (buttonIndex == 3) {
        [_btn setTitle:@"最近三月" forState:UIControlStateNormal];
        [self requestFinancialGains:@"90"];
    }
}

@end
