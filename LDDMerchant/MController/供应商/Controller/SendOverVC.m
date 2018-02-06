//
//  SendOverVC.m
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/21.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "SendOverVC.h"
#import "XLPaymentSuccessHUD.h"
#import "OrderIncomeVC.h"
@interface SendOverVC ()

@end

@implementation SendOverVC
-(void)viewWillAppear:(BOOL)animated
{
     
     self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
     [super viewDidLoad];
     self.view.backgroundColor = [UIColor backGray];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(Success)];
     self.navigationController.navigationBar.tintColor = [UIColor blackColor];
     [self showSuccessAnimation];
}

- (void)Success {
     
     NSArray *pushVCAry=[self.navigationController viewControllers];
     UIViewController *popVC=[pushVCAry objectAtIndex:pushVCAry.count-3];
     [self.navigationController popToViewController:popVC animated:YES];
     
     for (UIViewController *temp in self.navigationController.viewControllers) {
          if ([temp isKindOfClass:[OrderIncomeVC class]]) {
               [self.navigationController popToViewController:temp animated:YES];
          } else {
               [self.navigationController popToRootViewControllerAnimated:YES];
          }
     }
}

-(void)showSuccessAnimation {
     //显示支付完成动画
     [XLPaymentSuccessHUD showIn:self.view frame:WDH_CGRectMake(285 / 2, 150, 90, 90)];
     UILabel * label = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 260, 375, 30)];
     label.textAlignment = 1;
     label.font = FontSize(15);
     label.text = @"发货成功";
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
