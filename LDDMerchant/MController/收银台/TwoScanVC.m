//
//  TwoScanVC.m
//  收银台
//
//  Created by 张敬文 on 2017/5/25.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "TwoScanVC.h"
#import "AFNetworking.h"
#import "UIImage+QRCode.h"
@interface TwoScanVC ()
@property (nonatomic, strong) UIImageView *QRImgView;
@end

@implementation TwoScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    // Do any additional setup after loading the view.
}

- (void) configView
{
    UIImageView * backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"收银付款二维码"]];
    backImageView.frame = WDH_CGRectMake(0, 64, 375, 603);
    [self.view addSubview:backImageView];
    
    UILabel * back = [[UILabel alloc] initWithFrame:WDH_CGRectMake(70, 210, 235, 235)];
    back.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1];
    [self.view addSubview:back];
    
    self.QRImgView = [[UIImageView alloc]initWithFrame:WDH_CGRectMake(85, 225, 205, 205)];
    _QRImgView.image = [UIImage qrImageWithContent:[NSString stringWithFormat:@"Code@#%@#%@", _orderId, _totalAmount] logo:nil size:200 red:38 green:38 blue:38];
    [self.view addSubview:_QRImgView];
//    self.QRImgView.image =
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
