//
//  OrderDetailVC.m
//  供应商
//
//  Created by 张敬文 on 2017/8/5.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "OrderDetailVC.h"
#import "AFNetworking.h"
#import "OrderDetailCell.h"
#import "ChooseSendVC.h"
#import "SendOverVC.h"
@interface OrderDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * arrayImage;
@property (nonatomic, strong) NSDictionary * dic;
@property (nonatomic, strong) NSString * orderStr;
@property (nonatomic, strong) NSString * orderCompany;
@end

@implementation OrderDetailVC
-(NSMutableArray *)arrayImage {
     if (!_arrayImage) {
          _arrayImage = [NSMutableArray arrayWithCapacity:1];
     }
     return _arrayImage;
}

-(void)viewWillAppear:(BOOL)animated{
     self.navigationController.navigationBar.translucent = NO;
     
     if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
          self.automaticallyAdjustsScrollViewInsets = NO;
     }
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
     _orderStr = @"";
     _orderCompany = @"";
     
     
    self.view.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    self.title = @"订单详情";
    [self request];
    // Do any additional setup after loading the view.
    [self setNavigationBarConfiguer];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reValue1:) name:@"sendGood" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifikation:) name:UIKeyboardWillChangeFrameNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
     UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
     
     [self.tableView addGestureRecognizer:myTap];
}

-(void)keyboardWillHide {
     self.tableView.frame = WDH_CGRectMake(0, 0, 375, 603);
}

- (void)scrollTap:(id)sender {
     [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.view endEditing:YES];
}

-(void)notifikation:(NSNotification *)sender
{
     CGRect rect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
     self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, rect.origin.y);
     NSLog(@"键盘大小------%@",sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
}

- (void)reValue1:(NSNotification * )notifi{
     if ([notifi.userInfo[@"label"] isEqualToString:@"无需物流"]) {
          _orderStr = @"";
          _orderCompany = @"无需物流";
     } else {
          _orderStr = notifi.userInfo[@"tf"];
          _orderCompany = notifi.userInfo[@"label"];
          UILabel * label = [self.view viewWithTag:568745];
          label.text = [NSString stringWithFormat:@"发货方式       %@", _orderCompany];
     }
}

-(void)viewWillDisappear:(BOOL)animated{
     self.navigationController.navigationBar.translucent = YES;
     
     if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
          self.automaticallyAdjustsScrollViewInsets = YES;
     }
}

- (void)setNavigationBarConfiguer {
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
         UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发货" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction)];
     
     //临时
//     self.navigationItem.rightBarButtonItem = rightBarButtonItem;
     
     if ([_type intValue] == 0) {
          self.navigationItem.rightBarButtonItem = rightBarButtonItem;
     } else if ([_type intValue] == 1) {
          
     } else {
     }
     
     UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
     self.navigationItem.leftBarButtonItem = item;

    
}

