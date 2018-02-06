//
//  LYTManagementVC.m
//  满意
//
//  Created by 云盛科技 on 2017/5/26.
//  Copyright © 2017年 云盛科技. All rights reserved.
//
#define kScreenWidth1          ([UIScreen mainScreen].bounds.size.width / 375)
#define kScreenHeight1         ([UIScreen mainScreen].bounds.size.height / 667)
#import "LYTManagementVC.h"
#import "LYTManagementCell.h"
#import "LYTManagementModel.h"



#import "AFNetworking.h"
#import "LYTUpStraightGoods.h"
#import "UIImageView+WebCache.h"

@interface LYTManagementVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIButton * allBtn;
@property (nonatomic, strong) UIButton * upBtn;
@property (nonatomic, strong) UIButton * downBtn;
@property (nonatomic, strong) UIButton * shutBtn;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, copy) NSString * str;
@property (nonatomic, copy) NSString * spreader;
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation LYTManagementVC

-(void)viewWillAppear:(BOOL)animated
{
    _str = @"1";
    [self request];

}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直供管理";
//    self.view.backgroundColor = [UIColor backGray];
    [self.view addSubview:self.tableView];
    [self configNav];
    [self configView];
}
- (void)configNav
{
    UIBarButtonItem *barBtn =[[UIBarButtonItem alloc]initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnClick)];
    self.navigationItem.rightBarButtonItem =barBtn;
}

- (void)configView
{
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375 * kScreenWidth1, 40 * kScreenHeight1)];
    
    aView.backgroundColor = [UIColor whiteColor];
    self.allBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _allBtn.frame = CGRectMake(0 * kScreenWidth1, 5 * kScreenHeight1, 375 / 4 * kScreenWidth1, 30 * kScreenHeight1);
    [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
    [_allBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_allBtn addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:_allBtn];
    
    self.upBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _upBtn.frame = CGRectMake(375 / 4 * kScreenWidth1, 5 * kScreenHeight1, 375 / 4 * kScreenWidth1, 30 * kScreenHeight1);
    [_upBtn setTitle:@"已上线" forState:UIControlStateNormal];
    [_upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_upBtn addTarget:self action:@selector(handleAction1) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:_upBtn];
    
    self.downBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _downBtn.frame = CGRectMake(375 / 2 * kScreenWidth1, 5 * kScreenHeight1, 375 / 4 * kScreenWidth1, 30 * kScreenHeight1);
    [_downBtn setTitle:@"已下线" forState:UIControlStateNormal];
    [_downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_downBtn addTarget:self action:@selector(handleAction2) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:_downBtn];
    
    self.shutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _shutBtn.frame = CGRectMake((375 / 2 + 375 / 4) * kScreenWidth1, 5 * kScreenHeight1, 375 / 4 * kScreenWidth1, 30 * kScreenHeight1);
    [_shutBtn setTitle:@"已禁用" forState:UIControlStateNormal];
    [_shutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_shutBtn addTarget:self action:@selector(handleAction3) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:_shutBtn];
    
    self.tableView.tableHeaderView = aView;
    self.tableView.separatorStyle =NO;
    [self.tableView registerClass:[LYTManagementCell class] forCellReuseIdentifier:@"22"];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}


