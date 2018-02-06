//
//  OrderInfoVC.m
//  收银台
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "OrderInfoVC.h"
#import "OrderInfoModel.h"
#import "OrderInfoCell.h"
#import "AFNetworking.h"
@interface OrderInfoVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *RightArr;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@end

@implementation OrderInfoVC

- (void)request1 {
    [_RightArr removeAllObjects];
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
            _nameLabel.text = dic[@"orderName"];
            _priceLabel.text = [NSString stringWithFormat:@"合计: %.2f", [dic[@"totalAmount"] floatValue]];
            NSArray *arr = dic[@"relations"];
            for (NSDictionary * dic in arr) {
                OrderInfoModel * model = [OrderInfoModel InfoWithDictionary:dic];
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
    [self request1];
    // Do any additional setup after loading the view.
}

- (void) configView
{
    UILabel * label3 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 64, 375, 5)];
    label3.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    [self.view addSubview:label3];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(20, 70, 375 / 2 - 50, 80)];
    self.nameLabel.textAlignment = 1;
    [self.view addSubview:_nameLabel];
    self.priceLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(375 / 2, 70, 375 / 2 - 20, 80)];
    self.priceLabel.textAlignment = 1;
    [self.view addSubview:_priceLabel];
    
    UILabel * label = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 150, 375 / 3, 50)];
    label.text = @"名称";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(375 / 3, 150, 375 / 3, 50)];
    label1.text = @"数量";
    label1.textAlignment = 1;
    label1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(375 / 3 * 2, 150, 375 / 3, 50)];
    label2.text = @"价格";
    label2.textAlignment = 1;
    label2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label2];
    
    UILabel * lineLabel1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 200, 375, 1)];
    lineLabel1.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    [self.view addSubview:lineLabel1];
    
    self.tableView = [[UITableView alloc]initWithFrame:WDH_CGRectMake(0, 201, 375, 466) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1001;
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = 40 * kScreenHeight1;
    [_tableView registerClass:[OrderInfoCell class] forCellReuseIdentifier:@"44"];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _RightArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderInfoCell * zjwCell = [tableView dequeueReusableCellWithIdentifier:@"44" forIndexPath:indexPath];
    OrderInfoModel * model = _RightArr[indexPath.row];
    zjwCell.leftLabel.text = model.name;
     [zjwCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    zjwCell.rightLabel.text = [NSString stringWithFormat:@"%.2f", [model.price floatValue]];
    zjwCell.centerLabel.text = model.count;
    return zjwCell;
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
