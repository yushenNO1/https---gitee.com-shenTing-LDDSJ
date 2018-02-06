//
//  LYTPurchaseVC.m
//  满意
//
//  Created by 云盛科技 on 2017/5/25.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "LYTPurchaseVC.h"
#import "LYTPurchaseCell.h"
#import "AFNetworking.h"
#import "LYTPurchaseModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#import "GoodsDetailsController.h"
@interface LYTPurchaseVC ()<UITableViewDelegate,UITableViewDataSource>
{
     int coure;
     int selectType;
}
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UILabel *firstLabel;
@property(nonatomic,strong)UILabel *secondLabel;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)UILabel *amountLabel;
@end

@implementation LYTPurchaseVC
-(NSMutableArray *)dataArr{
     if (!_dataArr) {
          _dataArr = [NSMutableArray arrayWithCapacity:0];
     }
     return _dataArr;
}
- (void)viewDidLoad {
     [super viewDidLoad];
     coure = 0;
     selectType = 0;
     
     
     [self requestPurchaseList];
     
     [self.view addSubview:self.tableView];
     self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
          coure = 0;
          if (selectType == 0) {
               [self requestPurchaseList];
          }else{
               [self requestShareList];
          }
          
     }];
     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(handleLoadMore)];
     [self.tableView registerClass:[LYTPurchaseCell class] forCellReuseIdentifier:@"LYTPurchaseCell"];
     [self configFootView];
     [self configView];
}
-(void)handleLoadMore{
     coure += 10;
     if (selectType == 0) {
          [self requestPurchaseList];
     }else{
          [self requestShareList];
     }
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 40)];
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.delegate = self;
         _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}
-(void)configFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40*kScreenHeight1, self.view.bounds.size.width, 40*kScreenHeight1)];
     footView.tag = 124578;
    footView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];

     _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 10*kScreenHeight1, 90*kScreenWidth1, 20*kScreenHeight1)];
     _countLabel.text = @"共0件";
     _countLabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
//     _countLabel.textColor = [UIColor xiaobiaotiColor];
     [footView addSubview:_countLabel];
     
     UILabel *aaa = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 280*kScreenWidth1, 10*kScreenHeight1, 60*kScreenWidth1, 20*kScreenHeight1)];
     aaa.text = @"总金额:";
     aaa.font = [UIFont systemFontOfSize:14*kScreenHeight1];
