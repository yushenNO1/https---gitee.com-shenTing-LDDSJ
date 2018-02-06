//
//  AgentViewController.m
//  YSApp
//
//  Created by 云盛科技 on 16/9/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "AgentViewController.h"

#import "YSHYClipViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ShopTypeModel.h"
#import "WSSAddressTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
@interface AgentViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ClipViewControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>

{
    ClipType clipType;
    UIImagePickerController *_imagePickerController;
    float latitude;
    float longitude;
}
@property (nonatomic, retain) CLLocationManager * locationManager;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *mobileField;
@property (nonatomic, strong) UITextField *addressField;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, copy) NSString * imageStr;
@property (nonatomic, copy) NSString * areaId;
@end

@implementation AgentViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改信息";

     
    self.view.backgroundColor = [UIColor backGray];
    self.tabBarController.tabBar.hidden = YES;
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
     UILabel * backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 243 * kScreenHeight1, 375 * kScreenWidth1, 50 * kScreenHeight1)];
     backLabel.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:backLabel];
     
     UILabel * backLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 298 * kScreenHeight1, 375 * kScreenWidth1, 50 * kScreenHeight1)];
     backLabel1.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:backLabel1];
     
     UILabel * backLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 353 * kScreenHeight1, 375 * kScreenWidth1, 100 * kScreenHeight1)];
     backLabel2.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:backLabel2];
     [self location];
     [self configView];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifikation:) name:UIKeyboardWillChangeFrameNotification object:nil];
     
}
-(void)notifikation:(NSNotification *)sender
{
     NSLog(@"asdasd--as-d--asd-----%@",sender);
     CGRect rect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
     self.view.frame = CGRectMake(0, -(self.view.bounds.size.height - rect.origin.y), self.view.bounds.size.width, self.view.bounds.size.height);
}
- (void) configView
{
     NSDictionary *shopInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
     _areaId = shopInfo[@"areaId"];
     _imageStr = shopInfo[@"cover"];
     UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375 * kScreenWidth1, 50 * kScreenHeight1)];
     label.text = @"请认真填写以下内容";
     NSArray * ary = @[@"商家名称", @"手机号码", @"商家地址"];
     for (int i = 0; i < 3; i++) {
          UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20 * kScreenWidth1, 64 + (243 + i * 55) * kScreenHeight1, 80 * kScreenWidth1, 50 * kScreenHeight1)];
          label.text = ary[i];
          label.font = [UIFont systemFontOfSize:15];
          [self.view addSubview:label];
          
          UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(101 * kScreenWidth1, 64 + (255.5 + i * 55) * kScreenHeight1, 1 * kScreenWidth1, 25 * kScreenHeight1)];
          lineLabel.backgroundColor = [UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1];
          [self.view addSubview:lineLabel];
     }
     
     self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(115 * kScreenWidth1, 64 + 353 * kScreenHeight1, 220 * kScreenWidth1, 50 * kScreenHeight1)];
     _addressLabel.text = @"地址";
     _addressLabel.font = [UIFont systemFontOfSize:15];
     [self.view addSubview:_addressLabel];
     
     self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(115 * kScreenWidth1, 64 + 243 * kScreenHeight1, 230 * kScreenWidth1, 50 * kScreenHeight1)];
     _nameField.text = @"店铺名称";
     _nameField.font = [UIFont systemFontOfSize:15];
     [self.view addSubview:_nameField];
     
     self.mobileField = [[UITextField alloc] initWithFrame:CGRectMake(115 * kScreenWidth1, 64 + 298 * kScreenHeight1, 230 * kScreenWidth1, 50 * kScreenHeight1)];
     _mobileField.text = @"联系方式";
     _mobileField.font = [UIFont systemFontOfSize:15];
     [self.view addSubview:_mobileField];
     
     self.addressField = [[UITextField alloc] initWithFrame:CGRectMake(115 * kScreenWidth1, 64 + 403 * kScreenHeight1, 230 * kScreenWidth1, 50 * kScreenHeight1)];
     _addressField.text = @"详细地址";
     _addressField.font = [UIFont systemFontOfSize:15];
     [self.view addSubview:_addressField];
     
     self.imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 375 * kScreenWidth1, 213 * kScreenHeight1)];
     _imageView.image = [UIImage imageNamed:@"jia@2x"];
     [self.view addSubview:_imageView];
     
     _nameField.text = [NSString stringWithFormat:@"%@", shopInfo[@"shopName"]];
     _mobileField.text = [NSString stringWithFormat:@"%@", shopInfo[@"mobile"]];
     NSString * add = [NSString stringWithFormat:@"%@", shopInfo[@"areaString"]];
     NSString * add1 = [NSString stringWithFormat:@"%@", shopInfo[@"detailAddress"]];
     NSArray * aaary = [add componentsSeparatedByString:add1];
     _addressLabel.text = [aaary firstObject];
     _addressField.text = add1;
     [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", shopInfo[@"coverUrl"]]]];
     
     UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
     but.frame = CGRectMake(290 * kScreenWidth1, 64 + 213 * kScreenHeight1, 75 * kScreenWidth1, 30 * kScreenHeight1);
     [but setTitle:@"修改封面" forState:UIControlStateNormal];
     [but setTitleColor:[UIColor colorWithRed:253 / 255.0 green:56 / 255.0 blue:84 / 255.0 alpha:1.0] forState:UIControlStateNormal];
     but.backgroundColor = [UIColor clearColor];
     but.titleLabel.font = [UIFont systemFontOfSize:13];
     [but addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:but];
     
     
     UIButton * but2 = [UIButton buttonWithType:UIButtonTypeSystem];
     but2.frame = CGRectMake(335 * kScreenWidth1, 64 + 368 * kScreenHeight1, 20 * kScreenWidth1, 20 * kScreenHeight1);
     [but2 setBackgroundImage:[UIImage imageNamed:@"修改收货地址"] forState:UIControlStateNormal];
     [but2 addTarget:self action:@selector(handleAction2) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:but2];
     
     UIButton * but1 = [UIButton buttonWithType:UIButtonTypeSystem];
     but1.frame = CGRectMake(15 * kScreenWidth1, 609 * kScreenHeight1, 345 * kScreenWidth1, 43 * kScreenHeight1);
     but1.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:56 / 255.0 blue:84 / 255.0 alpha:1.0];
     but1.layer.cornerRadius = 5;
     but1.layer.masksToBounds = YES;
     [but1 setTitle:@"确认修改" forState:UIControlStateNormal];
     [but1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [but1 addTarget:self action:@selector(handleAction1) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:but1];
     
}

