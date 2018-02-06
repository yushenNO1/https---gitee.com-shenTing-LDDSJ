//
//  addGoodsVC.m
//  供应商
//
//  Created by 张敬文 on 2017/7/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "addGoodsVC.h"
#import "CloverText.h"
#import "AddGoodsCell.h"
#import "AddGoodsCell1.h"
#import "FreightVC.h"
#import "GoodsDetailVC.h"
#import "AddImageVC.h"
#import "AddModel.h"
#import "ChooseProCell.h"
@interface addGoodsVC ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
//轮播
@property (nonatomic, strong) NSMutableArray * ChooseProAry;
@property (nonatomic, strong) NSMutableArray * ChooseProIdAry;
@property (nonatomic, strong) NSMutableArray * ChooseProStatusAry;
@property (nonatomic, strong) UIView * PickVC;  //弹窗
@property (nonatomic, strong) UITableView * CitytableView;
@property (nonatomic, strong) SDCycleScrollView * SDCycleScrollView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) CloverText * textField_1;
@property (nonatomic, strong) CloverText * textField_2;
@property (nonatomic, strong) UIButton * addBtn;
@property (nonatomic, strong) UIButton * ImageBtn;
@property (nonatomic, strong) NSArray * ImageAry;
@property (nonatomic, strong) NSArray * ImageIdAry;
@property (nonatomic, strong) NSMutableArray * ImageOneAry;
@property (nonatomic, strong) NSMutableArray * dataAry;
@property (nonatomic, assign) int index;
@property (nonatomic, copy) NSString * transport_id;
@property (nonatomic, copy) NSString * contentIds;
@property (nonatomic, strong) NSArray * contentAry;  //商品详情请求内容数据
@property (nonatomic, strong) NSArray * content1Ary;  //商品详情中途转换内容数据
@property (nonatomic, copy) NSString * imageIds;
@property (nonatomic, strong) NSString * imgStrArr;       //图片标题
@property (nonatomic, copy) NSString * barCode;
@property (nonatomic, copy) NSString * cateIds;
@property (nonatomic, copy) NSString * cateNames;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * keyword;
@property (nonatomic, copy) NSString * categoryName;
@property (nonatomic, copy) NSString * transportName;
@property (nonatomic, assign) NSInteger Catepage;
@property (nonatomic, assign) NSInteger CateOneIndex;
@property (nonatomic, assign) NSInteger CateTwoIndex;
@end

@implementation addGoodsVC
-(NSMutableArray *)ChooseProAry {
     if (!_ChooseProAry) {
          _ChooseProAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _ChooseProAry;
}

-(NSMutableArray *)ImageOneAry {
     if (!_ImageOneAry) {
          _ImageOneAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _ImageOneAry;
}

-(NSMutableArray *)ChooseProIdAry {
     if (!_ChooseProIdAry) {
          _ChooseProIdAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _ChooseProIdAry;
}

-(NSMutableArray *)ChooseProStatusAry {
     if (!_ChooseProStatusAry) {
          _ChooseProStatusAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _ChooseProStatusAry;
}

-(NSMutableArray *)dataAry {
     if (!_dataAry) {
          _dataAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _dataAry;
}



- (void)viewWillAppear:(BOOL)animated
{
     
     self.navigationController.navigationBar.translucent = YES;
     
     if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
          self.automaticallyAdjustsScrollViewInsets = NO;
     }
     
     _barCode = @"";
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reValue4:) name:@"imageIds" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reValue1:) name:@"Image" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reValue2:) name:@"detail" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reValue3:) name:@"freight" object:nil];
}

- (void)reValue2:(NSNotification * )notifi{
     _contentIds = @"";
     _contentIds = [NSString stringWithFormat:@"%@", notifi.userInfo[@"detail"]];
     _content1Ary = notifi.userInfo[@"data"];
}

