//
//  OrderIncomeVC.m
//  供应商
//
//  Created by 张敬文 on 2017/8/5.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "OrderIncomeVC.h"
#import "MyMoneyVC.h"
#import "ScanVC.h"
#import "OrderDetailVC.h"
#import "AFNetworking.h"
#import "OrderDetailCell.h"
#import "OrderDetailCell11.h"
#import "MJRefresh.h"
@interface OrderIncomeVC () <UITableViewDelegate, UITableViewDataSource>{
     NSInteger _offset;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * waitBtn;
@property (nonatomic, strong) UIButton * SendBtn;
@property (nonatomic, strong) UIButton * OverBtn;
@property (nonatomic, strong) UILabel * waitLabel;
@property (nonatomic, strong) UILabel * SendLabel;
@property (nonatomic, strong) UILabel * OverLabel;
@property (nonatomic, strong) UILabel * waitNum;
@property (nonatomic, strong) UILabel * SendNum;
@property (nonatomic, strong) UILabel * OverNum;
@property (nonatomic, strong) NSMutableArray * arrayImage;
@property (nonatomic, copy) NSString * code;
@end

@implementation OrderIncomeVC
-(NSMutableArray *)arrayImage {
     if (!_arrayImage) {
          _arrayImage = [NSMutableArray arrayWithCapacity:1];
     }
     return _arrayImage;
}

-(void)viewWillAppear:(BOOL)animated
{
     _code = @"0";  //待发货:0  已发货:1  已完成:2
     [_arrayImage removeAllObjects];
     _offset = 0;
     [self request];
     [self requestCount];
}

- (void)addRefreshAndLoadMore {
     self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(handleRefresh)];
     //添加上拉刷新
     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(handleLoadMore)];
}
- (void)handleRefresh {//刷新
     _offset = 0;
     [_arrayImage removeAllObjects];
     [self request];
}

- (void)handleLoadMore {//加载更多
     _offset+=10;
     [self request];
}

- (void) requestCount {
     NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
     NSLog(@"接口内容:%@", [NSString stringWithFormat:@"%@",[NSString stringWithFormat:GYSOrderCount]]);
     [manager GET:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:GYSOrderCount]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"订单数量数据%@", responseObject);
          if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
               _waitNum.text = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"toSendCount"]];
               _SendNum.text = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"shippedCount"]];
               _OverNum.text = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"confirmCount"]];
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

- (void)viewDidLoad {
    [super viewDidLoad];

     
    
    self.view.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    self.title = @"订单管理";
    [self configView];
     [self addRefreshAndLoadMore];
//    [self setNavigationBarConfiguer];
    // Do any additional setup after loading the view.
}

- (void)setNavigationBarConfiguer {
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"我的收入" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
     UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
     self.navigationItem.leftBarButtonItem = item;
     
     
}

