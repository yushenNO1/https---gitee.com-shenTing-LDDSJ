//
//  SuppliersOverVC.m
//  供应商
//
//  Created by 张敬文 on 2017/7/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "SuppliersOverVC.h"
#import "SuppliersOverCell.h"
#import "SuppliersOverModel.h"
#import "addGoodsVC.h"
#import "AFNetworking.h"
#import "OrderIncomeVC.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#define kMargin         10
#define kItemWidth      (kScreenWidth - 3 * kMargin) / 2
#define kItemHeight     250
@interface SuppliersOverVC ()<UITableViewDelegate, UITableViewDataSource>{
     NSInteger _offset;
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * saleBtn;
@property (nonatomic, strong) UIButton * downBtn;
@property (nonatomic, strong) UIButton * timeBtn;
@property (nonatomic, strong) UIButton * numBtn;
@property (nonatomic, strong) UIButton * inventoryBtn;
@property (nonatomic, strong) UIImageView * inventoryImage;
@property (nonatomic, strong) UIImageView * numImage;
@property (nonatomic, strong) UIImageView * timeImage;
@property (nonatomic, copy) NSString * code_1;
@property (nonatomic, copy) NSString * code_2;
@property (nonatomic, copy) NSString * code_3;
@property (nonatomic, copy) NSString * code_4;
@property (nonatomic, strong) NSMutableArray * arrayindex;
@end

@implementation SuppliersOverVC
-(NSMutableArray *)arrayindex {
     if (!_arrayindex) {
          _arrayindex = [NSMutableArray arrayWithCapacity:1];
     }
     return _arrayindex;
}

- (void) viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
     self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:15]};
     [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

     _code_1 = @"1";  //默认为出售中数据   1:出售中  2.已下架
     _code_2 = @"0";  //默认为出售中数据   1:时间  2.销量  3.库存
     _code_3 = @"0";  //默认为0 未选中任何排序  1时间排序  2销量排序  3库存排序
     _code_4 = @"0";  //排序规则 默认为0递减  1递增
     _offset = 0;
     [_arrayindex removeAllObjects];
     _saleBtn.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:80 / 255.0 blue:114 / 255.0 alpha:1];
     [_saleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     _downBtn.backgroundColor = [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1];
     [_downBtn setTitleColor:[UIColor colorWithRed:137 / 255.0 green:137 / 255.0 blue:137 / 255.0 alpha:1] forState:UIControlStateNormal];
     [_timeBtn setBackgroundImage:[UIImage imageNamed:@"添加时间"] forState:UIControlStateNormal];
     [_numBtn setBackgroundImage:[UIImage imageNamed:@"销量"] forState:UIControlStateNormal];
     [_inventoryBtn setBackgroundImage:[UIImage imageNamed:@"库存"] forState:UIControlStateNormal];
     [self request:@"status" status:@"1"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.view.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    self.title = @"商品管理";
    
    [self configView];
    [self addRefreshAndLoadMore];
    // Do any additional setup after loading the view.
}

- (void)addRefreshAndLoadMore {
     self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(handleRefresh)];
     //添加上拉刷新
     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(handleLoadMore)];
}
- (void)handleRefresh {//刷新
     _offset = 0;
     [_arrayindex removeAllObjects];
     NSString * status;
     NSString * orderPar;
     if ([_code_1 integerValue] == 1) {
          status = @"1";
     } else {
          status = @"2";
     }
     if ([_code_2 integerValue] == 0) {
          orderPar = @"status";
     } else if ([_code_2 integerValue] == 1) {
          orderPar = @"create_time";
     } else if ([_code_2 integerValue] == 2) {
          orderPar = @"volume";
     } else if ([_code_2 integerValue] == 3) {
          orderPar = @"stock";
     }
     [self request:orderPar status:status];

}

- (void)handleLoadMore {//加载更多
     _offset+=10;
     NSString * status;
     NSString * orderPar;
     if ([_code_1 integerValue] == 1) {
          status = @"1";
     } else {
          status = @"2";
     }
     if ([_code_2 integerValue] == 0) {
          orderPar = @"status";
     } else if ([_code_2 integerValue] == 1) {
          orderPar = @"create_time";
     } else if ([_code_2 integerValue] == 2) {
          orderPar = @"volume";
     } else if ([_code_2 integerValue] == 3) {
          orderPar = @"stock";
     }
     [self request:orderPar status:status];
}


