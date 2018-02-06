//
//  GoodsDetailVC.m
//  供应商
//
//  Created by 张敬文 on 2017/8/1.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "GoodsDetailVC.h"
#import "TextDetailCell.h"
#import "ImageDetailCell.h"
#import "TextImageModel.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
@interface GoodsDetailVC ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong)UIView * pickerVC;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSMutableArray * arrayindex;
@property (nonatomic, strong) NSMutableArray * Ary;
@property (nonatomic, assign) NSInteger code;
@end

@implementation GoodsDetailVC
-(NSMutableArray *)arrayindex {
    if (!_arrayindex) {
        _arrayindex = [NSMutableArray arrayWithCapacity:1];
    }
    return _arrayindex;
}

-(NSMutableArray *)Ary {
     if (!_Ary) {
          _Ary = [NSMutableArray arrayWithCapacity:1];
     }
     return _Ary;
}

- (void)viewDidLoad {
    [super viewDidLoad];

     
    [self request];
    self.view.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    self.title = @"商品详情";
    [self configView];
    [self  setNavigationBarConfiguer];
     self.imagePickerController = [[UIImagePickerController alloc] init];
     _imagePickerController.delegate = self;
     _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
     _imagePickerController.allowsEditing = NO;
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifikation:) name:UIKeyboardWillChangeFrameNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
     
     UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
     
     [self.tableView addGestureRecognizer:myTap];
}

-(void)keyboardWillHide {
     self.tableView.frame = WDH_CGRectMake(0, 0, 375, 617);
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

- (void)setNavigationBarConfiguer {
     [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
     UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction)];
     self.navigationItem.rightBarButtonItem = rightBarButtonItem;
     UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
     self.navigationItem.leftBarButtonItem = item;
     
     
}

- (void) leftBarBtnClick {
     [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightBarButtonItemAction {
     int i = 0;
     
     for (TextImageModel * model in _arrayindex) {
          
          if ([model.type intValue] == 1) {
               NSString * Str1 = [model.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
               NSDictionary * dic = @{@"type":model.type,
                                      @"content":Str1,
                                      @"orders":[NSString stringWithFormat:@"%d", i]};
               [self.Ary addObject:dic];

          } else {
               NSDictionary * dic = @{@"id":model.imageCode,
                                      @"type":model.type,
                                      @"orders":[NSString stringWithFormat:@"%d", i]};
               [self.Ary addObject:dic];
          }
          i++;
     }
     [self requestSave:_Ary];
}

- (void) request {
     if ([_goodId isEqualToString:@"="]) {
          //新增不添加
     } else if ([_goodId isEqualToString:@"-"]) {
          for (TextImageModel * model in _dataAry) {
               [self.arrayindex addObject:model];
          }
          [self.tableView reloadData];
     } else {
          if ([_type intValue] == 2) {
               for (TextImageModel * model in _dataAry) {
                    [self.arrayindex addObject:model];
               }
          } else {
               for (NSDictionary * dataDic in _dataAry) {
                    if ([dataDic[@"type"] intValue] == 1) {
                         UIImage * image = [[UIImage alloc] init];
                         NSDictionary * dic1 = @{@"text":[NSString stringWithFormat:@"%@", dataDic[@"content"]], @"image":image, @"type":@"1",@"imageCode":@""};
                         TextImageModel * model = [TextImageModel textWithDictionary:dic1];
                         [self.arrayindex addObject:model];
                    } else {
                         UIImage * image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dataDic[@"content"]]]]];
                         if (image1) {
                              NSDictionary * dic1 = @{@"text":@"", @"image":image1, @"type":@"2", @"imageCode":[NSString stringWithFormat:@"%@", dataDic[@"id"]]};
                              TextImageModel * model = [TextImageModel textWithDictionary:dic1];
                              [self.arrayindex addObject:model];
                         } else {
                              UIImage * image = [[UIImage alloc] init];
                              NSDictionary * dic1 = @{@"text":@"", @"image":image, @"type":@"2", @"imageCode":[NSString stringWithFormat:@"%@", dataDic[@"id"]]};
                              TextImageModel * model = [TextImageModel textWithDictionary:dic1];
                              [self.arrayindex addObject:model];
                         }
                         
                    }
               }
          }
          [self.tableView reloadData];
     }
}

