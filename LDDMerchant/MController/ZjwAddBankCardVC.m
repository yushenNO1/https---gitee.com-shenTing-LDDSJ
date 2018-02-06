//
//  ZjwAddBankCardVC.m
//  LSK
//
//  Created by 张敬文 on 2017/1/17.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "ZjwAddBankCardVC.h"
#import "UIColor+Addition.h"
#import "ZjwAddBankCell.h"
#import "ZjwBankCardModel.h"
#import "NetURL.h"
#import "AFNetworking.h"
@interface ZjwAddBankCardVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel * banklabel;
@property (nonatomic, strong) UIView * pickerVC;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray *bankCardName;
@property (nonatomic, strong) NSArray *bankCardImage;
@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation ZjwAddBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    _bankCardName = @[@"支付宝", @"中国银行", @"工商银行", @"建设银行", @"交通银行", @"农业银行", @"招商银行"];
    _bankCardImage = @[@"zhifu_ico@3x", @"china_ico@3x", @"gongshang_ico@3x", @"jianshe_ico@3x", @"jiaotong_ico@3x", @"longye_ico@3x", @"zhaoshang_ico@3x"];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor backGray];
    [self configView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
     UITextField * tf = [self.view viewWithTag:10010];
     [tf resignFirstResponder];
}

- (void)configView {
    for (int i = 0; i < 3; i++) {
        UILabel * backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 74 + 55 * i, kScreenWidth, 50 )];
        backLabel.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backLabel];
    }

    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 74, 60, 50)];
    nameLabel.text = @"户名:";
    
    UILabel * bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 184, 60, 50)];
    bankLabel.text = @"卡号:";
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 139, 30, 30)];
    _imageView.image = [UIImage imageNamed:@""];
    [self.view addSubview:_imageView];
    
    UILabel * nameLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 74, 200, 50)];
    nameLab.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
    UITextField * backTf = [[UITextField alloc] initWithFrame:CGRectMake(80, 187, 275, 50)];
    backTf.borderStyle = UITextBorderStyleNone;
    backTf.tag = 10010;
    backTf.placeholder = @"收款人储蓄卡号, 支付宝号, 微信号";
    [backTf setValue:[UIFont systemFontOfSize:13]   forKeyPath:@"_placeholderLabel.font"];
    
    [self.view addSubview:nameLabel];
    [self.view addSubview:bankLabel];
    [self.view addSubview:nameLab];
    [self.view addSubview:backTf];
    
    UILabel * egLabel = [[UILabel alloc] initWithFrame:CGRectMake(20* kScreenWidth1, 254* kScreenHeight1, 375 -30, 50* kScreenHeight1)];
    egLabel.numberOfLines = 0;
    egLabel.textColor = [UIColor colorWithRed:232 / 255.0 green:78 / 255.0 blue:64 / 255.0 alpha:1.0];
    egLabel.text = @"* 如果持卡人非实名注册用户本人, 或者银行卡信息不符, 提现申请将被驳回";
    egLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:egLabel];
    
    self.banklabel = [[UILabel alloc] initWithFrame:CGRectMake((375-200*kScreenWidth1)/2, 134, 200*kScreenWidth1, 35)];
    _banklabel.text = @"(请选择开户银行)";
    _banklabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
    _banklabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_banklabel];
    
    UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
    Btn.frame = CGRectMake(0, 129* kScreenHeight1, 375* kScreenWidth1, 50* kScreenHeight1);
    [Btn addTarget:self action:@selector(receiveRed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake((375-200*kScreenWidth1) / 2 , 400 * kScreenHeight1, 200*kScreenWidth1, 44* kScreenHeight1);
    btn.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:46 / 255.0 blue:51 / 255.0 alpha:1.0];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
}

- (void)handleAction {
    //添加银行卡
    [self request];
}

- (void) request {
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
     
     if([_banklabel.text isEqualToString:@"(请选择开户银行)"])//_roaldSearchText
     {
          Alert_Show(@"请选择开户行")
     }
     else
     {
          NSString *str = [_banklabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          NSString *str2 = [[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
          UITextField * tf = [self.view viewWithTag:10010];
          NSString *str1 = [tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          NSString *str3 = @"0";
          if ([_banklabel.text isEqualToString:@"支付宝"]) {
               str3 = @"1";
          } else if ([_banklabel.text isEqualToString:@"微信"]) {
               str3 = @"2";
          }
          if (str.length == 0 || str1.length == 0) {
               Alert_Show(@"银行卡信息填写不完整");
          } else {
               NSString * Url = [NSString stringWithFormat:addBankCard, str, str1, str2, str3];
               [manager POST:Url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"++++%@", responseObject);
                    if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
                         Alert_show_pushRoot(@"添加成功");
                    } else{
                         
                         Alert_Show(responseObject[@"message"]);
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

     }
     
        
    
}

- (void) receiveRed {
    //奖金领取
    _pickerVC = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375 * kScreenWidth1, 667 * kScreenHeight1)];
    _pickerVC.backgroundColor = [UIColor blackColor];
    _pickerVC.alpha = 0.5;
    _pickerVC.userInteractionEnabled = YES;
    [self.view  addSubview:_pickerVC];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewAction)];
    [_pickerVC addGestureRecognizer:tap];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(115 / 2 * kScreenWidth1, 80 * kScreenHeight1, 260 * kScreenWidth1, 320 * kScreenHeight1) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 101;
    _tableView.rowHeight = 40 * kScreenHeight1;
    _tableView.layer.cornerRadius = 5 * kScreenWidth1;
    _tableView.layer.masksToBounds = YES;
    _tableView.scrollEnabled = NO;
    UIView * bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260 * kScreenWidth1, 40 * kScreenHeight1)];
    bView.backgroundColor = [UIColor colorWithRed:37 / 255.0 green:40 / 255.0 blue:37 / 255.0 alpha:1];
    UILabel * cLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260 * kScreenWidth1, 40 * kScreenHeight1)];
    cLabel.text = @"点击选择开户行";
    cLabel.textAlignment = NSTextAlignmentCenter;
    cLabel.textColor = [UIColor whiteColor];
    cLabel.font = [UIFont systemFontOfSize:17];
    [bView addSubview:cLabel];
    UIButton * aBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    aBtn.frame = CGRectMake(220 * kScreenWidth1, 10 * kScreenHeight1, 20 * kScreenWidth1, 20 * kScreenHeight1);
    [aBtn setBackgroundImage:[UIImage imageNamed:@"X_write@3x"] forState:UIControlStateNormal];
    [aBtn addTarget:self action:@selector(pickerViewAction) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:aBtn];
    _tableView.tableHeaderView = bView;
    [_tableView registerClass:[ZjwAddBankCell class] forCellReuseIdentifier:@"add"];
    [self.view addSubview:_tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bankCardName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZjwAddBankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"add" forIndexPath:indexPath];
    cell.MidLabel.text = _bankCardName[indexPath.row];
    cell.LeftImageView.image = [UIImage imageNamed:_bankCardImage[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZjwAddBankCell  * cell = [tableView cellForRowAtIndexPath:indexPath];
    _banklabel.text = cell.MidLabel.text;
    _imageView.image = cell.LeftImageView.image;
    [self pickerViewAction];
}

- (void) pickerViewAction {
    [[self.view viewWithTag:101] removeFromSuperview];
    [_pickerVC removeFromSuperview];
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