- (void)reValue3:(NSNotification * )notifi{
     _transport_id = @"";
     _transport_id = [NSString stringWithFormat:@"%@", notifi.userInfo[@"freight"]];
     UILabel * label = [self.view viewWithTag:90002];
     label.text = [NSString stringWithFormat:@"%@", notifi.userInfo[@"name"]];
}
- (void)reValue4:(NSNotification * )notifi{
     self.imgStrArr = notifi.userInfo[@"imageIds"];
}
- (void)reValue1:(NSNotification * )notifi{
     _imageIds = @"";
    self.ImageAry = notifi.userInfo[@"image"];
    self.ImageIdAry = notifi.userInfo[@"id"];
     
     for (NSString * str in _ImageIdAry) {
          _imageIds = [NSString stringWithFormat:@"%@%@,", _imageIds, str];
     }
    if (_ImageAry.count == 0) {
        _ImageBtn.frame = WDH_CGRectMake(0, 0, 375, 170);
        [_ImageBtn setBackgroundImage:[UIImage imageNamed:@"添加商品22"] forState:UIControlStateNormal];
    } else {
        _ImageBtn.frame = WDH_CGRectMake(300, 25, 50, 50);
         [_ImageBtn setBackgroundImage:[UIImage imageNamed:@"添加商品图片2"] forState:UIControlStateNormal];
         UIView * backView = [self.view viewWithTag:200];
         NSLog(@"%ld", _ImageAry.count);
         self.SDCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:WDH_CGRectMake(0, 0, 375, 170) imageNamesGroup:[NSArray arrayWithArray:_ImageAry]];
         _SDCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
         _SDCycleScrollView.showPageControl = YES;
         _SDCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
         _SDCycleScrollView.autoScrollTimeInterval = 3.0;
         _SDCycleScrollView.currentPageDotColor = [UIColor colorWithRed:250 / 255.0 green:47 / 255.0 blue:91 / 255.0 alpha:1];
         _SDCycleScrollView.pageDotColor = [UIColor colorWithRed:117 / 255.0 green:117 / 255.0 blue:117 / 255.0 alpha:1];
         _SDCycleScrollView.pageControlDotSize = CGSizeMake(6 * kScreenWidth1, 6 * kScreenHeight1);
         [backView addSubview:_SDCycleScrollView];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
     self.navigationController.navigationBar.translucent = YES;
     
     if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
          self.automaticallyAdjustsScrollViewInsets = YES;
     }
}


- (void)viewDidLoad {
    [super viewDidLoad];
     
     
     _name = @"";
     _keyword = @"";
     _imageIds = @"";
     _contentIds = @"";
     _transport_id = @"";
     _cateIds = @"";
     _barCode = @"";
     [self setNavigationBarConfiguer];
     if ([_goodId isEqualToString:@"="]) {
          //新增状态
          if ([_typeStr isEqualToString:@"1"]) {
               NSDictionary * dic = @{@"name":@"", @"price":@"", @"stock":@"", @"mAccount":@"", @"type":@"1"};
               AddModel * model = [AddModel addWithDictionary:dic];
               [self.dataAry addObject:model];
               [self configView];
          }else{
               NSDictionary * dic = @{@"name":@"", @"price":@"", @"stock":@"", @"mAccount":@"", @"orders":@"", @"fen":@"", @"deduction":@"", @"type":@"2"};
               AddModel * model = [AddModel addWithDictionary:dic];
               [self.dataAry addObject:model];
               [self configView];
          }
          
     } else {
          //编辑状态
          [self request];
     }
     
    self.view.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    self.title = @"添加商品";
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifikation:) name:UIKeyboardWillChangeFrameNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
     
     UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
     
     [self.tableView addGestureRecognizer:myTap];
}

-(void)keyboardWillHide {
     self.tableView.frame = WDH_CGRectMake(0, 64, 375, 603);
}

- (void)scrollTap:(id)sender {
     [self.view endEditing:YES];
}



-(void)notifikation:(NSNotification *)sender
{
     CGRect rect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
     self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, rect.origin.y);
     NSLog(@"键盘大小------%@",sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
}

- (void) initData {
     
}

- (void)setNavigationBarConfiguer {
     [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
     UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(requestAll)];
     self.navigationItem.rightBarButtonItem = rightBarButtonItem;
     UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
     self.navigationItem.leftBarButtonItem = item;
     
     
}

- (void) leftBarBtnClick {
     [self.navigationController popViewControllerAnimated:YES];
}


