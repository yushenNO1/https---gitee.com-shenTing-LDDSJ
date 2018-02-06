//
//  MerchantTVC.m
//  YSApp
//
//  Created by 张敬文 on 2017/1/3.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "MerchantTVC.h"
#import "WithdrawView1.h"

#import "WithdrawVC.h"
#import "DCPaymentView.h"
#import "UIColor+Addition.h"
#import "AFNetworking.h"
#import "PaymentsViewController.h"
#import "NetURL.h"
#import "ShowCardModel.h"
#import "ZjwBankCardVC.h"
#import "ZjwBankCardModel.h"
#import "ZjwAddBankCardVC.h"
#import "SYModifyPasswordVC.h"
#import "SYVerificationMobileController.h"
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width / 375)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height / 667)
@interface MerchantTVC ()
{
    UILabel *l ;
}
@property (nonatomic,retain) UITableView *withDrawTable;
@property (nonatomic,retain) NSDictionary *cardDic;
@property (nonatomic,retain) NSArray *arr;
@property (nonatomic,retain) UIImage *headerImage;
@property (nonatomic,retain) UIImageView *headerImg;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *tail;
@property (nonatomic,retain) UILabel *typeLabel;
@property (nonatomic,copy) NSString *cardId;
@property (nonatomic,copy) NSString *limitMoney;
@property (nonatomic,copy) NSString *limitCount;
@property (nonatomic,copy) NSString *titleLab;
@property (nonatomic,copy) NSString *tailLabel;
@property (nonatomic,copy) NSString *typeLab;
@property (nonatomic,copy) NSString *keyongAmount;
@property (nonatomic,copy) NSString *dongjieAmount;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,retain) NSMutableArray *bankModelArr;
@property (nonatomic, copy) NSString *ZDStr;
//提现银行卡信息

@property (nonatomic, copy) NSString *cardType;
@property (nonatomic, copy) NSString *cardNo;
@property (nonatomic, copy) NSString *bank;
@end

@implementation MerchantTVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家提现";
    self.view.backgroundColor = [UIColor backGray];
    [self configNav];
    [self configView];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveValue:) name:@"Draw" object:nil];
    
}



- (NSMutableArray *)bankModelArr {//懒加载初始化数组
    if (!_bankModelArr) {
        self.bankModelArr = [NSMutableArray array];
    }
    return _bankModelArr;
}
-(void)configNav{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(barBtn333333Click:)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)receiveValue:(NSNotification *)sender {
    ZjwBankCardModel * model = sender.userInfo[@"withDraw"];
    
//    NSArray * bankCardName = @[@"支付宝", @"微信", @"中国银行", @"工商银行", @"建设银行", @"交通银行", @"农业银行", @"招商银行"];
//    NSArray * bankCardImage = @[@"zhifu_ico@3x", @"weixin_ico@3x", @"china_ico@3x", @"gongshang_ico@3x", @"jianshe_ico@3x", @"jiaotong_ico@3x", @"longye_ico@3x", @"zhaoshang_ico@3x"];
    
    NSArray * bankCardName = @[@"建设银行", @"中国银行", @"农业银行", @"工商银行", @"招商银行", @"交通银行", @"中国邮政", @"中原银行", @"民生银行", @"光大银行", @"兴业银行"];
    NSArray * bankCardImage = @[@"jian_pay_ico", @"china_pay_ico", @"long_pay_ico", @"buess_pay_ico", @"zhao_pay_ico", @"jiao_pay_ico", @"youzheng_bank", @"zhongyuan_bank", @"minsheng_bank", @"guangda_bank", @"xingye_bank"];
    
    int i = 0;
    for (NSString * str in bankCardName) {
        if ([model.bank isEqualToString:str]) {
            break;
        } else {
            i++;
        }
    }
    
     UIButton * Btn = [self.view viewWithTag:123321];
     [Btn setTitle:@"" forState:UIControlStateNormal];
    
    _headerImg.image = [UIImage imageNamed:bankCardImage[i]];
    _titleLabel.text = model.name;
    _typeLabel.text = model.bank;
    _tail.text = model.cardNo;
    _cardId = model.cardId;
}

