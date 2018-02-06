//
//  OverVC.m
//  LSK
//
//  Created by 张敬文 on 2017/5/2.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "OverVC.h"
#import "XLPaymentSuccessHUD.h"
@interface OverVC ()

@end

@implementation OverVC
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(Success)];

    [self showSuccessAnimation];
}

- (void)Success {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)showSuccessAnimation {
    //显示支付完成动画
    [XLPaymentSuccessHUD showIn:self.view frame:WDH_CGRectMake(285 / 2, 150, 90, 90)];
    UILabel * label = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 260, 375, 30)];
    label.textAlignment = 1;
    label.font = FontSize(15);
    label.text = @"商家申请成功";
    [self.view addSubview:label];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [XLPaymentSuccessHUD hideIn:self.view];
    self.tabBarController.tabBar.hidden = NO;
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
