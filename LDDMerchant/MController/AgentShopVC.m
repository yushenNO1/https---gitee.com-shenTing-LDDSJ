//
//  AgentShopVC.m
//  WDHMerchant
//
//  Created by 云盛科技 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "AgentShopVC.h"
#import "ApplyAgentVC.h"
#import "LYTManagementVC.h"
#import "AFNetworking.h"
#import "AgentShopCell.h"
#import "AgentShopDetailVC.h"
@interface AgentShopView : UIView
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIButton *anniuBtn;

@property(nonatomic,strong)UILabel *line;
@end
@implementation AgentShopView

-(instancetype)initWithFrame:(CGRect)frame{
     self = [super initWithFrame:frame];
     if (self) {
          [self addSubview:self.imgView];
          [self addSubview:self.titleLabel];
          [self addSubview:self.contentLabel];
          [self addSubview:self.anniuBtn];
          [self addSubview:self.line];
     }
     return self;
}
-(UIImageView *)imgView{
     if (!_imgView) {
          _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20*kScreenWidth1, 20*kScreenHeight1, 40, 40)];
     }
     return _imgView;
}
-(UILabel *)titleLabel{
     if (!_titleLabel) {
          _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70*kScreenWidth1, 20*kScreenHeight1, 200*kScreenWidth1, 20*kScreenHeight1)];
          _titleLabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
     }
     return _titleLabel;
}
-(UILabel *)contentLabel{
     if (!_contentLabel) {
          _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(70*kScreenWidth1, 40*kScreenHeight1, 200*kScreenWidth1, 20*kScreenHeight1)];
          _contentLabel.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
          _contentLabel.font = [UIFont systemFontOfSize:13*kScreenHeight1];
     }
     return _contentLabel;
}
-(UIButton *)anniuBtn{
     if (!_anniuBtn) {
          _anniuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
          _anniuBtn.frame = CGRectMake(275*kScreenWidth1, 30*kScreenHeight1, 75*kScreenWidth1, 24*kScreenHeight1);
          _anniuBtn.titleLabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
          _anniuBtn.layer.cornerRadius = 3;
          _anniuBtn.layer.masksToBounds = YES;
          _anniuBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:66/255.0 blue:89/255.0 alpha:1];
     }
     return _anniuBtn;
}
-(UILabel *)line{
     if (!_line) {
          _line = [[UILabel alloc]initWithFrame:CGRectMake(0, 79*kScreenHeight1, 375*kScreenWidth1, 1*kScreenHeight1)];
          _line.textColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
     }
     return _line;
}
@end


@interface AgentShopVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)UITableView *LYTTable;

@property(nonatomic,copy)NSMutableArray *tableArr;
@end

@implementation AgentShopVC

-(NSMutableArray *)tableArr{
     if (!_tableArr) {
          _tableArr = [NSMutableArray arrayWithCapacity:0];
     }
     return _tableArr;
}
-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
     [self requestShopAgentSupplierList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
     
     
     self.LYTTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
     
     [self.LYTTable registerClass:[AgentShopCell class] forCellReuseIdentifier:@"AgentShopCell"];
     self.LYTTable.delegate = self;
     self.LYTTable.dataSource = self;
     [self.view addSubview:self.LYTTable];
     [self configView];
}
-(void)configView{
     
     NSDictionary *shopInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];

     
     
     
     UIView *headerView = [[UIView alloc]initWithFrame:WDH_CGRectMake(0, 0, 375, 30)];
     headerView.backgroundColor = [UIColor whiteColor];
     
     UILabel *nameLabel = [[UILabel alloc]initWithFrame:WDH_CGRectMake(0, 0, 375/3, 30)];
     nameLabel.text = @"商家名称";
     nameLabel.font = [UIFont systemFontOfSize:14];
     nameLabel.textAlignment = NSTextAlignmentCenter;
     [headerView addSubview:nameLabel];
     
     
     UILabel *profileLabel = [[UILabel alloc]initWithFrame:WDH_CGRectMake(375/3, 0, 375/3, 30)];
     profileLabel.text = @"联系方式";
     profileLabel.font = [UIFont systemFontOfSize:14];
     profileLabel.textAlignment = NSTextAlignmentCenter;
     [headerView addSubview:profileLabel];
     
     
     UILabel *profileLabel1 = [[UILabel alloc]initWithFrame:WDH_CGRectMake(375/3*2, 0, 375/3, 30)];
     profileLabel1.text = @"店铺状态";
     profileLabel1.font = [UIFont systemFontOfSize:14];
     profileLabel1.textAlignment = NSTextAlignmentCenter;
     [headerView addSubview:profileLabel1];
     
     self.LYTTable.tableHeaderView = headerView;
     self.LYTTable.tableFooterView = [UIView new];
//     NSArray *imgArr = @[@"申请代理icon@3x",@"上传商品icon@3x"];
//     NSArray *titlegArr = @[@"代理申请",@"上传直供"];
//     NSArray *contentArr = @[@"点击计入申请区域代理",@"点击进入上传直供商品"];
//     NSArray *btnArr = @[@"点击申请",@"点击上传"];
//     for (int i = 0; i < 1; i ++) {
//          AgentShopView *view = [[AgentShopView alloc]initWithFrame:CGRectMake(0, 70*kScreenHeight1 + 80*kScreenHeight1 * i, 375*kScreenWidth1, 80*kScreenHeight1)];
//          view.imgView.image = [UIImage imageNamed:imgArr[i]];
//          view.titleLabel.text = titlegArr[i];
//          view.contentLabel.text = contentArr[i];
//          [view.anniuBtn addTarget:self action:@selector(anniuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//          view.anniuBtn.tag = i;
//          [view.anniuBtn setTitle:btnArr[i] forState:UIControlStateNormal];
//          [self.view addSubview:view];
//     }
     
     
     
     
     
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.tableArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dic = self.tableArr[indexPath.row];
     AgentShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AgentShopCell"];
     cell.leftLabel.text = dic[@"name"];
     cell.centerLabel.text = dic[@"mobile"];
     if ([dic[@"status"]intValue] == 0) {
          [cell.rightBtn setTitle:@"审批中" forState:UIControlStateNormal];
     }else if ([dic[@"status"]intValue] == 1){
          [cell.rightBtn setTitle:@"审批通过" forState:UIControlStateNormal];
     }else if ([dic[@"status"]intValue] == 2){
          [cell.rightBtn setTitle:@"审批不通过" forState:UIControlStateNormal];
     }else if ([dic[@"status"]intValue] == 3){
          [cell.rightBtn setTitle:@"禁用" forState:UIControlStateNormal];
     }else if ([dic[@"status"]intValue] == 4){
          //申请代理
          [cell.rightBtn setTitle:@"废弃" forState:UIControlStateNormal];
     }
     return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dic = self.tableArr[indexPath.row];
     AgentShopDetailVC *vc = [[AgentShopDetailVC alloc]init];
     vc.dataDic = dic;
     [self.navigationController pushViewController:vc animated:YES];
}
-(void)requestShopAgentSupplierList{
     [self.tableArr removeAllObjects];
     NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
     //[NSString stringWithFormat:@"%@%@",LSKurl,MerchantsInfo]
     [manager GET:[NSString stringWithFormat:LSKurl@"/api/v1/life/agent/supplier/list?count=100&cursor=0"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"当前代理下的商家------%@", responseObject);
          for (NSDictionary *dic in responseObject[@"data"]) {
               [self.tableArr addObject:dic];
          }
          [self.LYTTable reloadData];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"当前代理下的商家------%@", error);
     }];
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