- (void) leftBarBtnClick {
     [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightBarButtonItemAction {
    //我的收入
    MyMoneyVC * zjwVC = [[MyMoneyVC alloc] init];
    [self.navigationController pushViewController:zjwVC animated:YES];
}

- (void) configView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = 100;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[OrderDetailCell class] forCellReuseIdentifier:@"11"];
    [_tableView registerClass:[OrderDetailCell11 class] forCellReuseIdentifier:@"OrderDetailCell11"];
    
    
     UILabel * backLabel = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(0, 69, 375, 50)];
     backLabel.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:backLabel];
     
     self.waitNum = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(0, 74, 375 / 3, 20)];
     _waitNum.backgroundColor = [UIColor whiteColor];
     _waitNum.text = @"0";
     _waitNum.textAlignment = 1;
     _waitNum.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     _waitNum.font = [UIFont systemFontOfSize:15* kScreenHeight1];
     [self.view addSubview:_waitNum];
     
     self.waitLabel = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(0, 94, 375 / 3, 20)];
     _waitLabel.backgroundColor = [UIColor whiteColor];
     _waitLabel.text = @"待处理";
     _waitLabel.textAlignment = 1;
     _waitLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     _waitLabel.font = [UIFont systemFontOfSize:15];
     [self.view addSubview:_waitLabel];
     
    self.waitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _waitBtn.frame = WDH_CGRectWidth(0, 69, 375 / 3, 50);
    _waitBtn.backgroundColor = [UIColor clearColor];
    [_waitBtn addTarget:self action:@selector(handleWait) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_waitBtn];
     
     self.SendNum = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(375 / 3, 74, 375 / 3, 20)];
     _SendNum.backgroundColor = [UIColor whiteColor];
     _SendNum.text = @"0";
     _SendNum.textAlignment = 1;
     _SendNum.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     _SendNum.font = [UIFont systemFontOfSize:15* kScreenHeight1];
     [self.view addSubview:_SendNum];
     
     self.SendLabel = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(375 / 3, 94, 375 / 3, 20)];
     _SendLabel.backgroundColor = [UIColor whiteColor];
     _SendLabel.text = @"已发货";
     _SendLabel.textAlignment = 1;
     _SendLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     _SendLabel.font = [UIFont systemFontOfSize:15* kScreenHeight1];
     [self.view addSubview:_SendLabel];
    
    self.SendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _SendBtn.frame = WDH_CGRectWidth(375 / 3, 69, 375 / 3, 50);
    _SendBtn.backgroundColor = [UIColor clearColor];
    [_SendBtn addTarget:self action:@selector(handleSend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_SendBtn];
     
     self.OverNum = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(375 / 3 * 2, 74, 375 / 3, 20)];
     _OverNum.backgroundColor = [UIColor whiteColor];
     _OverNum.text = @"0";
     _OverNum.textAlignment = 1;
     _OverNum.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     _OverNum.font = [UIFont systemFontOfSize:15* kScreenHeight1];
     [self.view addSubview:_OverNum];
     
     self.OverLabel = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(375 / 3 * 2, 94, 375 / 3, 20)];
     _OverLabel.backgroundColor = [UIColor whiteColor];
     _OverLabel.text = @"已完成";
     _OverLabel.textAlignment = 1;
     _OverLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     _OverLabel.font = [UIFont systemFontOfSize:15* kScreenHeight1];
     [self.view addSubview:_OverLabel];
    
    self.OverBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _OverBtn.frame = WDH_CGRectWidth(375 / 3 * 2, 69, 375 / 3, 50);
     _OverBtn.backgroundColor = [UIColor clearColor];
    [_OverBtn addTarget:self action:@selector(handleOver) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_OverBtn];
     
     [self requestCount];
}

- (void)handleWait {
     _code = @"0";
     _offset = 0;
     [_arrayImage removeAllObjects];
     [self request];
}

- (void)handleSend {
     _code = @"1";
     _offset = 0;
     [_arrayImage removeAllObjects];
     [self request];
}

- (void)handleOver {
     _code = @"2";
     _offset = 0;
     [_arrayImage removeAllObjects];
     [self request];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return _arrayImage.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     NSDictionary * dic = _arrayImage[section];
     NSArray * Ary = dic[@"millOrderGoodsVoList"];
     return Ary.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = _arrayImage[indexPath.section];
    NSArray * ary = dic[@"millOrderGoodsVoList"];
    
    if (indexPath.row ==  ary.count ) {
        OrderDetailCell11 * zjwCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell11" forIndexPath:indexPath];
        NSDictionary * dic = _arrayImage[indexPath.section];
        NSArray * ary = dic[@"millOrderGoodsVoList"];
        zjwCell.label.text = [NSString stringWithFormat:@"共%ld件商品 合计: ¥%.2f", ary.count, [dic[@"orderAmount"] floatValue]];
        zjwCell.Btn.tag = [dic[@"orderId"] integerValue];
        if ([_code isEqualToString:@"1"]) {
            [zjwCell.Btn setTitle:@"查看物流" forState:UIControlStateNormal];
        } else if ([_code isEqualToString:@"2"]) {
            [zjwCell.Btn setTitle:@"已完成" forState:UIControlStateNormal];
        } else {
            [zjwCell.Btn setTitle:@"发货" forState:UIControlStateNormal];
        }
        [zjwCell.Btn addTarget:self action:@selector(handleGo:) forControlEvents:UIControlEventTouchUpInside];
        return zjwCell;
    }else{
        OrderDetailCell * zjwCell = [tableView dequeueReusableCellWithIdentifier:@"11" forIndexPath:indexPath];
        NSDictionary * dataDic = ary[indexPath.row];
        [zjwCell.ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dataDic[@"cover"]]]];
        zjwCell.TopLabel.text = [NSString stringWithFormat:@"%@", dataDic[@"goodsName"]];
        zjwCell.colorLabel.text = [NSString stringWithFormat:@"%@", @""];
        zjwCell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [dataDic[@"goodsPrice"] floatValue]];
        zjwCell.numLabel.text = [NSString stringWithFormat:@"*%d", [dataDic[@"goodsCount"] intValue]];
        zjwCell.descripeLabel.text = [NSString stringWithFormat:@"%@", dataDic[@"parameterName"]];
        [zjwCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return zjwCell;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     NSDictionary * dic = _arrayImage[section];
     UIView * backView = [[UIView alloc] initWithFrame:WDH_CGRectWidth(0, 0, 375, 50)];
     backView.backgroundColor = [UIColor whiteColor];
     UILabel * label = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(20, 0, 300, 50)];
     label.text = [NSString stringWithFormat:@"订单号: %@", dic[@"orderNo"]];
     label.font = [UIFont systemFontOfSize:15];
     label.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     [backView addSubview:label];
     UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
     Btn.frame = WDH_CGRectWidth(0, 0, 375, 50);
     Btn.backgroundColor = [UIColor clearColor];
     Btn.tag = [dic[@"orderId"] integerValue];
     [Btn addTarget:self action:@selector(handleGo:) forControlEvents:UIControlEventTouchUpInside];
     [backView addSubview:Btn];
     return backView;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//     NSDictionary * dic = _arrayImage[section];