- (void) configView
{
    self.tableView = [[UITableView alloc]initWithFrame:WDH_CGRectMake(0, 150, 375, 517) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = 176* kScreenHeight1;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[SuppliersOverCell class] forCellReuseIdentifier:@"11"];
    
    self.saleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _saleBtn.frame = WDH_CGRectMake(0, 64, 375 / 2, 45);
    _saleBtn.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:80 / 255.0 blue:114 / 255.0 alpha:1];
    [_saleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saleBtn setTitle:@"出售中" forState:UIControlStateNormal];
    [_saleBtn addTarget:self action:@selector(handleSale) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saleBtn];
    
    self.downBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _downBtn.frame = WDH_CGRectMake(375 / 2, 64, 375 / 2, 45);
    _downBtn.backgroundColor = [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1];
    [_downBtn setTitleColor:[UIColor colorWithRed:137 / 255.0 green:137 / 255.0 blue:137 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_downBtn setTitle:@"已下架" forState:UIControlStateNormal];
    [_downBtn addTarget:self action:@selector(handleDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_downBtn];
    
    UILabel * backLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 64 + 45, 375, 40)];
    backLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backLabel];
    
    self.timeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _timeBtn.frame = WDH_CGRectMake(0, 64 + 45, 375 / 3, 40);
     [_timeBtn setBackgroundImage:[UIImage imageNamed:@"添加时间"] forState:UIControlStateNormal];
    [_timeBtn addTarget:self action:@selector(handleTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timeBtn];
    
//    self.timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 64 + 65, 5, 10)];
//    _timeImage.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_timeImage];
    
    UILabel * lineLabel_1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(375 / 3, 64 + 50, 1, 30)];
    lineLabel_1.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    [self.view addSubview:lineLabel_1];
    
    self.numBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _numBtn.frame = WDH_CGRectMake(375 / 3 + 1, 64 + 45, 375 / 3, 40);
    [_numBtn setBackgroundImage:[UIImage imageNamed:@"销量"] forState:UIControlStateNormal];
    [_numBtn addTarget:self action:@selector(handleNum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_numBtn];
    
//    self.numImage = [[UIImageView alloc] initWithFrame:CGRectMake(100 + 375 / 3, 64 + 65, 5, 10)];
//    _numImage.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_numImage];
    
    UILabel * lineLabel_2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(375 / 3 * 2 + 1, 64 + 50, 1, 30)];
    lineLabel_2.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    [self.view addSubview:lineLabel_2];
    
    self.inventoryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _inventoryBtn.frame = WDH_CGRectMake(375 / 3 * 2 + 2, 64 + 45, 375 / 3, 40);
    [_inventoryBtn setBackgroundImage:[UIImage imageNamed:@"库存"] forState:UIControlStateNormal];
    [_inventoryBtn addTarget:self action:@selector(handleInventory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_inventoryBtn];
    
//    self.inventoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(100 + 375 / 3 * 2, 64 + 65, 5, 10)];
//    _inventoryImage.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_inventoryImage];
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.backgroundColor = [UIColor whiteColor];
    addBtn.frame = WDH_CGRectMake(375/4, 617, 375/2 , 50);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"添加商品"] forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(handleAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
//    UIButton * orderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    orderBtn.backgroundColor = [UIColor whiteColor];
//    orderBtn.frame = WDH_CGRectMake(375 / 2, 617, 375 / 2, 50);
//    [orderBtn setBackgroundImage:[UIImage imageNamed:@"订单与收入"] forState:UIControlStateNormal];
//    [orderBtn addTarget:self action:@selector(handleOrder) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:orderBtn];
//
//    UILabel * lineLabel_3 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(375 / 2 + 1, 627, 1, 30)];
//    lineLabel_3.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
//    [self.view addSubview:lineLabel_3];
}

- (void) request:(NSString *)orderParam
          status:(NSString *)status{
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:GYSGoodList]];
     // 请求
     NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
     // 超时
     request.timeoutInterval = 10;
     // 请求方式
     request.HTTPMethod = @"POST";
    
    NSLog(@"_millId_millId----%@",_millId);
     // 设置请求体和参数
     // 创建一个描述订单的JSON数据
     NSDictionary* orderInfo = @{@"millId":_millId,
                                 @"strStatus":status,
                                 @"index":[NSString stringWithFormat:@"%ld", _offset],
                                 @"max":@"10",
                                 @"orderParam":orderParam,
                                 @"orderType":_code_4};
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
               NSLog(@"结果信息%@", dic);
               NSArray * ary = dic[@"data"];
               
               if ([[dic[@"status"] class] isEqual:[NSNull class]]) {
                    
               }else if (dic[@"status"]==nil){
                    
               }else{
                    _offset = 0;
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
               }

               
               
               if (ary != nil){
                    if (ary.count == 0) {
                         [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                         for (NSDictionary * dataDic in ary) {
                              SuppliersOverModel * model = [SuppliersOverModel overWithDictionary:dataDic];
                              [self.arrayindex addObject:model];
                         }

                         [self.tableView.mj_footer endRefreshing];
                    }
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView reloadData];
               }
               
          } else {
               [self.tableView.mj_header endRefreshing];
               NSLog(@"结果信息%@", connectionError);
          }
          
      }];
}

