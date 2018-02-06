//
//  ScanCheckVC.m
//  收银台
//
//  Created by 张敬文 on 2017/5/25.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "ScanCheckVC.h"
#import "LYTFMDB.h"
#import "QRCodeViewController.h"
#import "ScanAddeleteCell.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "OrderInfoModel.h"
#import "TwoScanVC.h"
#import "FormulaStringCalcUtility.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)
@interface ScanCheckVC ()<UITableViewDelegate, UITableViewDataSource,AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate>
//计算器
@property (nonatomic, strong) UILabel * resultLabel;
@property (nonatomic, copy) NSString * sumCode;
@property (nonatomic, assign) int code2;
/**边框*/
@property (nonatomic,weak) UIImageView *QRImageView;
/**扫描*/
@property (nonatomic,weak) UIImageView *scanImageView;
/**最底层的view*/
@property (nonatomic,weak) UIView *bottomView;

@property (nonatomic,strong) AVCaptureDevice *device;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preview;

@property (strong, nonatomic) CIDetector *detector;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UIButton * ortherTf;
@property (nonatomic, strong) UILabel * ortherLabel;
@property (nonatomic, strong) UILabel * sumLabel;
@property (nonatomic, strong) UIButton * addBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *orderAry;

@property (nonatomic, copy) NSString *scanStr;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger code1;
@property (nonatomic, assign) NSInteger timer;
@property (nonatomic, strong) UIView * pickerVC;
@property (nonatomic, strong) UITextField * moneyCodeTf3;
@property (nonatomic, strong) UITextField * moneyCodeTf1;
@property (nonatomic, strong) UITextField * moneyCodeTf2;

@property (nonatomic, strong) UIView * pickerVC1;
@end

@implementation ScanCheckVC
- (void)request2:(NSString *)str3 {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    NSString * Url = @"";
     
    NSString * ortherStr = _ortherLabel.text;
    NSArray * ary = [ortherStr componentsSeparatedByString:@"+"];
     
     
    if (![_orderId isEqualToString:@""]) {
        Url = [NSString stringWithFormat:SYTOrderId, _orderId, _name, [ary lastObject]];
    } else {
        Url = [NSString stringWithFormat:SYTOrderNoId, _name, [ary lastObject]];
    }
    
    float price = 0;
    for (OrderInfoModel * model in _dataArr) {
        price = [model.priceZ floatValue] + price;
    }
    _contentLabel.text = [NSString stringWithFormat:@"%.2f", price];
    _sumLabel.text = [NSString stringWithFormat:@"%.2f", [_ortherLabel.text floatValue] + [_contentLabel.text floatValue]];
     
     
     
    NSString * str1 = @"";
    for (OrderInfoModel * model in _dataArr) {
        str1 = [NSString stringWithFormat:@"%@&goods=%@-%@", str1, model.goodId, model.count];
         NSLog(@"asdastr1-----%@----date ---%ld",str1,_dataArr.count);
    }
     
     NSString *urlStr = [[NSString stringWithFormat:@"%@%@",Url,str1]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     NSLog(@"链接----%@", Url);
          [manager POST:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSLog(@"---shangpinbuzu----%@", responseObject);
               if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"0"]) {
                    if ([str3 isEqualToString:@"1"]) {
                         [self.navigationController popViewControllerAnimated:YES];
                    } else {
                         TwoScanVC * vc = [[TwoScanVC alloc] init];
                         vc.orderId = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"orderId"]];
                         vc.totalAmount = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"totalAmount"]];
                         [self.navigationController pushViewController:vc animated:YES];
                    }
                    NSLog(@"---shengchengdingdan----%@", responseObject);
               } else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"1011"]) {
                    NSDictionary * dic = responseObject[@"data"];
                    NSArray * ary = dic[@"list"];
                    NSString * str = @"";
                    for (NSDictionary * dataDic in ary) {
                         [self.orderAry addObject:[NSString stringWithFormat:@"%@", dataDic[@"goodId"]]];
                         if ([str isEqualToString:@""]) {
                              str = [NSString stringWithFormat:@"%@", dataDic[@"goodName"]];
                         } else {
                              str = [NSString stringWithFormat:@"%@, %@", str, dataDic[@"goodName"]];
                         }
                    }
                    NSString * data = [NSString stringWithFormat:@"商品%@库存不足, 是否清除", str];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:data preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                    {
                         NSArray * ary1 = [NSArray arrayWithArray:_dataArr];
                         [_dataArr removeAllObjects];
                         for (int i = 0; i < ary1.count; i++) {
                              OrderInfoModel * model = ary1[i];
                              for (NSString * order in self.orderAry) {
                                   if ([model.goodId isEqualToString:order]) {
                                        //不再添加=清除
                                   } else {
                                        [self.dataArr addObject:model];
                                   }
                              }
                         }
                         [self AllDataChange];
                         [self.tableView reloadData];
                    }];
                    UIAlertAction *dissAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:goAction];
                    [alert addAction:dissAction];
                    [self presentViewController:alert animated:YES completion:nil];
               }else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"1005"]){
                    Alert_Show(@"商品不存在")
               }
               
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               NSLog(@"-------%@", error);
          }];
}

