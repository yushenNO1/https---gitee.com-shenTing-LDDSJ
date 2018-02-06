//
//  SuppliersVC.m
//  供应商
//
//  Created by 张敬文 on 2017/7/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "SuppliersVC.h"
#import "PerfectInfoVC.h"
@interface SuppliersVC ()

@end

@implementation SuppliersVC

- (void)viewDidLoad {
    [super viewDidLoad];

     
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"供应商";
    [self configView];
    // Do any additional setup after loading the view.
}

- (void) configView
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:WDH_CGRectMake(0, 64, 375, 603)];
    imageView.image = [UIImage imageNamed:@"供应商申请背景图"];
    [self.view addSubview:imageView];
    
    UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
    Btn.frame = WDH_CGRectMake(20, 597, 335, 50);
    Btn.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:74 / 255.0 blue:91 / 255.0 alpha:1];
    [Btn setTitle:@"立即申请" forState:UIControlStateNormal];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Btn.layer.cornerRadius = 5;
    Btn.layer.masksToBounds = YES;
    Btn.titleLabel.font = [UIFont systemFontOfSize:20* kScreenHeight1];
    [self.view addSubview:Btn];
    [Btn addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void) handleAction
{
     if ([_type isEqualToString:@"1"]) {
          PerfectInfoVC * zjwVC = [[PerfectInfoVC alloc] init];
          zjwVC.type = @"1";
          [self.navigationController pushViewController:zjwVC animated:YES];
     } else {
          PerfectInfoVC * zjwVC = [[PerfectInfoVC alloc] init];
          zjwVC.type = @"2";
          zjwVC.dic = _dic;
          [self.navigationController pushViewController:zjwVC animated:YES];
     }
    
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