- (void) requestSave:(NSMutableArray *)ary {
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", GYSGoodContent]];
     // 请求
     NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
     // 超时
     request.timeoutInterval = 10;
     // 请求方式
     request.HTTPMethod = @"POST";
     // 设置请求体和参数
     // 创建一个描述订单的JSON数据
     NSString * str2 = @"";
     if ([_goodId isEqualToString:@"="]) {
          //新增不添加
     } else if ([_goodId isEqualToString:@"-"]) {
          //新增二次添加
     } else {
          str2 = _goodId;
     }
     
     NSDictionary* orderInfo = @{@"goodId":str2,
                                 @"contentDetailVo":ary};
     // OC对象转JSON
     NSData* json = [NSJSONSerialization dataWithJSONObject:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
     NSString *strs=[[NSString alloc] initWithData:json
                                          encoding:NSUTF8StringEncoding];
     // 设置请求头
     NSLog(@"最终提交数据:%@", strs);
     // 设置请求头
     // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
     //     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setValue:str forHTTPHeaderField:@"Authorization"];
     request.HTTPBody = json;
     [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
          NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
          NSLog(@"保存结果信息%@", dic);
          if ([dic[@"code"] intValue] == 0) {
               NSString * str = [NSString stringWithFormat:@"%@", dic[@"data"]];
               NSArray * ary = [NSArray arrayWithArray:_arrayindex];
               NSDictionary *dic = @{@"detail":str, @"data":ary};
               [[NSNotificationCenter defaultCenter] postNotificationName:@"detail" object:nil userInfo:dic];
               [self.navigationController popViewControllerAnimated:YES];
          }
          

     }];
}


- (void) configView {
    self.tableView = [[UITableView alloc]initWithFrame:WDH_CGRectMake(0, 0, 375, 617) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[TextDetailCell class] forCellReuseIdentifier:@"11"];
    [_tableView registerClass:[ImageDetailCell class] forCellReuseIdentifier:@"22"];
    
    
    UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
    Btn.frame = WDH_CGRectMake(-1, 617, 377, 50);
    Btn.layer.borderColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1].CGColor;
    Btn.layer.borderWidth = 1.0f;
     Btn.backgroundColor = [UIColor whiteColor];
    [Btn setTitleColor:[UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1] forState:UIControlStateNormal];
    [Btn setTitle:@"添加" forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn];
}

- (void) handleAction {
    [self handleMore];
}

- (void)handleMore
{
    self.tabBarController.tabBar.hidden = YES;
    
    self.pickerVC = [[UIView alloc]initWithFrame:WDH_CGRectMake(0, 0, 375, 667)];
    _pickerVC.backgroundColor = [UIColor blackColor];
    _pickerVC.alpha = 0.3;
    _pickerVC.userInteractionEnabled = YES;
    [self.view  addSubview:_pickerVC];
    UITapGestureRecognizer * tap44 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleAction3)];
    [_pickerVC addGestureRecognizer:tap44];
    
    UIView * view = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 467, 375, 200)];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = 804;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    
    NSArray * ary = @[@"文字", @"图片"];
    NSArray * ary1 = @[@"文字", @"图片"];
    for (int i = 0; i < 2; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:WDH_CGRectMake(60 + i * 175, 25, 80, 80)];
        imageView.image = [UIImage imageNamed:ary1[i]];
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        [view addSubview:imageView];
        
        UILabel * textLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(50 + i * 175, 110, 100, 30)];
        textLabel.text = ary[i];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:15* kScreenHeight1];
        [view addSubview:textLabel];
        
        UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
        Btn.frame = WDH_CGRectMake(50 + i * 175, 0, 125, 130);
        Btn.tag = i;
        Btn.backgroundColor = [UIColor clearColor];
        [Btn addTarget:self action:@selector(handleGo:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:Btn];
    }
    
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 150, 375, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    [view addSubview:lineLabel];
    
    UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
    Btn.frame = WDH_CGRectMake(0, 151, 375, 49);
    [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Btn setTitle:@"取消" forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(handleAction3) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:Btn];
}

- (void) handleGo:(UIButton *)sender
{
    self.tabBarController.tabBar.hidden = NO;
    [[self.view viewWithTag:804] removeFromSuperview];
    [_pickerVC removeFromSuperview];
    if (sender.tag == 0) {
        //添加文字
        UIImage * image = [[UIImage alloc] init];
         NSDictionary * dic = @{@"text":@"", @"image":image, @"type":@"1", @"imageCode":@""};
        TextImageModel * model = [TextImageModel textWithDictionary:dic];
        [self.arrayindex addObject:model];
        [self.tableView reloadData];
    } else if (sender.tag == 1) {
        //添加图片
        UIImage * image = [[UIImage alloc] init];
        NSDictionary * dic = @{@"text":@"", @"image":image, @"type":@"2", @"imageCode":@""};
        TextImageModel * model = [TextImageModel textWithDictionary:dic];
        [self.arrayindex addObject:model];
        [self.tableView reloadData];
    }
}

