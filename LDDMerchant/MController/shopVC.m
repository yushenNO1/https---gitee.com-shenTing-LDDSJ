//
//  shopVC.m
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "shopVC.h"
#import "UIImageView+WebCache.h"

#import "UIColor+Addition.h"
#import "AFNetworking.h"
#import "NetURL.h"
#import "shopMapVC.h"
#import "AgentViewController.h"
@interface shopVC ()
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * rightLabel;

@property (nonatomic, strong) UILabel * addLabel1;
@property (nonatomic, strong) UIButton * areaBtn;
@property (nonatomic, strong) UILabel * numLabel1;
@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic,copy) NSString * JStr;  //经度
@property (nonatomic,copy) NSString * WStr;  //纬度


@end

@implementation shopVC
-(void)viewWillAppear:(BOOL)animated
{
     [self configView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店管理";
    self.view.backgroundColor = [UIColor backGray];
     [self configNav];
     
}
- (void)configNav
{
     UIBarButtonItem *barBtn =[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnClick)];
     self.navigationItem.rightBarButtonItem =barBtn;
}

- (void)barBtnClick {
     AgentViewController * vc = [[AgentViewController alloc] init];
     [self.navigationController pushViewController:vc animated:YES];
}

- (void) configView {
    
    
    NSDictionary * responseObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyInfo"];
    NSLog(@"56464---%@", responseObject);
    

    
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, (self.view.bounds.size.width), 200)];
    view1.backgroundColor =[UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(10 * kScreenWidth1, 64 + 16 * kScreenHeight1, 100 * kScreenWidth1, 100 * kScreenHeight1);
    _imageView.layer.cornerRadius = 50* kScreenWidth1;
    _imageView.layer.masksToBounds = YES;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", responseObject[@"licence"]]] placeholderImage:[UIImage imageNamed:@"img_11"]];
    [view1 addSubview:_imageView];

    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 * kScreenWidth1, 64 + 12 * kScreenHeight1, 200 * kScreenWidth1, 40 * kScreenHeight1)];
    _nameLabel.text = responseObject[@"name"];
    
    _nameLabel.font = [UIFont systemFontOfSize:20];
    [view1 addSubview:_nameLabel];
    
    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 * kScreenWidth1, 64 + 60 * kScreenHeight1, 200 * kScreenWidth1, 30 * kScreenHeight1)];
    _leftLabel.text = responseObject[@"areaName"];
    
    _leftLabel.font = [UIFont systemFontOfSize:15];
    _leftLabel.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:_leftLabel];
   
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 * kScreenWidth1, 64 + 80 * kScreenHeight1, 200 * kScreenWidth1, 30 * kScreenHeight1)];
    _rightLabel.text = responseObject[@"categoryName"];
    
    _rightLabel.textColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
    _rightLabel.font = [UIFont systemFontOfSize:15];
    _rightLabel.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:_rightLabel];
    
    [self.view addSubview:view1];
    
    UILabel * backLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 150 * kScreenHeight1, 375 * kScreenWidth1, 60 * kScreenHeight1)];
    backLabel1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backLabel1];

    UILabel * backLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 215 * kScreenHeight1, 375 * kScreenWidth1, 60 * kScreenHeight1)];
    backLabel4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backLabel4];
    
    UILabel * backLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 280 * kScreenHeight1, 375 * kScreenWidth1, 60 * kScreenHeight1)];
    backLabel2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backLabel2];
    UILabel * backLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 345 * kScreenHeight1, 375 * kScreenWidth1, 60 * kScreenHeight1)];
    backLabel3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backLabel3];
    
    UILabel * addLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kScreenWidth1, 64 + 165 * kScreenHeight1, 100 * kScreenWidth1, 30 * kScreenHeight1)];
    addLabel.text = @"基本信息:";
    [self.view addSubview:addLabel];
    
    UILabel * dianMianLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kScreenWidth1, 64 + 230 * kScreenHeight1, 100 * kScreenWidth1, 30 * kScreenHeight1)];
    dianMianLabel.text = @"店面信息:";
    [self.view addSubview:dianMianLabel];
    
    UILabel * areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kScreenWidth1, 64 + 295 * kScreenHeight1, 80 * kScreenWidth1, 30 * kScreenHeight1)];
    areaLabel.text = @"门面地址:";
    [self.view addSubview:areaLabel];
    
    UILabel * numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kScreenWidth1, 64 + 360 * kScreenHeight1, 150 * kScreenWidth1, 30 * kScreenHeight1)];
    numLabel.text = @"关联账号:";
    [self.view addSubview:numLabel];
    
    self.addLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(90 * kScreenWidth1, 64 + 150 * kScreenHeight1, 275 * kScreenWidth1, 60 * kScreenHeight1)];
    _addLabel1.text = responseObject[@"name"];
    _addLabel1.numberOfLines = 0;
    _addLabel1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_addLabel1];
    
    UILabel * dianMianLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(90 * kScreenWidth1, 64 + 215 * kScreenHeight1, 275 * kScreenWidth1, 60 * kScreenHeight1)];
    dianMianLabel1.text = responseObject[@"content"];
    dianMianLabel1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:dianMianLabel1];
    
    
    UILabel * dianMianLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(90 * kScreenWidth1, 64 + 280 * kScreenHeight1, 275 * kScreenWidth1, 60 * kScreenHeight1)];
    dianMianLabel2.text = [NSString stringWithFormat:@"%@%@",responseObject[@"addressDetail"],responseObject[@"address"]];
    dianMianLabel2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:dianMianLabel2];
//    self.areaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [_areaBtn setBackgroundImage:[UIImage imageNamed:@"postion@3x"] forState:UIControlStateNormal];
//    [_areaBtn addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventTouchUpInside];
//    _areaBtn.frame = CGRectMake(330 * kScreenWidth1, 64 + 293 * kScreenHeight1, 25 * kScreenWidth1, 30 * kScreenHeight1);
//    [self.view addSubview:_areaBtn];
    
    self.numLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(90 * kScreenWidth1, 64 + 345 * kScreenHeight1, 275 * kScreenWidth1, 60 * kScreenHeight1)];
    NSMutableString * str2 = [responseObject[@"mobile"] mutableCopy];
    [str2 deleteCharactersInRange:NSMakeRange(3, 4)];
    [str2 insertString:@"****" atIndex:3];
    _numLabel1.text = str2;
    //头像
    
    _JStr = responseObject[@"longitude"];
    _WStr = responseObject[@"latitude"];
    _numLabel1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_numLabel1];

}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
//}

- (void) handleAction
{
    shopMapVC * shopVC = [[shopMapVC alloc] init];
    shopVC.JStr = _JStr;
    shopVC.WStr = _WStr;
    shopVC.shopName = _nameLabel.text;
    [self.navigationController pushViewController:shopVC animated:YES];
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
