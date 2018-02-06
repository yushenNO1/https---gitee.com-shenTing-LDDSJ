//
//  projectVC.m
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "projectVC.h"
#import "projectCell.h"
#import "projectModel.h"
#import "goodsViewController.h"

#import "UIImageView+WebCache.h"

#import "UIColor+Addition.h"
#import "AFNetworking.h"
#import "NetURL.h"
#import "LYTShareVC.h"
#import "LYTUpStraightGoods.h"
@interface projectVC ()
@property (nonatomic, strong) UIButton * allBtn;
@property (nonatomic, strong) UIButton * upBtn;
@property (nonatomic, strong) UIButton * downBtn;
@property (nonatomic, strong) UIButton * shutBtn;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, copy) NSString * str;
@property (nonatomic, copy) NSString * spreader;
@end

@implementation projectVC

-(void)viewWillAppear:(BOOL)animated
{
    _str = @"1";
    [self request];
     NSDictionary *infoMy = [[NSUserDefaults standardUserDefaults]objectForKey:@"infoMy"];
     //涉及到个人信息的判断
     self.spreader = [NSString stringWithFormat:@"%@", infoMy[@"userVo"][@"spreadCode"]];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品管理";
    self.view.backgroundColor = [UIColor backGray];
      [self configView];
    [self configNav];
   
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
    [self.tableView registerClass:[projectCell class] forCellReuseIdentifier:@"22"];
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
     NSDictionary *shopInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
     if ([[shopInfo[@"agent"] class] isEqual:[NSNull class]]) {
          //申请代理
           [self popVer1];
     }else if (shopInfo[@"agent"]==nil){
          //申请代理
           [self popVer1];
     }else{
          if ([shopInfo[@"agent"][@"status"]intValue] == 0) {
                [self popVer1];
          }else if ([shopInfo[@"agent"][@"status"]intValue] == 1){
               [self popVer];
          }else if ([shopInfo[@"agent"][@"status"]intValue] == 2){
               [self popVer1];
          }else if ([shopInfo[@"agent"][@"status"]intValue] == 3){
                [self popVer1];
          }else if ([shopInfo[@"agent"][@"status"]intValue] == 4){
                [self popVer1];
          }
     }
    
}

- (void) popVer1 {
     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择新增商品类型" preferredStyle:UIAlertControllerStyleActionSheet];
     UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"普通商品" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          goodsViewController * goodVC = [[goodsViewController alloc] init];
          goodVC.idString = nil;
          [self.navigationController pushViewController:goodVC animated:YES];
     }];
     UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
     }];
     [alert addAction:alertAction1];
     [alert addAction:alertAction2];
     [self presentViewController:alert animated:YES completion:nil];
}


