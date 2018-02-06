//
//  CheckStandVC.m
//  收银台
//
//  Created by 张敬文 on 2017/5/25.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "CheckStandVC.h"
#import "ScanCheckVC.h"
#import "CheckStandModel.h"
#import "AFNetworking.h"
#import "CheckStandCell.h"
#import "CheckStandVC1.h"
#import "TwoScanVC.h"
@interface CheckStandVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;

@property (nonatomic, strong) NSMutableArray *ImageArr;

@property (nonatomic, strong) UIView * pickerVC;
@property (nonatomic, strong) UITextField * moneyCodeTf;
@property (nonatomic, assign) int code;
@end

@implementation CheckStandVC

- (void)request {
    [_ImageArr removeAllObjects];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:SYTWList] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"-------%@", responseObject);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"0"]) {
            NSDictionary * dic = responseObject[@"data"];
            NSArray *arr = dic[@"list"];
            for (NSDictionary * dic in arr) {
                CheckStandModel * model = [CheckStandModel GoodsWithDictionary:dic];
                [self.ImageArr addObject:model];
            }
            [self.tableView reloadData];
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"-------%@", error);
    }];
}

- (void)requestDelete:(NSString *)orderId {
     NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     [manager GET:[NSString stringWithFormat:SYTDeleteOrder, orderId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"---删除----%@", responseObject);
          if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"0"]) {
               Alert_Show(@"删除成功")
          } else {
               Alert_Show(@"删除失败")
          }
          
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"-------%@", error);
     }];
}


-(NSMutableArray *)ImageArr {
    if (!_ImageArr) {
        self.ImageArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _ImageArr;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:32 / 255.0 green:178 / 255.0 blue:255 / 255.0 alpha:1];
    [self request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"收银台";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
     UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
     self.navigationItem.leftBarButtonItem = item;


}



- (void) leftBarBtnClick {
     [self.navigationController popToRootViewControllerAnimated:YES];
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:253 / 255.0 green:56 / 255.0 blue:84 / 255.0 alpha:1.0];
}


- (void) configView
{
    UIView * TopView = [[UIView alloc] initWithFrame:WDH_CGRectMake(0, 64, 375, 100)];
    TopView.backgroundColor = [UIColor redColor];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _rightBtn.frame = CGRectMake((375 / 2 + 1) * kScreenWidth1, 64, 375 / 2 * kScreenWidth1, 50* kScreenHeight1);
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"已付款"] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightBtn addTarget:self action:@selector(handleRight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightBtn];
    
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(375 / 2 * kScreenWidth1, 64 + 10* kScreenHeight1, 1 * kScreenWidth1, 30* kScreenHeight1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    [self.view addSubview:lineLabel];
    
    UILabel * lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 50* kScreenHeight1, 375* kScreenWidth1, 1* kScreenHeight1)];
    lineLabel1.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    [self.view addSubview:lineLabel1];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _leftBtn.frame = CGRectMake(0, 64, 375 / 2 * kScreenWidth1, 50* kScreenHeight1);
    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"开始收银"] forState:UIControlStateNormal];
    
    [_leftBtn setTitleColor:[UIColor colorWithRed:226 / 255.0 green:32 / 255.0 blue:0 alpha:1] forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_leftBtn addTarget:self action:@selector(handleLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    
    UILabel * lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 51* kScreenHeight1, 375* kScreenWidth1, 5* kScreenHeight1)];
    lineLabel2.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    [self.view addSubview:lineLabel2];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 56* kScreenHeight1, 375 * kScreenWidth1, 547* kScreenHeight1) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1001;
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = 155 * kScreenHeight1;
    [_tableView registerClass:[CheckStandCell class] forCellReuseIdentifier:@"11"];
    [self.view addSubview:_tableView];
}

- (void)handleLeft {
    NSLog(@"左边");
    [self handleMore];
    [_leftBtn setTitleColor:[UIColor colorWithRed:226 / 255.0 green:32 / 255.0 blue:0 alpha:1] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)handleMore
{
    self.pickerVC = [[UIView alloc]initWithFrame:WDH_CGRectMake(0, 0, 375, 667)];
    _pickerVC.backgroundColor = [UIColor blackColor];
    _pickerVC.alpha = 0.5;
    _pickerVC.userInteractionEnabled = YES;
    [self.view  addSubview:_pickerVC];
    UITapGestureRecognizer * tap44 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleAction4)];
    [_pickerVC addGestureRecognizer:tap44];
    
    UIView * view = [[UIView alloc] initWithFrame:WDH_CGRectMake(50, 200, 275, 130)];
    view.backgroundColor = [UIColor clearColor];

    view.tag = 804;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    
    self.moneyCodeTf = [[UITextField alloc] initWithFrame:WDH_CGRectMake(0, 0, 275, 50)];
    _moneyCodeTf.backgroundColor = [UIColor whiteColor];

    _moneyCodeTf.placeholder = @"请输入桌号或手机号/选填";
    _moneyCodeTf.textAlignment = NSTextAlignmentCenter;
    _moneyCodeTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [view addSubview:_moneyCodeTf];
    
    UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
    Btn.frame = WDH_CGRectMake(0, 60, 275, 50);
    Btn.backgroundColor = [UIColor colorWithRed:32 / 255.0 green:178 / 255.0 blue:255 / 255.0 alpha:1];
    [Btn setTitle:@"开始收银" forState:UIControlStateNormal];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(handleAction3) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:Btn];
}