#pragma mark
#pragma mark --------------- 提现界面的 UI ----------
-(void)configView{
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(0, 64 , self.view.bounds.size.width, 70 * kScreenHeight)];
    view5.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view5];
    _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(110*kScreenWidth1, 5, 250*kScreenWidth1, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _headerImg =[[UIImageView alloc]initWithFrame:CGRectMake(35, 10, 35*kScreenWidth1, 35)];
    _typeLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 50, 85*kScreenWidth1, 10)];
    _typeLabel.font =[UIFont systemFontOfSize:12];
    _typeLabel.textColor =[UIColor lightGrayColor];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _tail =[[UILabel alloc]initWithFrame:CGRectMake(110, 35, 250*kScreenWidth1, 30)];
    UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(0, 69, 375*kScreenWidth1, 1)];
    label.backgroundColor = [UIColor backGray];
    
    [view5 addSubview:_headerImg];
    [view5 addSubview:_titleLabel];
    [view5 addSubview:_tail];
    [view5 addSubview:_typeLabel];
    [view5 addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0 * kScreenHeight, self.view.bounds.size.width, 70 * kScreenHeight);
    btn.tag = 123321;
    [btn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"请点击此处选择提现银行卡" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view5 addSubview:btn];
    
    WithdrawView1 *view1 = [[WithdrawView1 alloc]initWithFrame:CGRectMake(0, 145 , self.view.bounds.size.width, 60 * kScreenHeight)];
    view1.titleLabel.text = @"可提资金";
    view1.tag = 111;
    view1.contentLabel.textColor = [UIColor redColor];
    view1.backgroundColor = [UIColor whiteColor];
    view1.contentLabel.text = [NSString stringWithFormat:@"%.2f", [_fundCount doubleValue]];
    
    [self.view addSubview:view1];

    
    WithdrawView1 *view3 = [[WithdrawView1 alloc]initWithFrame:CGRectMake(0, 215 , self.view.bounds.size.width, 60 * kScreenHeight)];
    view3.titleLabel.text = @"资        金";
    view3.tag = 333;
    view3.backgroundColor = [UIColor whiteColor];
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(115 * kScreenWidth, 15 * kScreenHeight, 200 * kScreenWidth, 30 * kScreenHeight)];
//    text.borderStyle = UITextBorderStyleRoundedRect;
    text.keyboardType = UIKeyboardTypeDecimalPad;
    text.placeholder = @"提现资金";
    text.tag = 10000;
    [view3 addSubview:text];
    [self.view addSubview:view3];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20 *kScreenWidth, 290 * kScreenHeight, 300* kScreenWidth, 20* kScreenHeight)];
    lable.text = @"注:商家提现无手续费";
     lable.textColor=[UIColor redColor];
    lable.font = [UIFont systemFontOfSize:13* kScreenHeight];
    [self.view addSubview:lable];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake((self.view.bounds.size.width-250)/2, 340 * kScreenHeight, 250, 44);
    [btn1 setBackgroundColor:[UIColor colorWithRed:241 / 255.0 green:73 / 255.0 blue:97 / 255.0 alpha:1]];
    [btn1 setTitle:@"确认提现" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    btn1.layer.cornerRadius = 5;
    btn1.layer.masksToBounds = YES;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    l = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-220)/2 * kScreenWidth, 390 * kScreenHeight, 220 * kScreenWidth, 20 * kScreenHeight)];
    l.font = [UIFont systemFontOfSize:12* kScreenHeight];
    l.textColor = [UIColor grayColor];
    [self.view addSubview:l];
}
#pragma mark
#pragma mark --------------- 各btn点击方法 ----------
-(void)barBtn333333Click:(UIBarButtonItem *)sender
{//结算明细界面
    WithdrawVC * wdVC = [[WithdrawVC alloc] init];
    [self.navigationController pushViewController:wdVC animated:YES];
}