//     UIView * backView = [[UIView alloc] initWithFrame:WDH_CGRectWidth(0, 0, 375, 95)];
//     backView.backgroundColor = [UIColor whiteColor];
//     UILabel * label = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(20, 0, 335, 50)];
//     NSArray * ary = dic[@"millOrderGoodsVoList"];
//     label.text = [NSString stringWithFormat:@"共%ld件商品 合计: ¥%.2f", ary.count, [dic[@"orderAmount"] floatValue]];
//     label.font = [UIFont systemFontOfSize:15];
//     label.textAlignment = 2;
//     label.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
//     [backView addSubview:label];
//     UILabel * lineLabel = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(0, 40, 375, 1)];
//     lineLabel.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
//     [backView addSubview:lineLabel];
//     UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
//     Btn.frame = WDH_CGRectWidth(280, 50, 80, 30);
//     Btn.tag = [dic[@"orderId"] integerValue];
//     Btn.layer.cornerRadius = 15;
//     Btn.layer.masksToBounds = YES;
//     Btn.layer.borderWidth = 1.0f;
//     Btn.layer.borderColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1].CGColor;
//     if ([_code isEqualToString:@"1"]) {
//          [Btn setTitle:@"查看物流" forState:UIControlStateNormal];
//     } else if ([_code isEqualToString:@"2"]) {
//          [Btn setTitle:@"已完成" forState:UIControlStateNormal];
//     } else {
//          [Btn setTitle:@"发货" forState:UIControlStateNormal];
//     }
//     [Btn setTitleColor:[UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1] forState:UIControlStateNormal];
//     [Btn addTarget:self action:@selector(handleGo:) forControlEvents:UIControlEventTouchUpInside];
//     [backView addSubview:Btn];
//     UILabel * colorLabel = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(0, 90, 375, 5)];
//     colorLabel.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
//     [backView addSubview:colorLabel];
//     return backView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = _arrayImage[indexPath.section];
    NSArray * ary = dic[@"millOrderGoodsVoList"];
    if (indexPath.row ==  ary.count ){
        return 95* kScreenHeight1;
    }else{
        return 103* kScreenHeight1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     return 50* kScreenHeight1;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//     return 95* kScreenHeight1;
//}

- (void) handleGo :(UIButton *) sender {
     OrderDetailVC * orderVC = [[OrderDetailVC alloc] init];
     orderVC.orderId = [NSString stringWithFormat:@"%ld", sender.tag];
     orderVC.type = _code;
     [self.navigationController pushViewController:orderVC animated:YES];
}

- (void) request {
     
     NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
     NSLog(@"接口内容:%@", [NSString stringWithFormat:@"%@",[NSString stringWithFormat:GYSOrderList, _code, _offset]]);
     [manager GET:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:GYSOrderList, _code, _offset]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"订单列表数据%@", responseObject);
          
          
          if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
               NSDictionary * dic = responseObject[@"data"];
               NSArray * ary = dic[@"orderList"];
               if (ary != nil){
                    if (ary.count == 0) {
                         [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                         for (NSDictionary * dataDic in ary) {
                              [self.arrayImage addObject:dataDic];
                         }
                         [self.tableView.mj_footer endRefreshing];
                    }
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView reloadData];
               }
               NSLog(@"订单列表内容%@", _arrayImage);
          }
          
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          [self.tableView.mj_header endRefreshing];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