- (void) handleAction2 {
     WSSAddressTableViewController *vc = [[WSSAddressTableViewController alloc]init];
     vc.content = ^(NSString *provinceID, NSString *cityID, NSString *detaiID, NSString *provinceStr, NSString *cityStr, NSString *detailStr)
     {
          self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",provinceStr,cityStr,detailStr];
          if ([detaiID longLongValue] <= 0)
          {
               _areaId = cityID;
          }else{
               _areaId = detaiID;
          }
          NSLog(@"huoqu ----ID---%@", _areaId);
     };
     [self.navigationController pushViewController:vc animated:YES];
}

- (void) handleAction1 {
     [self request];
}

- (void)request {
     if ([self isMobile:_mobileField.text]) {
          NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
          AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
          manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
          manager.requestSerializer = [AFJSONRequestSerializer serializer];
          manager.responseSerializer = [AFJSONResponseSerializer serializer];
          
          [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
          NSString *urlStr = [[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:@"/api/v1/life/shop/edit?areaId=%@&mobile=%@&cover=%@&detailAddress=%@&latitude=%f&longitude=%f",_areaId, _mobileField.text, _imageStr, _addressField.text, latitude, longitude]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          NSLog(@"asdasd---%@",[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:@"/api/v1/life/shop/edit?areaId=%@&mobile=%@&cover=%@&detailAddress=%@&latitude=%f&longitude=%f",_areaId, _mobileField.text, _imageStr, _addressField.text, latitude, longitude]]);
          [manager POST:urlStr  parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSLog(@"asdasd---%@",responseObject);
               if ([responseObject[@"code"] intValue]== 0){
                    [self loadMyInfo];
                    Alert_show_pushRoot(@"修改成功")
               }
               
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               NSLog(@"修改商家信息失败原因----%@",error);
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
          if ([responseObject[@"code"] intValue]== 0){
               
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

- (void) handleAction {
     UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"上传商家封面" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
     UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
          [self photoalbumr];
     }];
     UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          [self addPicEvent];
     }];
     UIAlertAction *dissAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     }];
     [alertSheet addAction:actionPhoto];
     [alertSheet addAction:actionCamera];
     [alertSheet addAction:dissAction];
     [self presentViewController:alertSheet animated:YES completion:nil];
}