- (void)request1 {
    
    
    [_dataArr removeAllObjects];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:SYTOrderDetail, _orderId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"---12312312----%@", responseObject);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"0"]) {
            NSDictionary * dic = responseObject[@"data"];
            NSArray *arr = dic[@"relations"];
            for (NSDictionary * dic in arr) {
                OrderInfoModel * model = [OrderInfoModel InfoWithDictionary:dic];
                [self.dataArr addObject:model];
            }
            
            _ortherLabel.text = [NSString stringWithFormat:@"+%.2f", [dic[@"extAmount"] floatValue]];
            _sumLabel.text = [NSString stringWithFormat:@"总计: %.2f", [dic[@"totalAmount"] floatValue]];
            _contentLabel.text = [NSString stringWithFormat:@"+%.2f", [dic[@"totalAmount"] floatValue] - [dic[@"extAmount"] floatValue]];
            
            [self.tableView reloadData];
        } else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"1005"]){
            Alert_Show(@"商品不存在")
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"-------%@", error);
    }];
}

- (void)request:(NSString *)barCode {
    
    NSArray * ary = [[LYTFMDB sharedDataBase] getAllNews];
    NSLog(@"数据库内容:%@", ary);
    
    if (![[LYTFMDB sharedDataBase] isExistSeachText:barCode]) {
        
        NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
        [manager GET:[NSString stringWithFormat:SYTGoodDetail, barCode] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"---12312312----%@", responseObject);
            if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"0"]) {
                NSDictionary * dic = responseObject[@"data"];
                GoodsInfoModel * model = [GoodsInfoModel GoodsInfoWithDictionary:dic];
                model.barCode = barCode;
                [[LYTFMDB sharedDataBase] insertPdcToCarWithModel:model];
                //做处理
                NSInteger a = 0;
                for (OrderInfoModel * model1 in _dataArr) {
                    if ([model1.goodId integerValue] == model.shopId) {
                        a = 1;
                        model1.count = [NSString stringWithFormat:@"%d", [model1.count intValue] + 1];
                    }
                }
                [self.tableView reloadData];
                
                if (a == 0) {
                    NSString * name = model.name;
                    NSString * goodId = [NSString stringWithFormat:@"%ld", model.shopId];
                    NSString * price = [NSString stringWithFormat:@"%.2f", model.price];
                    NSDictionary * dic1 = @{@"name":name, @"price":price, @"count":@"1", @"goodId":goodId};
                    OrderInfoModel * model1 = [OrderInfoModel InfoWithDictionary:dic1];
                    [self.dataArr addObject:model1];
                    [self.tableView reloadData];
                }
            } else if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"1006"]) {
                Alert_Show(@"当前商品不属于本商家")
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"-------%@", error);
        }];
    } else {
        GoodsInfoModel * model = [[LYTFMDB sharedDataBase] getNewsModelById:barCode];
        NSLog(@"++++%@", model);
        
        int a = 0;
        for (OrderInfoModel * model1 in _dataArr) {
            if ([model1.goodId integerValue] == model.shopId) {
                model1.count = [NSString stringWithFormat:@"%d", [model1.count intValue] + 1];
                a = 1;
            }
        }
        [self.tableView reloadData];
        if (a == 0) {
            //做处理
            NSString * name = model.name;
            NSString * goodId = [NSString stringWithFormat:@"%ld", model.shopId];
            NSString * price = [NSString stringWithFormat:@"%.2f", model.price];
            NSDictionary * dic = @{@"name":name, @"price":price, @"count":@"1", @"goodId":goodId};
            OrderInfoModel * model1 = [OrderInfoModel InfoWithDictionary:dic];
            [self.dataArr addObject:model1];
            [self.tableView reloadData];
        }
        
        
        
    }
}