- (void)handleAction4
{
    [[self.view viewWithTag:804] removeFromSuperview];
    [_pickerVC removeFromSuperview];
}

- (void)handleAction3
{
    [[self.view viewWithTag:804] removeFromSuperview];
    [_pickerVC removeFromSuperview];
    if (_moneyCodeTf.text.length != 0) {
        ScanCheckVC * VC = [[ScanCheckVC alloc] init];
        VC.name = _moneyCodeTf.text;
        VC.orderId = @"";
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        ScanCheckVC * VC = [[ScanCheckVC alloc] init];
        VC.name = @"";
        VC.orderId = @"";
        [self.navigationController pushViewController:VC animated:YES];
    }
     
}

- (void)handleRight {
    NSLog(@"右边");
    CheckStandVC1 * vc = [[CheckStandVC1 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor colorWithRed:226 / 255.0 green:32 / 255.0 blue:0 alpha:1] forState:UIControlStateNormal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ImageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckStandCell * zjwCell = [tableView dequeueReusableCellWithIdentifier:@"11" forIndexPath:indexPath];
    CheckStandModel * model = _ImageArr[indexPath.row];
    zjwCell.backImageView.image = [UIImage imageNamed:@"未支付底"];
    zjwCell.TopTitleLabel.tag = indexPath.row + 100000;
    zjwCell.TopTitleLabel.text = model.orderName;
    zjwCell.MidTitleLabel.text = [NSString stringWithFormat:@"合计: %.2f", model.totalAmount];
    zjwCell.leftBtn.tag = model.GoodId;
    zjwCell.rightBtn.tag = model.GoodId + 100000;
    zjwCell.TopBtn.tag = model.GoodId + 1000000;
    [zjwCell.leftBtn setTitle:@"生成付款二维码" forState:UIControlStateNormal];
     [zjwCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [zjwCell.rightBtn setBackgroundImage:[UIImage imageNamed:@"未支付二维码"] forState:UIControlStateNormal];
    [zjwCell.leftBtn addTarget:self action:@selector(handleGo:) forControlEvents:UIControlEventTouchUpInside];
    [zjwCell.rightBtn addTarget:self action:@selector(handleGo1:) forControlEvents:UIControlEventTouchUpInside];
     zjwCell.TopBtn.hidden = NO;
     [zjwCell.TopBtn addTarget:self action:@selector(handleGo2:) forControlEvents:UIControlEventTouchUpInside];
    return zjwCell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
     CheckStandModel * model = _ImageArr[indexPath.row];
     [self requestDelete:[NSString stringWithFormat:@"%ld", model.GoodId]];
     [_ImageArr removeObjectAtIndex:indexPath.row];
     [tableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
     //别动这个空格键
     NSString * str = @"        ";
     return str;
}

- (void) handleGo2:(UIButton *)sender
{
     NSString * orderId = [NSString stringWithFormat:@"%ld", sender.tag - 1000000];
     [self requestDelete:orderId];
}

- (void) handleGo1:(UIButton *)sender
{
    CheckStandCell * cellView = (CheckStandCell *)sender.superview;
    CheckStandModel * model = _ImageArr[cellView.TopTitleLabel.tag - 100000];
    ScanCheckVC * VC = [[ScanCheckVC alloc] init];
    VC.name = model.orderName;
    VC.orderId = [NSString stringWithFormat:@"%ld", sender.tag - 100000];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void) handleGo:(UIButton *)sender
{
    CheckStandCell * cellView = (CheckStandCell *)sender.superview;
    CheckStandModel * model = _ImageArr[cellView.TopTitleLabel.tag - 100000];
     if (model.totalAmount == 0) {
          Alert_Show(@"您并没有需要支付的金额")
     } else {
          TwoScanVC * vc = [[TwoScanVC alloc] init];
          vc.orderId = [NSString stringWithFormat:@"%ld", sender.tag];
          vc.totalAmount = [NSString stringWithFormat:@"%.2f", model.totalAmount];
          [self.navigationController pushViewController:vc animated:YES];
     }
     
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.view endEditing:YES];
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
