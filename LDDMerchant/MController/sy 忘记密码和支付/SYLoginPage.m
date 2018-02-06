//
//  SYLoginPage.m
//  MainPage
//
//  Created by 云盛科技 on 2017/1/12.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "SYLoginPage.h"
#import "SYForgetPswVC.h"
#import "AFNetworking.h"
#import "NetURL.h"
#import "MerchantsVC.h"
#import "LYTFMDB.h"

@interface LoginTextView : UIView
@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,strong)UITextField *textFiled;


@property(nonatomic,strong)UILabel *line;
@end
@implementation LoginTextView

-(instancetype)initWithFrame:(CGRect)frame{
     self = [super initWithFrame:frame];
     if (self) {
          [self addSubview:self.imgView];
          [self addSubview:self.textFiled];

          [self addSubview:self.line];
     }
     return self;
}
-(UIImageView *)imgView{
     if (!_imgView) {
          _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 32, 36)];
     }
     return _imgView;
}
-(UITextField *)textFiled{
     if (!_textFiled) {
          _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(60, 15, 200, 25)];
     }
     return _textFiled;
}

-(UILabel *)line{
     if (!_line) {
          _line = [[UILabel alloc]initWithFrame:CGRectMake(60, 44, 200, 1)];
          _line.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
     }
     return _line;
}
@end

@interface SYLoginPage ()
@property (nonatomic, strong) UITextField *moboleText;
@property (nonatomic, strong) UITextField *passwordText;
/** 登录按钮 */
@property (nonatomic, strong) UIButton *startLogin;
@property (nonatomic, copy) NSString * code;
@end

@implementation SYLoginPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.title = @"商家登陆";
    
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor colorWithRed:37 / 255.0 green:40 / 255.0 blue:37 / 255.0 alpha:1], NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:56 / 255.0 blue:84 / 255.0 alpha:1.0];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:253 / 255.0 green:56 / 255.0 blue:84 / 255.0 alpha:1.0];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self loginConfig];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationKey:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


#pragma mark ------------------ 请求 >>> 个人信息 ----------------
- (void)loadMyInfo1 {
    NSLog(@"zoumeizou---%@", [NSString stringWithFormat:@"%@%@",LSKurl, Info]);
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     NSLog(@"touken-------%@",str);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,Info] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"个人信息:%@", responseObject);
        if ([responseObject[@"code"] intValue]== 0){
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"] forKey:@"infoMy"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JGLOgin" object:nil];
            //涉及到个人信息的判断
            NSDictionary * dic = responseObject[@"data"];
            
            if ([[NSString stringWithFormat:@"%@", dic[@"shopStatus"]] isEqualToString:@"1"]) {
                UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
                MerchantsVC * zjwVC = [[MerchantsVC alloc] init];
                UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:zjwVC];
                window.rootViewController = naVC;
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
                 [[LYTFMDB sharedDataBase]deleAllSeachText];
                 
                Alert_Show(@"暂无权限!")
            }
            
            
            
        } else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error---%@",error);
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

//用token访问商家
-(void)visitToShopWithTouken:(NSString *)token{
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     NSLog(@"访问商家---%@",[NSString stringWithFormat:LSKurl@"/api/v1/life/supplier/info"]);
     [manager GET:[NSString stringWithFormat:LSKurl@"/api/v1/life/supplier/info"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"用token访问商家-----%@",responseObject);
          if ([responseObject[@"code"] integerValue] == 0) {
               UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
               MerchantsVC * zjwVC = [[MerchantsVC alloc] init];
               UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:zjwVC];
               window.rootViewController = naVC;
          }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"用token访问商家shibai-----%@",error);
     }];
}