-(NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArr;
}

-(NSMutableArray *)orderAry {
     if (!_orderAry) {
          self.orderAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _orderAry;
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _scanStr = @"";
    [self.dataArr removeAllObjects];
}

-(void)viewWillDisappear:(BOOL)animated
{
    _scanStr = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
     UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 375 * kScreenWidth1, 180 * kScreenHeight1)];
     backView.backgroundColor = [UIColor blackColor];
     [self.view addSubview:backView];
     
    if ([_orderId isEqualToString:@""]) {
        //新创建订单
    } else {
        //读取已生成订单
        [self request1];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    [self configView];
    //扫码
    [self startScan];
     
}

- (void) configView
{
    
    
    self.contentLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(240, 294, 115, 50)];
    _contentLabel.numberOfLines = 0;
    
    _contentLabel.textColor = [UIColor colorWithRed:0 green:130 / 255.0 blue:215 / 255.0 alpha:1];
    _contentLabel.font = [UIFont systemFontOfSize:18];
    _contentLabel.text = @"0.00";
    _contentLabel.textAlignment = 2;
    [self.view addSubview:_contentLabel];
    
    self.ortherLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(240, 244, 115, 50)];
    _ortherLabel.numberOfLines = 0;
    
    _ortherLabel.textColor = [UIColor colorWithRed:0 green:130 / 255.0 blue:215 / 255.0 alpha:1];
    _ortherLabel.font = [UIFont systemFontOfSize:18];
    _ortherLabel.textAlignment = 2;
     _ortherLabel.text = @"0.00";
    [self.view addSubview:_ortherLabel];
     
    self.ortherTf = [UIButton buttonWithType:UIButtonTypeSystem];
    _ortherTf.frame = WDH_CGRectMake(100, 249, 130, 40);
    _ortherTf.backgroundColor = [UIColor whiteColor];
    [_ortherTf setTitle:@"添加其他价格" forState:UIControlStateNormal];
    [_ortherTf addTarget:self action:@selector(handleChange) forControlEvents:UIControlEventTouchUpInside];
    [_ortherTf setTitleColor:[UIColor colorWithRed:199 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:_ortherTf];
    
    self.sumLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 344, 355, 50)];
    _sumLabel.textColor = [UIColor colorWithRed:0 green:130 / 255.0 blue:215 / 255.0 alpha:1];
    _sumLabel.font = [UIFont systemFontOfSize:20];
    _sumLabel.textAlignment = 2;
     _sumLabel.text = @"0.00";
    [self.view addSubview:_sumLabel];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:WDH_CGRectMake(0, 445, 375, 170) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1001;
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = 40 * kScreenHeight1;
    [_tableView registerClass:[ScanAddeleteCell class] forCellReuseIdentifier:@"22"];
    [self.view addSubview:_tableView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 394, 375 / 3, 50)];
    label.text = @"名称";
    label.textAlignment = 1;
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(375 / 3, 394, 375 / 3, 50)];
    label1.text = @"数量";
    label1.textAlignment = 1;
    label1.backgroundColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(375 / 3 * 2, 394, 375 / 3, 50)];
    label2.text = @"价格";
    label2.textAlignment = 1;
    label2.backgroundColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label2];
    
    UILabel * lineLabel1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 444, 375, 1)];
    lineLabel1.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    [self.view addSubview:lineLabel1];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = WDH_CGRectMake(0, 617, 375 / 2 + 50, 50);
    [leftBtn setTitle:@"直接付款" forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor colorWithRed:32 / 255.0 green:178 / 255.0 blue:255 / 255.0 alpha:1];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(handlePay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = WDH_CGRectMake(375 / 2 + 50, 617, 375 / 2 + 1 - 50, 50);
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(handleOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}

- (void) handleChange {
     [self configView1];
     _code2 = 0;
     NSString * ortherStr = _ortherLabel.text;
     NSArray * ary = [ortherStr componentsSeparatedByString:@"+"];
     if ([[ary lastObject] floatValue] == 0) {
          _sumCode = @"0";
     } else {
          _sumCode = [ary lastObject];
     }
     _resultLabel.text = _sumCode;

}

- (void) AllDataChange
{
    float price = 0;
    for (OrderInfoModel * model in _dataArr) {
        price = [model.priceZ floatValue] + price;
    }
    _contentLabel.text = [NSString stringWithFormat:@"+%.2f", price];
    _sumLabel.text = [NSString stringWithFormat:@"总计: %.2f", [_ortherLabel.text floatValue] + [_contentLabel.text floatValue]];
}

- (void) handlePay
{
    //直接付款
    [self request2:@"2"];
}

- (void) handleOrder
{
    //生成订单
    [self request2:@"1"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScanAddeleteCell * zjwCell = [tableView dequeueReusableCellWithIdentifier:@"22" forIndexPath:indexPath];
    OrderInfoModel * model = _dataArr[indexPath.row];
    model.priceZ = [NSString stringWithFormat:@"%.2f", [model.price floatValue] * [model.count integerValue]];
    zjwCell.leftLabel.text = model.name;
    zjwCell.centerLabel.text = model.count;
    zjwCell.centerLabel.tag = indexPath.row + 10000;
    zjwCell.rightLabel.text = [NSString stringWithFormat:@"%.2f", [model.priceZ floatValue]];
    [zjwCell.deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [zjwCell.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self AllDataChange];
     zjwCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    zjwCell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    return zjwCell;
}

- (void)addBtnClicked:(UIButton *)sender{
    ScanAddeleteCell * cellView = (ScanAddeleteCell *)sender.superview;
    OrderInfoModel * model = _dataArr[cellView.centerLabel.tag - 10000];
    int a = [cellView.centerLabel.text intValue];
    if (a >= 9) {
        //        _addBtn.userInteractionEnabled = NO;
    } else {
        a++;
    }
    model.count = [NSString stringWithFormat:@"%d", a];
    model.priceZ = [NSString stringWithFormat:@"%.2f", a * [model.price floatValue]];
    cellView.rightLabel.text = [NSString stringWithFormat:@"%.2f", [model.priceZ floatValue]];
    cellView.centerLabel.text = [NSString stringWithFormat:@"%d", a];
    [self AllDataChange];
}

- (void)deleteBtnClicked:(UIButton *)sender{
    ScanAddeleteCell * cellView = (ScanAddeleteCell *)sender.superview;
    OrderInfoModel * model = _dataArr[cellView.centerLabel.tag - 10000];
    int a = [cellView.centerLabel.text intValue];
    if (a <= 1) {
        //        _deleteBtn.userInteractionEnabled = NO;
    } else {
        a--;
    }
    model.count = [NSString stringWithFormat:@"%d", a];
    model.priceZ = [NSString stringWithFormat:@"%.2f", a * [model.price floatValue]];
    cellView.rightLabel.text = [NSString stringWithFormat:@"%.2f", [model.priceZ floatValue]];
    cellView.centerLabel.text = [NSString stringWithFormat:@"%d", a];
    [self AllDataChange];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 扫码部分
- (void)startScan
{
    // 判断有没有相机
    //判断是否可以打开相机，模拟器此功能无法使用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    //如果没获得权限
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,请先到系统“隐私”中打开相机权限哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    //获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    self.output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    //设置扫码支持的编码格式
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode128Code];
    //AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeQRCode
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    layer.frame = WDH_CGRectMake(50, 80, 275, 150);
    [self.view.layer addSublayer:layer];

    [self setupContentView];
    //扫描框
    self.output.rectOfInterest =  CGRectMake ((ScreenH-self.bottomView.frame.size.height)*0.5/ScreenH,(ScreenW-self.bottomView.frame.size.width)*0.5/ScreenW,self.bottomView.frame.size.height/ScreenH,self.bottomView.frame.size.width/ScreenW);
    NSLog(@"---%@",NSStringFromCGRect(self.output.rectOfInterest));
    //开始捕获
    [self.session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
//    NSLog(@"%@", metadataObjects);
    if (metadataObjects.count == 0) {
        NSLog(@"-------%@", metadataObjects);
        return;
    }
    
    if (metadataObjects.count > 0) {
        
//        [self.scanImageView.layer removeAllAnimations];
        
//        //停止扫描
        [self.session stopRunning];
        [self scrollView];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        NSLog(@"扫描结果--%@", metadataObject.stringValue);
        [self request:metadataObject.stringValue];
        //扫描得到的文本 可以拿到扫描后的文本做其他操作哦
        
        
        
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:metadataObject.stringValue delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
    }
}

-(void)scrollView
{
    //    if (scrollView.contentOffset.y + self.view.bounds.size.height + 20*kScreenHeight1 >= scrollView.contentSize.height) {
    NSLog(@"滑动到底部");
    if (_timer == 1) {
        UILabel * label = [self.view viewWithTag:11];
        label.hidden = NO;
        label.text = @"正在识别";
        _code1 = 3;
        NSTimer * timer = [[NSTimer alloc] init];
        timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
    } else {
        UILabel * SLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(225 / 2, 400, 150, 40)];
        SLabel.text = @"正在识别";
        _code1 = 3;
        SLabel.font = [UIFont systemFontOfSize:15];
        SLabel.backgroundColor = [UIColor whiteColor];
        SLabel.textColor = [UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1];
        SLabel.layer.cornerRadius = 5;
        SLabel.layer.borderColor = [UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1].CGColor;
        SLabel.layer.borderWidth = 1.0f;
        SLabel.layer.masksToBounds = YES;
        SLabel.textAlignment = 1;
        SLabel.tag = 11;
        [self.view addSubview:SLabel];
        
        NSTimer * timer = [[NSTimer alloc] init];
        _timer = 1;
        timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
    }
    //    }
}

- (void) function:(NSTimer *)timer {
    UILabel * label = [self.view viewWithTag:11];
    if (_code1 > 0) {
        _code1--;
        if (_code1 == 1) {
            label.text = @"扫描成功";
            
        } else if (_code1 == 0) {
            label.hidden = YES;
            [self.session startRunning];
//            [self startQRAnimation];
        } else {
            
        }
    } else {
        [timer invalidate];
    }
}

- (void)setupContentView
{
     
     
    // 最底层的view
    UIView *bottomView = [[UIView alloc] initWithFrame:WDH_CGRectMake(50, 79, 275, 150)];
    [self.view addSubview:bottomView];
    bottomView.layer.borderColor = [UIColor whiteColor].CGColor;
    bottomView.layer.borderWidth = 1;
    self.bottomView = bottomView;
    
    // 提示
//    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, 375, 30)];
//    lable.font = [UIFont systemFontOfSize:14];
//    lable.text = @"将对应条码放入扫描框内即可扫描";
//    lable.textColor = [UIColor whiteColor];
//    lable.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:lable];
    
    // 边框
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:bottomView.bounds];
    imageView.image = [UIImage imageNamed:@"qrcode_border"];
    [bottomView addSubview:imageView];
    self.QRImageView = imageView;
    
    // 扫描效果
    UIImageView *scanView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, 0)];
    scanView.image = [UIImage imageNamed:@"qrcode_scanline_qrcode"];
    [bottomView addSubview:scanView];
    self.scanImageView = scanView;
    
    [self startQRAnimation];
}