- (void) requestlist {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:bankCardList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"qingqiu 银行卡列表%@", responseObject);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSArray * dataArr = responseObject[@"data"][@"list"];
            if (dataArr.count == 0) {
                UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"您尚未添加银行卡,请前往添加" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"前往" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {//跳往设置支付密码
                    ZjwAddBankCardVC * payVC = [[ZjwAddBankCardVC alloc] init];
                    [self.navigationController pushViewController:payVC animated:YES];
                }];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
                [alertVC addAction:okAction];
                [alertVC addAction:cancelAction];
                [self presentViewController:alertVC animated:YES completion:nil];
            } else {
                ZjwBankCardVC * zjwVC = [[ZjwBankCardVC alloc] init];
                [self.navigationController pushViewController:zjwVC animated:YES];
            }
        } else {
            //失败
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error-----%@",error);
        Alert_Show(@"网络忙请稍后")
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

-(void)chooseBtnClick:(UIButton *)sender{
    [self requestlist];
}

-(void)btnClick:(UIButton *)sender{
    UITextField *text = (UITextField *)[self.view viewWithTag:10000];
    if ([text.text doubleValue] >= 0.01){
        if (_tail.text.length > 0){
            if (text.text.length > 0){
                if ([_fundCount doubleValue] >= [text.text doubleValue]) {
                    DCPaymentView *payAlert = [[DCPaymentView alloc]init];
                    payAlert.title = @"请输入支付密码";
                    payAlert.detail = @"提现";
                    payAlert.amount= [text.text doubleValue];
                    [payAlert show];
                    payAlert.completeHandle = ^(NSString *inputPwd) {
                        self.password = inputPwd;
                        [self request1];
                    };
                    payAlert.dismissView = ^(int dissmiss){
                        NSLog(@"%d-----dissmiss",dissmiss);
                    };
                }else{
                    Alert_Show(@"可提现资金不足")
                }
            }else{
                Alert_Show(@"请输入提现金额")
            }
        }else{
            Alert_Show(@"请选择要提现银行")
        }
    }
    else{
        Alert_Show(@"提现金额必须大于0.01")
    }
}

-(NSArray *)cuttingString:(NSString *)string with:(NSString *)str{
    NSArray *array = [string componentsSeparatedByString:str];
    return  array;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark
#pragma mark --------------- 请求 >>> 提现 ----------
- (void) request1 {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    UITextField * tf = [self.view viewWithTag:10000];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:BusinisWithdrawUrl, _cardId, tf.text, _password]]);
    NSLog(@"token------%@", str);
    [manager POST:[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:BusinisWithdrawUrl, _cardId, tf.text, _password]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"1111---12-提现结果----%@", responseObject);
        
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            Alert_Show(@"提现成功")
            tf.text = nil;
            _fundCount = [NSString stringWithFormat:@"%.2f", [_fundCount doubleValue] - [tf.text doubleValue]];
            WithdrawView1 *view1 = [self.view viewWithTag:111];
            view1.contentLabel.text = _fundCount;
        } else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"716"]) {
            tf.text = nil;
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"您尚未设置支付密码, 请前往设置支付密码!" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {//跳往设置支付密码
                SYVerificationMobileController * payVC = [[SYVerificationMobileController alloc] init];
                payVC.discriminatePage = 6;
                [self.navigationController pushViewController:payVC animated:YES];
            }];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
            [alertVC addAction:cancelAction];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }else {
            tf.text = nil;
            NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            Alert_Show(str)
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        Alert_Show(@"提现失败")
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
#pragma mark ------------------ 请求 >>> 商家信息 ----------------
- (void)loadMyInfo {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,MyInfo] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"商家信息-----阿达-----%@",responseObject);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"null"withString:@"\"LYTChange\""];
        NSData *jsonData1 = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:jsonData1 options:NSJSONReadingMutableContainers error:&err];
        if ([responseObject[@"code"] intValue]== 0){
            WithdrawView1 *view1 = [self.view viewWithTag:111];
            view1.contentLabel.text =  [NSString stringWithFormat:@"%.2f", [responseObject[@"data"][@"fund"]doubleValue]];

            NSDictionary * dic = responseObject[@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"MyInfo"];
        } else {
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