- (void) request {
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     NSURL* url = [NSURL URLWithString:GYSGoodDetail];
     // 请求
     NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
     // 超时
     request.timeoutInterval = 10;
     // 请求方式
     request.HTTPMethod = @"POST";
     
     // 设置请求体和参数
     // 创建一个描述订单的JSON数据
     NSDictionary* orderInfo = @{@"millId":_millId,
                                 @"goodId":_goodId};
     // OC对象转JSON
     NSData* json = [NSJSONSerialization dataWithJSONObject:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
     // 设置请求头
     
     // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
     //     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setValue:str forHTTPHeaderField:@"Authorization"];
     
     request.HTTPBody = json;
     
     [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
          
          if (data) {
               NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
               NSLog(@"编辑商品获取商品详情信息%@", dic);
               //处理
               _imageIds = @"";
               _contentIds = @"";
               _transport_id = @"";
               _cateIds = @"";
               _barCode = @"";
               
               NSDictionary * dataDic = dic[@"data"];
               _textField_1.textField.text = @"";
               _textField_2.textField.text = @"";
               _name = [NSString stringWithFormat:@"%@", dataDic[@"goodName"]];
               _keyword = [NSString stringWithFormat:@"%@", dataDic[@"keyWord"]];
               _categoryName = [NSString stringWithFormat:@"%@", dataDic[@"categoryName"]];
               _transportName = [NSString stringWithFormat:@"%@", dataDic[@"transportName"]];
               if ([[dataDic[@"parameterList"] class] isEqual:[NSNull class]]) {
                    
               }else if (dataDic[@"parameterList"]==nil){
                    
               }else{
                    
                    NSArray * ary = dataDic[@"parameterList"];
                    for (NSDictionary * dataDic in ary) {
                         if ([dataDic[@"type"] intValue] == 1) {
                              NSDictionary * dic = @{@"name":[NSString stringWithFormat:@"%@", dataDic[@"name"]], @"price":[NSString stringWithFormat:@"%.2f", [dataDic[@"price"] doubleValue]], @"stock":[NSString stringWithFormat:@"%@", dataDic[@"stock"]], @"mAccount":[NSString stringWithFormat:@"%.2f", [dataDic[@"mAccount"]doubleValue] ],@"type":dataDic[@"type"]};
                              AddModel * model = [AddModel addWithDictionary:dic];
                              [self.dataAry addObject:model];
                         }else{
                              NSDictionary * dic = @{@"name":[NSString stringWithFormat:@"%@", dataDic[@"name"]], @"price":[NSString stringWithFormat:@"%.2f", [dataDic[@"price"] doubleValue]], @"stock":[NSString stringWithFormat:@"%@", dataDic[@"stock"]], @"mAccount":[NSString stringWithFormat:@"%.2f", [dataDic[@"mAccount"]doubleValue] ], @"fen":[NSString stringWithFormat:@"%.2f",[dataDic[@"fen"]doubleValue] * 100],@"deduction":dataDic[@"deduction"],@"type":dataDic[@"type"]};
                              AddModel * model = [AddModel addWithDictionary:dic];
                              [self.dataAry addObject:model];
                         }
                         
                    }
               }
               
               _transport_id = [NSString stringWithFormat:@"%@", dataDic[@"transportId"]];
               _cateIds = [NSString stringWithFormat:@"%@", dataDic[@"goodsCategoryId"]];
               
               
               if ([[dataDic[@"goodContentList"] class] isEqual:[NSNull class]]) {
                    
               }else if (dataDic[@"goodContentList"]==nil){
                    
               }else{
                    self.contentAry = dataDic[@"goodContentList"];
                    NSMutableArray * data = [NSMutableArray arrayWithCapacity:1];
                    for (NSDictionary * dic in _contentAry) {
                         [data addObject:[NSString stringWithFormat:@"%@", dic[@"id"]]];
                    }
                    NSArray * ary = [NSArray arrayWithArray:data];
                    for (NSString * str in ary) {
                         _contentIds = [NSString stringWithFormat:@"%@%@,", _contentIds, str];
                    }
               }
               
               if ([[dataDic[@"goodImageList"] class] isEqual:[NSNull class]]) {
                    
               }else if (dataDic[@"goodImageList"]==nil){
                    
               }else{
                    NSArray * ary = dataDic[@"goodImageList"];
                    NSLog(@"图片都有啥---%@",ary);
                    NSMutableArray * data = [NSMutableArray arrayWithCapacity:1];
                    
                   
                    int index = 0;
                    for (NSDictionary * dic in ary) {
                         [self.ImageOneAry addObject:[NSString stringWithFormat:@"%@", dic[@"thumbnail"]]];
                         [data addObject:[NSString stringWithFormat:@"%@", dic[@"id"]]];
                         if (index == 0) {
                              _imgStrArr = dic[@"id"];
                         }else{
                              _imgStrArr = [NSString stringWithFormat:@"%@,%@",_imgStrArr,dic[@"id"]];
                         }
                         index ++;
                    }
                    
                    
                    _ImageIdAry = [NSArray arrayWithArray:data];
                    for (NSString * str in _ImageIdAry) {
                         _imageIds = [NSString stringWithFormat:@"%@%@,", _imageIds, str];
                    }
               }
               
               
               [self configView];
          } else {
               
               Alert_Show(@"请求失败")
          }
          
          
     }];

}