- (void)startQRAnimation
{
    [self.scanImageView.layer removeAllAnimations];
    
    self.QRImageView.frame = self.bottomView.bounds;
    //    self.bottomView.center = self.view.center;
     
    CGRect frame = self.scanImageView.frame;
    frame.size.height = 0;
    self.scanImageView.frame = frame;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        CGRect frame = self.scanImageView.frame;
        frame.size.height = self.bottomView.frame.size.height;
        self.scanImageView.frame = frame;
    } completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 计算机部分
- (void) configView1;
{
     self.pickerVC1 = [[UIView alloc]initWithFrame:WDH_CGRectMake(0, 0, 375, 667)];
     _pickerVC1.backgroundColor = [UIColor blackColor];
     _pickerVC1.alpha = 0.5;
     _pickerVC1.userInteractionEnabled = YES;
     [self.view  addSubview:_pickerVC1];
     UITapGestureRecognizer * tap44 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleAction4)];
     [_pickerVC1 addGestureRecognizer:tap44];
     
     UIView * view = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 0, 375, 667)];
     view.backgroundColor = [UIColor clearColor];
     
     view.tag = 904;
     [self.view addSubview:view];
     [self.view bringSubviewToFront:view];
     
     UILabel * backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 267, 375, 100)];
     backLabel.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
     [view addSubview:backLabel];
     
     self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 267, 355, 100)];
     _resultLabel.textAlignment = 2;
     _resultLabel.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
     _resultLabel.font = [UIFont systemFontOfSize:25];
     _resultLabel.numberOfLines = 0;
     
     [view addSubview:_resultLabel];
     
     NSArray * ary = @[@"AC", @"C", @"/", @"*", @"7", @"8", @"9", @"-", @"4", @"5", @"6", @"", @"1", @"2", @"3", @"", @"0", @".", @"=", @"确定"];
     for (int i = 0; i < 20; i++) {
          UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
          [Btn setTitle:ary[i] forState:UIControlStateNormal];
          Btn.tag = i;
          if (i < 4) {
               Btn.frame = CGRectMake((375 / 4 + 1) * i, 367, (375 / 4 + 1), 60);
          } else if (4 <= i && i < 8){
               Btn.frame = CGRectMake((375 / 4 + 1)* (i - 4), 427, (375 / 4 + 1), 60);
          } else if (8 <= i && i < 12){
               Btn.frame = CGRectMake((375 / 4 + 1) * (i - 8), 487, (375 / 4 + 1), 60);
          } else if (12 <= i && i < 16){
               Btn.frame = CGRectMake((375 / 4 + 1) * (i - 12), 547, (375 / 4 + 1), 60);
          } else {
               Btn.frame = CGRectMake((375 / 4 + 1) * (i - 16), 607, (375 / 4 + 1), 60);
          }
          Btn.layer.borderColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1].CGColor;
          Btn.layer.borderWidth = 0.5f;
          [Btn setBackgroundColor:[UIColor whiteColor]];
          [Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          if (i == 0) {
               [Btn addTarget:self action:@selector(handleAC) forControlEvents:UIControlEventTouchUpInside];
          } else if (i == 1) {
               [Btn addTarget:self action:@selector(handleC) forControlEvents:UIControlEventTouchUpInside];
          } else if (i == 2) {
               [Btn addTarget:self action:@selector(handleChu) forControlEvents:UIControlEventTouchUpInside];
          } else if (i == 3) {
               [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               [Btn setBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:159 / 255.0 blue:29 / 255.0 alpha:1]];
               [Btn addTarget:self action:@selector(handleCheng) forControlEvents:UIControlEventTouchUpInside];
               
          } else if (i == 7) {
               [Btn setBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:159 / 255.0 blue:29 / 255.0 alpha:1]];
               [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               [Btn addTarget:self action:@selector(handleJian) forControlEvents:UIControlEventTouchUpInside];
               
          } else if (i == 18) {
               [Btn addTarget:self action:@selector(handleDeng) forControlEvents:UIControlEventTouchUpInside];
          } else if (i == 11) {
               [Btn addTarget:self action:@selector(handleJia) forControlEvents:UIControlEventTouchUpInside];
          } else if (i == 15) {
               [Btn addTarget:self action:@selector(handleJia) forControlEvents:UIControlEventTouchUpInside];
          } else if (i == 19) {
               [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               [Btn setBackgroundColor:[UIColor colorWithRed:32 / 255.0 green:178 / 255.0 blue:254 / 255.0 alpha:1]];
               [Btn addTarget:self action:@selector(handleOK) forControlEvents:UIControlEventTouchUpInside];
               
          } else {
               [Btn addTarget:self action:@selector(handleNumber:) forControlEvents:UIControlEventTouchUpInside];
          }
          [view addSubview:Btn];
     }
     
     UIButton * Jia = [UIButton buttonWithType:UIButtonTypeSystem];
     Jia.frame = CGRectMake((375 / 4 + 1) * 3, 487, 375 / 4 + 1, 120);
     Jia.layer.borderColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1].CGColor;
     Jia.layer.borderWidth = 0.5f;
     [Jia setBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:159 / 255.0 blue:29 / 255.0 alpha:1]];
     [Jia setTitle:@"+" forState:UIControlStateNormal];
     [Jia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [Jia addTarget:self action:@selector(handleJia) forControlEvents:UIControlEventTouchUpInside];
     [view addSubview:Jia];
}