//刷新为出售中数据
- (void) handleSale
{
     _offset = 0;
     [_arrayindex removeAllObjects];
     if ([_code_2 isEqualToString:@"0"]) {
          [self request:@"status" status:@"1"];
     } else if ([_code_2 isEqualToString:@"1"]) {
          [self request:@"create_time" status:@"1"];
     } else if ([_code_2 isEqualToString:@"2"]) {
          [self request:@"volume" status:@"1"];
     } else if ([_code_2 isEqualToString:@"3"]) {
          [self request:@"stock" status:@"1"];
     }
     
    _code_1 = @"1";
    _saleBtn.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:80 / 255.0 blue:114 / 255.0 alpha:1];
    [_saleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _downBtn.backgroundColor = [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1];
    [_downBtn setTitleColor:[UIColor colorWithRed:137 / 255.0 green:137 / 255.0 blue:137 / 255.0 alpha:1] forState:UIControlStateNormal];

}

//刷新为已下架数据
- (void) handleDown
{
     _offset = 0;
     [_arrayindex removeAllObjects];
     if ([_code_2 isEqualToString:@"0"]) {
          [self request:@"status" status:@"2"];
     } else if ([_code_2 isEqualToString:@"1"]) {
          [self request:@"create_time" status:@"2"];
     } else if ([_code_2 isEqualToString:@"2"]) {
          [self request:@"volume" status:@"2"];
     } else if ([_code_2 isEqualToString:@"3"]) {
          [self request:@"stock" status:@"2"];
     }
    _code_1 = @"2";
    _saleBtn.backgroundColor = [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1];
    [_saleBtn setTitleColor:[UIColor colorWithRed:137 / 255.0 green:137 / 255.0 blue:137 / 255.0 alpha:1] forState:UIControlStateNormal];
    _downBtn.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:80 / 255.0 blue:114 / 255.0 alpha:1];
    [_downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

//刷新为当前数据的时间顺序
- (void) handleTime
{
     _offset = 0;
     [_arrayindex removeAllObjects];
     _code_2 = @"1";
     if ([_code_3 isEqualToString:@"0"] || [_code_3 isEqualToString:@"2"] || [_code_3 isEqualToString:@"3"]) {
          _code_3 = @"1";
          _code_4 = @"0";
          [_timeBtn setBackgroundImage:[UIImage imageNamed:@"添加时间下"] forState:UIControlStateNormal];
          [_numBtn setBackgroundImage:[UIImage imageNamed:@"销量"] forState:UIControlStateNormal];
          [_inventoryBtn setBackgroundImage:[UIImage imageNamed:@"库存"] forState:UIControlStateNormal];
     } else {
          if ([_code_4 isEqualToString:@"0"]) {
               _code_4 = @"1";
               [_timeBtn setBackgroundImage:[UIImage imageNamed:@"添加时间上"] forState:UIControlStateNormal];
          } else {
               _code_4 = @"0";
               [_timeBtn setBackgroundImage:[UIImage imageNamed:@"添加时间下"] forState:UIControlStateNormal];
          }
     }
     NSLog(@"789----%@", _code_4);
     
     if ([_code_1 isEqualToString:@"1"]) {
          [self request:@"create_time" status:@"1"];
     } else {
          [self request:@"create_time" status:@"2"];
     }
}

//刷新为当前数据的销量顺序
- (void) handleNum
{
     _offset = 0;
     [_arrayindex removeAllObjects];
     _code_2 = @"2";
     
     if ([_code_3 isEqualToString:@"0"] || [_code_3 isEqualToString:@"1"] || [_code_3 isEqualToString:@"3"]) {
          _code_3 = @"2";
          _code_4 = @"0";
          [_timeBtn setBackgroundImage:[UIImage imageNamed:@"添加时间"] forState:UIControlStateNormal];
          [_numBtn setBackgroundImage:[UIImage imageNamed:@"销量下"] forState:UIControlStateNormal];
          [_inventoryBtn setBackgroundImage:[UIImage imageNamed:@"库存"] forState:UIControlStateNormal];
     } else {
          if ([_code_4 isEqualToString:@"0"]) {
               _code_4 = @"1";
               [_numBtn setBackgroundImage:[UIImage imageNamed:@"销量上"] forState:UIControlStateNormal];
          } else {
               _code_4 = @"0";
               [_numBtn setBackgroundImage:[UIImage imageNamed:@"销量下"] forState:UIControlStateNormal];
          }
     }
     NSLog(@"456----%@", _code_4);
     
     
     if ([_code_1 isEqualToString:@"1"]) {
          [self request:@"volume" status:@"1"];
     } else {
          [self request:@"volume" status:@"2"];
     }
}

//刷新为当前数据的库存顺序
- (void) handleInventory
{
     _offset = 0;
     [_arrayindex removeAllObjects];
     _code_2 = @"3";
     
     if ([_code_3 isEqualToString:@"0"] || [_code_3 isEqualToString:@"1"] || [_code_3 isEqualToString:@"2"]) {
          _code_4 = @"0";
          _code_3 = @"3";
          [_timeBtn setBackgroundImage:[UIImage imageNamed:@"添加时间"] forState:UIControlStateNormal];
          [_numBtn setBackgroundImage:[UIImage imageNamed:@"销量"] forState:UIControlStateNormal];
          [_inventoryBtn setBackgroundImage:[UIImage imageNamed:@"库存下"] forState:UIControlStateNormal];

     } else {
          if ([_code_4 isEqualToString:@"0"]) {
               _code_4 = @"1";
               [_inventoryBtn setBackgroundImage:[UIImage imageNamed:@"库存上"] forState:UIControlStateNormal];
          } else {
               _code_4 = @"0";
               [_inventoryBtn setBackgroundImage:[UIImage imageNamed:@"库存下"] forState:UIControlStateNormal];
          }
     }
     NSLog(@"123----%@", _code_4);
     
     if ([_code_1 isEqualToString:@"1"]) {
          [self request:@"stock" status:@"1"];
     } else {
          [self request:@"stock" status:@"2"];
     }
}

- (void) handleAdd
{
    
     
     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加" message:@"添加商品" preferredStyle:UIAlertControllerStyleActionSheet];
     UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"直供" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          //直供
          addGoodsVC * zjwVC = [[addGoodsVC alloc] init];
          zjwVC.millId = _millId;
          zjwVC.goodId = @"=";
          zjwVC.typeStr = @"1";
          [self.navigationController pushViewController:zjwVC animated:YES];
     }];
     UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"积分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          //积分
          addGoodsVC * zjwVC = [[addGoodsVC alloc] init];
          zjwVC.millId = _millId;
          zjwVC.goodId = @"=";
          zjwVC.typeStr = @"2";
          [self.navigationController pushViewController:zjwVC animated:YES];
     }];
     UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          //直供
          
     }];
     [alert addAction:action1];
     [alert addAction:action2];
     [alert addAction:action3];
     [self presentViewController:alert animated:YES completion:nil];
}

