//
//  AddImageVC.m
//  供应商
//
//  Created by 张敬文 on 2017/8/3.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "AddImageVC.h"
#import "addGoodsVC.h"
#import "AFNetworking.h"
#import "QiniuSDK.h"         //七牛云上传文件

@interface AddImageVC ()<UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIButton * addBtn;
@property (nonatomic, strong) NSMutableArray * arrayImage;
@property (nonatomic, strong) NSMutableArray * codeImage;
@property (nonatomic, strong) NSMutableArray * codeImage1;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation AddImageVC
-(NSMutableArray *)arrayImage {
    if (!_arrayImage) {
        _arrayImage = [NSMutableArray arrayWithCapacity:1];
    }
    return _arrayImage;
}

-(NSMutableArray *)codeImage {
     if (!_codeImage) {
          _codeImage = [NSMutableArray arrayWithCapacity:1];
     }
     return _codeImage;
}

-(NSMutableArray *)codeImage1 {
     if (!_codeImage1) {
          _codeImage1 = [NSMutableArray arrayWithCapacity:1];
     }
     return _codeImage1;
}

- (void)viewDidLoad {
    [super viewDidLoad];

     
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加图片";
    [self setNavigationBarConfiguer];
    [self configView];
    self.imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = NO;
    // Do any additional setup after loading the view.
}

- (void) configView {
    UIView * backView = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 64, 375, 210)];
    backView.tag = 101;
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    float interval =(375 - 3 * 90) / 4;
    self.addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _addBtn.frame = WDH_CGRectMake(interval, 20, 90, 90);
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(imageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_addBtn];
    
}

- (void)imageBtnClick {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *hidAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:hidAlert];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)setNavigationBarConfiguer {
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(uploadPicture)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
     UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
     self.navigationItem.leftBarButtonItem = item;
     
     
}

- (void) leftBarBtnClick {
     [self.navigationController popViewControllerAnimated:YES];
}
static int queueId = 0;
-(void)uploadPicture{
     NSString *token = @"_18Pt7DD_nSLz4_h2h2Z3x13kBww4Q_ZA21l99so:KGBrCdPPzy-5ongnzdDp-3g6PHw=:eyJzY29wZSI6IndkaC1xaW5pdSIsImRlYWRsaW5lIjoxNTc5MDcwNzUxfQ==";
     NSDictionary *shopInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
     QNUploadManager *upManager = [[QNUploadManager alloc] init];
     [WKProgressHUD showInView:self.view withText:@"图片上传中..." animated:YES];
     //创建串行队列
     dispatch_queue_t  queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     for (NSData * data in _codeImage) {
          //2.添加任务到队列中执行
          dispatch_sync(queue, ^{
               //key: 图片名        命名方式:用户id+时间戳
               NSDate* dat = [NSDate date];
               NSTimeInterval a=[dat timeIntervalSince1970]*1000;
               NSString *timeString = [NSString stringWithFormat:@"%ld", (long)a];    //转为字符型
               NSString *key = [NSString stringWithFormat:@"%@-%@.png",shopInfo[@"id"],timeString];
               NSString *utf8Str = [key stringByAddingPercentEscapesUsingEncoding : NSUTF8StringEncoding];
               [upManager putData:data key:utf8Str token:token
                         complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                              NSLog(@"-----....%@", info);
                              NSLog(@"------...~~~%@", resp);
                              queueId = queueId+1 ;
                              [self.codeImage1 addObject:[NSString stringWithFormat:@"%@",resp[@"key"]]];
                              
                              NSLog(@"每次县城结束有没有递增---%d",queueId);
                              if (queueId == _codeImage.count) {
                                   [WKProgressHUD dismissAll:YES];
                                   NSArray * ary = [NSArray arrayWithArray:_arrayImage];
                                   NSArray * ary1 = [NSArray arrayWithArray:_codeImage1];
                                   [self updatePictureToServer];      //图片地址上传到服务器
                                   NSDictionary *dic = @{@"image":ary, @"id":ary1};
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"Image" object:nil userInfo:dic];
                                   
                              }
                         } option:nil];
          });
          [NSThread sleepForTimeInterval:1.0f];
          
     }
}
-(void)updatePictureToServer{
     NSString *tempStr = @"files=";
     int index = 0;
     for (NSString *str in self.codeImage1) {
          if (index == 0) {
               tempStr = [NSString stringWithFormat:@"%@https://static.wdh158.com/%@",tempStr,str];
          }else{
               tempStr = [NSString stringWithFormat:@"%@&files=https://static.wdh158.com/%@",tempStr,str];
          }
          index ++ ;
     }
     NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
     [manager POST:[NSString stringWithFormat:LSKurl@"/api/v1/life/goodImage/upload?%@",tempStr] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"上传服务器成功---%@",responseObject);
          if ([responseObject[@"code"] intValue] == 0) {
               NSDictionary *dic = @{@"imageIds":responseObject[@"data"]};
               [[NSNotificationCenter defaultCenter] postNotificationName:@"imageIds" object:nil userInfo:dic];
               [self.navigationController popViewControllerAnimated:YES];
          }else{
               Alert_Show(@"上传失败")
          }
          
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"上传服务器失败%@",error);
     }];
}