- (void) leftBarBtnClick {
     [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightBarButtonItemAction {
     NSString * URL = @"";
     if ([_orderCompany isEqualToString:@""]) {
          Alert_Show(@"请选择发货方式")
     } else if ([_orderCompany isEqualToString:@"无需物流"]) {
          URL = [NSString stringWithFormat:@"%@?orderId=%@&shippingName=%@", GYSOrderSend, _orderId, @"wuxuwuliu"];
     } else {
          URL = [NSString stringWithFormat:@"%@?orderId=%@&shippingName=%@&shippingCode=%@", GYSOrderSend, _orderId, _orderCompany, _orderStr];
     }
     
     NSString *Str =[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
     [manager POST:Str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"订单详情数据%@", responseObject);
          if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
               SendOverVC * zjwVC = [[SendOverVC alloc] init];
               [self.navigationController pushViewController:zjwVC animated:YES];
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


- (void)configView {
    self.tableView = [[UITableView alloc]initWithFrame:WDH_CGRectMake(0, 0, 375, 603) style:UITableViewStylePlain];
     _tableView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
     _tableView.delegate = self;
     _tableView.dataSource = self;
     _tableView.separatorStyle = NO;
     _tableView.rowHeight = 105* kScreenHeight1;
     [self.view addSubview:_tableView];
     [_tableView registerClass:[OrderDetailCell class] forCellReuseIdentifier:@"11"];
     
    UIView * scrollView = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 0, 375, 335)];
    scrollView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
     _tableView.tableHeaderView = scrollView;
     
     UIView * scrollView_1 = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 0, 375, 265)];
     scrollView_1.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
     _tableView.tableFooterView = scrollView_1;
    
    //头部状态
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(-1, 0, 377, 80)];
     if ([_type intValue] == 0) {
          titleLabel.text = @"订单状态: 待发货";
     } else if ([_type intValue] == 1) {
          titleLabel.text = @"订单状态: 已发货";
     } else {
          titleLabel.text = @"订单状态: 已完成";
     }
     
     UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"订单蓝红条"]];
     imageView.frame = WDH_CGRectMake(0, 80, 375, 5);
     [scrollView addSubview:imageView];
    
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = 1;
    titleLabel.layer.borderColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1].CGColor;
    titleLabel.layer.borderWidth = 1.0f;
    titleLabel.font = [UIFont systemFontOfSize:17* kScreenHeight1];
    titleLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
    [scrollView addSubview:titleLabel];
    
    //第一部分
    UILabel * titleLabel_1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(15, 85, 200, 50)];
    titleLabel_1.text = @"订单信息";
    titleLabel_1.font = [UIFont systemFontOfSize:15* kScreenHeight1];
    titleLabel_1.textColor = [UIColor colorWithRed:154 / 255.0 green:154 / 255.0 blue:154 / 255.0 alpha:1];
    [scrollView addSubview:titleLabel_1];
    
    
    NSArray * ary = @[@"订单号", @"下单时间", @"付款时间"];
     NSArray * ary1 = @[[NSString stringWithFormat:@"%@", _dic[@"orderNo"]], [NSString stringWithFormat:@"%@", _dic[@"createTime"]], [NSString stringWithFormat:@"%@", _dic[@"payTime"]]];
    for (int i = 0; i < 4; i++) {
        if (i == 3) {
            UILabel * lineLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 135 + 50 * i, 375, 1)];
            lineLabel.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
            [scrollView addSubview:lineLabel];
        } else {
            UILabel * lineLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 135 + 50 * i, 375, 1)];
            lineLabel.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
            [scrollView addSubview:lineLabel];
            
            UILabel * backLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 136 + 50 * i, 375, 49)];
            backLabel.backgroundColor = [UIColor whiteColor];
            [scrollView addSubview:backLabel];
            
            UILabel * leftLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(15, 136 + 50 * i, 100, 49)];
            leftLabel.text = ary[i];
            leftLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
            leftLabel.font = [UIFont systemFontOfSize:15* kScreenHeight1];
            [scrollView addSubview:leftLabel];
             
             UILabel * rightLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(130, 136 + 50 * i, 220, 49)];
             rightLabel.text = ary1[i];
             rightLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
             rightLabel.font = [UIFont systemFontOfSize:15* kScreenHeight1];
             [scrollView addSubview:rightLabel];
        }
    }
    
    //第二部分
    UILabel * titleLabel_2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(15, 286, 200, 49)];
    titleLabel_2.text = @"商品信息";
    titleLabel_2.font = [UIFont systemFontOfSize:15* kScreenHeight1];
    titleLabel_2.textColor = [UIColor colorWithRed:154 / 255.0 green:154 / 255.0 blue:154 / 255.0 alpha:1];
    [scrollView addSubview:titleLabel_2];
    
    //第三部分
    UILabel * titleLabel_3 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(15, 0, 200, 50)];
    titleLabel_3.text = @"买家信息";
    titleLabel_3.font = [UIFont systemFontOfSize:15* kScreenHeight1];
    titleLabel_3.textColor = [UIColor colorWithRed:154 / 255.0 green:154 / 255.0 blue:154 / 255.0 alpha:1];
    [scrollView_1 addSubview:titleLabel_3];
    
    NSArray * ary2 = @[@"姓名", @"电话", @"地址"];
    NSArray * ary3 = @[[NSString stringWithFormat:@"%@", _dic[@"consignee"]], [NSString stringWithFormat:@"%@", _dic[@"mobile"]], [NSString stringWithFormat:@"%@", _dic[@"address"]]];
    for (int i = 0; i < 4; i++) {
        if (i == 3) {
            UILabel * lineLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 50 + 50 * i, 375, 1)];
            lineLabel.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
            [scrollView_1 addSubview:lineLabel];
        } else {
             
            UILabel * lineLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 50 + 50 * i, 375, 1)];
            lineLabel.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
            [scrollView_1 addSubview:lineLabel];
            
            UILabel * backLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 51 + 50 * i, 375, 49)];
            backLabel.backgroundColor = [UIColor whiteColor];
            [scrollView_1 addSubview:backLabel];
            
            UILabel * leftLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(15, 51 + 50 * i, 100, 49)];
            leftLabel.text = ary2[i];
            leftLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
            leftLabel.font = [UIFont systemFontOfSize:15* kScreenHeight1];
            [scrollView_1 addSubview:leftLabel];
             
             UILabel * rightLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(130, 51 + 50 * i, 220, 49)];
             rightLabel.text = ary3[i];
             rightLabel.numberOfLines = 0;
             rightLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
             if (i == 2) {
                  rightLabel.font = [UIFont systemFontOfSize:12* kScreenHeight1];
             } else {
                  rightLabel.font = [UIFont systemFontOfSize:15* kScreenHeight1];
             }
             
             [scrollView_1 addSubview:rightLabel];
        }
        
    }
    
    //第四部分
    UIView * View = [[UIView alloc] initWithFrame:WDH_CGRectMake(-1, 205, 377, 50)];
    View.layer.borderColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1].CGColor;
    View.layer.borderWidth = 1.0f;
    View.backgroundColor = [UIColor whiteColor];
    [scrollView_1 addSubview:View];
    
    UILabel * titleLabel_4 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(15, 0, 350, 50)];
     titleLabel_4.tag = 568745;
    titleLabel_4.text = @"发货方式";
     
    titleLabel_4.font = [UIFont systemFontOfSize:15* kScreenHeight1];
    titleLabel_4.textColor = [UIColor colorWithRed:154 / 255.0 green:154 / 255.0 blue:154 / 255.0 alpha:1];
    [View addSubview:titleLabel_4];
    
    UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
    Btn.frame = WDH_CGRectMake(0, 205, 375, 50);
    Btn.backgroundColor = [UIColor clearColor];
     if ([_type intValue] == 0) {
          UIImageView * rightImage = [[UIImageView alloc] initWithFrame:WDH_CGRectMake(350, 220, 8, 20)];
          rightImage.image = [UIImage imageNamed:@"添加商品分类"];
          [scrollView_1 addSubview: rightImage];
          [Btn addTarget:self action:@selector(handleChoose) forControlEvents:UIControlEventTouchUpInside];
//          titleLabel.text = @"订单状态: 待发货";
          
     } else if ([_type intValue] == 1) {
          titleLabel_4.text = [NSString stringWithFormat:@"发货方式       %@", _dic[@"shippingName"]];
//          titleLabel.text = @"订单状态: 已发货";
//          [Btn addTarget:self action:@selector(handleChoose) forControlEvents:UIControlEventTouchUpInside];
          
     } else {
          titleLabel_4.text = [NSString stringWithFormat:@"发货方式       %@", _dic[@"shippingName"]];
//          titleLabel.text = @"订单状态: 已完成";
//          [Btn addTarget:self action:@selector(handleChoose) forControlEvents:UIControlEventTouchUpInside];
          
     }
    
    [scrollView_1 addSubview:Btn];
}

- (void) handleChoose
{
    //选择发货方式
    NSLog(@"发货方式");
     ChooseSendVC * VC = [[ChooseSendVC alloc] init];
     [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     NSArray * ary = _dic[@"millOrderGoodsVoList"];
     return ary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     OrderDetailCell * zjwCell = [tableView dequeueReusableCellWithIdentifier:@"11" forIndexPath:indexPath];
     NSArray * ary = _dic[@"millOrderGoodsVoList"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) request {
     [_arrayImage removeAllObjects];
     NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
     [manager GET:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:GYSOrderDetail, _orderId]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"订单详情数据%@", responseObject);
          if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
               self.dic = responseObject[@"data"];
               [self configView];
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