//     aaa.textColor = [UIColor xiaobiaotiColor];
     [footView addSubview:aaa];
     
     _amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 220*kScreenWidth1, 10*kScreenHeight1, 180*kScreenWidth1, 20*kScreenHeight1)];
     _amountLabel.text = @"¥0.00";
     _amountLabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
     _amountLabel.textColor = [UIColor colorWithRed:232/255.0 green:15/255.0 blue:61/255.0 alpha:1];
     [footView addSubview:_amountLabel];
     
     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
     btn.frame = CGRectMake(kScreenWidth - 110*kScreenWidth1, 0, 110*kScreenWidth1, 40*kScreenHeight1);
     btn.backgroundColor = [UIColor colorWithRed:222/255.0 green:60/255.0 blue:80/255.0 alpha:1];
     [btn setTitle:@"提交订单" forState:UIControlStateNormal];
     [btn addTarget:self action:@selector(jiesuanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     [footView addSubview:btn];
     
    [self.view addSubview:footView];
}
-(void)configView{
     UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60*kScreenHeight1)];
     headerView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
     UIView *witView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 55*kScreenHeight1)];
     witView.backgroundColor = [UIColor whiteColor];
     [headerView addSubview:witView];
     
     
     UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 15*kScreenHeight1, 30, 30)];
     img.image= [ UIImage imageNamed:@"直供商品icon@3x"];
     [witView addSubview:img];
     
     _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(90*kScreenWidth1, 20*kScreenHeight1, 80*kScreenWidth1, 20*kScreenHeight1)];
     _firstLabel.textColor = [UIColor colorWithRed:239/255.0 green:69/255.0 blue:91/255.0 alpha:1];
     _firstLabel.text = @"直供商品";
     _firstLabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
     [witView addSubview:_firstLabel];
     
     UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(184*kScreenWidth1, 15*kScreenHeight1, 1*kScreenWidth1, 30*kScreenHeight1)];
     lineLabel.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
     [witView addSubview:lineLabel];
     
     
     UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(238*kScreenWidth1, 15*kScreenHeight1, 30, 30)];
     img1.image= [ UIImage imageNamed:@"分享商品@3x"];

     [witView addSubview:img1];
     
     _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(278*kScreenWidth1, 20*kScreenHeight1, 80*kScreenWidth1, 20*kScreenHeight1)];
     _secondLabel.textColor = [UIColor blackColor];
     _secondLabel.text = @"分享直供";
     _secondLabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
     [witView addSubview:_secondLabel];
     
     UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 55*kScreenHeight1, self.view.bounds.size.width, 1*kScreenHeight1)];
     line1.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
     [headerView addSubview:line1];
     
     for (int i = 0; i < 2; i ++) {
          UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
          btn.frame = CGRectMake(self.view.bounds.size.width / 2 * i , 0, self.view.bounds.size.width / 2, 60*kScreenHeight1);
          [headerView addSubview:btn];
          btn.tag = i;
          [btn addTarget: self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     }
     
     self.tableView.tableHeaderView = headerView;
}
-(void)headerBtnClick:(UIButton *)sender{
     coure = 0;
     UIView *view = [self.view viewWithTag:124578];
     if (sender.tag == 0) {
          selectType = 0;
          _firstLabel.textColor = [UIColor colorWithRed:239/255.0 green:69/255.0 blue:91/255.0 alpha:1];
          _secondLabel.textColor = [UIColor blackColor];
          
          [self requestPurchaseList];
          
          view.hidden = NO;
          self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 40);
     }else{
          selectType = 1;
          _firstLabel.textColor = [UIColor blackColor];
          _secondLabel.textColor = [UIColor colorWithRed:239/255.0 green:69/255.0 blue:91/255.0 alpha:1];
          [self requestShareList];
          view.hidden = YES;
          self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height );
     }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     NSInteger a = 0;
     double aa = 0;
     for (LYTPurchaseModel *model in _dataArr) {
          if ([model.didSelect isEqualToString:@"1"]) {
               a = a + model.shopCount;
               aa = aa + [model.price doubleValue] * model.shopCount;
               _countLabel.text = [NSString stringWithFormat:@"共%ld件",a];
               _amountLabel.text = [NSString stringWithFormat:@"¥%.2f",aa];
          }
     }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     LYTPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LYTPurchaseCell" forIndexPath:indexPath];
     if (selectType == 0) {
          LYTPurchaseModel *model = [self.dataArr objectAtIndex:indexPath.row];
          cell.yuanImgView.hidden = NO;
          cell.changeBtn.hidden = NO;
          cell.yuanBtn.hidden = NO;
          cell.countLabel.hidden = NO;
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          //改变状态不需要修改的内容
          if ([model.didSelect isEqualToString:@"0"]) {
               cell.yuanImgView.image = [UIImage imageNamed:@"pay_mark_no@3x"];
          }else{
               cell.yuanImgView.image = [UIImage imageNamed:@"pay_mark_ok@3x"];
          }
          if ([model.isChange isEqualToString:@"0"]) {
               [cell.changeBtn setTitle:@"编辑" forState:UIControlStateNormal];
          }else{
               [cell.changeBtn setTitle:@"完成" forState:UIControlStateNormal];
          }
          [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"buess_ico_loading@3x"]];
          [cell.yuanBtn addTarget:self action:@selector(yuanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
          cell.yuanBtn.tag = indexPath.row;
          [cell.changeBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
          cell.changeBtn.tag = indexPath.row;
          
          if ([model.isChange isEqualToString:@"0"]) {
               cell.completeStateView.hidden = NO;
               cell.editStateView.hidden = YES;
               cell.titleLabel.text = model.name;
               cell.contentLabel.text = [NSString stringWithFormat:@"商品来源:%@",model.shopName];
               cell.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.price doubleValue]];
               cell.countLabel.text = [NSString stringWithFormat:@"x%ld",model.shopCount];
          }else{
               cell.completeStateView.hidden = YES;
               cell.editStateView.hidden = NO;
               [cell.jianBtn addTarget:self action:@selector(jianBtnClick:) forControlEvents:UIControlEventTouchUpInside];
               cell.jianBtn.tag = indexPath.row;
               [cell.jiaBtn addTarget:self action:@selector(jiaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
               cell.jiaBtn.tag = indexPath.row;
               cell.countTextFiled.text = [NSString stringWithFormat:@"%ld",model.shopCount];
               [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
               cell.deleteBtn.tag = indexPath.row;
               cell.deleteBtn.hidden = YES;
               
               [cell.countTextFiled addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
               cell.countTextFiled.tag = indexPath.row;
          }
          
          
          return cell;
     }else{
          LYTPurchaseModel *model = [self.dataArr objectAtIndex:indexPath.row];
          cell.yuanImgView.hidden = YES;
          cell.changeBtn.hidden = YES;
          cell.yuanBtn.hidden = YES;
          cell.countLabel.hidden = YES;
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          //改变状态不需要修改的内容
          cell.editStateView.hidden = YES;
          cell.completeStateView.hidden = NO;
          [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"buess_ico_loading@3x"]];
          cell.titleLabel.text = model.goodsName;
          cell.contentLabel.text = model.address;
          cell.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.price doubleValue]];
          
          
          
          return cell;
     }
     
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     LYTPurchaseModel *model = [_dataArr objectAtIndex:indexPath.row];
     GoodsDetailsController *vc = [[GoodsDetailsController alloc]init];
     if (selectType == 0) {
          vc.life_id = model.goodId;
     }else{
          vc.life_id = model.goodsId;
     }
     
     [self.navigationController pushViewController:vc animated:YES];
}

