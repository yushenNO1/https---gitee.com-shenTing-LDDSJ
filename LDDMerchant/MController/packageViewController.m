//
//  packageViewController.m
//  goods
//
//  Created by 王松松 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "GoodsTableViewCell.h"
#import "goodsViewController.h"
#import "packageViewController.h"
#import "PackModel.h"
#import "newViewController.h"
#import "AFNetworking.h"
#import "NetURL.h"
@interface packageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * dataArray1;
@property (nonatomic, assign) NSInteger code;
@end

@implementation packageViewController
-(void)viewWillAppear:(BOOL)animated {
     _code = 0;
    [self request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"套餐条目";
    UIBarButtonItem *barBtn =[[UIBarButtonItem alloc]initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnClick)];
    self.navigationItem.rightBarButtonItem =barBtn;
    [self tableView];
    [self dataArray1];
}

- (NSMutableArray *)dataArray1 {
    if (!_dataArray1) {
        self.dataArray1 = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray1;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

- (void)tableView
{
    UITableView *tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource =self;
    tableView.delegate =self;
    tableView.separatorStyle =NO;
    tableView.tag = 1000;
    [tableView registerClass:[GoodsTableViewCell class] forCellReuseIdentifier:@"cells"];
    
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30 * kScreenHeight1)];
//    view.backgroundColor =[UIColor whiteColor];
    
    
    
    UILabel *leLabel = [[UILabel alloc] init];
    leLabel.frame = CGRectMake(40 * kScreenWidth1, 0 * kScreenHeight1, 50 * kScreenWidth1, 30 * kScreenHeight1);
    leLabel.text =@"名称";
    leLabel.textAlignment = 0;
    [view addSubview:leLabel];
    
    UILabel *ceLabel = [[UILabel alloc] init];
    ceLabel.frame = CGRectMake(160 * kScreenWidth1, 0 * kScreenHeight1, 50 * kScreenWidth1, 30 * kScreenHeight1);
    ceLabel.text =@"单价";
    ceLabel.textAlignment = 0;
    [view addSubview:ceLabel];
    
    UILabel *reLabel = [[UILabel alloc] init];
    reLabel.frame = CGRectMake(270 * kScreenWidth1, 0 * kScreenHeight1, 50 * kScreenWidth1, 30 * kScreenHeight1);
    reLabel.text =@"份数";
    reLabel.textAlignment = 0;
    [view addSubview:reLabel];

    tableView.tableHeaderView = view;
    [self.view addSubview:tableView];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsTableViewCell *cellView =[tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    PackModel * model = _dataArray[indexPath.section];
    cellView.leftLabel.text =model.nameStr;
    cellView.centerLabel.text =[NSString stringWithFormat:@"%.2f", model.priceStr];
    [cellView.clearBtn1 addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([_dataArray1[indexPath.section] isEqualToString:@"1"]){
        [cellView.leftImgBut setBackgroundImage:[UIImage imageNamed:@"yuan@3x"] forState:UIControlStateNormal];
    }else{
        [cellView.leftImgBut setBackgroundImage:[UIImage imageNamed:@"quan@3x"] forState:UIControlStateNormal];
    }
    cellView.clearBtn1.tag = indexPath.section;
    cellView.num_tf.tag = 10000 + indexPath.section;
    [cellView.deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cellView.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cellView.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    return cellView;
}

- (void)addBtnClicked:(UIButton *)sender{
    GoodsTableViewCell * cellView = (GoodsTableViewCell *)sender.superview;
    PackModel * model = _dataArray[cellView.num_tf.tag - 10000];
    int a = [cellView.num_tf.text intValue];
    if (a > 8) {
        //        _addBtn.userInteractionEnabled = NO;
    } else {
        a++;
    }
    model.count = a;
    cellView.num_tf.text = [NSString stringWithFormat:@"%d", a];
}

- (void)deleteBtnClicked:(UIButton *)sender{
    GoodsTableViewCell * cellView = (GoodsTableViewCell *)sender.superview;
    PackModel * model = _dataArray[cellView.num_tf.tag - 10000];
    int a = [cellView.num_tf.text intValue];
    if (a <= 1) {
        //        _deleteBtn.userInteractionEnabled = NO;
    } else {
        a--;
    }
    model.count = a;
    cellView.num_tf.text = [NSString stringWithFormat:@"%d", a];
}

- (void)handleAction:(UIButton *)sender
{
    if ([_dataArray1[sender.tag] isEqualToString:@"1"])
    {
        GoodsTableViewCell *cell =(GoodsTableViewCell *)sender.superview;
        [cell.leftImgBut setBackgroundImage:[UIImage imageNamed:@"quan@3x"] forState:UIControlStateNormal];
        [_dataArray1 removeObjectAtIndex:sender.tag];
        [_dataArray1 insertObject:@"2" atIndex:sender.tag];
    }else{
        GoodsTableViewCell *cell =(GoodsTableViewCell *)sender.superview;
        [cell.leftImgBut setBackgroundImage:[UIImage imageNamed:@"yuan@3x"] forState:UIControlStateNormal];
        [_dataArray1 removeObjectAtIndex:sender.tag];
        [_dataArray1 insertObject:@"1" atIndex:sender.tag];
    }
    
    UITableView *table = [self.view viewWithTag:1000];
    [table reloadData];
//    if (sender.tag >= 5000) {
//        sender.tag = sender.tag - 5000;
//        GoodsTableViewCell *cell =(GoodsTableViewCell *)sender.superview;
//        [cell.leftImgBut setBackgroundImage:[UIImage imageNamed:@"yuan@3x"] forState:UIControlStateNormal];
//        for (int i = 0; i < _dataArray1.count; i++) {
//            if ([_dataArray1[i] isEqualToString:[NSString stringWithFormat:@"%ld", sender.tag]]) {
//                [_dataArray1 removeObjectAtIndex:i];
//            }
//        }
//    } else {
//        sender.tag = sender.tag + 5000;
    //        GoodsTableViewCell *cell =(GoodsTableViewCell *)sender.superview;
    //        [cell.leftImgBut setBackgroundImage:[UIImage imageNamed:@"quan@3x"] forState:UIControlStateNormal];
    //        NSString * str = [NSString stringWithFormat:@"%ld", (sender.tag - 5000)];
    //        [_dataArray1 addObject:str];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
     if (_code == 0) {
          _str = @"";
          for (int i = 0; i < _dataArray1.count; i++) {
               if ([_dataArray1[i] intValue] == 2) {
                    PackModel * model = _dataArray[i];
                    if (!model.count) {
                         model.count = 1;
                    }
                    _str = [NSString stringWithFormat:@"%@%d-%d,", _str, model.idStr, model.count];
                    NSLog(@"储存信息:%@", _str);
               }
          }
          NSInteger b = _str.length - 1;
          if (_str.length != 0) {
               NSString * str1 = [_str substringToIndex:b];
               NSDictionary* dic =@{ @"jiequ":str1};
               [[NSNotificationCenter defaultCenter] postNotificationName:@"packagePass" object:nil userInfo:dic];
               goodsViewController * goods = [[goodsViewController alloc] init];
               [self.navigationController popToViewController:goods animated:YES];
          } else {
               NSDictionary* dic =@{ @"jiequ":_str};
               [[NSNotificationCenter defaultCenter] postNotificationName:@"packagePass" object:nil userInfo:dic];
               goodsViewController * goods = [[goodsViewController alloc] init];
               [self.navigationController popToViewController:goods animated:YES];
          }
     }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     _code = 1;
     PackModel * model = _dataArray[indexPath.section];
     newViewController *newVC =[[newViewController alloc]init];
     newVC.idStr = [NSString stringWithFormat:@"%d", model.idStr];
     newVC.nameStr = model.nameStr;
     newVC.priceStr = [NSString stringWithFormat:@"%.2f", model.priceStr];
     [self.navigationController pushViewController:newVC animated:YES];
}

-(void)barBtnClick
{
     _code = 1;
    //新增套餐
    newViewController *newVC =[[newViewController alloc]init];
    newVC.idStr = nil;
    [self.navigationController pushViewController:newVC animated:YES];
}
#pragma mark ------------------ 请求 >>> 套餐条目 ----------------
- (void)request {
    [_dataArray removeAllObjects];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,setEntry] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"data"];
            for (NSDictionary *dic2 in arr) {
                PackModel *orderContentModel = [[PackModel alloc]initWithFrameWithDic:dic2];
                [self.dataArray addObject:orderContentModel];
                [self.dataArray1 addObject:@"1"];
            }
            [[self.view viewWithTag:1000] reloadData];
        } else {
            Alert_Show(@"暂无可选套餐")
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