- (void)handleAction4
{
     [[self.view viewWithTag:904] removeFromSuperview];
     [_pickerVC1 removeFromSuperview];
}

- (void) handleAC
{
     _code2 = 0;
     _sumCode = @"0";
     _resultLabel.text = _sumCode;
}

- (void) handleJian
{
     _code2 = 0;
     if ([_sumCode isEqualToString:@"0"]) {
          _sumCode = @"0";
          _resultLabel.text = _sumCode;
     } else {
          NSString * last = [_sumCode substringFromIndex:_sumCode.length - 1];
          if ([last isEqualToString:@"-"] || [last isEqualToString:@"+"] || [last isEqualToString:@"*"] || [last isEqualToString:@"/"]){
               
          } else {
               _sumCode = [NSString stringWithFormat:@"%@-", _sumCode];
               _resultLabel.text = _sumCode;
          }
     }
}

- (void) handleJia
{
     _code2 = 0;
     if ([_sumCode isEqualToString:@"0"]) {
          _sumCode = @"0";
          _resultLabel.text = _sumCode;
     } else {
          NSString * last = [_sumCode substringFromIndex:_sumCode.length - 1];
          if ([last isEqualToString:@"-"] || [last isEqualToString:@"+"] || [last isEqualToString:@"*"] || [last isEqualToString:@"/"]){
               
          } else {
               _sumCode = [NSString stringWithFormat:@"%@+", _sumCode];
               _resultLabel.text = _sumCode;
          }
     }
}