- (void)  requestAll{
     [self.view endEditing:YES];
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     NSURL* url = [NSURL URLWithString:GYSGoodAll];
     // 请求
     NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
     // 超时
     request.timeoutInterval = 10;
     // 请求方式
     request.HTTPMethod = @"POST";
     
     
     NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
     for (AddModel * model in _dataAry) {
          if ([_typeStr isEqualToString:@"1"]) {
               NSDictionary * dic = @{@"name":model.name, @"price":model.price, @"stock":model.stock, @"mAccount":model.mAccount, @"orders":@"",@"type":@"1"};
               [ary addObject:dic];
          }else{
              //分润去掉;
//               NSDictionary * dic = @{@"name":model.name, @"price":model.price, @"stock":model.stock, @"mAccount":model.mAccount, @"orders":@"",@"fen":model.fen,@"deduction":model.deduction,@"type":@"2"};
              NSDictionary * dic = @{@"name":model.name, @"price":model.price, @"stock":model.stock, @"mAccount":model.mAccount, @"orders":@"",@"deduction":model.deduction,@"type":@"2"};
               [ary addObject:dic];
          }
          
     }
     // 设置请求体和参数
     
     NSString * operaType = @"";
     NSString * goodId = @"";
     if ([_goodId isEqualToString:@"="]) {
          operaType = @"1";
          goodId = @"";
     } else {
          operaType = @"2";
          goodId = _goodId;
     }
     NSLog(@"_imgStrArr---%@",_imgStrArr);
     // 创建一个描述订单的JSON数据
     NSDictionary* orderInfo = @{@"goodId":goodId,
                                 @"operaType":operaType,
                                 @"imageIds":_imgStrArr,    //轮播Id
                                 @"contentIds": _contentIds,   //详情Id
                                 @"name":_textField_1.text,
                                 @"keyWord":_textField_2.text,
                                 @"millId":_millId,
                                 @"transport_id":_transport_id,   //模板Id
                                 @"prameterList":ary,
                                 @"goodsCategoryId":_cateIds,
                                 @"barCode":_barCode,
                                 @"profile":@"",
                                 @"type":_typeStr
                                 };
     
     NSLog(@"+++++添加商品内容信息%@", orderInfo);
     // OC对象转JSON
     
     
     NSData* json = [NSJSONSerialization dataWithJSONObject:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
     // 设置请求头
     
     // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
     //     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setValue:str forHTTPHeaderField:@"Authorization"];
     
     request.HTTPBody = json;
     
     if ([_imageIds isEqualToString:@""]) {
          Alert_Show(@"您还没有选择商品轮播图片");
     } else if ([_contentIds isEqualToString:@""]) {
          Alert_Show(@"您还没有编辑商品详情页");
     } else if ([_textField_1.text isEqualToString:@""]) {
          Alert_Show(@"您还没有填写商品名称");
     } else if ([_textField_2.text isEqualToString:@""]) {
          Alert_Show(@"您还没有填写商品关键字");
     } else if ([_cateIds isEqualToString:@""]) {
          Alert_Show(@"您还没有选择商品分类");
     } else if ([_transport_id isEqualToString:@""]) {
          Alert_Show(@"您还没有选择运费模板");
     } else {
          int i = 0;
          for (NSDictionary * dic in ary) {
               if ([dic[@"price"] floatValue] / 2 > [dic[@"mAccount"] floatValue]) {
                    i = 1;
                    break;
               } else if ([dic[@"price"] isEqualToString:@""] || [dic[@"stock"] isEqualToString:@""] || [dic[@"mAccount"] isEqualToString:@""] || [dic[@"name"] isEqualToString:@""]) {
                    i = 2;
                    break;
               }
          }
          if (i == 1) {
               Alert_Show(@"商品的成本不能低于商品价格的50%")
          } else if (i == 1) {
               Alert_Show(@"商品规格信息填写不完整")
          } else {
               [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    if (data) {
                         NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                         NSLog(@"-----添加商品结果信息%@", dic);
                         if ([dic[@"code"] intValue] == 0) {
                              [self.navigationController popViewControllerAnimated:YES];
                         } else {
                              NSString * str = [NSString stringWithFormat:@"%@", dic[@"message"]];
                              Alert_Show(str)
                         }
                         
                    } else {
                         NSLog(@"-----添加商品结果信息%@", connectionError);
                         
                    }
               }];
          }
     }
     
     

}