- (void)handleAction
{
    [_allBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_shutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _str = @"1";
    [self request];
}

- (void)handleAction1
{
    [_allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_upBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_shutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _str = @"2";
    [self request1];
}

- (void)handleAction2
{
    [_allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_downBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_shutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _str = @"3";
    [self request2];
}

- (void)handleAction3
{
    [_allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_shutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _str = @"4";
    [self request3];
}


- (void)barBtnClick {
    LYTUpStraightGoods * goodVC = [[LYTUpStraightGoods alloc] init];
    goodVC.idString = nil;
    [self.navigationController pushViewController:goodVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYTManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"22" forIndexPath:indexPath];
    LYTManagementModel * model = _dataArray[indexPath.section];
    if ([[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"0"]) {
        cell.downBtn.backgroundColor = [UIColor lightGrayColor];
        cell.downBtn.userInteractionEnabled = NO;
        cell.upBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
        cell.upBtn.userInteractionEnabled = YES;
        cell.editBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
        cell.editBtn.userInteractionEnabled = YES;
        cell.deleBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
        cell.deleBtn.userInteractionEnabled = YES;
        cell.upBtn.tag = model.idStr + 2;
        cell.editBtn.tag = model.idStr - 1;
        NSLog(@"编辑的id%ld", cell.editBtn.tag);
        cell.deleBtn.tag = model.idStr + 1;
        cell.shareBtn.hidden = YES;
    } else if ([[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"2"]) {
        cell.upBtn.backgroundColor = [UIColor lightGrayColor];
        cell.upBtn.userInteractionEnabled = NO;
        cell.editBtn.backgroundColor = [UIColor lightGrayColor];
        cell.editBtn.userInteractionEnabled = NO;
        cell.deleBtn.backgroundColor = [UIColor lightGrayColor];
        cell.deleBtn.userInteractionEnabled = NO;
        cell.downBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
        cell.downBtn.userInteractionEnabled = YES;
        cell.downBtn.tag = model.idStr;
        //开启分享
        cell.shareBtn.hidden = NO;
        [cell.shareBtn addTarget:self action:@selector(handleShare:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"4"]) {
        cell.downBtn.backgroundColor = [UIColor lightGrayColor];
        cell.downBtn.userInteractionEnabled = NO;
        cell.deleBtn.backgroundColor = [UIColor lightGrayColor];
        cell.deleBtn.userInteractionEnabled = NO;
        cell.upBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
        cell.upBtn.userInteractionEnabled = YES;
        cell.editBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
        cell.editBtn.userInteractionEnabled = YES;
        cell.editBtn.tag = model.idStr - 1;
        cell.upBtn.tag = model.idStr + 2;
        cell.shareBtn.hidden = YES;
        cell.shareBtn.tag = indexPath.row;
    } else if ([[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"5"]) {
        cell.downBtn.backgroundColor = [UIColor lightGrayColor];
        cell.downBtn.userInteractionEnabled = NO;
        cell.deleBtn.backgroundColor = [UIColor lightGrayColor];
        cell.deleBtn.userInteractionEnabled = NO;
        cell.upBtn.backgroundColor = [UIColor lightGrayColor];
        cell.upBtn.userInteractionEnabled = NO;
        cell.editBtn.backgroundColor = [UIColor lightGrayColor];
        cell.editBtn.userInteractionEnabled = NO;
        cell.shareBtn.hidden = YES;
        
    }
     cell.shareBtn.tag = indexPath.row;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",model.dateStr];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.nameStr];
    [cell.upBtn addTarget:self action:@selector(handleUp:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn addTarget:self action:@selector(handleEdit:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleBtn addTarget:self action:@selector(handleDel:) forControlEvents:UIControlEventTouchUpInside];
    [cell.downBtn addTarget:self action:@selector(handleDown:) forControlEvents:UIControlEventTouchUpInside];
    [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.imageStr]]];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

//分享操作
- (void) handleShare:(UIButton *)sender {
    //分享
    LYTManagementModel * model = _dataArray[sender.tag];
    NSLog(@"fenxiang直供分享 -----%@",[NSString stringWithFormat:@""@"/App/Local/goods_info/id/%d/spreader----%@-------- - --%ld", model.idStr,model.isShared,sender.tag]);
     if ([model.isShared intValue] == 0) {
          [self requestShareShop:1 AndGoodsId:model.idStr];
     }else{
          [self requestShareShop:0 AndGoodsId:model.idStr];
     }
     
}

//上线操作
- (void) handleUp:(UIButton *)sender{
    NSLog(@"上线操作");
    NSString * passStr = [NSString stringWithFormat:@"%d", sender.tag - 2];
    [self requestUp:passStr];
}

//下线操作
- (void) handleDown:(UIButton *)sender{
    NSLog(@"下线操作%ld", sender.tag);
    NSString * passStr = [NSString stringWithFormat:@"%ld", sender.tag];
    [self requestDown:passStr];
}

//编辑操作
- (void) handleEdit:(UIButton *)sender{
    
    NSLog(@"编辑操作");
    NSString * passStr = [NSString stringWithFormat:@"%d", sender.tag + 1];
    LYTUpStraightGoods * goodVC = [[LYTUpStraightGoods alloc] init];
    NSLog(@"idStr%@", passStr);
    goodVC.idString = passStr;
    [self.navigationController pushViewController:goodVC animated:YES];
    
}

//删除操作
- (void) handleDel:(UIButton *)sender{
    NSLog(@"删除操作");
    NSString * passStr = [NSString stringWithFormat:@"%ld", sender.tag - 1];
    [self requestDele:passStr];
}

#pragma mark * 项目管理
#pragma mark ----------------------- 申请上线 ----------------------
- (void) requestUp:(NSString *)passStr {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat: [NSString stringWithFormat:@"%@%@",LSKurl,projectManagement], passStr]  parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"申请上线%@", responseObject);
         if ([_str isEqualToString:@"1"]) {
              [self request];
         }else if ([_str isEqualToString:@"2"]){
              [self request1];
         }else if ([_str isEqualToString:@"3"]){
              [self request2];
         }else if ([_str isEqualToString:@"4"]){
              [self request3];
         }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"申请上线失败%@",error);
    }];
}
#pragma mark ----------------------- 申请下线 ----------------------
- (void) requestDown:(NSString *)passStr {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:[NSString stringWithFormat:@"%@%@",LSKurl,applyOffline], passStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"申请下线%@", responseObject);
         if ([_str isEqualToString:@"1"]) {
              [self request];
         }else if ([_str isEqualToString:@"2"]){
              [self request1];
         }else if ([_str isEqualToString:@"3"]){
              [self request2];
         }else if ([_str isEqualToString:@"4"]){
              [self request3];
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"申请下线失败%@",error);
    }];
}
#pragma mark ------------------ 项目删除 ----------------
- (void) requestDele:(NSString *)passStr {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:[NSString stringWithFormat:@"%@%@",LSKurl,applyDelete], passStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"项目删除%@", responseObject[@"error_code"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"项目删除shibai%@", error);
    }];
}

