//
//  ChooseSendVC.m
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/16.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "ChooseSendVC.h"
#import "ScanVC.h"
#import "SendListVC.h"
@interface ChooseSendVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView * imageView_1;
@property (nonatomic, strong) UIImageView * imageView_2;
@property (nonatomic, strong) UILabel * label_2;
@property (nonatomic, strong) UITextField * tf;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * label;
@end

@implementation ChooseSendVC

- (void)viewDidLoad {
    [super viewDidLoad];
     
     _code = @"0";
     self.title = @"发货";
     self.view.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
     [self  setNavigationBarConfiguer];
     [self configView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reValue1:) name:@"send" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reValue:) name:@"Scan" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifikation:) name:UIKeyboardWillChangeFrameNotification object:nil];
//     UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
//     
//     [self.tableView addGestureRecognizer:myTap];
}
//
//- (void)scrollTap:(id)sender {
//     [self.view endEditing:YES];
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.view endEditing:YES];
}

-(void)notifikation:(NSNotification *)sender
{
     CGRect rect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
     self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, rect.origin.y);
     NSLog(@"键盘大小------%@",sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
}

- (void)reValue:(NSNotification * )notifi{
     if ([notifi.userInfo[@"code"] length] != 0) {
          _tf.text = notifi.userInfo[@"code"];
     }
}

- (void)reValue1:(NSNotification * )notifi{
     _label = [NSString stringWithFormat:@"%@", notifi.userInfo[@"text"]];
     _label_2.text = [NSString stringWithFormat:@"快递公司         %@", notifi.userInfo[@"text"]];
}

- (void) configView {
     UIView * backView_1 = [[UIView alloc] initWithFrame:WDH_CGRectMake(-1, 50 + 64, 377, 100)];
     backView_1.backgroundColor = [UIColor whiteColor];
     backView_1.layer.borderWidth = 1.0f;
     backView_1.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
     [self.view addSubview:backView_1];
     
     UILabel * lineLabel_1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 100 + 64, 375, 1)];
     lineLabel_1.backgroundColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1];
     [self.view addSubview:lineLabel_1];
     
     UILabel * label_1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(20, 0 + 64, 375, 50)];
     label_1.text = @"发货方式";
     label_1.textColor = [UIColor colorWithRed:160 / 255.0 green:160 / 255.0 blue:160 / 255.0 alpha:1];
     label_1.font = [UIFont systemFontOfSize:15];
     [self.view addSubview:label_1];
     
     UILabel * textLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(20, 50 + 64, 300, 49)];
     textLabel.text = @"快递";
     textLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     textLabel.font = [UIFont systemFontOfSize:13];
     [self.view addSubview:textLabel];
     
     UILabel * textLabel1 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(20, 101 + 64, 100, 48)];
     textLabel1.text = @"无需物流";
     textLabel1.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     textLabel1.font = [UIFont systemFontOfSize:13];
     [self.view addSubview:textLabel1];
     
     self.imageView_1 = [[UIImageView alloc] initWithFrame:WDH_CGRectMake(330, 65 + 64, 20, 20)];
     _imageView_1.image = [UIImage imageNamed:@"包邮"];
     [self.view addSubview:_imageView_1];
     
     self.imageView_2 = [[UIImageView alloc] initWithFrame:WDH_CGRectMake(330, 115 + 64, 20, 20)];
     _imageView_2.image = [UIImage imageNamed:@"包邮"];
     _imageView_2.hidden = YES;
     [self.view addSubview:_imageView_2];

     UIButton * Btn = [UIButton buttonWithType:UIButtonTypeSystem];
     Btn.frame = WDH_CGRectMake(0, 50 + 64, 375, 50);
     Btn.tag = 1;
     Btn.backgroundColor = [UIColor clearColor];
     [Btn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:Btn];
     
     UIButton * Btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
     Btn1.frame = WDH_CGRectMake(0, 100 + 64, 375, 50);
     Btn1.tag = 2;
     Btn1.backgroundColor = [UIColor clearColor];
     [Btn1 addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:Btn1];
     
     
     UIView * backView_2 = [[UIView alloc] initWithFrame:WDH_CGRectMake(-1, 200 + 64, 377, 100)];
     backView_2.backgroundColor = [UIColor whiteColor];
     backView_2.layer.borderWidth = 1.0f;
     backView_2.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
     [self.view addSubview:backView_2];
     
     UILabel * lineLabel_2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 250 + 64, 375, 1)];
     lineLabel_2.backgroundColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1];
     [self.view addSubview:lineLabel_2];
     
     UILabel * textLabel2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(20, 150 + 64, 375, 50)];
     textLabel2.text = @"快递单号";
     textLabel2.textColor = [UIColor colorWithRed:160 / 255.0 green:160 / 255.0 blue:160 / 255.0 alpha:1];
     textLabel2.font = [UIFont systemFontOfSize:15];
     [self.view addSubview:textLabel2];
     
     self.tf = [[UITextField alloc] initWithFrame:WDH_CGRectMake(20, 200 + 64, 200, 49)];
     _tf.delegate = self;
     _tf.placeholder = @"请输入快递单号";
     [self.view addSubview:_tf];
     
     UILabel * lineLabel_3 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(250, 205 + 64, 1, 40)];
     lineLabel_3.backgroundColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1];
     [self.view addSubview:lineLabel_3];
     
     UIButton * Btn22 = [UIButton buttonWithType:UIButtonTypeSystem];
     Btn22.frame = WDH_CGRectMake(280, 210 + 64, 40, 30);
     [Btn22 setBackgroundImage:[UIImage imageNamed:@"扫码快递单号"] forState:UIControlStateNormal];
     [Btn22 addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:Btn22];
     
     self.label_2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(20, 251 + 64, 300, 48)];
     _label_2.text = @"快递公司";
     _label_2.tag = 9;
     _label_2.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     _label_2.font = [UIFont systemFontOfSize:13* kScreenHeight1];
     [self.view addSubview:_label_2];
     
     UIButton * Btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
     Btn2.frame = WDH_CGRectMake(0, 250 + 64, 375, 50);
     Btn2.backgroundColor = [UIColor clearColor];
     [Btn2 addTarget:self action:@selector(handleAction1) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:Btn2];
}