- (void) handleChu
{
     _code2 = 0;
     if ([_sumCode isEqualToString:@"0"]) {
          _sumCode = @"0";
          _resultLabel.text = _sumCode;
     } else {
          NSString * last = [_sumCode substringFromIndex:_sumCode.length - 1];
          if ([last isEqualToString:@"-"] || [last isEqualToString:@"+"] || [last isEqualToString:@"*"] || [last isEqualToString:@"/"]){
               
          } else {
               _sumCode = [NSString stringWithFormat:@"%@/", _sumCode];
               _resultLabel.text = _sumCode;
          }
     }
     
}

- (void) handleCheng
{
     _code2 = 0;
     if ([_sumCode isEqualToString:@"0"]) {
          _sumCode = @"0";
          _resultLabel.text = _sumCode;
     } else {
          NSString * last = [_sumCode substringFromIndex:_sumCode.length - 1];
          if ([last isEqualToString:@"-"] || [last isEqualToString:@"+"] || [last isEqualToString:@"*"] || [last isEqualToString:@"/"]){
               
          } else {
               _sumCode = [NSString stringWithFormat:@"%@*", _sumCode];
               _resultLabel.text = _sumCode;
          }
     }
     
}

- (void) handleDeng
{
     NSString * sum = [FormulaStringCalcUtility calcComplexFormulaString:_resultLabel.text];
     _code2 = 1;
     _sumCode = sum;
     _resultLabel.text = _sumCode;
}