- (void) popVer {
     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择新增商品类型" preferredStyle:UIAlertControllerStyleActionSheet];
     UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"直供商品" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          //上传直供
          LYTUpStraightGoods * goodVC = [[LYTUpStraightGoods alloc] init];
          goodVC.idString = nil;
          [self.navigationController pushViewController:goodVC animated:YES];
     }];
     UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"普通商品" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          goodsViewController * goodVC = [[goodsViewController alloc] init];
          goodVC.idString = nil;
          [self.navigationController pushViewController:goodVC animated:YES];
     }];
     UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
     }];
     [alert addAction:alertAction];
     [alert addAction:alertAction1];
     [alert addAction:alertAction2];
     [self presentViewController:alert animated:YES completion:nil];
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
    projectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"22" forIndexPath:indexPath];
    projectModel * model = _dataArray[indexPath.section];
     
     if ([model.goodsType intValue] == 2) {
          if ([[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"12"]) {
               cell.downBtn.backgroundColor = [UIColor lightGrayColor];
               cell.downBtn.userInteractionEnabled = NO;
               cell.upBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               [cell.upBtn setTitle:@"上线" forState:UIControlStateNormal];
               cell.upBtn.userInteractionEnabled = YES;
               cell.editBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.editBtn.userInteractionEnabled = YES;
               cell.deleBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.deleBtn.userInteractionEnabled = YES;
               
               
               cell.deleBtn.tag = model.idStr + 1;
               cell.shareBtn.hidden = YES;
          } else if ([[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"2"] || [[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"14"]) {
               cell.upBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.upBtn.userInteractionEnabled = YES;
               [cell.upBtn setTitle:@"下线" forState:UIControlStateNormal];
               cell.editBtn.backgroundColor = [UIColor lightGrayColor];
               cell.editBtn.userInteractionEnabled = NO;
               cell.deleBtn.backgroundColor = [UIColor lightGrayColor];
               cell.deleBtn.userInteractionEnabled = NO;
               cell.downBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.downBtn.userInteractionEnabled = YES;
               if ([model.isOwner intValue] == 0) {
                    cell.shareBtn.hidden = YES;
               }else{
                    //开启分享
                    if ([model.goodsType intValue] == 1) {
                         cell.shareBtn.hidden = YES;
                    }else{
                         cell.shareBtn.hidden = NO;
                         if ([model.isShared intValue] == 0) {
                              [cell.shareBtn setBackgroundImage:[UIImage imageNamed:@"大分享直供@1x"] forState:UIControlStateNormal];
                         }else{
                              [cell.shareBtn setBackgroundImage:[UIImage imageNamed:@"大取消直供@1x"] forState:UIControlStateNormal];
                         }
                    }
               }
               
               
               
               [cell.shareBtn addTarget:self action:@selector(handleShare:) forControlEvents:UIControlEventTouchUpInside];
          } else if ([[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"4"]) {
               cell.downBtn.backgroundColor = [UIColor lightGrayColor];
               cell.downBtn.userInteractionEnabled = NO;
               cell.deleBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.deleBtn.userInteractionEnabled = YES;
               cell.upBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.upBtn.userInteractionEnabled = YES;
               [cell.upBtn setTitle:@"上线" forState:UIControlStateNormal];
               cell.editBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.editBtn.userInteractionEnabled = YES;
               
               
               cell.shareBtn.hidden = YES;
               
          } else if ([[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"1"] || [[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"3"]) {
               cell.downBtn.backgroundColor = [UIColor lightGrayColor];
               cell.downBtn.userInteractionEnabled = NO;
               cell.deleBtn.backgroundColor = [UIColor lightGrayColor];
               cell.deleBtn.userInteractionEnabled = NO;
               cell.upBtn.backgroundColor = [UIColor lightGrayColor];
               cell.upBtn.userInteractionEnabled = NO;
               [cell.upBtn setTitle:@"审核中" forState:UIControlStateNormal];
               cell.editBtn.backgroundColor = [UIColor lightGrayColor];
               cell.editBtn.userInteractionEnabled = NO;
               cell.shareBtn.hidden = YES;
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

     } else {
          if ([[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"0"]) {
               cell.downBtn.backgroundColor = [UIColor lightGrayColor];
               cell.downBtn.userInteractionEnabled = NO;
               cell.upBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               [cell.upBtn setTitle:@"上线" forState:UIControlStateNormal];
               cell.upBtn.userInteractionEnabled = YES;
               cell.editBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.editBtn.userInteractionEnabled = YES;
               cell.deleBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.deleBtn.userInteractionEnabled = YES;
               
               
               cell.deleBtn.tag = model.idStr + 1;
               cell.shareBtn.hidden = YES;
          } else if ([[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"2"]) {
               cell.upBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.upBtn.userInteractionEnabled = YES;
               [cell.upBtn setTitle:@"下线" forState:UIControlStateNormal];
               cell.editBtn.backgroundColor = [UIColor lightGrayColor];
               cell.editBtn.userInteractionEnabled = NO;
               cell.deleBtn.backgroundColor = [UIColor lightGrayColor];
               cell.deleBtn.userInteractionEnabled = NO;
               cell.downBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.downBtn.userInteractionEnabled = YES;
               if ([model.isOwner intValue] == 0) {
                    cell.shareBtn.hidden = YES;
               }else{
                    //开启分享
                    if ([model.goodsType intValue] == 1) {
                         cell.shareBtn.hidden = YES;
                    }else{
                         cell.shareBtn.hidden = NO;
                         if ([model.isShared intValue] == 0) {
                              [cell.shareBtn setBackgroundImage:[UIImage imageNamed:@"大分享直供@1x"] forState:UIControlStateNormal];
                         }else{
                              [cell.shareBtn setBackgroundImage:[UIImage imageNamed:@"大取消直供@1x"] forState:UIControlStateNormal];
                         }
                    }
               }
               
               
               
               [cell.shareBtn addTarget:self action:@selector(handleShare:) forControlEvents:UIControlEventTouchUpInside];
          } else if ([[NSString stringWithFormat:@"%d", model.codeStr] isEqualToString:@"4"]) {
               cell.downBtn.backgroundColor = [UIColor lightGrayColor];
               cell.downBtn.userInteractionEnabled = NO;
               cell.deleBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.deleBtn.userInteractionEnabled = YES;
               cell.upBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.upBtn.userInteractionEnabled = YES;
               [cell.upBtn setTitle:@"上线" forState:UIControlStateNormal];
               cell.editBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
               cell.editBtn.userInteractionEnabled = YES;
               
               
               cell.shareBtn.hidden = YES;
               
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

     }
     
     
    cell.shareBtn.tag = indexPath.section;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",model.dateStr];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.nameStr];
    [cell.upBtn addTarget:self action:@selector(handleUp:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn addTarget:self action:@selector(handleEdit:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleBtn addTarget:self action:@selector(handleDel:) forControlEvents:UIControlEventTouchUpInside];
    [cell.downBtn addTarget:self action:@selector(handleDown:) forControlEvents:UIControlEventTouchUpInside];
    [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.imageStr]]];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
     cell.editBtn.tag = indexPath.section;
     cell.upBtn.tag = model.idStr ;
     cell.downBtn.tag = indexPath.section;
    return cell;
}

//分享操作
- (void) handleShare:(UIButton *)sender {
    //分享
     projectModel * model = _dataArray[sender.tag];
     NSLog(@"fenxiang -----%@",[NSString stringWithFormat:LSKurl1@"/App/Local/goods_info/id/%d/spreader/%@------%@", model.idStr, _spreader,model.goodsType]);
    
     
     if ([model.isShared intValue] == 0) {
          [self requestShareShop:1 AndGoodsId:model.idStr];
     }else{
          [self requestShareShop:0 AndGoodsId:model.idStr];
     }
}

//上线操作
- (void) handleUp:(UIButton *)sender{
    NSLog(@"上线操作");
     
     for (projectModel * model in _dataArray) {
          if (model.idStr == sender.tag) {
               if ([model.goodsType intValue] == 2) {
                    NSString * passStr = [NSString stringWithFormat:@"%ld", sender.tag ];
                    if ([sender.titleLabel.text isEqualToString:@"上线"]) {
                         [sender setTitle:@"审核中" forState:UIControlStateNormal];
                         [self requestUp:passStr];
                    }else if ([sender.titleLabel.text isEqualToString:@"下线"]){
                         [sender setTitle:@"审核中" forState:UIControlStateNormal];
                         [self requestDown:passStr];
                    } else {
                         Alert_Show(@"当前状态不可进行其他操作");
                    }
               } else {
                    NSString * passStr = [NSString stringWithFormat:@"%ld", sender.tag ];
                    if ([sender.titleLabel.text isEqualToString:@"上线"]) {
                         [sender setTitle:@"下线" forState:UIControlStateNormal];
                         [self requestUp:passStr];
                    } else {
                         [sender setTitle:@"上线" forState:UIControlStateNormal];
                         [self requestDown:passStr];
                    }
               }
          }
     }
     
     
    
}

//分享操作
- (void) handleDown:(UIButton *)sender{
     //分享
     projectModel * model = _dataArray[sender.tag];
     NSLog(@"fenxiang -----%@",[NSString stringWithFormat:LSKurl1@"/App/Local/goods_info/id/%d/spreader/%@------%@", model.idStr, _spreader,model.goodsType]);
    [LYTShareVC shareImage:[NSString stringWithFormat:@"%@",model.imageStr] Title:model.nameStr content:@"本地生活分享" AndUrl:[NSString stringWithFormat:LSKurl1@"/App/Local/goods_info/id/%d/spreader/%@", model.idStr, _spreader]];
}

//编辑操作
- (void) handleEdit:(UIButton *)sender{
    
    NSLog(@"编辑操作");
     
    
     projectModel * model = _dataArray[sender.tag];
     NSString * passStr = [NSString stringWithFormat:@"%ld------%@", sender.tag,model.goodsType];
     if ([model.goodsType intValue] == 1) {
          goodsViewController * goodVC = [[goodsViewController alloc] init];
          NSLog(@"idStr%@", passStr);
          goodVC.idString = [NSString stringWithFormat:@"%d",model.idStr];
          [self.navigationController pushViewController:goodVC animated:YES];
     }else{
          LYTUpStraightGoods * goodVC = [[LYTUpStraightGoods alloc] init];
          goodVC.idString = [NSString stringWithFormat:@"%d",model.idStr];
          goodVC.isOwner = [NSString stringWithFormat:@"%@",model.isOwner];
          [self.navigationController pushViewController:goodVC animated:YES];
     }
    
    
}

//删除操作
- (void) handleDel:(UIButton *)sender{
    NSLog(@"删除操作");
    NSString * passStr = [NSString stringWithFormat:@"%ld", sender.tag - 1];
    [self requestDele:passStr];
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
          NSLog(@"项目分享shibai%@", error);
     }];
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
    [manager GET:[NSString stringWithFormat: [NSString stringWithFormat:@"%@%@",LSKurl,projectManagement], passStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject[@"error_code"]);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            Alert_Show(@"操作成功")
            if ([_str isEqualToString:@"3"]) {
                
                [self request2];
            } else {
                [self request];
            }
        } else {
            Alert_Show(@"操作失败")
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
        NSLog(@"%@", responseObject[@"error_code"]);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            Alert_Show(@"操作成功")
            if ([_str isEqualToString:@"2"]) {
                
                [self request1];
            } else {
                [self request];
            }
        } else {
            Alert_Show(@"操作失败")
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
        NSLog(@"%@", responseObject[@"error_code"]);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            Alert_Show(@"操作成功")
            [self request];
        } else {
            Alert_Show(@"操作失败")
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
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,listQuery] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSArray * dataArr = responseObject[@"data"][@"list"];
            for (NSDictionary * tempDic in dataArr) {
                projectModel * wdm = [projectModel projectWithDictionary:tempDic];
                [self.dataArray addObject:wdm];
            }
            NSLog(@"参数错误%@", responseObject);

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
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,OnlineListItems] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSArray * dataArr = responseObject[@"data"][@"list"];
            for (NSDictionary * tempDic in dataArr) {
                projectModel * wdm = [projectModel projectWithDictionary:tempDic];
                [self.dataArray addObject:wdm];
            }
            NSLog(@"参数错误%@", responseObject);
            
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
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,offlineProjectList] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSArray * dataArr = responseObject[@"data"][@"list"];
            for (NSDictionary * tempDic in dataArr) {
                projectModel * wdm = [projectModel projectWithDictionary:tempDic];
                [self.dataArray addObject:wdm];
            }
            NSLog(@"参数错误%@", responseObject);
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

#pragma mark ------------------ 禁用项目列表 ----------------
- (void) request3 {
    [self.dataArray removeAllObjects];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,shutProject] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSArray * dataArr = responseObject[@"data"][@"list"];
            for (NSDictionary * tempDic in dataArr) {
                projectModel * wdm = [projectModel projectWithDictionary:tempDic];
                [self.dataArray addObject:wdm];
            }
            NSLog(@"参数错误%@", responseObject);
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
