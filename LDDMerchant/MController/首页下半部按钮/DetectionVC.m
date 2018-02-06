//
//  DetectionVC.m
//  WDHMerchant
//
//  Created by 云盛科技 on 2017/ 5/17.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "DetectionVC.h"
#import "UIColor+Addition.h"
#import "NetURL.h"
#import "AFNetworking.h"

#import "UIImage+QRCode.h"
@interface DetectionVC ()
{
     UILabel * backLabel1;
     UIImageView *bagImg;
}
@property (nonatomic, strong) UIImageView *QRImgView;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, strong) UIImageView *QRImgView1;
@end

@implementation DetectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"检测点";
     self.view.backgroundColor = [UIColor backGray];
     
     
     
     
     
     [self configView];
}
-(void)configView
{
     bagImg = [[UIImageView alloc]init];
     bagImg.frame = CGRectMake(50 * kScreenWidth1, 160 * kScreenHeight1, self.view.bounds.size.width-100 * kScreenWidth1, 360 * kScreenHeight1);
     bagImg.backgroundColor = [UIColor whiteColor];
     bagImg.image = [UIImage imageNamed:@"扫码图IOS"];
     [self.view addSubview:bagImg];
     bagImg.layer.cornerRadius = 5;
     bagImg.layer.masksToBounds = YES;
     
     UIImageView *QRImgView = [[UIImageView alloc]init];
     QRImgView.frame = CGRectMake(65*kScreenWidth1, 140*kScreenHeight1, self.view.bounds.size.width-230*kScreenWidth1, self.view.bounds.size.width-230*kScreenWidth1);
     _QRImgView = QRImgView;
     QRImgView.backgroundColor = [UIColor whiteColor];
     [bagImg addSubview:QRImgView];
     
     
     backLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.width-80 * kScreenHeight1, self.view.bounds.size.width-100 * kScreenWidth1, 60 * kScreenHeight1)];
     backLabel1.font = [UIFont systemFontOfSize:18 * kScreenHeight1];
     backLabel1.textAlignment = NSTextAlignmentCenter;
     backLabel1.text = @"检测点收费";
     backLabel1.textColor = [UIColor whiteColor];
     [bagImg addSubview:backLabel1];
     NSString *QRCode = [[NSUserDefaults standardUserDefaults]objectForKey:@"DetectionVCQRCode"];
     if ([[QRCode class] isEqual:[NSNull class]]) {
          [self request];
     }else if (QRCode==nil){
          [self request];
     }else{
          self.QRImgView.image = [UIImage qrImageWithContent:QRCode logo:[UIImage imageNamed:@"组-1_90"] size:200 red:38 green:38 blue:38];
          UIImageView *QRImgView1 = [[UIImageView alloc]init];
          QRImgView1.frame = CGRectMake(50 * kScreenWidth1, 160 * kScreenHeight1, self.view.bounds.size.width-100 * kScreenWidth1, 360 * kScreenHeight1);
          QRImgView1.image = [self convertViewToImage:bagImg];
          self.QRImgView1 = QRImgView1;
          QRImgView1.userInteractionEnabled=YES;
          [self.view addSubview:QRImgView1];
          UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestures:)];
          [QRImgView1 addGestureRecognizer:longPressGestureRecognizer];
     }
     UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 530 * kScreenHeight1, kScreenWidth, 20 * kScreenHeight1)];
     l.font = [UIFont systemFontOfSize:12];
     l.textColor = [UIColor redColor];
     l.textAlignment =NSTextAlignmentCenter;
     l.text = @"注：长按保存到本地，打印、制台历、随您处置";
     [self.view addSubview:l];
     
}