- (void) handleOrder
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayindex.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SuppliersOverCell * cell = [tableView dequeueReusableCellWithIdentifier:@"11" forIndexPath:indexPath];
     SuppliersOverModel * model = _arrayindex[indexPath.row];
     [cell.LeftImageView sd_setImageWithURL:[NSURL URLWithString:model.goodImageList[0][@"thumbnail"]] placeholderImage:[UIImage imageNamed:@"图片@3x"]];
     cell.titleLabel.text = model.goodName;
     cell.priceLabel.text = [NSString stringWithFormat:@"¥:%.2f", [model.shopPrice floatValue]];
     cell.numLabel.text = [NSString stringWithFormat:@"销量:%@", model.volume];
     cell.saveLabel.text = [NSString stringWithFormat:@"库存:%@", model.stock];
     cell.dateLabel.text = [NSString stringWithFormat:@"%@", @""];
     cell.editBtn.tag = 100000 + indexPath.row;
     [cell.editBtn setImage:[UIImage imageNamed:@"编辑 "] forState:UIControlStateNormal];
     [cell.editBtn addTarget:self action:@selector(handleEdit:) forControlEvents:UIControlEventTouchUpInside];
     cell.downBtn.tag = 200000 + indexPath.row;
     [cell.downBtn addTarget:self action:@selector(handleDown:) forControlEvents:UIControlEventTouchUpInside];
     cell.deleteBtn.tag = 300000 + indexPath.row;
     [cell.deleteBtn setImage:[UIImage imageNamed:@"删除 "] forState:UIControlStateNormal];
     [cell.deleteBtn addTarget:self action:@selector(handleDelete:) forControlEvents:UIControlEventTouchUpInside];
     if ([model.status integerValue] == 0) {
          [cell.downBtn setImage:[UIImage imageNamed:@"上架"] forState:UIControlStateNormal];
     } else if ([model.status integerValue] == 1) {
          [cell.downBtn setImage:[UIImage imageNamed:@"上架 审核中"] forState:UIControlStateNormal];
     } else if ([model.status integerValue] == 2) {
          [cell.downBtn setImage:[UIImage imageNamed:@"下架"] forState:UIControlStateNormal];
     } else if ([model.status integerValue] == 3) {
          [cell.downBtn setImage:[UIImage imageNamed:@"上架"] forState:UIControlStateNormal];
     } else if ([model.status integerValue] == 4) {
          [cell.downBtn setImage:[UIImage imageNamed:@"下架审核中"] forState:UIControlStateNormal];
     } else if ([model.status integerValue] == 5) {
          [cell.downBtn setImage:[UIImage imageNamed:@"上架"] forState:UIControlStateNormal];
     } else if ([model.status integerValue] == 6) {
          [cell.downBtn setImage:[UIImage imageNamed:@"下架"] forState:UIControlStateNormal];
     }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//编辑商品