- (void) handleAction3 {
    self.tabBarController.tabBar.hidden = NO;
    [[self.view viewWithTag:804] removeFromSuperview];
    [_pickerVC removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayindex.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TextImageModel * model = _arrayindex[indexPath.row];
    if ([model.type intValue] == 1) {
        TextDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"11" forIndexPath:indexPath];
        cell.Tf.text = model.text;
        cell.Tf.tag = 100 + indexPath.row;
        cell.Tf.delegate = self;
        cell.Tf.textField.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.moveBtn.tag = indexPath.row;
        [cell.moveBtn addTarget:self action:@selector(handleMove:) forControlEvents:UIControlEventTouchUpInside];
         cell.deleteBtn.tag = 10000 + indexPath.row;
         [cell.deleteBtn addTarget:self action:@selector(handledelete:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if ([model.type intValue] == 2) {
        ImageDetailCell * zjwcell = [tableView dequeueReusableCellWithIdentifier:@"22" forIndexPath:indexPath];
        zjwcell.addImageView.image = model.image;
         zjwcell.addBtn.tag = 1000 + indexPath.row;
         [zjwcell.addBtn addTarget:self action:@selector(handleAdd:) forControlEvents:UIControlEventTouchUpInside];
        zjwcell.selectionStyle = UITableViewCellSelectionStyleNone;
        zjwcell.moveBtn.tag = indexPath.row;
        [zjwcell.moveBtn addTarget:self action:@selector(handleMove:) forControlEvents:UIControlEventTouchUpInside];
         zjwcell.deleteBtn.tag = 10000 + indexPath.row;
         [zjwcell.deleteBtn addTarget:self action:@selector(handledelete:) forControlEvents:UIControlEventTouchUpInside];
        return zjwcell;
    }
    return nil;
}

- (void)handledelete:(UIButton *)sender {
     [_arrayindex removeObjectAtIndex:sender.tag - 10000];
     [self.tableView reloadData];
}

- (void)textViewDidChange:(CloverText *)textView
{
     if (textView.text.length == 0) {
          textView.textField.hidden = NO;
     }
     else {
          textView.textField.hidden = YES;
     }
     
     TextImageModel * model = _arrayindex[textView.tag - 100];
     model.text = textView.text;
     [_arrayindex removeObjectAtIndex:textView.tag - 100];
     [_arrayindex insertObject:model atIndex:textView.tag - 100];
     NSLog(@"走了没");
}

//- (BOOL)textViewShouldEndEditing:(UITextView *)textView
//{
//     NSLog(@"走了没111");
//     TextImageModel * model = _arrayindex[textView.tag - 100];
//     model.text = textView.text;
//     [_arrayindex removeObjectAtIndex:textView.tag - 100];
//     [_arrayindex insertObject:model atIndex:textView.tag - 100];
//     NSLog(@"当前数据内容:%@", _arrayindex);
//     return YES;
//}

- (void) handleMove :(UIButton *) sender
{
     if (sender.tag == 0) {
          //不操作
     } else {
          TextImageModel * model = _arrayindex[sender.tag];
          [_arrayindex removeObjectAtIndex:sender.tag];
          [_arrayindex insertObject:model atIndex:sender.tag - 1];
          [_tableView reloadData];
     }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextImageModel * model = _arrayindex[indexPath.row];
    if ([model.type intValue] == 1) {
        return 140* kScreenHeight1;
    } else if ([model.type intValue] == 2) {
        return 200* kScreenHeight1;
    }
    return 0;
}

#pragma mark - 处理图片

- (void) handleAdd:(UIButton *) sender
{
     _code = sender.tag;
     
     UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
          
          _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
          [self presentViewController:_imagePickerController animated:YES completion:nil];
     }];
     UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
          
          
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
     [picker dismissViewControllerAnimated:YES completion:^{
          NSData * ImageStr = [self Image_TransForm_Data:image];
          
          UIButton * Btn = [self.view viewWithTag:_code];
          ImageDetailCell * cell = (ImageDetailCell *)Btn.superview;
          cell.addImageView.image = image;
          
          
          TextImageModel * model = _arrayindex[_code - 1000];
          model.image = image;
          [_arrayindex removeObjectAtIndex:_code - 1000];
          [_arrayindex insertObject:model atIndex:_code - 1000];
          
          
          
          NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
          AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
          manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
          manager.requestSerializer = [AFJSONRequestSerializer serializer];
          manager.responseSerializer = [AFJSONResponseSerializer serializer];
          [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
          //          [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
          [manager POST:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:GYSImageDetailUpload]] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
               if (ImageStr != NULL)
               {
                    [formData appendPartWithFileData:ImageStr name:@"files" fileName:@"files.jpg" mimeType:@"image/jpeg"];
                    
               }
          } progress:^(NSProgress * _Nonnull uploadProgress) {
               
          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSLog(@"上传图片%@", responseObject);
               
               if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
                    TextImageModel * model = _arrayindex[_code - 1000];
                    NSString*string =[NSString stringWithFormat:@"%@", responseObject[@"data"]];
                    NSArray *array = [string componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
                    NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
                    model.imageCode = [array firstObject];
                    [_arrayindex removeObjectAtIndex:_code - 1000];
                    [_arrayindex insertObject:model atIndex:_code - 1000];
                    NSLog(@"当前数据内容:%@", _arrayindex);
                    [self archiveImage];//归档
               }
               
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
     }];
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
