//
//  LYTRefundManage.m
//  WDHMerchant
//
//  Created by 李宇廷 on 2018/1/24.
//  Copyright © 2018年 Zjw. All rights reserved.
//

#import "LYTRefundManage.h"
#import "LYTRefundCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "LYTRefundDetailVC.h"
@interface LYTRefundManage ()<UITableViewDelegate,UITableViewDataSource>
{
     NSInteger _typeId;
     NSInteger _cursor;
}
@property(nonatomic,strong)UILabel *lineLabel ;
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,copy)NSMutableArray *tableArr;
@property(nonatomic,strong)UITableView *table;
@end


@implementation LYTRefundManage
-(NSMutableArray *)tableArr{
     if (!_tableArr) {
          _tableArr = [NSMutableArray arrayWithCapacity:0];
          
     }
     return _tableArr;
}
-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
     _cursor = 0;
     [_table.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
     _typeId = 0;
     _cursor = 0;
     NSArray *titleArr = @[@"待处理",@"已处理"];
     for (int i = 0; i < 2; i ++) {
          UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
          btn.frame = CGRectMake(kScreenWidth/2*i, 64, kScreenWidth/2, 50);
          [btn setTitle:titleArr[i] forState:UIControlStateNormal];
          [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
          [self.view addSubview:btn];
          btn.tag = i;
          [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
     }
     _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 113, kScreenWidth/2, 1)];
     _lineLabel.backgroundColor = [UIColor redColor];
     [self.view addSubview:_lineLabel];
     

     _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, kScreenWidth, kScreenHeight - 64)];
     _table.delegate =self;
     _table.dataSource = self;
    _table.tableFooterView = [UIView new];
     [self.view addSubview:_table];
     [_table registerClass:[LYTRefundCell class] forCellReuseIdentifier:@"LYTRefundCell"];
     _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(handleRefresh)];
     //添加上拉刷新
     _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(handleLoadMore)];
     
     [self requestRefundWithCursor:_cursor type:_typeId];
}

-(void)btnClick:(UIButton *)sender{
     _cursor = 0;
     if (sender.tag == 0) {
          _typeId = sender.tag + 1;
          
     }else{
          _typeId = sender.tag + 1;
     }
     _lineLabel.frame = CGRectMake(sender.tag * kScreenWidth/2, 113, kScreenWidth/2, 1);
     [_table.mj_header beginRefreshing];
}
- (void)handleRefresh {//刷新
     [self requestRefundWithCursor:_cursor type:_typeId];
}

- (void)handleLoadMore {//加载更多
     _cursor += 10;
     [self requestRefundWithCursor:_cursor type:_typeId];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 120;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.tableArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dic = self.tableArr[indexPath.row];
     LYTRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LYTRefundCell"];
     cell.orderLabel.text = [NSString stringWithFormat:@"订单号:%@",dic[@"order_no"]];
     cell.stateLable.text = dic[@"reason"];
     
     if ([dic[@"state"] intValue] == 0) {
          [cell.stateBtn setTitle:@"待审核" forState:UIControlStateNormal];
     }else if ([dic[@"state"] intValue] == 1){
          [cell.stateBtn setTitle:@"已审核" forState:UIControlStateNormal];
     }else if ([dic[@"state"] intValue] == 2){
          [cell.stateBtn setTitle:@"已入库" forState:UIControlStateNormal];
     }else if ([dic[@"state"] intValue] == 3){
          [cell.stateBtn setTitle:@"已完成" forState:UIControlStateNormal];
     }else if ([dic[@"state"] intValue] == 4){
          [cell.stateBtn setTitle:@"已取消" forState:UIControlStateNormal];
     }else if ([dic[@"state"] intValue] == 5){
          [cell.stateBtn setTitle:@"部分入库" forState:UIControlStateNormal];
     }else if ([dic[@"state"] intValue] == 6){
          [cell.stateBtn setTitle:@"拒绝申请" forState:UIControlStateNormal];
     }
     
     
//     NSString*str=dic[@"create_time"];//时间戳
    
    NSString *timeStampString  = dic[@"create_time"];
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
     NSLog(@"开始时间: %@", dateString);

     cell.timeLabel.text = dateString;
     return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      NSDictionary *dic = self.tableArr[indexPath.row];
    
    if ([dic[@"state"] intValue] == 3 ) {
        Alert_Show(@"该退款信息已完成，暂不能修改");
    }else if ([dic[@"state"] intValue] == 4) {
        Alert_Show(@"该退款信息已取消，暂不能修改");
    }else if ( [dic[@"state"] intValue] == 6 ) {
        Alert_Show(@"该退款信息已拒绝，暂不能修改");
    }{
        LYTRefundDetailVC *vc = [[LYTRefundDetailVC alloc]init];
        vc.dataDic = dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)requestRefundWithCursor:(NSInteger)indexId type:(NSInteger)typeId{
     if (indexId == 0) {
          [self.tableArr removeAllObjects];
     }
     NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
     //[NSString stringWithFormat:@"%@%@",LSKurl,MerchantsInfo]
     NSLog(@"url------%@",[NSString stringWithFormat:LSKurl@"/api/v1/life/mgorder/sellback/list?type=%ld&cursor=%ld&count=10",typeId,indexId]);
     [manager GET:[NSString stringWithFormat:LSKurl@"/api/v1/life/mgorder/sellback/list?type=%ld&cursor=%ld&count=10",typeId,indexId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"退款管理------%@-", responseObject);
          for (NSDictionary *dic in responseObject[@"data"]) {
               [self.tableArr addObject:dic];
          }
          [_table reloadData];
          [_table.mj_header endRefreshing];
          [_table.mj_footer endRefreshing];
          if ([responseObject[@"data"] count] <= 0) {
               [_table.mj_footer endRefreshingWithNoMoreData];
          }
          
          
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"当前代理下的商家------%@", error);
     }];
}
@end
