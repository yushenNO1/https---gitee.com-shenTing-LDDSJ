//
//  WSSNameAuthenticationViewController.m
//  cccc
//
//  Created by 王松松 on 2017/1/14.
//  Copyright © 2017年 云盛科技. All rights reserved.
//


#import "WSSNameAuthenticationViewController.h"
#import "AFNetworking.h"
#import "UIColor+Addition.h"
#import "NetURL.h"
#define kScreenWidth        [[UIScreen mainScreen] bounds].size.width           //屏宽
#define kScreenHeight       [[UIScreen mainScreen] bounds].size.height          //屏高
#define kScreenWidth1       ([UIScreen mainScreen].bounds.size.width / 375)     //适配宽度
#define kScreenHeight1      ([UIScreen mainScreen].bounds.size.height / 667)    //适配高度
//#import "WSSRealNameHelpViewController.h"
@interface WSSNameAuthenticationViewController ()
@property (nonatomic, strong) NSString *strName;
@property (nonatomic, strong) NSString *card;
@property (nonatomic, strong) NSString *card1;
@end

@implementation WSSNameAuthenticationViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:33/255.0 green:35/255.0 blue:33/255.0 alpha:1];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"实名认证";
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height+64)];
    [self.view addSubview:view];
    
    view.backgroundColor = [UIColor backGray];

//    
//    UIBarButtonItem *barBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"-@3x"] style:UIBarButtonItemStylePlain target:self action:@selector(barBtnClick)];
//    self.navigationItem.rightBarButtonItem =barBtn;

    
    [self CreateUI];
}

//- (void)barBtnClick
//{
//    WSSRealNameHelpViewController *help =[[WSSRealNameHelpViewController alloc]init];
//    [self.navigationController pushViewController:help animated:YES];
//
//}

