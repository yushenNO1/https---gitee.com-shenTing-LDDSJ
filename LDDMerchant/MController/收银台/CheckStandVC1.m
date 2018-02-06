//
//  CheckStandVC1.m
//  收银台
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "CheckStandVC1.h"
#import "CheckStandModel.h"
#import "AFNetworking.h"
#import "CheckStandCell.h"
#import "OrderInfoVC.h"
@interface CheckStandVC1 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *RightArr;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation CheckStandVC1

- (void)request1 {
    [_RightArr removeAllObjects];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:SYTYList] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"-------%@", responseObject);
        if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]]isEqualToString:@"0"]) {
            NSDictionary * dic = responseObject[@"data"];
            NSArray *arr = dic[@"list"];
            for (NSDictionary * dic in arr) {
                CheckStandModel * model = [CheckStandModel GoodsWithDictionary:dic];
                [self.RightArr addObject:model];
            }
            [self.tableView reloadData];
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"-------%@", error);
    }];
}

-(NSMutableArray *)RightArr {
    if (!_RightArr) {
        self.RightArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _RightArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self request1];
    [self configView];
    // Do any additional setup after loading the view.
}

- (void) configView
{
    self.tableView = [[UITableView alloc]initWithFrame:WDH_CGRectMake(0, 0, 375, 667) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1001;
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = 155 * kScreenHeight1;
    [_tableView registerClass:[CheckStandCell class] forCellReuseIdentifier:@"33"];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _RightArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckStandCell * zjwCell = [tableView dequeueReusableCellWithIdentifier:@"33" forIndexPath:indexPath];
    CheckStandModel * model = _RightArr[indexPath.row];
    zjwCell.backImageView.image = [UIImage imageNamed:@"已支付底"];
    zjwCell.TopTitleLabel.text = model.orderName;
    zjwCell.MidTitleLabel.text = [NSString stringWithFormat:@"合计: %.2f", model.totalAmount];
    zjwCell.leftBtn.tag = model.GoodId;
    [zjwCell.leftBtn setTitle:@"查看订单详情" forState:UIControlStateNormal];
    [zjwCell.leftBtn addTarget:self action:@selector(handleGo:) forControlEvents:UIControlEventTouchUpInside];
     [zjwCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [zjwCell.rightBtn setBackgroundImage:[UIImage imageNamed:@"已支付二维码"] forState:UIControlStateNormal];
     zjwCell.TopBtn.hidden = YES;
    return zjwCell;
}

- (void) handleGo:(UIButton *)sender
{
    OrderInfoVC * zjwVC = [[OrderInfoVC alloc] init];
    zjwVC.orderId = [NSString stringWithFormat:@"%ld", sender.tag];
    [self.navigationController pushViewController:zjwVC animated:YES];
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