- (void) configView {
    self.tableView = [[UITableView alloc]initWithFrame:WDH_CGRectMake(0, 64, 375, 603) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
     if ([_typeStr isEqualToString:@"1"]) {
          _tableView.rowHeight = 228;
     }else{
          _tableView.rowHeight = 283;
     }
    
    [self.view addSubview:_tableView];
    [_tableView registerClass:[AddGoodsCell class] forCellReuseIdentifier:@"11"];
    [_tableView registerClass:[AddGoodsCell1 class] forCellReuseIdentifier:@"22"];
    UIView * headView = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 0, 375, 340)];
    headView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    _tableView.tableHeaderView = headView;
    
    UIView * imageView = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 0, 375, 170)];
    imageView.tag = 200;
    [headView addSubview:imageView];
    
     
     self.ImageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
     if ([_goodId isEqualToString:@"="]) {
          if (_ImageAry.count == 0) {
               _ImageBtn.frame = WDH_CGRectMake(0, 0, 375, 170);
               [_ImageBtn setBackgroundImage:[UIImage imageNamed:@"添加商品22"] forState:UIControlStateNormal];
          } else {
               _ImageBtn.frame = WDH_CGRectMake(300, 25, 50, 50);
               [_ImageBtn setBackgroundImage:[UIImage imageNamed:@"添加商品图片2"] forState:UIControlStateNormal];
          }
     } else {
          if ([[_ImageAry class] isEqual:[NSNull class]] || _ImageAry == nil || _ImageAry.count == 0) {
               self.SDCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:WDH_CGRectMake(0, 0, 375, 170) imageURLStringsGroup:[NSArray arrayWithArray:_ImageOneAry]];
               _SDCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
               _SDCycleScrollView.showPageControl = YES;
               _SDCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
               _SDCycleScrollView.autoScrollTimeInterval = 3.0;
               _SDCycleScrollView.currentPageDotColor = [UIColor colorWithRed:250 / 255.0 green:47 / 255.0 blue:91 / 255.0 alpha:1];
               _SDCycleScrollView.pageDotColor = [UIColor colorWithRed:117 / 255.0 green:117 / 255.0 blue:117 / 255.0 alpha:1];
               _SDCycleScrollView.pageControlDotSize = CGSizeMake(6 * kScreenWidth1, 6 * kScreenHeight1);
               [imageView addSubview:_SDCycleScrollView];
               _ImageBtn.frame = WDH_CGRectMake(300, 25, 50, 50);
               [_ImageBtn setBackgroundImage:[UIImage imageNamed:@"添加商品图片2"] forState:UIControlStateNormal];
          } else {
               self.SDCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:WDH_CGRectMake(0, 0, 375, 170) imageNamesGroup:[NSArray arrayWithArray:_ImageAry]];
               _SDCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
               _SDCycleScrollView.showPageControl = YES;
               _SDCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
               _SDCycleScrollView.autoScrollTimeInterval = 3.0;
               _SDCycleScrollView.currentPageDotColor = [UIColor colorWithRed:250 / 255.0 green:47 / 255.0 blue:91 / 255.0 alpha:1];
               _SDCycleScrollView.pageDotColor = [UIColor colorWithRed:117 / 255.0 green:117 / 255.0 blue:117 / 255.0 alpha:1];
               _SDCycleScrollView.pageControlDotSize = CGSizeMake(6 * kScreenWidth1, 6 * kScreenHeight1);
               [imageView addSubview:_SDCycleScrollView];
               _ImageBtn.frame = WDH_CGRectMake(300, 25, 50, 50);
               [_ImageBtn setBackgroundImage:[UIImage imageNamed:@"添加商品图片2"] forState:UIControlStateNormal];
          }
     }
    [_ImageBtn addTarget:self action:@selector(handleImage) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_ImageBtn];
    
    self.textField_1 = [[CloverText alloc]initWithFrame:WDH_CGRectMake(10, 180, 355, 70) placeholder:@"请填写商品名称"];
    _textField_1.font = [UIFont systemFontOfSize:17];
    _textField_1.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
     if (_name.length == 0) {
          
     } else {
          _textField_1.textField.text = @"";
          _textField_1.text = _name;
          
     }
     _textField_1.delegate = self;
    _textField_1.layer.borderWidth = 1.0f;
    [headView addSubview:_textField_1];
    
    self.textField_2 = [[CloverText alloc]initWithFrame:WDH_CGRectMake(10, 260, 355, 70) placeholder:@"请填写商品关键字"];
    _textField_2.font = [UIFont systemFontOfSize:17];
    _textField_2.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
     if (_keyword.length == 0) {
          
     } else {
          _textField_2.textField.text = @"";
          _textField_2.text = _keyword;
          
     }
     _textField_2.delegate = self;
    _textField_2.layer.borderWidth = 1.0f;
    [headView addSubview:_textField_2];
    
    UIView * headView1 = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 0, 375, 210)];
    headView1.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    _tableView.tableFooterView = headView1;
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"添加商品型号 "] forState:UIControlStateNormal];
    _addBtn.frame = CGRectMake(225, 5, 130, 20);
    [_addBtn addTarget:self action:@selector(handleAdd) forControlEvents:UIControlEventTouchUpInside];
    [headView1 addSubview:_addBtn];
    
    NSArray * ary = @[@"商品详情", @"分类", @"运费模板"];
     NSArray * ary1;
     if ([_goodId isEqualToString:@"="]) {
          //新增状态
          ary1 = @[@"", @"请选择分类", @"请选择模板"];
     } else {
          //编辑状态
          ary1 = @[@"", _categoryName, _transportName];
     }
     
    for (int i = 0; i < 3; i++) {
        UILabel * backLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(-1, 40 + i * 55, 377, 50)];
        backLabel.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;;
        backLabel.layer.borderWidth = 1.0f;
        backLabel.backgroundColor = [UIColor whiteColor];
        [headView1 addSubview:backLabel];
        
        UILabel * leftLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(15, 40 + i * 55, 100, 50)];
        leftLabel.text = ary[i];
        leftLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
        [headView1 addSubview:leftLabel];
         
         UILabel * rightLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(130, 40 + i * 55, 210, 50)];
         rightLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
         rightLabel.textAlignment = 2;
         rightLabel.text = ary1[i];
         rightLabel.tag = 90000 + i;
         [headView1 addSubview:rightLabel];
         
         UIImageView * rightImage = [[UIImageView alloc] initWithFrame:WDH_CGRectMake(350, 55 + i * 55, 8, 20)];
         rightImage.image = [UIImage imageNamed:@"添加商品分类"];
         [headView1 addSubview: rightImage];
        
        UIButton * clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        clearBtn.backgroundColor = [UIColor clearColor];
        clearBtn.tag = 100 + i;
        clearBtn.frame = WDH_CGRectMake(0, 40 + i * 55, 375, 50);
        [clearBtn addTarget:self action:@selector(handleGo:) forControlEvents:UIControlEventTouchUpInside];
        [headView1 addSubview:clearBtn];
    }
}