- (void) handleEdit:(UIButton *) sender {
     
     SuppliersOverModel * model = _arrayindex[sender.tag - 100000];
     
     if ([model.status intValue] == 0 || [model.status intValue] == 3 || [model.status intValue] == 5) {
          addGoodsVC * adVC = [[addGoodsVC alloc] init];
          adVC.goodId = [NSString stringWithFormat:@"%@", model.goodId];
          adVC.millId = _millId;
          adVC.typeStr = [NSString stringWithFormat:@"%d", model.type];
          [self.navigationController pushViewController:adVC animated:YES];
     } else {
          Alert_Show(@"该商品当前状态不可编辑");
     }
     
     
}

//上下架商品
- (void) handleDown:(UIButton *) sender {
     SuppliersOverModel * model = _arrayindex[sender.tag - 200000];
     if ([model.status integerValue] == 0) {
          [self requestStatus:@"1" goodId:model.goodId];
     } else if ([model.status integerValue] == 1) {
          //上架审核中
          NSLog(@"上架审核中");
     } else if ([model.status integerValue] == 2) {
          [self requestStatus:@"3" goodId:model.goodId];
     } else if ([model.status integerValue] == 3) {
          //上架审核失败
          [self requestStatus:@"1" goodId:model.goodId];
          NSLog(@"上架审核失败");
     } else if ([model.status integerValue] == 4) {
//          //下架审核中
//          NSLog(@"下架审核中");
     } else if ([model.status integerValue] == 5) {
//          [self requestStatus:@"1" goodId:model.goodId];
     } else if ([model.status integerValue] == 6) {
//          //下架审核失败
//          NSLog(@"下架审核失败");
//          [self requestStatus:@"3" goodId:model.goodId];
     }
     //sender.tag - 200000
     
}

//删除商品
- (void) handleDelete:(UIButton *) sender {
     //sender.tag - 300000
     SuppliersOverModel * model = _arrayindex[sender.tag - 300000];
     if ([model.status intValue] == 0 || [model.status intValue] == 3 || [model.status intValue] == 5) {
          [self requestStatus:@"7" goodId:model.goodId];
     } else {
          Alert_Show(@"该商品当前状态不可删除");
     }
     
}

- (void)requestStatus:(NSString *)status
               goodId:(NSString *)goodId
{
     NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
     [manager GET:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:GYSGoodStatusChange@"/%@/%@", status, goodId]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"状态变更数据%@", responseObject);
          if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
               NSLog(@"状态变更成功");
               
               NSString * status;
               NSString * orderPar;
               if ([_code_1 integerValue] == 1) {
                    status = @"1";
               } else {
                    status = @"2";
               }
               if ([_code_2 integerValue] == 0) {
                    orderPar = @"status";
               } else if ([_code_2 integerValue] == 1) {
                    orderPar = @"create_time";
               } else if ([_code_2 integerValue] == 2) {
                    orderPar = @"volume";
               } else if ([_code_2 integerValue] == 3) {
                    orderPar = @"stock";
               }
               [_arrayindex removeAllObjects];
               _offset = 0;
               [self request:orderPar status:status];
          } else {
               NSString * message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
               Alert_Show(message);
          }
          
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"错误信息%@", error);
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