//点击远点改变选中状态
-(void)yuanBtnClick:(UIButton *)sender{
    NSLog(@"改变选中状态");
     LYTPurchaseModel *model = [self.dataArr objectAtIndex:sender.tag];
     if ([model.didSelect isEqualToString:@"0"]) {
          model.didSelect = @"1";
     }else{
          model.didSelect = @"0";
     }
     [self.tableView reloadData];
     
}
//切换编辑状态
-(void)changeBtnClick:(UIButton *)sender{
    NSLog(@"切换编辑状态");
     LYTPurchaseModel *model = [self.dataArr objectAtIndex:sender.tag];
     if ([model.isChange isEqualToString:@"0"]) {
          model.isChange = @"1";
     }else{
          model.isChange = @"0";
     }
    [self.tableView reloadData];
}
//减号按钮
-(void)jianBtnClick:(UIButton *)sender{
    NSLog(@"数量减少了");
     LYTPurchaseModel *model = [self.dataArr objectAtIndex:sender.tag];
     if (model.shopCount <= 1) {
          Alert_Show(@"购买数量不能小于1")
     }else{
          model.shopCount --;
     }
     [self.tableView reloadData];
}
//加好按钮
-(void)jiaBtnClick:(UIButton *)sender{
    NSLog(@"数量增加了");
     LYTPurchaseModel *model = [self.dataArr objectAtIndex:sender.tag];
     model.shopCount ++;
     [self.tableView reloadData];
}
//删除按钮
-(void)deleteBtnClick:(UIButton *)sender{
    NSLog(@"删除按钮点击了");
     
}
//UITextField改变
-(void)textFiledChange:(UITextField *)sender{
    NSLog(@"UITextField改变了");
     if (sender.text.length <= 0 || [sender.text integerValue] <= 0) {
          LYTPurchaseModel *model = [self.dataArr objectAtIndex:sender.tag];
          model.shopCount = [sender.text integerValue];
          NSInteger a = 0;
          double aa = 0;
          for (LYTPurchaseModel *model in _dataArr) {
               if ([model.didSelect isEqualToString:@"1"]) {
                    a = a + model.shopCount;
                    aa = aa + [model.price doubleValue] * model.shopCount;
                    _countLabel.text = [NSString stringWithFormat:@"共%ld件",a];
                    _amountLabel.text = [NSString stringWithFormat:@"¥%.2f",aa];
               }
          }
          Alert_Show(@"商品数量不合法")
     }else{
          LYTPurchaseModel *model = [self.dataArr objectAtIndex:sender.tag];
          model.shopCount = [sender.text integerValue];
          NSInteger a = 0;
          double aa = 0;
          for (LYTPurchaseModel *model in _dataArr) {
               if ([model.didSelect isEqualToString:@"1"]) {
                    a = a + model.shopCount;
                    aa = aa + [model.price doubleValue] * model.shopCount;
                    _countLabel.text = [NSString stringWithFormat:@"共%ld件",a];
                    _amountLabel.text = [NSString stringWithFormat:@"¥%.2f",aa];
               }
          }
     }
    
     
}
//结算
-(void)jiesuanBtnClick:(UIButton *)sender{
     [self requestPurchaseApply];
}
#pragma mark--------request
- (void)requestPurchaseList {
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/life/purchase/goodsList?count=10&cursor=%d",LSKurl,coure] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"直供商品列表:%@", responseObject);
         if (coure == 0) {
              [self.dataArr removeAllObjects];
         }
         for (NSDictionary *dic in responseObject[@"data"]) {
              LYTPurchaseModel *model = [[LYTPurchaseModel alloc]initWithDictionary:dic];
              
              [self.dataArr addObject:model];
         }
         _countLabel.text = [NSString stringWithFormat:@"共%d件",0];
         _amountLabel.text = [NSString stringWithFormat:@"¥%.2f",0.00];
         [self.tableView.mj_header endRefreshing];
         if ([responseObject[@"data"] count] == 0) {
              [self.tableView.mj_footer endRefreshingWithNoMoreData];
         }else{
              [self.tableView.mj_footer endRefreshing];
         }
         [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self.dataArr removeAllObjects];
         [self.tableView reloadData];
        NSLog(@"直供商品列表shibai :%@", error);
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

- (void)requestShareList {
     NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     [manager GET:[NSString stringWithFormat:@"%@/api/v1/life/sharedList?count=10&cursor=%d",LSKurl,coure] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"分享商品列表:%@", responseObject);
          if (coure == 0) {
               [self.dataArr removeAllObjects];
              
          }
          for (NSDictionary *dic in responseObject[@"data"][@"list"]) {
               LYTPurchaseModel *model = [[LYTPurchaseModel alloc]initWithDictionary:dic];
               
               [self.dataArr addObject:model];
          }
          [self.tableView.mj_header endRefreshing];
          if ([responseObject[@"data"][@"list"] count] == 0) {
               [self.tableView.mj_footer endRefreshingWithNoMoreData];
          }else{
               [self.tableView.mj_footer endRefreshing];
          }
          [self.tableView reloadData];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"分享商品列表shibai :%@", error);
          [self.dataArr removeAllObjects];
          [self.tableView reloadData];
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

- (void)requestPurchaseApply {
     int hefa = 0;
     NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
     for (LYTPurchaseModel *model in _dataArr) {
          if ([model.didSelect isEqualToString:@"1"]) {
               NSString *string = [NSString stringWithFormat:@"%@-%ld",model.goodId,model.shopCount];
               if (model.shopCount <= 0) {
                    hefa = 1;
                    Alert_Show(@"您所勾选的商品数量不合法,请修改后提交")
               }else{
                    [arr addObject:string];
               }
          }
     }
     if (hefa == 0) {
          NSString *arrStr = [NSString stringWithFormat:@"%@",[arr componentsJoinedByString:@","]];
          NSLog(@"什么效果----%@",arrStr);
          
          
          NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
          NSLog(@"按钮点击效果-------%@",[NSString stringWithFormat:@"%@/api/v1/life/purchase/apply?type=1&goods=%@",LSKurl,arrStr]);
          AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
          manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
          manager.requestSerializer = [AFJSONRequestSerializer serializer];
          manager.responseSerializer = [AFJSONResponseSerializer serializer];
          [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
          [manager POST:[NSString stringWithFormat:@"%@/api/v1/life/purchase/apply?type=1&goods=%@",LSKurl,arrStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSLog(@"支付按钮请求:%@", responseObject);
               if ([responseObject[@"code"] intValue] == 0) {
                    Alert_Show(@"采购订单已提交");
               }else if ([responseObject[@"code"] intValue] == 734){
                    Alert_Show(@"您未注册商家或者状态异常");
               }else if ([responseObject[@"code"] intValue] == 1010){
                    Alert_Show(@"订单状态错误");
               }else if ([responseObject[@"code"] intValue] == 732){
                    Alert_Show(@"您有采购订单正在审批中");
               }else if ([responseObject[@"code"] intValue] == 735){
                    Alert_Show(@"直供商品不存在");
               }else if ([responseObject[@"code"] intValue] == 758){
                    Alert_Show(@"直供商品状态异常");
               }else if ([responseObject[@"code"] intValue] == 1008){
                    Alert_Show(@"本商品不是直供商品");
               }else if ([responseObject[@"code"] intValue] == 1015){
                    Alert_Show(@"直供商品库存不足");
               }else if ([responseObject[@"code"] intValue] == 300320){
                    Alert_Show(@"商家禁止从商家本店采购商品");
               }else if ([responseObject[@"code"] intValue] == 1009){
                    Alert_Show(@"超出每次采购限额");
               }else if ([responseObject[@"code"] intValue] == 1007){
                    Alert_Show(@"所选商品必须属于同一商家");
               }
               
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               NSLog(@"支付按钮请求shibai :%@", error);
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
     }else{
          
     }
     
}
@end