- (void)location
{
     //1.创建定位对象
     self.locationManager = [[CLLocationManager alloc] init];
     //2.获取授权
     [_locationManager requestAlwaysAuthorization];
     //3.设置精确度
     _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
     //4.设置米数
     _locationManager.distanceFilter = 5.0f;
     //5.设置代理
     _locationManager.delegate = self;
     //6.开始定位
     [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
     //获取位置
     CLLocation * location = locations[0];
     //获取位置信息
     CLLocationCoordinate2D coor = location.coordinate;
     latitude = location.coordinate.latitude;
     longitude = location.coordinate.longitude;
     NSLog(@"longitude:%f latitude:%f %f %f", coor.longitude, coor.latitude, location.altitude, location.speed);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.view endEditing:YES];
}
//访问图片相册
- (void)photoalbumr {
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
          UIImagePickerController *picker = [[UIImagePickerController alloc] init];
          picker.delegate = self;
          picker.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:33/255.0 green:35/255.0 blue:33/255.0 alpha:1];
          picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
          [self presentViewController:picker animated:YES completion:nil];
     }
}
//调用相机
- (void) addPicEvent
{
     //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
     UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
     if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
          sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
          UIImagePickerController *picker = [[UIImagePickerController alloc] init];
          picker.delegate = self;
          picker.allowsEditing = YES;
          picker.sourceType = sourceType;
          [self presentViewController:picker animated:YES completion:nil];
     } else {
          UIImagePickerController *picker = [[UIImagePickerController alloc] init];
          picker.delegate = self;
          picker.allowsEditing = YES;
          picker.sourceType = sourceType;
          [self presentViewController:picker animated:YES completion:nil];
     }
     
}


#pragma mark
#pragma mark ----------- imagePickerControllerDelegate -----
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
     UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
     YSHYClipViewController * clipView = [[YSHYClipViewController alloc]initWithImage:image];
     clipView.delegate = self;
     clipView.clipType = SQUARECLIP;
     [clipView.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
     [picker pushViewController:clipView animated:YES];
     
}

#pragma mark
#pragma mark ---------- ClipViewControllerDelegate
-(void)ClipViewController:(YSHYClipViewController *)clipViewController FinishClipImage:(UIImage *)editImage
{
     [clipViewController dismissViewControllerAnimated:YES completion:^{
          _imageView.image = editImage;
          [self uploadThePictureRequest:[self Image_TransForm_Data:editImage]];
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
     [picker dismissViewControllerAnimated:YES completion:nil];
}

//类方法  图片 转换为二进制
-(NSData *)Image_TransForm_Data:(UIImage *)image
{
     NSData *imageData = UIImageJPEGRepresentation(image , 0.1);
     //几乎是按0.5图片大小就降到原来的一半 比如这里 24KB 降到11KB
     return imageData;
}


#pragma mark
#pragma mark ----------- 请求 >>> 上传头像 -----------
- (void)uploadThePictureRequest:(NSData *)data {
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     NSDictionary * dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"infoMy"];
     NSDictionary *dic1 = @{@"userId":dic[@"userVo"][@"id"]};
     [manager POST:[NSString stringWithFormat:@"%@/api/v1/mgs/file/imageUpload", LSKurl] parameters:dic1 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
          if (data != NULL)
          {
               [formData appendPartWithFileData:data name:@"files" fileName:@"files.jpg" mimeType:@"image/jpeg"];
          }
     } progress:^(NSProgress * _Nonnull uploadProgress) {
          
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"头像上传成功---------%@",responseObject);
          if ([responseObject[@"code"] integerValue]==0) {
//
               _imageStr = [NSString stringWithFormat:@"%@", responseObject[@"data"][0]];
          }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"头像上传失败---------%@",error);
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

//手机号
- (BOOL) isMobile:(NSString *)mobileNumbel{
    NSString * all = @"^[1][3,4,5,7,8][0-9]{9}$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", all];
    if ([mobileNumbel length] == 0){
        Alert_Show(@"电话号码为空,请输入您的电话号码");
        return NO;
    }else if ([regextestct evaluateWithObject:mobileNumbel]) {
        return YES;
    }else{
        Alert_Show(@"请输入正确的手机号!");
        return NO;
    }
}


@end