#pragma mark ------------------ 项目分享 ----------------
- (void) requestShareShop:(int)isShared AndGoodsId:(int)goodsId {
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     [manager POST:[NSString stringWithFormat:@"%@/api/v1/life/update?goodsId=%d&isShared=%d",LSKurl,goodsId,isShared] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"项目分享%@", responseObject);
          
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"项目分享shibai%@", error);
     }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击
}

#pragma mark ------------------ 项目列表查询 ----------------
- (void) request {
    [self.dataArray removeAllObjects];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     NSLog(@"");
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/life/shop/item/records?goodsType=2&&count=100",LSKurl] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSArray * dataArr = responseObject[@"data"][@"list"];
            for (NSDictionary * tempDic in dataArr) {
                LYTManagementModel * wdm = [LYTManagementModel projectWithDictionary:tempDic];
                [self.dataArray addObject:wdm];
            }
            NSLog(@"项目列表查询%@", responseObject);
            
            [self.tableView reloadData];
        } else {
            //参数错误
            NSLog(@"参数错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"项目列表查询失败%@", error);
    }];
}

#pragma mark ------------------ 上线项目列表 ----------------
//上线审批通过，已上线
- (void) request1 {
    [self.dataArray removeAllObjects];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     NSLog(@"aaaas----%@",[NSString stringWithFormat:@"%@/api/v1/life/shop/item/records?goodsType=2&status=2&count=100",LSKurl]);
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/life/shop/item/records?goodsType=2&status=2&count=100",LSKurl]  parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSArray * dataArr = responseObject[@"data"][@"list"];
            for (NSDictionary * tempDic in dataArr) {
                LYTManagementModel * wdm = [LYTManagementModel projectWithDictionary:tempDic];
                [self.dataArray addObject:wdm];
            }
            NSLog(@"上线项目列表%@", responseObject);
            
            [self.tableView reloadData];
        } else {
            //参数错误
            NSLog(@"参数错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上线项目列表shibai%@", error);
    }];
}

#pragma mark ------------------ 下线项目列表 ----------------
//下线审批通过，已下线
- (void) request2 {
    [self.dataArray removeAllObjects];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     NSLog(@"");
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/life/shop/item/records?goodsType=2&status=4&count=100",LSKurl] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSArray * dataArr = responseObject[@"data"][@"list"];
            for (NSDictionary * tempDic in dataArr) {
                LYTManagementModel * wdm = [LYTManagementModel projectWithDictionary:tempDic];
                [self.dataArray addObject:wdm];
            }
            NSLog(@"下线项目列表%@", responseObject);
            [self.tableView reloadData];
        } else {
            //参数错误
            NSLog(@"参数错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"下线项目列表%@", error);
    }];
}

#pragma mark ------------------ 禁用项目列表 ----------------
- (void) request3 {
    [self.dataArray removeAllObjects];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     NSLog(@"禁用项目列表---%@",[NSString stringWithFormat:@"%@/api/v1/life/shop/item/records?goodsType=2&status=5&count=100",LSKurl]);
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/life/shop/item/records?goodsType=2&status=5&count=100",LSKurl] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSArray * dataArr = responseObject[@"data"][@"list"];
            for (NSDictionary * tempDic in dataArr) {
                LYTManagementModel * wdm = [LYTManagementModel projectWithDictionary:tempDic];
                [self.dataArray addObject:wdm];
            }
            NSLog(@"禁用项目列表%@", responseObject);
            [self.tableView reloadData];
        } else {
            //参数错误
            NSLog(@"参数错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"禁用项目列表shibai %@", error);
    }];
}


@end
