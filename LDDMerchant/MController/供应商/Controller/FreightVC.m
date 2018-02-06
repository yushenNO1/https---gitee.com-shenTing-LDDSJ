//
//  FreightVC.m
//  供应商
//
//  Created by 张敬文 on 2017/7/27.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "FreightVC.h"
#import "FreightCell.h"
#import "FreightEditVC.h"
@interface FreightVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
//@property (nonatomic, strong) NSDictionary * dic;
@property (nonatomic, assign) NSInteger index;  //记录选中的模板内容下标
@property (nonatomic, strong) NSArray * ary;
@property (nonatomic, assign) NSInteger num;  //记录模板内容数量
@property (nonatomic, copy) NSString * str;  //记录模板内容数量
@property (nonatomic, copy) NSString * name;  //记录模板内容数量
@property (nonatomic, strong) NSMutableArray * MuAry;  //记录模板内容数量
@end

@implementation FreightVC
-(NSMutableArray *)MuAry {
     if (!_MuAry) {
          _MuAry = [NSMutableArray arrayWithCapacity:1];
     }
     return _MuAry;
}

- (void) viewWillAppear:(BOOL)animated
{
     [self.MuAry removeAllObjects];
     [self request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
     
     _str = @"0";
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"运费模板";
    [self  setNavigationBarConfiguer];
}

- (void)setNavigationBarConfiguer {
     [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
     UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(Over)];
     self.navigationItem.rightBarButtonItem = rightBarButtonItem;
     UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
     self.navigationItem.leftBarButtonItem = item;
     
     
}

- (void) leftBarBtnClick {
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)Over{
     int i = 0;
     int a = 0;
     for (NSString * idStr in _MuAry) {
          if ([idStr isEqualToString:@"2"]) {
               a = i;
               break;
          }
          i++;
     }
     
     if (a == 0) {
          _str = @"0";
          _name = @"全国包邮";
     } else {
          NSDictionary * dic = _ary[a - 1];
          _str = [NSString stringWithFormat:@"%@", dic[@"id"]];
          _name = [NSString stringWithFormat:@"%@", dic[@"name"]];
     }
     NSLog(@"选择的运费模板id%@", _str);
     NSDictionary *dic = @{@"freight":_str, @"name":_name};
     [[NSNotificationCenter defaultCenter] postNotificationName:@"freight" object:nil userInfo:dic];
     [self.navigationController popViewControllerAnimated:YES];
}

- (void) request {
     [self.MuAry removeAllObjects];
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     NSURL* url = [NSURL URLWithString:GYSFre];
     // 请求
     NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
     // 超时
     request.timeoutInterval = 10;
     // 请求方式
     request.HTTPMethod = @"POST";
     
     // 设置请求体和参数
     // 创建一个描述订单的JSON数据
     NSDictionary* orderInfo = @{@"millId":_millId,
                                 @"cursor":@"0",
                                 @"count":@"100"};
     // OC对象转JSON
     NSData* json = [NSJSONSerialization dataWithJSONObject:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
     // 设置请求头
     
     // 设置请求头类型 (因为发送给服务器的参数类型已经不是普通数据,而是JSON)
     //     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setValue:str forHTTPHeaderField:@"Authorization"];
     
     request.HTTPBody = json;
     
     [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
          
          NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
          self.ary = dic[@"data"];
//          NSLog(@"运费模板列表%@", _ary);
          for (int i = 0; i < _ary.count + 1; i++) {
               if (i == 0) {
                    [self.MuAry addObject:@"2"];
               } else {
                    [self.MuAry addObject:@"1"];
               }
               
          }
           [self configView];
     }];
}

- (void) configView
{
    self.tableView = [[UITableView alloc]initWithFrame:WDH_CGRectMake(0, 64, 375, 553) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = 61* kScreenHeight1;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[FreightCell class] forCellReuseIdentifier:@"freight"];
    
    UIButton * newBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    newBtn.backgroundColor = [UIColor whiteColor];
    newBtn.frame = WDH_CGRectMake(0, 617, 375, 50);
    [newBtn setBackgroundImage:[UIImage imageNamed:@"新建运费模版"] forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1] forState:UIControlStateNormal];
    [newBtn addTarget:self action:@selector(handleNew) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBtn];

}

- (void) handleNew
{
     FreightEditVC * zjwVC = [[FreightEditVC alloc] init];
     zjwVC.viewType = @"2";
     zjwVC.type = @"=";
     zjwVC.millId = _millId;
     [self.navigationController pushViewController:zjwVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ary.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FreightCell * cell = [[FreightCell alloc] init];
     
     
     
    if (indexPath.row == 0) {
        cell.TopLabel.text = @"全国包邮";
        cell.DownLabel.text =  @"全国范围内免邮费";
         NSLog(@"---%@", _MuAry);
         if ([_MuAry[indexPath.row] isEqualToString:@"1"]) {
              cell.LeftImageView.backgroundColor = [UIColor whiteColor];
         } else {
              cell.LeftImageView.image = [UIImage imageNamed:@"包邮"];
         }
        
         cell.deleteBtn.hidden = YES;
    } else {
        NSDictionary * dic = _ary[indexPath.row - 1];
         NSLog(@"%@", dic[@"name"]);
        cell.TopLabel.text = [NSString stringWithFormat:@"%@", dic[@"name"]];
        cell.DownLabel.text =  [NSString stringWithFormat:@"%@", dic[@"name"]];
         if ([_MuAry[indexPath.row] isEqualToString:@"1"]) {
              cell.LeftImageView.backgroundColor = [UIColor whiteColor];
         } else {
              cell.LeftImageView.image = [UIImage imageNamed:@"包邮"];
         }
         cell.deleteBtn.hidden = NO;
         cell.deleteBtn.tag = indexPath.row;
         [cell.deleteBtn addTarget:self action:@selector(handleEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
     
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [_MuAry removeAllObjects];
     for (int i = 0; i < _ary.count + 1; i++) {
          [self.MuAry addObject:@"1"];
     }

     [_MuAry removeObjectAtIndex:indexPath.row];
     [_MuAry insertObject:@"2" atIndex:indexPath.row];
     [tableView reloadData];
}

- (void) requestDelete:(NSString *)string {
    
}

- (void) handleEdit:(UIButton *) sender
{
     if (sender.tag == 1) {
          NSDictionary * dic = _ary[sender.tag - 1];
          FreightEditVC * zjwVC = [[FreightEditVC alloc] init];
          zjwVC.viewType = @"1";
          zjwVC.type = [NSString stringWithFormat:@"%@", dic[@"type"]];
          zjwVC.Id = [NSString stringWithFormat:@"%@", dic[@"id"]];
          zjwVC.millId = _millId;
          [self.navigationController pushViewController:zjwVC animated:YES];
     } else {
          NSDictionary * dic = _ary[sender.tag - 1];
          FreightEditVC * zjwVC = [[FreightEditVC alloc] init];
          zjwVC.viewType = @"2";
          zjwVC.type = [NSString stringWithFormat:@"%@", dic[@"type"]];
          zjwVC.Id = [NSString stringWithFormat:@"%@", dic[@"id"]];
          zjwVC.millId = _millId;
          [self.navigationController pushViewController:zjwVC animated:YES];
     }
    //新增
    //编辑
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
