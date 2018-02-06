//
//  FreightEditVC.m
//  供应商
//
//  Created by 张敬文 on 2017/7/27.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "FreightEditVC.h"
#import "FreightEditCell.h"
#import "ChooseProCell.h"
#import "FreightModel.h"
@interface FreightEditVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UIView * PickVC;  //弹窗
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITableView * CitytableView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) UIButton * addBtn;
@property (nonatomic, strong) NSMutableArray * dataAry;
@property (nonatomic, strong) NSMutableArray * provinceArray;
@property (nonatomic, strong) NSMutableArray * provinceArrayId;
@property (nonatomic, strong) NSMutableArray * ChooseProAry;
@property (nonatomic, strong) NSMutableArray * ChooseProIdAry;
@property (nonatomic, strong) NSMutableArray * TopProAry;
@property (nonatomic, strong) NSMutableArray * ProAry;
@property (nonatomic, strong) NSMutableArray * TextProAry;
@property (nonatomic, strong) NSMutableArray * DidChooseAry;  //已经选择过的

//最终需要提交的数据
@property (nonatomic, strong) NSMutableArray * PAry;   //待提交数据
@property (nonatomic, strong) NSMutableArray * QAry;   //待提交数据


@property (nonatomic, assign) NSInteger tag;  //当前正在操作的按钮
@end