- (void)textViewDidChange:(CloverText *)textView
{
     if (textView.text.length == 0) {
          textView.textField.hidden = NO;
     }
     else {
          textView.textField.hidden = YES;
     }
}

- (void) handleGo:(UIButton *) sender
{
    if (sender.tag == 100) {
        //商品详情
        GoodsDetailVC * zjwVC = [[GoodsDetailVC alloc] init];
         //新增 =
         if ([_goodId isEqualToString:@"="]) {
              
              if (_content1Ary.count != 0) {
                   NSLog(@"%@", _content1Ary);
                   zjwVC.dataAry = _content1Ary;
                   zjwVC.type = @"2";
                   zjwVC.goodId = @"-";
              } else {
                   zjwVC.type = @"1";
                   zjwVC.goodId = @"=";
              }
         } else {
              zjwVC.goodId = _goodId;
              if (_content1Ary.count != 0) {
                   zjwVC.dataAry = _content1Ary;
                   zjwVC.type = @"2";
              } else {
                   zjwVC.dataAry = _contentAry;
                   zjwVC.type = @"1";
              }
         }
        [self.navigationController pushViewController:zjwVC animated:YES];
    } else if (sender.tag == 101) {
        //分类选择弹窗
         [self requestCate];
    } else if (sender.tag == 102) {
        //运费模板
        FreightVC * zjwVC = [[FreightVC alloc] init];
         zjwVC.millId = _millId;
        [self.navigationController pushViewController:zjwVC animated:YES];
    }
}

- (void) handleImage {
    //添加轮播图
    AddImageVC * zjwVC = [[AddImageVC alloc] init];
    [self.navigationController pushViewController:zjwVC animated:YES];
}

