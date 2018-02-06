//
//  categoryViewController.m
//  goods
//
//  Created by 王松松 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//
#import "AFNetworking.h"
#import "NetURL.h"
#import "CategoryModel.h"
#import "CategoryTableViewCell.h"
#import "categoryViewController.h"
#import "UIColor+Addition.h"
@interface categoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong) NSMutableArray *parIdArr;
@property (nonatomic, strong) NSMutableArray *childrenArr;
@end

@implementation categoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backGray];
    // Do any additional setup after loading the view.
    self.title =@"品类选择";
    [self tableView];
    [self request];
}

//懒加载数组
-(NSMutableArray *)childrenArr {
    if (!_childrenArr) {
        self.childrenArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _childrenArr;
}

//懒加载数组
-(NSMutableArray *)categoryArr {
    if (!_categoryArr) {
        self.categoryArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _categoryArr;
}

//懒加载数组
-(NSMutableArray *)parIdArr {
    if (!_parIdArr) {
        self.parIdArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _parIdArr;
}

- (void)tableView
{
    UITableView *tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource =self;
    tableView.delegate =self;
    tableView.separatorStyle = NO;
    tableView.tag = 101;
    [tableView registerClass:[CategoryTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _categoryArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryTableViewCell *cellView=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cellView.label.text =_categoryArr [indexPath.section];
    cellView.accessoryType =UITableViewCellAccessoryDisclosureIndicator;

    return cellView;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * ary = _childrenArr[indexPath.section];
    if (ary.count == 0) {
        NSString * str = _categoryArr[indexPath.section];
        NSString * str1 = [NSString stringWithFormat:@"%@", _parIdArr[indexPath.section]];
        NSDictionary* dic =@{@"value":str, @"cateId":str1};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ValuePass" object:nil userInfo:dic];
        [self.navigationController popViewControllerAnimated:YES];
  
    } else {
        [self.categoryArr removeAllObjects];
        [self.parIdArr removeAllObjects];
        [self.childrenArr removeAllObjects];
        for (NSDictionary * dic in ary) {
            [self.categoryArr addObject:dic[@"name"]];
            [self.parIdArr addObject:dic[@"cateId"]];
            [self.childrenArr addObject:dic[@"children"]];
            UITableView * tableView = [self.view viewWithTag:101];
            [tableView reloadData];
        }
    }
}

#pragma mark
#pragma mark ------------------ 请求 >>> 分类查询 ----------------
- (void)request {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
     NSLog(@"asdasd品类-----%@",[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:classification,_typeId]]);
    [manager GET: [NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:classification,_typeId]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"pinlei品类----%@",responseObject);
        for (NSDictionary * dic in responseObject[@"data"]) {
            [self.categoryArr addObject:dic[@"name"]];
            [self.parIdArr addObject:dic[@"cateId"]];
            [self.childrenArr addObject:dic[@"children"]];
        }
        UITableView * tableView = [self.view viewWithTag:101];
        [tableView reloadData];
        
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
