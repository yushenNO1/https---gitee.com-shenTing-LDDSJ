//
//  ApplyAgentVC.m
//  WDHMerchant
//
//  Created by 云盛科技 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "ApplyAgentVC.h"
#import "LYTAgent.h"

@interface ApplyAgentVC ()

@end

@implementation ApplyAgentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
     UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 375*kScreenWidth1, 603*kScreenHeight1)];
     img.image = [UIImage imageNamed:@"区域代理申请背景"];
     [self.view addSubview:img];
     
     
     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
     btn.frame = CGRectMake(20*kScreenWidth1, 600*kScreenHeight1, 345*kScreenHeight1, 40*kScreenWidth1);
     btn.backgroundColor = [UIColor colorWithRed:239/255.0 green:64/255.0 blue:87/255.0 alpha:1];
     [self.view addSubview:btn];
     [btn setTitle:@"申请代理" forState:UIControlStateNormal];
     [btn addTarget: self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btnClick{
     LYTAgent *vc = [[LYTAgent alloc]init];
     [self.navigationController pushViewController:vc animated:YES];
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