- (void) handleAdd {
     if ([_typeStr isEqualToString:@"1"]){
          NSDictionary * dic = @{@"name":@"", @"price":@"", @"stock":@"", @"mAccount":@"", @"type":@"1"};
          AddModel * model = [AddModel addWithDictionary:dic];
          [self.dataAry addObject:model];
          [self.tableView reloadData];
     }else{
          NSDictionary * dic = @{@"name":@"", @"price":@"", @"stock":@"", @"mAccount":@"", @"orders":@"", @"fen":@"", @"deduction":@"", @"type":@"2"};
          AddModel * model = [AddModel addWithDictionary:dic];
          [self.dataAry addObject:model];
          [self.tableView reloadData];
     }
     
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (tableView.tag == 222) {
          return _ChooseProAry.count;
     } else {
          return _dataAry.count;
     }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (tableView.tag == 222) {
          UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Choose" forIndexPath:indexPath];
          NSDictionary * dic = _ChooseProAry[indexPath.row];
          cell.textLabel.text = [NSString stringWithFormat:@"%@", dic[@"name"]];
          cell.textLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
          cell.textLabel.font = [UIFont systemFontOfSize:15];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell;
     } else {
          if ([_typeStr isEqualToString:@"1"]) {
               AddGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"11" forIndexPath:indexPath];
               AddModel * model = _dataAry[indexPath.row];
               cell.OneTf.text = model.name;
               cell.OneTf.delegate = self;
               cell.OneTf.tag = 1000 * indexPath.row + 1;
               cell.TwoTf.text = model.price;
               cell.TwoTf.keyboardType = UIKeyboardTypeDecimalPad;
               cell.TwoTf.delegate = self;
               cell.TwoTf.tag = 1000 * indexPath.row + 2;
               cell.ThreeTf.keyboardType = UIKeyboardTypeNumberPad;
               cell.ThreeTf.text = model.stock;
               cell.ThreeTf.delegate = self;
               cell.ThreeTf.tag = 1000 * indexPath.row + 3;
               cell.FourTf.keyboardType = UIKeyboardTypeDecimalPad;
               cell.FourTf.text = model.mAccount;
               cell.FourTf.delegate = self;
               cell.FourTf.tag = 1000 * indexPath.row + 4;
               [cell.FourTf addTarget:self action:@selector(cellFourTf:) forControlEvents:UIControlEventEditingChanged];
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
               return cell;
          }else{
               AddGoodsCell1 * cell = [tableView dequeueReusableCellWithIdentifier:@"22" forIndexPath:indexPath];
               AddModel * model = _dataAry[indexPath.row];
               cell.OneTf.text = model.name;
               cell.OneTf.delegate = self;
               cell.OneTf.tag = 1000 * indexPath.row + 1;
               cell.TwoTf.text = model.price;
               cell.TwoTf.keyboardType = UIKeyboardTypeDecimalPad;
               cell.TwoTf.delegate = self;
               cell.TwoTf.tag = 1000 * indexPath.row + 2;
               cell.ThreeTf.keyboardType = UIKeyboardTypeNumberPad;
               cell.ThreeTf.text = model.stock;
               cell.ThreeTf.delegate = self;
               cell.ThreeTf.tag = 1000 * indexPath.row + 3;
               cell.FourTf.keyboardType = UIKeyboardTypeDecimalPad;
               cell.FourTf.text = model.mAccount;
               cell.FourTf.delegate = self;
               cell.FourTf.tag = 1000 * indexPath.row + 4;
               cell.fiveTf.keyboardType = UIKeyboardTypeNumberPad;
               cell.fiveTf.text = model.fen;
               cell.fiveTf.delegate = self;
               cell.fiveTf.tag = 1000 * indexPath.row + 5;
               cell.SixTf.keyboardType = UIKeyboardTypeDecimalPad;
               cell.SixTf.text = [NSString stringWithFormat:@"%@",model.deduction];
               cell.SixTf.delegate = self;
               cell.SixTf.tag = 1000 * indexPath.row + 6;
               
               [cell.FourTf addTarget:self action:@selector(cellFourTf:) forControlEvents:UIControlEventEditingChanged];
               [cell.fiveTf addTarget:self action:@selector(cellfiveTf:) forControlEvents:UIControlEventEditingChanged];
               [cell.SixTf addTarget:self action:@selector(cellSixTf:) forControlEvents:UIControlEventEditingChanged];
               
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
               return cell;
          }
          

     }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (tableView.tag == 222) {
          NSDictionary * dic = _ChooseProAry[indexPath.row];
          NSArray * ary = dic[@"children"];
          [_ChooseProAry removeAllObjects];
          if (ary.count == 0) {
               _cateIds = [NSString stringWithFormat:@"%@", dic[@"cateId"]];
               _cateNames = [NSString stringWithFormat:@"%@", dic[@"name"]];
               [self pickerViewAction];
          } else {
               UIButton * Btn = [self.view viewWithTag:5999];
               [Btn setTitle:@"返回上一级" forState:UIControlStateNormal];
               for (NSDictionary * dataDic in ary) {
                    [_ChooseProAry addObject:dataDic];
               }
               if (_Catepage == 0) {
                    _CateOneIndex = indexPath.row;
               } else if (_Catepage == 1) {
                    _CateTwoIndex = indexPath.row;
               }
               _Catepage++;
               [self.CitytableView reloadData];
          }
     }
}
-(void)cellFourTf:(UITextField *)sender{
     
}
-(void)cellfiveTf:(UITextField *)sender{
     if ([sender.text intValue]<=0 || [sender.text intValue] > 70) {
          Alert_Show(@"请输入0-70之间的整数")
     }
     
}
-(void)cellSixTf:(UITextField *)sender{
     
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.view endEditing:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
     NSInteger a = textField.tag - textField.tag % 1000;
     if ([_typeStr isEqualToString:@"1"]) {
          AddModel * model = _dataAry[a / 1000];
          if (textField.tag % 1000 == 1) {
               model.name = textField.text;
          } else if (textField.tag % 1000 == 2) {
               model.price = textField.text;
          } else if (textField.tag % 1000 == 3) {
               model.stock = textField.text;
          } else if (textField.tag % 1000 == 4) {
               model.mAccount = textField.text;
          }
          NSLog(@"编辑内容:%@", textField.text);
          
          [_dataAry removeObjectAtIndex:a / 1000];
          [_dataAry insertObject:model atIndex:a / 1000];
     }else{
          AddModel * model = _dataAry[a / 1000];
          if (textField.tag % 1000 == 1) {
               model.name = textField.text;
          } else if (textField.tag % 1000 == 2) {
               model.price = textField.text;
          } else if (textField.tag % 1000 == 3) {
               model.stock = textField.text;
          } else if (textField.tag % 1000 == 4) {
               model.mAccount = textField.text;
          }else if (textField.tag % 1000 == 5) {
               model.fen = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]/100.0];
          }else if (textField.tag % 1000 == 6) {
               model.deduction = textField.text;
          }
          NSLog(@"编辑内容:%@", textField.text);
          
          [_dataAry removeObjectAtIndex:a / 1000];
          [_dataAry insertObject:model atIndex:a / 1000];
     }
     
     return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popOver
{
     
     _PickVC = [[UIView alloc]initWithFrame:WDH_CGRectMake(0, 0, 375, 667)];
     _PickVC.backgroundColor = [UIColor blackColor];
     _PickVC.alpha = 0.5;
     _PickVC.userInteractionEnabled = YES;
     [self.view  addSubview:_PickVC];
     UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewAction)];
     [_PickVC addGestureRecognizer:tap];
     
     UIView * View = [[UIView alloc] initWithFrame:WDH_CGRectMake(40, 110, 295, 430)];
     View.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
     View.layer.cornerRadius = 10;
     View.layer.masksToBounds = YES;
     View.tag = 444;
     [self.view addSubview:View];
     
     self.CitytableView = [[UITableView alloc]initWithFrame:WDH_CGRectMake(0, 50, 295, 330) style:UITableViewStylePlain];
     _CitytableView.backgroundColor = [UIColor whiteColor];
     _CitytableView.delegate = self;
     _CitytableView.dataSource = self;
     _CitytableView.separatorStyle = NO;
     _CitytableView.rowHeight = 50* kScreenHeight1;
     _CitytableView.tag = 222;
     _CitytableView.layer.cornerRadius = 5;
     _CitytableView.layer.masksToBounds = YES;
     [View addSubview:_CitytableView];
     
     [_CitytableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Choose"];
     
     UILabel * textLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 0, 295, 49)];
     textLabel.backgroundColor = [UIColor whiteColor];
     textLabel.text = @"选择分类";
     textLabel.textAlignment = 1;
     textLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     textLabel.font = [UIFont systemFontOfSize:15];
     [View addSubview:textLabel];
     
     UILabel * Label = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 49, 295, 1)];
     Label.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 /255.0 blue:238 / 255.0 alpha:1];
     [View addSubview:Label];
     
     UILabel * Label1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 380, 295, 1)];
     Label1.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 /255.0 blue:238 / 255.0 alpha:1];
     [View addSubview:Label1];
     
     UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
     buyBtn.tag = 5999;
     buyBtn.frame = WDH_CGRectMake(0, 381, 295, 50);
     buyBtn.backgroundColor = [UIColor whiteColor];
     [buyBtn setTitle:@"取消" forState:UIControlStateNormal];
     [buyBtn setTitleColor:[UIColor colorWithRed:253 / 255.0 green:80 / 255.0 blue:114 / 255.0 alpha:1] forState:UIControlStateNormal];
     [buyBtn addTarget:self action:@selector(handleQD) forControlEvents:UIControlEventTouchUpInside];
     [View addSubview:buyBtn];
}