@implementation FreightEditVC
-(NSMutableArray *)PAry {
     if (!_PAry) {
          _PAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _PAry;
}

-(NSMutableArray *)DidChooseAry {
     if (!_DidChooseAry) {
          _DidChooseAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _DidChooseAry;
}

-(NSMutableArray *)QAry {
     if (!_QAry) {
          _QAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _QAry;
}

-(NSMutableArray *)ChooseProAry {
     if (!_ChooseProAry) {
          _ChooseProAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _ChooseProAry;
}

-(NSMutableArray *)ChooseProIdAry {
     if (!_ChooseProIdAry) {
          _ChooseProIdAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _ChooseProIdAry;
}

-(NSMutableArray *)dataAry {
     if (!_dataAry) {
          _dataAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _dataAry;
}

-(NSMutableArray *)ProAry {
     if (!_ProAry) {
          _ProAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _ProAry;
}

-(NSMutableArray *)TextProAry {
     if (!_TextProAry) {
          _TextProAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _TextProAry;
}

-(NSMutableArray *)TopProAry {
     if (!_TopProAry) {
          _TopProAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _TopProAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];

     
     NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city_full" ofType:@"json"]];
     NSDictionary * dataDic  = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
     _provinceArray = [NSMutableArray arrayWithCapacity:1];
     _provinceArrayId = [NSMutableArray arrayWithCapacity:1];
     for (NSDictionary * dic in dataDic) {
          [_provinceArray addObject:dic[@"name"]];
          [_provinceArrayId addObject:[NSString stringWithFormat:@"%@", dic[@"id"]]];
     }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"编辑模板";
     [self configView];
    _index = 0;
     if ([_type isEqualToString:@"="]) {
          NSArray * ary = @[];
          NSDictionary * dic = @{@"transportId":@"", @"number":@"", @"price":@"", @"addNumber":@"", @"addPrice":@"", @"customTransportAreaList":ary, @"text":@"选择地区", @"Cid":@""};
          FreightModel * model = [FreightModel freWithDictionary:dic];
          [self.dataAry addObject:model];
          [self.tableView reloadData];
     } else {
          [self requestList];
     }
     
    
     [self  setNavigationBarConfiguer];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifikation:) name:UIKeyboardWillChangeFrameNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
     
     UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
     
     [self.tableView addGestureRecognizer:myTap];
}

- (void)scrollTap:(id)sender {
     [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.view endEditing:YES];
}

-(void)keyboardWillHide {
     self.tableView.frame = WDH_CGRectMake(0, 0, 375, 667);
}

-(void)notifikation:(NSNotification *)sender
{
     CGRect rect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
     self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, rect.origin.y);
     NSLog(@"键盘大小------%@",sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
}



- (void) requestList {
     NSString * str7 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     NSURL* url = [NSURL URLWithString:GYSFreDetail];
     // 请求
     NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
     // 超时
     request.timeoutInterval = 10;
     // 请求方式
     request.HTTPMethod = @"POST";
     
     // 设置请求体和参数
     // 创建一个描述订单的JSON数据
     
     NSDictionary* orderInfo = @{@"id":_Id,
                                 @"type":_type};
     NSLog(@"-------%@", orderInfo);
     // OC对象转JSON
     NSData* json = [NSJSONSerialization dataWithJSONObject:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
     // 设置请求头
     
     // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
     //     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setValue:str7 forHTTPHeaderField:@"Authorization"];
     
     request.HTTPBody = json;
     
     [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
          
          
          
          NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city_full" ofType:@"json"]];
          NSDictionary * dataDic1  = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
          NSMutableArray * proAry = [NSMutableArray arrayWithCapacity:1];
          NSMutableArray * proIdAry = [NSMutableArray arrayWithCapacity:1];
          for (NSDictionary * dic in dataDic1) {
               [proAry addObject:[NSString stringWithFormat:@"%@", dic[@"name"]]];
               [proIdAry addObject:[NSString stringWithFormat:@"%@", dic[@"id"]]];
          }
          
          NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
          NSLog(@"模板详情:%@", dic);
          if ([dic[@"code"] intValue] == 0) {
               
          } else {
               NSString * a = [NSString stringWithFormat:@"%@", dic[@"message"]];
               Alert_Show(a);
          }
          
          NSDictionary * dataDic = dic[@"data"];
          if ([[dataDic[@"areaUntransportList"] class] isEqual:[NSNull class]]) {
               
          }else if (dataDic[@"areaUntransportList"]==nil){
               
          }else{
               //有值
               UILabel * Label_1 = [self.view viewWithTag:999998];
               
               NSArray * ary = dataDic[@"areaUntransportList"];
               
               NSMutableArray * ary1 = [NSMutableArray arrayWithCapacity:1];
               NSMutableArray * ary2 = [NSMutableArray arrayWithCapacity:1];
               for (NSDictionary * dic in ary) {
                    [ary1 addObject:[NSString stringWithFormat:@"%@", dic[@"areaId"]]];
               }
               
               for (NSString * str in ary1) {
                    int i = 0;
                    for (NSString * str1 in proIdAry) {
                         if ([str isEqualToString:str1]) {
                              [ary2 addObject:proAry[i]];
                         }
                         i++;
                    }
               }
               
               NSString * str = @"";
               Label_1.text = str;
               for (NSString * str in ary2) {
                    Label_1.text = [NSString stringWithFormat:@"%@ %@", Label_1.text, str];
               }
               NSLog(@"ary1---%@", proIdAry);
               NSLog(@"ary1---%@", ary1);
               NSLog(@"ary2---%@", ary2);
          }
          
          if ([[dataDic[@"customTransportList"] class] isEqual:[NSNull class]]) {
               
          }else if (dataDic[@"customTransportList"]==nil){
               
          }else{
               NSArray * ary = dataDic[@"customTransportList"];
               
               NSMutableArray * ary1 = [NSMutableArray arrayWithCapacity:1];
               NSMutableArray * ary2 = [NSMutableArray arrayWithCapacity:1];
               for (NSDictionary * dic in ary) {
                    [ary1 addObject:[NSString stringWithFormat:@"%@", dic[@"areaId"]]];
                    
                    NSArray * data = dic[@"customTransportAreaList"];
                    [ary2 removeAllObjects];
                    for (NSDictionary * ProDic in data) {
                         int i = 0;
                         for (NSString * str1 in proIdAry) {
                              if ([[NSString stringWithFormat:@"%@", ProDic[@"areaId"]] isEqualToString:str1]) {
                                   [ary2 addObject:proAry[i]];
                              }
                              i++;
                         }
                    }
                    
                    NSString * str3 = @"";
                    for (NSString * str1 in ary2) {
                         str3 = [NSString stringWithFormat:@"%@ %@", str3, str1];
                    }
                    
                    NSDictionary * dic1 = @{@"transportId":_Id, @"number":[NSString stringWithFormat:@"%@", dic[@"number"]], @"price":[NSString stringWithFormat:@"%@", dic[@"price"]], @"addNumber":[NSString stringWithFormat:@"%@", dic[@"addNumber"]], @"addPrice":[NSString stringWithFormat:@"%@", dic[@"addPrice"]], @"customTransportAreaList":data, @"text":str3, @"Cid":[NSString stringWithFormat:@"%@", dic[@"id"]]};
                    FreightModel * model = [FreightModel freWithDictionary:dic1];
                    [self.dataAry addObject:model];
               }
           }
          if ([_viewType intValue] == 2) {
               UITextField * text = [self.view viewWithTag:10086];
               text.text = [NSString stringWithFormat:@"%@", dataDic[@"name"]];
          } else {
               
          }


          [_tableView reloadData];
     }];
}


- (void)setNavigationBarConfiguer {
     [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
     UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction)];
     self.navigationItem.rightBarButtonItem = rightBarButtonItem;
     UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
     self.navigationItem.leftBarButtonItem = item;
}

- (void) leftBarBtnClick {
     [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightBarButtonItemAction {
     [self.view endEditing:YES];
     [self.PAry removeAllObjects];
     [self.QAry removeAllObjects];
     [self.TopProAry removeAllObjects];
     [self.ProAry removeAllObjects];
     NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city_full" ofType:@"json"]];
     NSDictionary * dataDic  = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
     NSMutableArray * proAry = [NSMutableArray arrayWithCapacity:1];
     NSMutableArray * proIdAry = [NSMutableArray arrayWithCapacity:1];
     for (NSDictionary * dic in dataDic) {
          [proAry addObject:dic[@"name"]];
          [proIdAry addObject:[NSString stringWithFormat:@"%@", dic[@"id"]]];
     }

     
     //处理数据
     UILabel * Label_1 = [self.view viewWithTag:999998];
     NSArray * ary = [Label_1.text componentsSeparatedByString:@" "];
     for (int i = 0; i < ary.count; i++) {
          if (i != 0) {
               [self.TopProAry addObject:ary[i]];
          }
     }
     
     NSMutableArray * data9 = [NSMutableArray arrayWithCapacity:1];
     for (NSString * str in _TopProAry) {
          for (int i = 0; i < proAry.count; i++) {
               if ([str isEqualToString:proAry[i]]) {
                    [data9 addObject:proIdAry[i]];
               }
          }
     }
     
     for (NSString * str in data9) {
          NSDictionary * dic = @{@"transportId":@"", @"areaId":str};
          [self.PAry addObject:dic];
     }
     
     
     
     for (int i = 0; i < _dataAry.count; i++) {
          NSMutableArray * data = [NSMutableArray arrayWithCapacity:1];
          UILabel * Label_3 = [self.view viewWithTag:200000 * i + 1];
          NSArray * ary2 = [Label_3.text componentsSeparatedByString:@" "];
          for (int i = 0; i < ary2.count; i++) {
               if (i != 0) {
                    [data addObject:ary2[i]];
               }
          }
          [self.ProAry addObject:data];
     }
     NSMutableArray * data3 = [NSMutableArray arrayWithCapacity:1];
     NSMutableArray * data4 = [NSMutableArray arrayWithCapacity:1];
     int i = 0;
     
     NSLog(@"-*-*-*-*-%@", _ProAry);
     
     
     for (NSMutableArray * data in _ProAry) {
          [data3 removeAllObjects];
          [data4 removeAllObjects];
          for (NSString * str in data) {
               for (int i = 0; i < proAry.count; i++) {
                    if ([str isEqualToString:proAry[i]]) {
                         [data3 addObject:proIdAry[i]];
                    }
               }
          }
          
          for (NSString * str1 in data3) {
               NSDictionary * dic = @{@"areaId":str1};
               [data4 addObject:dic];
               
          }
          FreightModel * model = _dataAry[i];
          NSDictionary * dic1 = @{@"transportId":@"", @"number":model.number, @"price":[NSString stringWithFormat:@"%.2f", [model.price floatValue]], @"addNumber":model.addNumber, @"addPrice":[NSString stringWithFormat:@"%.2f", [model.addPrice floatValue]], @"customTransportAreaList":data4, @"id":model.Cid};
          [self.QAry addObject:dic1];
          i++;
          
     }
     [self request];
}

- (void) request {
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", GYSFreEdit]];
     // 请求
     NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
     // 超时
     request.timeoutInterval = 10;
     // 请求方式
     request.HTTPMethod = @"POST";
     
     // 设置请求体和参数
     // 创建一个描述订单的JSON数据
     NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
     
     NSString * operaType = @"";
     NSString * tranId = @"";
     if ([_type isEqualToString:@"="]) {
          operaType = @"1";
          tranId = @"";
     } else {
          operaType = @"2";
          tranId = _Id;
     }
     
     if ([_type isEqualToString:@"="]) {
          operaType = @"1";
     } else {
          operaType = @"2";
     }

     if ([_viewType intValue] == 2) {
          UITextField * text = [self.view viewWithTag:10086];
          if (text.text.length != 0) {
               NSLog(@"-------%@", _millId);
               [ary removeAllObjects];
               NSDictionary* orderInfo1 = @{@"id":tranId,
                                            @"operaType":operaType,
                                            @"mill_id":_millId,
                                            @"type":@"3",
                                            @"name":text.text,
                                            @"customTransportList":_QAry,
                                            @"areaUntransportList":_PAry};
               
               [ary addObject:orderInfo1];
               NSLog(@"最终提交数据:%@", ary);
               // OC对象转JSON
               NSData* json = [NSJSONSerialization dataWithJSONObject:ary options:NSJSONWritingPrettyPrinted error:nil];
               NSString *strs=[[NSString alloc] initWithData:json
                                                    encoding:NSUTF8StringEncoding];
               // 设置请求头
               NSLog(@"最终提交数据:%@", strs);
               // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
               //     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
               [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
               [request setValue:str forHTTPHeaderField:@"Authorization"];
               
               request.HTTPBody = json;
               
               [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    NSLog(@"请求结果信息%@", dic);
                    if ([dic[@"code"] intValue] == 0) {
                         [self.navigationController popViewControllerAnimated:YES];
                    } else {
                         NSString * str = dic[@"message"];
                         Alert_Show(str)
                    }
                    
                    
               }];
          } else {
               Alert_Show(@"运费模板名称不能为空")
          }
     } else {
          NSDictionary* orderInfo1 = @{@"id":@"",
                                       @"operaType":operaType,
                                       @"mill_id":_millId,
                                       @"type":@"3",
                                       @"name":@"默认模板",
                                       @"customTransportList":_QAry,
                                       @"areaUntransportList":_PAry};
          
          [ary addObject:orderInfo1];
          NSLog(@"最终提交数据:%@", ary);
          // OC对象转JSON
          NSData* json = [NSJSONSerialization dataWithJSONObject:ary options:NSJSONWritingPrettyPrinted error:nil];
          NSString *strs=[[NSString alloc] initWithData:json
                                               encoding:NSUTF8StringEncoding];
          // 设置请求头
          NSLog(@"最终提交数据:%@", strs);
          // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
          //     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
          [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
          [request setValue:str forHTTPHeaderField:@"Authorization"];
          
          request.HTTPBody = json;
          
          [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
               
               NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
               NSLog(@"请求结果信息%@", dic);
               if ([dic[@"code"] intValue] == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
               } else {
                    NSString * str = dic[@"message"];
                    Alert_Show(str)
               }
               
               
          }];
     }
}

- (void) handleChoose:(UIButton *)sender {
     [self popOver:sender.tag];
}


- (void) pickerViewAction {
     [_PickVC removeFromSuperview];
     [[self.view viewWithTag:444] removeFromSuperview];
}

- (void) handleQD {
     [self pickerViewAction];
     UILabel * label = (UILabel *)[self.view viewWithTag:_tag - 1];
     NSString * str = @"";
     label.text = str;
     for (NSString * str in _ChooseProAry) {
          label.text = [NSString stringWithFormat:@"%@ %@", label.text, str];
     }
     
     if (_tag == 999999) {
          
     } else {
          FreightModel * model = _dataAry[(_tag - _tag % 200000) / 200000];
          model.text = label.text;
          [_dataAry removeObjectAtIndex:(_tag - _tag % 200000) / 200000];
          [_dataAry insertObject:model atIndex:(_tag - _tag % 200000) / 200000];
     }
}

- (void) handleAdd {
     
     if ([_viewType isEqualToString:@"1"]) {
          Alert_Show(@"默认模板不支持自定义地区添加, 去建立新模板吧!")
     } else {
          //添加文字
          NSArray * ary = @[];
          NSDictionary * dic = @{@"transportId":@"", @"number":@"", @"price":@"", @"addNumber":@"", @"addPrice":@"", @"customTransportAreaList":ary, @"text":@"选择地区", @"Cid":@""};
          FreightModel * model = [FreightModel freWithDictionary:dic];
          [self.dataAry addObject:model];
          [self.tableView reloadData];
     }
     
     
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     if (tableView.tag == 111) {
          return 1;
     } else {
          return 1;
     }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (tableView.tag == 222) {
          return _provinceArray.count - _DidChooseAry.count;
     } else {
          return _dataAry.count;
     }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (tableView.tag == 222) {
          
          for (NSString * pro in _DidChooseAry) {
               for (int i = 0; i < _provinceArray.count; i++) {
                    if ([pro isEqualToString:_provinceArray[i]]) {
                         [_provinceArray removeObjectAtIndex:i];
                         [_provinceArrayId removeObjectAtIndex:i];
                    }
               }
          }
          
          ChooseProCell * cell = [[ChooseProCell alloc] init];//[tableView dequeueReusableCellWithIdentifier:@"Choose" forIndexPath:indexPath];
          
          for (NSString * str in _ChooseProIdAry) {
               if ([str isEqualToString:_provinceArrayId[indexPath.row]]) {
                    [cell.deleteBtn setBackgroundImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
               }
          }
          
          
          
          cell.DownLabel.text = _provinceArray[indexPath.row];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell;
     } else {
          FreightEditCell * cell = [[FreightEditCell alloc] init];//[tableView dequeueReusableCellWithIdentifier:@"Edit" forIndexPath:indexPath];
          FreightModel * model = _dataAry[indexPath.row];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          cell.OneTf.tag = 1000 * (indexPath.row) + 1;
          cell.OneTf.text = model.number;
          cell.OneTf.delegate = self;
          cell.OneTf.keyboardType = UIKeyboardTypeNumberPad;
          cell.TwoTf.tag = 1000 * (indexPath.row) + 2;
          cell.TwoTf.text = model.price;
          cell.TwoTf.delegate = self;
          cell.TwoTf.keyboardType = UIKeyboardTypeDecimalPad;
          cell.ThreeTf.tag = 1000 * (indexPath.row) + 3;
          cell.ThreeTf.text = model.addNumber;
          cell.ThreeTf.delegate = self;
          cell.ThreeTf.keyboardType = UIKeyboardTypeNumberPad;
          cell.FourTf.tag = 1000 * (indexPath.row) + 4;
          cell.FourTf.text = model.addPrice;
          cell.FourTf.delegate = self;
          cell.FourTf.keyboardType = UIKeyboardTypeDecimalPad;
          cell.proBtn.tag = 200000 * (indexPath.row) + 2;
          [cell.proBtn addTarget:self action:@selector(handleChoose:) forControlEvents:UIControlEventTouchUpInside];
          cell.proLabel_2.tag = 200000 * (indexPath.row) + 1;
          cell.proLabel_2.text = model.text;
          return cell;
     }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (tableView.tag == 222) {
          ChooseProCell * cell = [tableView cellForRowAtIndexPath:indexPath];
          int i = 0;
          for (NSString * str in _ChooseProIdAry) {
               if ([str isEqualToString:_provinceArrayId[indexPath.row]]) {
                    i = 1;
                    break;
               } else {
                    i = 2;
               }
               
          }
          
          if (i == 1) {
               [cell.deleteBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
               [self.ChooseProIdAry removeObject:_provinceArrayId[indexPath.row]];
               [self.ChooseProAry removeObject:_provinceArray[indexPath.row]];
          } else {
               [cell.deleteBtn setBackgroundImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
               [self.ChooseProIdAry addObject:_provinceArrayId[indexPath.row]];
               [self.ChooseProAry addObject:_provinceArray[indexPath.row]];
          }
     }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
     NSLog(@"编辑的是%@---%ld", textField.text, textField.tag);
     NSInteger a = textField.tag % 1000;
     NSInteger b = (textField.tag - a) / 1000;
     NSLog(@"编辑的是第%ld行, 第%ld个", b, a);
     
     FreightModel * model = _dataAry[b];
     if (a == 1) {
          model.number = textField.text;
     } else if (a == 2) {
          model.price = textField.text;
     } else if (a == 3) {
          model.addNumber = textField.text;
     } else if (a == 4) {
          model.addPrice = textField.text;
     }
     NSLog(@"编辑内容:%@", textField.text);
     
     [_dataAry removeObjectAtIndex:b];
     [_dataAry insertObject:model atIndex:b];
     return YES;
}


- (void) requestDelete:(NSString *)string {
    
}

- (void)popOver:(NSInteger)tag
{
     [_ChooseProAry removeAllObjects];
     [_ChooseProIdAry removeAllObjects];
     [_DidChooseAry removeAllObjects];
     NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city_full" ofType:@"json"]];
     NSDictionary * dataDic  = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
     NSMutableArray * proAry = [NSMutableArray arrayWithCapacity:1];
     NSMutableArray * proIdAry = [NSMutableArray arrayWithCapacity:1];
     for (NSDictionary * dic in dataDic) {
          [proAry addObject:dic[@"name"]];
          [proIdAry addObject:[NSString stringWithFormat:@"%@", dic[@"id"]]];
     }
     
     _provinceArray = [NSMutableArray arrayWithCapacity:1];
     _provinceArrayId = [NSMutableArray arrayWithCapacity:1];
     for (NSDictionary * dic in dataDic) {
          [_provinceArray addObject:dic[@"name"]];
          [_provinceArrayId addObject:[NSString stringWithFormat:@"%@", dic[@"id"]]];
     }

     
     NSMutableArray * A = [NSMutableArray arrayWithCapacity:1];
     UILabel * Label_3 = [self.view viewWithTag:tag - 1];
     NSArray * ary3 = [Label_3.text componentsSeparatedByString:@" "];
     for (int i = 0; i < ary3.count; i++) {
          if (i != 0) {
               [A addObject:ary3[i]];
          }
     }

     NSMutableArray * A1 = [NSMutableArray arrayWithCapacity:1];
     //处理数据
     UILabel * Label_1 = [self.view viewWithTag:999998];
     NSArray * ary = [Label_1.text componentsSeparatedByString:@" "];
     for (int i = 0; i < ary.count; i++) {
          if (i != 0) {
               [A1 addObject:ary[i]];
          }
     }

     NSMutableArray * datachoose = [NSMutableArray arrayWithCapacity:1];
     for (int i = 0; i < _dataAry.count; i++) {
          NSMutableArray * data = [NSMutableArray arrayWithCapacity:1];
          UILabel * Label_3 = [self.view viewWithTag:200000 * i + 1];
          NSArray * ary2 = [Label_3.text componentsSeparatedByString:@" "];
          for (int i = 0; i < ary2.count; i++) {
               if (i != 0) {
                    [data addObject:ary2[i]];
               }
          }
          
          NSArray * ary = [NSArray arrayWithArray:data];
          
          [datachoose addObject:ary];
     }
     NSArray * ary1 = [NSArray arrayWithArray:A1];
     [datachoose addObject:ary1];

     for (NSArray * ary in datachoose) {
          for (NSString * str in ary) {
               [self.DidChooseAry addObject:str];
          }
     }
     
     for (NSString * str in A) {
          for (int i = 0; i < _DidChooseAry.count; i++) {
               if ([str isEqualToString:_DidChooseAry[i]]) {
                    [_DidChooseAry removeObjectAtIndex:i];
               }
          }
     }
     NSLog(@"已经选择为*-----%@", _DidChooseAry);
     
     _tag = tag;
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
     _CitytableView.rowHeight = 41* kScreenHeight1;
     _CitytableView.tag = 222;
     _CitytableView.layer.cornerRadius = 5;
     _CitytableView.layer.masksToBounds = YES;
     [View addSubview:_CitytableView];
     
     [_CitytableView registerClass:[ChooseProCell class] forCellReuseIdentifier:@"Choose"];
     
     UILabel * textLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 0, 295, 49)];
     textLabel.backgroundColor = [UIColor whiteColor];
     textLabel.text = @"选择地区";
     textLabel.textAlignment = 1;
     textLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     textLabel.font = [UIFont systemFontOfSize:15* kScreenHeight1];
     [View addSubview:textLabel];
     
     UILabel * Label = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 49, 295, 1)];
     Label.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 /255.0 blue:238 / 255.0 alpha:1];
     [View addSubview:Label];
     
     
     UILabel * Label1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(295 / 2, 380, 1, 50)];
     Label1.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 /255.0 blue:238 / 255.0 alpha:1];
     [View addSubview:Label1];
     
     UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
     buyBtn.frame = WDH_CGRectMake(0, 380, 295 / 2, 50);
     buyBtn.backgroundColor = [UIColor whiteColor];
     [buyBtn setTitle:@"取消" forState:UIControlStateNormal];
     [buyBtn setTitleColor:[UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1] forState:UIControlStateNormal];
     [buyBtn addTarget:self action:@selector(pickerViewAction) forControlEvents:UIControlEventTouchUpInside];
     [View addSubview:buyBtn];
     
     UIButton * buyBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
     buyBtn1.frame = WDH_CGRectMake(295 / 2 + 1, 380, 295 / 2, 50);
     buyBtn1.backgroundColor = [UIColor whiteColor];
     [buyBtn1 setTitle:@"确定" forState:UIControlStateNormal];
     [buyBtn1 setTitleColor:[UIColor colorWithRed:253 / 255.0 green:80 / 255.0 blue:114 / 255.0 alpha:1] forState:UIControlStateNormal];
     [buyBtn1 addTarget:self action:@selector(handleQD) forControlEvents:UIControlEventTouchUpInside];
     [View addSubview:buyBtn1];
}


- (void) configView
{
     self.tableView = [[UITableView alloc]initWithFrame:WDH_CGRectMake(0, 0, 375, 667) style:UITableViewStylePlain];
     _tableView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
     _tableView.delegate = self;
     _tableView.dataSource = self;
     _tableView.separatorStyle = NO;
     _tableView.rowHeight = 162* kScreenHeight1;
     _tableView.tag = 111;
     [self.view addSubview:_tableView];
     
     [_tableView registerClass:[FreightEditCell class] forCellReuseIdentifier:@"Edit"];
     
     NSInteger a = 0;
     if ([_viewType isEqualToString:@"1"]) {
          
     } else {
          a = 55;
     }
     
     //底部滑动视图
     UIView * backView = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 0, 375, 163 + a)];
     backView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
     _tableView.tableHeaderView = backView;
     
     if ([_viewType isEqualToString:@"1"]) {
          
     } else {
          UILabel * tbackLabel_9 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 5, 375, 50)];
          tbackLabel_9.backgroundColor = [UIColor whiteColor];
          [backView addSubview:tbackLabel_9];
          
          UITextField * Label_9 = [[UITextField alloc] initWithFrame:WDH_CGRectMake(20, 5, 335, 50)];
          Label_9.font = [UIFont systemFontOfSize:17* kScreenHeight1];
          Label_9.tag = 10086;
          Label_9.placeholder = @"请输入默认模板名称";
          Label_9.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
          [backView addSubview:Label_9];
     }
     
     //第一部分不发货
     UILabel * tbackLabel_1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 5 + a, 375, 50)];
     tbackLabel_1.backgroundColor = [UIColor whiteColor];
     [backView addSubview:tbackLabel_1];
     
     UILabel * Label_1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(20, 5 + a, 335, 50)];
     Label_1.text = @"选择不发货地区";
     Label_1.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     [backView addSubview:Label_1];
     
     UILabel * backLabel_1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 56 + a, 375, 50)];
     backLabel_1.backgroundColor = [UIColor whiteColor];
     [backView addSubview:backLabel_1];
     
     UILabel * proLabel_1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(20, 56 + a, 300, 50)];
     proLabel_1.text = @"选择地区";
     proLabel_1.tag = 999998;      //不发货地区
     proLabel_1.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     [backView addSubview:proLabel_1];
     
     UIButton * chooseBtn_1 = [UIButton buttonWithType:UIButtonTypeSystem];
     chooseBtn_1.backgroundColor = [UIColor clearColor];
     chooseBtn_1.frame = WDH_CGRectMake(20, 56 + a, 300, 50);
     chooseBtn_1.tag = 999999;
     [chooseBtn_1 addTarget:self action:@selector(handleChoose:) forControlEvents:UIControlEventTouchUpInside];
     [backView addSubview:chooseBtn_1];
     
     //第二部分选择性发货 主要部分
     UILabel * tbackLabel_2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 111 + a, 375, 50)];
     tbackLabel_2.backgroundColor = [UIColor whiteColor];
     [backView addSubview:tbackLabel_2];
     
     UILabel * Label_2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(20, 111 + a, 335, 50)];
     Label_2.text = @"全国包邮, 除以下地区";
     Label_2.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     [backView addSubview:Label_2];
     
     //底部滑动视图
     UIView * backView_1 = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 0, 375, 50)];
     backView_1.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
     _tableView.tableFooterView = backView_1;
     
     self.addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
     [_addBtn setBackgroundImage:[UIImage imageNamed:@"添加指定地区运费"] forState:UIControlStateNormal];
     _addBtn.frame = WDH_CGRectMake(20, 10, 130, 17);
     [_addBtn addTarget:self action:@selector(handleAdd) forControlEvents:UIControlEventTouchUpInside];
     [backView_1 addSubview:_addBtn];
     
     
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