- (void) rightBarButtonItemAction {
          NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
          AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
          manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
          manager.requestSerializer = [AFJSONRequestSerializer serializer];
          manager.responseSerializer = [AFJSONResponseSerializer serializer];
          [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
//          [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
          [manager POST:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:GYSImageUpload]] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
               for (NSData * data in _codeImage) {
               
               if (data != NULL)
               {
                    [formData appendPartWithFileData:data name:@"files" fileName:@"files.jpg" mimeType:@"image/jpeg"];

                   }
               }
               
          } progress:^(NSProgress * _Nonnull uploadProgress) {
               
          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSLog(@"上传图片%@", responseObject);
               
               if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
                    
                    NSString*string =[NSString stringWithFormat:@"%@", responseObject[@"data"]];
                    NSArray *array = [string componentsSeparatedByString:@","];
                    NSLog(@"array:%@",array);
                    for (int i = 0; i < array.count; i++) {
                         if (i < array.count - 1) {
                              [self.codeImage1 addObject:array[i]];
                         }
                    }
                    
                    NSArray * ary = [NSArray arrayWithArray:_arrayImage];
                    NSArray * ary1 = [NSArray arrayWithArray:_codeImage1];
                    NSDictionary *dic = @{@"image":ary, @"id":ary1};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Image" object:nil userInfo:dic];
                    [self.navigationController popViewControllerAnimated:YES];
               }
               NSString * str = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
               Alert_Show(str)
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               NSLog(@"上传图片失败%@", error);
               
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

#pragma mark ----------- imagePickerControllerDelegate -----
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData * ImageStr = [self Image_TransForm_Data:image];
        
        [self.codeImage addObject:ImageStr];
        //两种形式的保存
        [self.arrayImage addObject:image];
        
        UIView * backView = [self.view viewWithTag:101];
        [_addBtn removeFromSuperview];
        for(UIView * view in [backView subviews])
        {
            [view removeFromSuperview];
        }
        
        float interval =(375 - 3 * 90) / 4;
        for (int i = 0; i < _arrayImage.count + 1; i++) {
            
            int col =i%3;
            int row =i/3;
            
            float x =interval +col *(90 +interval);
            float y =20 +row *(90 +interval);
            
            if (i < 6 && i == _arrayImage.count) {
                self.addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                _addBtn.frame = CGRectMake(x, y, 90, 90);
                [_addBtn setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
                [_addBtn addTarget:self action:@selector(imageBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:_addBtn];
                
            } else if (i >= 6) {
                //不添加
            } else {
                UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
                Btn.frame = WDH_CGRectMake(x, y, 90, 90);
                [Btn setBackgroundImage:_arrayImage[i] forState:UIControlStateNormal];
//                [Btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:Btn];
                
                UIButton * xBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                xBtn.frame = WDH_CGRectMake(x + 80, y - 10, 20, 20);
                xBtn.layer.cornerRadius = 10;
                xBtn.layer.masksToBounds = YES;
                [xBtn setBackgroundImage:[UIImage imageNamed:@"删除1"] forState:UIControlStateNormal];
                xBtn.tag = i;
                [xBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:xBtn];
            }
        }
        
        [self archiveImage];//归档
    }];
}

- (void)delete:(UIButton *)sender{
    [_codeImage removeObjectAtIndex:sender.tag];
    [_arrayImage removeObjectAtIndex:sender.tag];
    UIView * backView = [self.view viewWithTag:101];
    [_addBtn removeFromSuperview];

    for(UIView * view in [backView subviews])
    {
        [view removeFromSuperview];
    }
    
    float interval =(375 - 3 * 90) / 4;
    for (int i = 0; i < _arrayImage.count + 1; i++) {
        
        int col =i%3;
        int row =i/3;
        
        float x =interval +col *(90 +interval);
        float y =20 +row *(90 +interval);
        
        if (i == _arrayImage.count) {
            self.addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            _addBtn.frame = WDH_CGRectMake(x, y, 90, 90);
            [_addBtn setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
            [_addBtn addTarget:self action:@selector(imageBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:_addBtn];
            
        } else if (i >= 6) {
            //不添加
        } else {
            UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
            Btn.frame = WDH_CGRectMake(x, y, 90, 90);
            [Btn setBackgroundImage:_arrayImage[i] forState:UIControlStateNormal];
//            [Btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:Btn];
            
            UIButton * xBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            xBtn.frame = CGRectMake(x + 80, y - 10, 20, 20);
            xBtn.layer.cornerRadius = 10;
            xBtn.layer.masksToBounds = YES;
            [xBtn setTitle:@"X" forState:UIControlStateNormal];
            xBtn.tag = i;
            xBtn.backgroundColor = [UIColor redColor];
            [xBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:xBtn];
        }
    }

}

- (void)archiveImage {
    NSMutableData *data = [NSMutableData dataWithCapacity:1];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:_image forKey:@"头像"];
    [archiver finishEncoding];
    [data writeToFile:[self geArrayImageFilePath] atomically:YES];
}
//获取文件路径
- (NSString *)geArrayImageFilePath {
    NSString * docuPathh = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [docuPathh stringByAppendingPathComponent:@"tx.txt"];
}
//类方法  图片 转换为二进制
-(NSData *)Image_TransForm_Data:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image , 0.5);
    //几乎是按0.5图片大小就降到原来的一半 比如这里 24KB 降到11KB
    return imageData;
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
