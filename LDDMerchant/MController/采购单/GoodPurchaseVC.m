//
//  GoodPurchaseVC.m
//  采购单
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "GoodPurchaseVC.h"
#import "GoodPurchaseCell.h"
#import "ExamineListVC.h"
#import "LYTPurchaseVC.h"
@interface GoodPurchaseVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *ImageArr;

@end

@implementation GoodPurchaseVC
-(NSMutableArray *)ImageArr {
    if (!_ImageArr) {
        self.ImageArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _ImageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
     self.title = @"商品采购";
     
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:WDH_CGRectMake(0, 0, 375, 603) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1001;
//    _tableView.separatorStyle = NO;
    _tableView.rowHeight = 80 * kScreenHeight1;
    [_tableView registerClass:[GoodPurchaseCell class] forCellReuseIdentifier:@"11"];
     _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodPurchaseCell * zjwCell = [tableView dequeueReusableCellWithIdentifier:@"11" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        zjwCell.leftImageView.image = [UIImage imageNamed:@"自营采购"];
        zjwCell.TopLabel.text = @"商品采购";
        zjwCell.DownLabel.text = @"直供商品采购";
        [zjwCell.Btn setTitle:@"立即采购" forState:UIControlStateNormal];
         zjwCell.textLabel.font = [UIFont systemFontOfSize:10];
        [zjwCell.Btn addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventTouchUpInside];
    } else {
         zjwCell.leftImageView.image = [UIImage imageNamed:@"采购单"];
        zjwCell.TopLabel.text = @"采购单";
        zjwCell.DownLabel.text = @"商家采购信息及审批信息";
        [zjwCell.Btn setTitle:@"立即查看" forState:UIControlStateNormal];
         zjwCell.textLabel.font = [UIFont systemFontOfSize:10];
        [zjwCell.Btn addTarget:self action:@selector(handleGo) forControlEvents:UIControlEventTouchUpInside];
    }
    [zjwCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return zjwCell;
}

- (void) handleAction
{
     LYTPurchaseVC * vc = [[LYTPurchaseVC alloc]init];
     [self.navigationController pushViewController:vc animated:YES];
}

- (void) handleGo
{
    ExamineListVC * zjwVC = [[ExamineListVC alloc] init];
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