- (void) pickerViewAction {
     [_PickVC removeFromSuperview];
     [[self.view viewWithTag:444] removeFromSuperview];
     UILabel * label = [self.view viewWithTag:90001];
     label.text = _cateNames;
     NSLog(@"选择分类的id串%@--%@", _cateIds, _cateNames);
}

- (void) requestCate {
     [_ChooseProAry removeAllObjects];
     [_ChooseProIdAry removeAllObjects];
     [_ChooseProStatusAry removeAllObjects];
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     NSURL* url = [NSURL URLWithString:GYSCateList];
     // 请求
     NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
     // 超时
     request.timeoutInterval = 10;
     // 请求方式
     request.HTTPMethod = @"GET";
     
     // 设置请求体和参数
     // 创建一个描述订单的JSON数据
//     NSDictionary* orderInfo = @{@"millId":_millId};
     // OC对象转JSON
//     NSData* json = [NSJSONSerialization dataWithJSONObject:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
     // 设置请求头
     
     // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
     //     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setValue:str forHTTPHeaderField:@"Authorization"];
     
//     request.HTTPBody = json;
     
     [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
          
          if (data) {
               NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
               NSLog(@"分类列表信息%@", dic);
               NSArray * ary = dic[@"data"];
               for (NSDictionary * dic1 in ary) {
                    [self.ChooseProAry addObject:dic1];
                    [self.ChooseProIdAry addObject:dic1];
               }
               _Catepage = 0;
               [self popOver];
          } else {
               
          }
          
          
          
     }];

}

- (void) handleQD {
     if (_Catepage == 0) {
          [self pickerViewAction];
     } else if (_Catepage == 1) {
          UIButton * Btn = [self.view viewWithTag:5999];
          [Btn setTitle:@"取消" forState:UIControlStateNormal];
          NSArray * ary = [NSArray arrayWithArray:_ChooseProIdAry];
          [_ChooseProAry removeAllObjects];
          for (NSDictionary * dic in ary) {
               [self.ChooseProAry addObject:dic];
          }
          _Catepage--;
          [self.CitytableView reloadData];
     } else if (_Catepage == 2) {
          NSArray * ary = [NSArray arrayWithArray:_ChooseProIdAry];
          NSDictionary * dic = ary[_CateOneIndex];
          NSArray * dataAry = dic[@"children"];
          [_ChooseProAry removeAllObjects];
          for (NSDictionary * dic in dataAry) {
               [self.ChooseProAry addObject:dic];
          }
          _Catepage--;
          [self.CitytableView reloadData];
     }
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