- (void)setNavigationBarConfiguer {
     [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
     UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(Over)];
     self.navigationItem.rightBarButtonItem = rightBarButtonItem;
     UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
     self.navigationItem.leftBarButtonItem = item;
    
}

- (void) leftBarBtnClick {
     [self.navigationController popViewControllerAnimated:YES];
}



- (void) handleAction:(UIButton *)sender {
     if (sender.tag == 1) {
          _code = @"0";
          _imageView_1.hidden = NO;
          _imageView_2.hidden = YES;
     } else {
          _code = @"1";
          _imageView_1.hidden = YES;
          _imageView_2.hidden = NO;
     }
//     ScanVC * VC = [[ScanVC alloc] init];
//     [self.navigationController pushViewController:VC animated:YES];
}

- (void) handleAction1 {
     SendListVC * VC = [[SendListVC alloc] init];
     [self.navigationController pushViewController:VC animated:YES];
}

- (void) Over {
     if ([_code isEqualToString:@"0"]) {
          if (_tf.text.length == 0) {
               Alert_Show(@"请填写快递单号")
          } else if ([_label_2.text isEqualToString:@"快递公司"]) {
               Alert_Show(@"请选择快递公司")
          } else {
               //快递信息验证通过
               NSDictionary *dic = @{@"label":_label, @"tf":_tf.text};
               [[NSNotificationCenter defaultCenter] postNotificationName:@"sendGood" object:nil userInfo:dic];
               [self.navigationController popViewControllerAnimated:YES];
          }
     } else {
          //无需物流通过
          NSDictionary *dic = @{@"label":@"无需物流", @"tf":@""};
          [[NSNotificationCenter defaultCenter] postNotificationName:@"sendGood" object:nil userInfo:dic];
          [self.navigationController popViewControllerAnimated:YES];
     }
     
}

- (void) Action {
     ScanVC * zjwVC = [[ScanVC alloc] init];
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