- (void)popView{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)dissMissBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)loginConfig{
//
//     if (_type == 1) {
//          UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//          btn.frame = CGRectMake(self.view.bounds.size.width-60*kScreenWidth1, 30*kScreenHeight1, 50*kScreenWidth1, 25*kScreenHeight1);
//          [btn setTitle:@"取消" forState:UIControlStateNormal];
//          [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//          [self.view addSubview:btn];
//          [btn addTarget:self action:@selector(dissMissBtnClick) forControlEvents:UIControlEventTouchUpInside];
//     }
//
//
//     UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(225 / 2*kScreenWidth1, 105*kScreenHeight1, 150*kScreenWidth1, 80*kScreenHeight1)];
//     imageView.image = [UIImage imageNamed:@"buess_ico_loading@3x"];
//     [self.view addSubview:imageView];
//
//     //手机号的白色背景
//     UIView *mobileView = [[UIView alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 250*kScreenHeight1, kScreenWidth-100*kScreenWidth1, 45*kScreenHeight1)];
//     mobileView.backgroundColor = [UIColor whiteColor];
//     mobileView.layer.cornerRadius = 5;
//     [self.view addSubview:mobileView];
//
//     UILabel *mobile = [[UILabel alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 10*kScreenHeight1, 60*kScreenWidth1, 25*kScreenHeight1)];
//     mobile.text = @"手机号";
//     mobile.font = [UIFont systemFontOfSize:16*kScreenHeight1];
//     mobile.textAlignment = NSTextAlignmentCenter;
//     [mobileView addSubview:mobile];
//
//     UIImageView *grayImg = [[UIImageView alloc]initWithFrame:CGRectMake(80*kScreenWidth1, 10*kScreenHeight1, 1*kScreenWidth1, 25*kScreenHeight1)];
//     grayImg.image = [UIImage imageNamed:@"loading_line"];
//     [mobileView addSubview:grayImg];
//
//     UITextField *moboleText = [[UITextField alloc]initWithFrame:CGRectMake(100*kScreenWidth1, 10*kScreenHeight1, 150*kScreenWidth1, 25*kScreenHeight1)];
//     _moboleText = moboleText;
//     moboleText.keyboardType = UIKeyboardTypeNumberPad;
//     moboleText.placeholder = @"请输入手机号";
//     moboleText.font = [UIFont systemFontOfSize:15*kScreenHeight1];
//     [moboleText addTarget:self action:@selector(moboletfClick:) forControlEvents:UIControlEventEditingDidEnd];
//     [mobileView addSubview:moboleText];
//
//     //密码的白色背景
//     UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 310*kScreenHeight1, kScreenWidth-100*kScreenWidth1, 45*kScreenHeight1)];
//     passwordView.backgroundColor = [UIColor whiteColor];
//     passwordView.layer.cornerRadius = 5;
//     [self.view addSubview:passwordView];
//
//     UILabel *password = [[UILabel alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 10*kScreenHeight1, 60*kScreenWidth1, 25*kScreenHeight1)];
//     password.text = @"密码";
//     password.font = [UIFont systemFontOfSize:16*kScreenHeight1];
//     password.textAlignment = NSTextAlignmentCenter;
//     [passwordView addSubview:password];
//
//     UIImageView *grayImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(80*kScreenWidth1, 10*kScreenHeight1, 1*kScreenWidth1, 25*kScreenHeight1)];
//     grayImg2.image = [UIImage imageNamed:@"loading_line"];
//     [passwordView addSubview:grayImg2];
//
//     UITextField *passwordText = [[UITextField alloc]initWithFrame:CGRectMake(100*kScreenWidth1, 10*kScreenHeight1, 150*kScreenWidth1, 25*kScreenHeight1)];
//     _passwordText = passwordText;
//     passwordText.secureTextEntry = YES;
//     passwordText.placeholder = @"请输入登录密码";
//     [passwordText addTarget:self action:@selector(passwordtfClick) forControlEvents:UIControlEventEditingChanged];
//     passwordText.font = [UIFont systemFontOfSize:15*kScreenHeight1];
//     [passwordView addSubview:passwordText];
//
//     //忘记密码和快捷注册
//     UIButton *forgetPsw = [UIButton buttonWithType:UIButtonTypeCustom];
//     forgetPsw.frame = CGRectMake(225*kScreenWidth1, 370*kScreenHeight1, 100*kScreenWidth1, 30*kScreenHeight1);
//     [forgetPsw setTitle:@"忘记密码" forState: UIControlStateNormal];
//     [forgetPsw setImage:[UIImage imageNamed:@"loading_problem"] forState:UIControlStateNormal];
//     forgetPsw.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//     [forgetPsw setTitleEdgeInsets:UIEdgeInsetsMake( 0, -forgetPsw.imageView.frame.size.width-10*kScreenWidth1, 0,forgetPsw.imageView.frame.size.width)];
//     [forgetPsw setImageEdgeInsets:UIEdgeInsetsMake(0.0,forgetPsw.titleLabel.bounds.size.width,0,-forgetPsw.titleLabel.bounds.size.width-10*kScreenWidth1 )];
//     [forgetPsw setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//     forgetPsw.titleLabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
//     [forgetPsw addTarget:self action:@selector(forgetPswBtn) forControlEvents:UIControlEventTouchUpInside];
//     UIImageView * imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_-@3x"]];
//     imageView1.frame = CGRectMake(305*kScreenWidth1, 378*kScreenHeight1, 14*kScreenWidth1, 14*kScreenHeight1);
//     [self.view addSubview:imageView1];
//     [self.view addSubview:forgetPsw];
//
//
//
//     UIButton *startLogin = [UIButton buttonWithType:UIButtonTypeSystem];
//     self.startLogin = startLogin;
//     startLogin.frame = CGRectMake(50*kScreenWidth1,450*kScreenHeight1, kScreenWidth-100*kScreenWidth1, 45*kScreenHeight1);
//     [startLogin setTitle:@"登录" forState: UIControlStateNormal];
//     startLogin.titleLabel.font = [UIFont systemFontOfSize:17];
//     [startLogin setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
//     startLogin.layer.cornerRadius = 5;
//     //    startLogin.enabled = NO;
//     //    startLogin.backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0   blue:195/255.0 alpha:1];//灰色
//     self.startLogin.backgroundColor = [UIColor colorWithRed:222/255.0 green:28/255.0 blue:30/255.0 alpha:1];//红色
//     self.startLogin.enabled = YES;
//     [startLogin addTarget:self action:@selector(startLoginBtn) forControlEvents:UIControlEventTouchUpInside];
//     [self.view addSubview:startLogin];
//
//     UIButton *copyright = [UIButton buttonWithType:UIButtonTypeCustom];
//     copyright.frame = CGRectMake(140*kScreenWidth1,510*kScreenHeight1, 100*kScreenWidth1, 20*kScreenHeight1);
//     [copyright setTitle:@"同意量多多协议" forState: UIControlStateNormal];
//     [copyright setTitleColor:[UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1] forState:UIControlStateNormal];
//     copyright.titleLabel.font = [UIFont systemFontOfSize:13*kScreenHeight1];
//     [self.view addSubview:copyright];
//}

- (void)loginConfig{
     
     if (_type == 1) {
          UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
          btn.frame = CGRectMake(self.view.bounds.size.width-60*kScreenWidth1, 30*kScreenHeight1, 50*kScreenWidth1, 25*kScreenHeight1);
          [btn setTitle:@"取消" forState:UIControlStateNormal];
          [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          [self.view addSubview:btn];
          [btn addTarget:self action:@selector(dissMissBtnClick) forControlEvents:UIControlEventTouchUpInside];
     }
     
     
     UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
     imageView.image = [UIImage imageNamed:@"商家版登录背景"];
     [self.view addSubview:imageView];
     
     
     UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(138*kScreenWidth1, 91*kScreenHeight1, 98, 240)];
     imgView.image = [UIImage imageNamed:@"量多多商家版"];
     [self.view addSubview:imgView];
     
     
     LoginTextView *view1 = [[LoginTextView alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 400*kScreenHeight1, kScreenWidth - 100, 50)];
     view1.textFiled.placeholder = @"请输入用户名/手机号";
     _moboleText = view1.textFiled;
     view1.imgView.image = [UIImage imageNamed:@"用户名"];
     [self.view addSubview:view1];
     
     LoginTextView *view2 = [[LoginTextView alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 400*kScreenHeight1 + 70, kScreenWidth - 100, 50)];
     view2.textFiled.placeholder = @"请输入用户名/手机号";
     view2.textFiled.secureTextEntry = YES;
     _passwordText = view2.textFiled;
     view2.imgView.image = [UIImage imageNamed:@"密码"];
     [self.view addSubview:view2];
     
     
     
//     //手机号的白色背景
//     UIView *mobileView = [[UIView alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 250*kScreenHeight1, kScreenWidth-100*kScreenWidth1, 45*kScreenHeight1)];
//     mobileView.backgroundColor = [UIColor whiteColor];
//     mobileView.layer.cornerRadius = 5;
//     [self.view addSubview:mobileView];
//
//     UILabel *mobile = [[UILabel alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 10*kScreenHeight1, 60*kScreenWidth1, 25*kScreenHeight1)];
//     mobile.text = @"手机号";
//     mobile.font = [UIFont systemFontOfSize:16*kScreenHeight1];
//     mobile.textAlignment = NSTextAlignmentCenter;
//     [mobileView addSubview:mobile];
//
//     UIImageView *grayImg = [[UIImageView alloc]initWithFrame:CGRectMake(80*kScreenWidth1, 10*kScreenHeight1, 1*kScreenWidth1, 25*kScreenHeight1)];
//     grayImg.image = [UIImage imageNamed:@"loading_line"];
//     [mobileView addSubview:grayImg];
//
//     UITextField *moboleText = [[UITextField alloc]initWithFrame:CGRectMake(100*kScreenWidth1, 10*kScreenHeight1, 150*kScreenWidth1, 25*kScreenHeight1)];
//     _moboleText = moboleText;
//     moboleText.keyboardType = UIKeyboardTypeNumberPad;
//     moboleText.placeholder = @"请输入手机号";
//     moboleText.font = [UIFont systemFontOfSize:15*kScreenHeight1];
//     [moboleText addTarget:self action:@selector(moboletfClick:) forControlEvents:UIControlEventEditingDidEnd];
//     [mobileView addSubview:moboleText];
//
//     //密码的白色背景
//     UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 310*kScreenHeight1, kScreenWidth-100*kScreenWidth1, 45*kScreenHeight1)];
//     passwordView.backgroundColor = [UIColor whiteColor];
//     passwordView.layer.cornerRadius = 5;
//     [self.view addSubview:passwordView];
//
//     UILabel *password = [[UILabel alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 10*kScreenHeight1, 60*kScreenWidth1, 25*kScreenHeight1)];
//     password.text = @"密码";
//     password.font = [UIFont systemFontOfSize:16*kScreenHeight1];
//     password.textAlignment = NSTextAlignmentCenter;
//     [passwordView addSubview:password];
//
//     UIImageView *grayImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(80*kScreenWidth1, 10*kScreenHeight1, 1*kScreenWidth1, 25*kScreenHeight1)];
//     grayImg2.image = [UIImage imageNamed:@"loading_line"];
//     [passwordView addSubview:grayImg2];
//
//     UITextField *passwordText = [[UITextField alloc]initWithFrame:CGRectMake(100*kScreenWidth1, 10*kScreenHeight1, 150*kScreenWidth1, 25*kScreenHeight1)];
//     _passwordText = passwordText;
//     passwordText.secureTextEntry = YES;
//     passwordText.placeholder = @"请输入登录密码";
//     [passwordText addTarget:self action:@selector(passwordtfClick) forControlEvents:UIControlEventEditingChanged];
//     passwordText.font = [UIFont systemFontOfSize:15*kScreenHeight1];
//     [passwordView addSubview:passwordText];
//
//     //忘记密码和快捷注册
//     UIButton *forgetPsw = [UIButton buttonWithType:UIButtonTypeCustom];
//     forgetPsw.frame = CGRectMake(225*kScreenWidth1, 370*kScreenHeight1, 100*kScreenWidth1, 30*kScreenHeight1);
//     [forgetPsw setTitle:@"忘记密码" forState: UIControlStateNormal];
//     [forgetPsw setImage:[UIImage imageNamed:@"loading_problem"] forState:UIControlStateNormal];
//     forgetPsw.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//     [forgetPsw setTitleEdgeInsets:UIEdgeInsetsMake( 0, -forgetPsw.imageView.frame.size.width-10*kScreenWidth1, 0,forgetPsw.imageView.frame.size.width)];
//     [forgetPsw setImageEdgeInsets:UIEdgeInsetsMake(0.0,forgetPsw.titleLabel.bounds.size.width,0,-forgetPsw.titleLabel.bounds.size.width-10*kScreenWidth1 )];
//     [forgetPsw setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//     forgetPsw.titleLabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
//     [forgetPsw addTarget:self action:@selector(forgetPswBtn) forControlEvents:UIControlEventTouchUpInside];
//     UIImageView * imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_-@3x"]];
//     imageView1.frame = CGRectMake(305*kScreenWidth1, 378*kScreenHeight1, 14*kScreenWidth1, 14*kScreenHeight1);
//     [self.view addSubview:imageView1];
//     [self.view addSubview:forgetPsw];
     
     
     
     UIButton *startLogin = [UIButton buttonWithType:UIButtonTypeSystem];
     self.startLogin = startLogin;
     startLogin.frame = CGRectMake(127 *kScreenWidth1,535*kScreenHeight1,121.5,33);;
     [startLogin setTitle:@"登录" forState: UIControlStateNormal];
     startLogin.titleLabel.font = [UIFont systemFontOfSize:17];
     [startLogin setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
     startLogin.layer.cornerRadius = 5;
     //    startLogin.enabled = NO;
     //    startLogin.backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0   blue:195/255.0 alpha:1];//灰色
     self.startLogin.backgroundColor = [UIColor colorWithRed:213/255.0 green:114/255.0 blue:113/255.0 alpha:1]; //红色
     self.startLogin.enabled = YES;
     [startLogin addTarget:self action:@selector(startLoginBtn) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:startLogin];
     
//     UIButton *copyright = [UIButton buttonWithType:UIButtonTypeCustom];
//     copyright.frame = CGRectMake(140*kScreenWidth1,510*kScreenHeight1, 100*kScreenWidth1, 20*kScreenHeight1);
//     [copyright setTitle:@"同意量多多协议" forState: UIControlStateNormal];
//     [copyright setTitleColor:[UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1] forState:UIControlStateNormal];
//     copyright.titleLabel.font = [UIFont systemFontOfSize:13*kScreenHeight1];
//     [self.view addSubview:copyright];
}

-(void)notificationKey:(NSNotification *)noti{
    NSLog(@"notinoti--%@",noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
    CGRect rect = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -(kScreenHeight - rect.origin.y)/2, kScreenWidth, kScreenHeight);
    }];
    
}
- (void)moboletfClick:(UITextField *)sender{
    [self isMobile:sender.text];
}
- (void)passwordtfClick{
    if (self.passwordText.text.length == 0) {
      
    }else if(self.passwordText.text.length >= 6){
        self.startLogin.backgroundColor = [UIColor colorWithRed:222/255.0 green:28/255.0 blue:30/255.0 alpha:1];

//        self.startLogin.enabled = NO;
    }
}
//忘记密码按钮
- (void)forgetPswBtn{
    if (_type == 1) {
        SYForgetPswVC *vc = [[SYForgetPswVC alloc]init];
        vc.type = _type;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        SYForgetPswVC *vc = [[SYForgetPswVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//登录按钮
- (void)startLoginBtn{
    if (self.moboleText.text.length == 0){
        Alert_Show(@"请输入您的手机号码");
    } else if (self.passwordText.text.length == 0){
        Alert_Show(@"请输入您的登录密码");
    } else{
        [self LoginRequest];
    }
}
#pragma mark
#pragma mark ------------ 登录请求
- (void)LoginRequest{
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     [manager.requestSerializer setValue:@"Basic bW9iaWxlOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
     
     [manager POST:[NSString stringWithFormat:loginUrl,self.moboleText.text,self.passwordText.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"登录请求%@",responseObject);
          
          NSString *tokenStr = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
          NSLog(@"tokentoken%@",tokenStr);
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
          [[LYTFMDB sharedDataBase]deleAllSeachText];
          
          
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
          if (responseObject[@"access_token"] != nil) {
               [[NSUserDefaults standardUserDefaults]setObject:tokenStr  forKey:@"token"];
               [[NSUserDefaults standardUserDefaults]setObject:self.moboleText.text forKey:@"LoginID"];
               [[NSUserDefaults standardUserDefaults]setObject:self.passwordText.text forKey:@"PwdID"];
               
               if (_type == 1) {
                    [self dismissViewControllerAnimated:YES completion:nil];
               }else{
                    [self visitToShopWithTouken:responseObject[@"access_token"]];
               }
          }else{
               NSString *errorStr = [ErrorCode initWithErrorCode:[NSString stringWithFormat:@"%@", responseObject[@"code"]]];
               Alert_Show(errorStr)
          }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if ([error code] == -1009) {
               NSString *errorStr = [IsLogin requestErrorCode:[error code]];
               Alert_Show(errorStr)
          } else if ([error code] == -1001) {
               Alert_Show(@"请求超时")
          } else {
               if([[error localizedDescription] rangeOfString:@"("].location !=NSNotFound){
                    NSArray *arr = [[error localizedDescription] componentsSeparatedByString:@"("];
                    NSArray *arr1 = [arr[1] componentsSeparatedByString:@")"];
                    if ([arr1[0] integerValue] == 500) {
                         Alert_Show(@"服务器忙,请稍后再试")
                    }else if ([arr1[0] integerValue] == 400){
                         Alert_Show(@"您的账号密码输入有误")
                    }
               }else{
                    Alert_Show(@"登录失败")
               }
          }
          NSLog(@"登录请求失败%@",error);
          
     }];
}


//验证手机号
- (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[-0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if ([mobileNumbel length] == 0){
        Alert_Show(@"电话号码为空,请输入您的电话号码");
        return NO;
    }else if (([regextestmobile evaluateWithObject:mobileNumbel]
               || [regextestcm evaluateWithObject:mobileNumbel]
               || [regextestct evaluateWithObject:mobileNumbel]
               || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }else{
        _moboleText.text = nil;
        Alert_Show(@"请输入正确的手机号!");
        return NO;
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