- (void)CreateUI
{

    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/1.8)];
    backView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *lab =[[UILabel alloc]initWithFrame:CGRectMake(40 * kScreenWidth1, 60 * kScreenHeight1, 100 * kScreenWidth1, 40 * kScreenHeight1)];
    lab.text =@"姓名";
    lab.font =[UIFont systemFontOfSize:16 * kScreenHeight1];
    [backView addSubview:lab];
    UITextField *tf =[[UITextField alloc]initWithFrame:CGRectMake(140 * kScreenWidth1, 60 * kScreenHeight1, 170 * kScreenWidth1, 40 * kScreenHeight1)];
    tf.placeholder =@"请输入真实姓名";
    tf.tag = 2;
    [tf addTarget:self action:@selector(tf:) forControlEvents:UIControlEventEditingChanged];
    tf.font =[UIFont systemFontOfSize:14 * kScreenHeight1];
    tf.adjustsFontSizeToFitWidth =YES;
    [backView addSubview:tf];
    UILabel *labLine =[[UILabel alloc]initWithFrame:CGRectMake(40 * kScreenWidth1, 100 * kScreenHeight1, 290 * kScreenWidth1, 1 * kScreenHeight1)];
    labLine.backgroundColor =[UIColor lightGrayColor];
    labLine.alpha =0.5;
    [backView addSubview:labLine];
    
    
    UILabel *lab1 =[[UILabel alloc]initWithFrame:CGRectMake(40 * kScreenWidth1, 110 * kScreenHeight1, 100 * kScreenWidth1, 40 * kScreenHeight1)];
    lab1.text =@"身份证号码";
    lab1.font =[UIFont systemFontOfSize:16 * kScreenHeight1];
    [backView addSubview:lab1];
    UITextField *tf1 =[[UITextField alloc]initWithFrame:CGRectMake(140 * kScreenWidth1, 110 * kScreenHeight1, 170 * kScreenWidth1, 40 * kScreenHeight1)];
    tf1.placeholder =@"请输入身份证";
    tf1.tag = 1100;
    [tf1 addTarget:self action:@selector(tf:) forControlEvents:UIControlEventEditingChanged];
    tf1.font =[UIFont systemFontOfSize:14 * kScreenHeight1];
    tf1.adjustsFontSizeToFitWidth =YES;//自适应文字大小
    [backView addSubview:tf1];
    UILabel *labLine1 =[[UILabel alloc]initWithFrame:CGRectMake(40 * kScreenWidth1, 150 * kScreenHeight1, 290 * kScreenWidth1, 1 * kScreenHeight1)];
    labLine1.backgroundColor =[UIColor lightGrayColor];
    labLine1.alpha =0.5;
    [backView addSubview:labLine1];

    
    UILabel *lab2 =[[UILabel alloc]initWithFrame:CGRectMake(40 * kScreenWidth1, 160 * kScreenHeight1, 100 * kScreenWidth1, 40 * kScreenHeight1)];
    lab2.text =@"确认号码";
    lab2.font =[UIFont systemFontOfSize:16 * kScreenHeight1];
    [backView addSubview:lab2];
    UITextField *tf2 =[[UITextField alloc]initWithFrame:CGRectMake(140 * kScreenWidth1, 160 * kScreenHeight1, 170 * kScreenWidth1, 40 * kScreenHeight1)];
    tf2.placeholder =@"请再次输入身份证";
    tf2.font =[UIFont systemFontOfSize:14 * kScreenHeight1];
    tf2.adjustsFontSizeToFitWidth =YES;
    [tf2 addTarget:self action:@selector(tf:) forControlEvents:UIControlEventEditingChanged];
    tf2.tag = 100;
    [backView addSubview:tf2];
    UILabel *labLine3 =[[UILabel alloc]initWithFrame:CGRectMake(40 * kScreenWidth1, 200 * kScreenHeight1, 290 * kScreenWidth1, 1 * kScreenHeight1)];
    labLine3.backgroundColor =[UIColor lightGrayColor];
    labLine3.alpha =0.5;
    [backView addSubview:labLine3];


    UILabel *labNote =[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 270 * kScreenWidth1) / 2, 200 * kScreenHeight1, 280 * kScreenWidth1, 50 * kScreenHeight1)];
    labNote.text =@"*根据国家按相关规定,提现转账等业务必须实名认证且不能修改,请务必填写正确.";
    labNote.numberOfLines =0;
    labNote.font =[UIFont systemFontOfSize:13 * kScreenHeight1];
    labNote.textColor =[UIColor redColor];
    [backView addSubview:labNote];

    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake((kScreenWidth - 100 * kScreenWidth1) / 2, 280 * kScreenHeight1, 100 * kScreenWidth1, 35 * kScreenHeight1);
    btn.backgroundColor =[UIColor redColor];
    btn.layer.masksToBounds =YES;
    btn.layer.cornerRadius =5 * kScreenHeight1;
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
- (void)tf:(UITextField *)textField{
    
    NSLog(@"asd--a-sd----*%@",textField.text);
    if (textField.tag == 1100){
        _card = textField.text;
    }
    else if (textField.tag == 2){
        _strName = textField.text;
    }
    else if (textField.tag == 100){
        _card1 = textField.text;
    }
    
}
- (void)btnClick
{
    if ([_card1 isEqualToString:_card]) {
        NSLog(@"确认...");
        [self request];
    }
    else{
        Alert_Show(@"两次身份证输入不同")
    }
}
#pragma mark --------------- 实名认证 ----------------
- (void)request{
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
   
    NSString *str1 = [_strName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"-----%@",[NSString stringWithFormat:@"%@/api/v1/user/realname/save?name=%@&identityCardNo=%@",LSKurl,str1,_card]);
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/user/realname/save?name=%@&identityCardNo=%@",LSKurl,str1,_card] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"实名认证----%@",responseObject);
        if ([responseObject[@"code"]integerValue] == 0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"实名认证成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            Alert_Show(responseObject[@"message"])
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