- (void)request {
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     [manager GET:[NSString stringWithFormat:@"%@/api/v1/life/payCode/get?codeType=3",LSKurl] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"%@", responseObject);
          if ([responseObject[@"code"] intValue]== 0){
               //@"buess_ico_loading@3x"
               
               NSDictionary *myInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"infoMy"];
               NSDictionary *shopInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
               self.QRImgView.image = [UIImage qrImageWithContent:[NSString stringWithFormat:@"%@/index.php?m=Mobile&c=User&a=reg&spreader=%@&$Code#%@",LSKurl1, myInfo[@"userVo"][@"spreadCode"], responseObject[@"data"]] logo:[UIImage imageNamed:@"组-1_90"] size:200 red:38 green:38 blue:38];
               [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@/index.php?m=Mobile&c=User&a=reg&spreader=%@&$Code#%@",LSKurl1, myInfo[@"userVo"][@"spreadCode"], responseObject[@"data"]] forKey:@"DetectionVCQRCode"];
               self.shopName = shopInfo[@"shopName"];
               
               UIImageView *QRImgView1 = [[UIImageView alloc]init];
               QRImgView1.frame = CGRectMake(50 * kScreenWidth1, 160 * kScreenHeight1, self.view.bounds.size.width-100 * kScreenWidth1, 360 * kScreenHeight1);
               QRImgView1.image = [self convertViewToImage:bagImg];
               self.QRImgView1 = QRImgView1;
               QRImgView1.userInteractionEnabled=YES;
               [self.view addSubview:QRImgView1];
               UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestures:)];
               [QRImgView1 addGestureRecognizer:longPressGestureRecognizer];
//               [self loadMyInfo];
          } else if([responseObject[@"code"] intValue]== 930){
               Alert_show_pushRoot(@"仪器申请状态异常,请提交申请")
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

//#pragma mark ------------------ 请求 >>> 商家信息 ----------------
//- (void)loadMyInfo {
//     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//     manager.requestSerializer = [AFJSONRequestSerializer serializer];
//     manager.responseSerializer = [AFJSONResponseSerializer serializer];
//     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
//     [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,MyInfo] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//          if ([responseObject[@"code"] intValue]== 0){
//               
//          } else {
//               
//          }
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//          if ([error code] == -1009) {
//               NSString *errorStr = [IsLogin requestErrorCode:[error code]];
//               Alert_Show(errorStr)
//          }else if ([error code] == -1001) {
//               Alert_Show(@"请求超时")
//          }else{
//               if([[error localizedDescription] rangeOfString:@"("].location !=NSNotFound){
//                    NSArray *arr = [[error localizedDescription] componentsSeparatedByString:@"("];
//                    NSArray *arr1 = [arr[1] componentsSeparatedByString:@")"];
//                    if ([arr1[0] integerValue] == 500) {
//                         Alert_Show(@"服务器忙,请稍后再试")
//                    }else if ([arr1[0] integerValue] == 401){
//                         
//                         if ([IsLogin LoginRequest] == 0) {
//                              
//                              UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
//                              SYLoginPage * zjwVC = [[SYLoginPage alloc] init];
//                              UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:zjwVC];
//                              window.rootViewController = naVC;
//                         }else{
//                              [self loadMyInfo];
//                         }
//                    }
//               }
//          }
//     }];
//}

#pragma mark
- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)gesture{
     
     NSLog(@"121212");
     if(gesture.state==UIGestureRecognizerStateBegan){
          UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
          
          UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
               NSLog(@"取消保存图片");
          }];
          UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
               NSLog(@"确认保存图片");
               // 保存图片到相册
               UIImageWriteToSavedPhotosAlbum(self.QRImgView1.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
               
          }];
          [alertControl addAction:cancel];
          [alertControl addAction:confirm];
          [self presentViewController:alertControl animated:YES completion:nil];
     }
}

#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo{
     NSString*message =@"呵呵";
     if(!error) {
          message =@"成功保存到相册";
          UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
          }];
          [alertControl addAction:action];
          [self presentViewController:alertControl animated:YES completion:nil];
     }else{
          message = [error description];
          NSLog(@"提示error%@",message);
          UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
          }];
          [alertControl addAction:action];
          [self presentViewController:alertControl animated:YES completion:nil];
     }
}
//-(UIImage *)addViewImage:(UIView *)view{
//     UIGraphicsBeginImageContext(view.bounds.size);
//     [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//     UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//     return viewImage;
//}
-(UIImage*)convertViewToImage:(UIView*)v{
     CGSize s = v.bounds.size;
     // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
     UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
     [v.layer renderInContext:UIGraphicsGetCurrentContext()];
     UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return image;
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