- (void) handleC
{
     _code2 = 0;
     if (_sumCode.length == 1) {
          NSString * sum = [_sumCode substringToIndex:[_sumCode length] - 1];
          _sumCode = @"0";
          _resultLabel.text = _sumCode;
     } else {
          NSString * sum = [_sumCode substringToIndex:[_sumCode length] - 1];
          _sumCode = sum;
          _resultLabel.text = _sumCode;
     }
}

- (void) handleOK
{
     [[self.view viewWithTag:904] removeFromSuperview];
     [_pickerVC1 removeFromSuperview];
     
     _code2 = 0;
     NSString * sum = [FormulaStringCalcUtility calcComplexFormulaString:_resultLabel.text];
     NSLog(@"最终值:%@", sum);

     _ortherLabel.text = [NSString stringWithFormat:@"+%.2f", [sum floatValue]];
     _sumLabel.text = [NSString stringWithFormat:@"总计: %.2f", [_ortherLabel.text floatValue] + [_contentLabel.text floatValue]];
}

- (void) handleNumber:(UIButton *) sender
{
     if ([_sumCode isEqualToString:@"0"]) {
          _sumCode = [NSString stringWithFormat:@"%@", sender.titleLabel.text];
          _resultLabel.text = _sumCode;
     } else {
          if (_code2 == 1) {
               _sumCode = [NSString stringWithFormat:@"%@", sender.titleLabel.text];
               _resultLabel.text = _sumCode;
               _code2 = 0;
          } else {
               _sumCode = [NSString stringWithFormat:@"%@%@", _sumCode, sender.titleLabel.text];
               _resultLabel.text = _sumCode;
          }
     }
}


@end
