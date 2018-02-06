//
//  AgentShopDetailVC.m
//  WDHMerchant
//
//  Created by 李宇廷 on 2018/1/22.
//  Copyright © 2018年 Zjw. All rights reserved.
//

#import "AgentShopDetailVC.h"

#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "JMDropMenu.h"

@interface AgentView : UIView
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;

@end

@implementation AgentView
-(instancetype)initWithFrame:(CGRect)frame{
     self = [super initWithFrame:frame];
     if (self) {
          [self addSubview:self.titleLabel];
          [self addSubview:self.contentLabel];
          self.backgroundColor = [UIColor backGray];
     }
     return self;
}
-(UILabel *)titleLabel{
     if (!_titleLabel) {
          _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 20)];
          _titleLabel.textAlignment = NSTextAlignmentRight;
          _titleLabel.font = [UIFont systemFontOfSize:14];
     }
     return _titleLabel;
}
-(UILabel *)contentLabel{
     if (!_contentLabel) {
          _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 10, self.frame.size.width - 90, 20)];
          _contentLabel.font = [UIFont systemFontOfSize:14];
     }
     return _contentLabel;
}

@end

@interface AgentShopDetailVC ()<JMDropMenuDelegate>
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,assign)NSInteger   indexId;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIView *backView;
@end

@implementation AgentShopDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self configView];
     self.view.backgroundColor = [UIColor whiteColor];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifikation:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)notifikation:(NSNotification *)sender
{
     CGRect rect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
     self.scroll.frame = CGRectMake(0, -rect.size.height, kScreenWidth, kScreenHeight);
     NSLog(@"键盘大小------%@",sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
}
-(void)configView{
     NSLog(@"dataDic-----%@",_dataDic);
     _scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
     _scroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
     [self.view addSubview:_scroll];
     
     AgentView *view1 = [[AgentView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 40)];
     [_scroll addSubview:view1];
     view1.titleLabel.text = @"商铺名:";
     view1.contentLabel.text = _dataDic[@"name"];
     
     AgentView *view2 = [[AgentView alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth - 20, 40)];
     [_scroll addSubview:view2];
     view2.titleLabel.text = @"手机号:";
     view2.contentLabel.text = _dataDic[@"mobile"];
     
     AgentView *view3 = [[AgentView alloc]initWithFrame:CGRectMake(10, 90, kScreenWidth - 20, 40)];
     [_scroll addSubview:view3];
     view3.titleLabel.text = @"地址:";
     view3.contentLabel.text = _dataDic[@"addressDetail"];
     
     AgentView *view4 = [[AgentView alloc]initWithFrame:CGRectMake(10, 130, kScreenWidth - 20, 40)];
     [_scroll addSubview:view4];
     view4.titleLabel.text = @"详细地址:";
     view4.contentLabel.text = _dataDic[@"address"];
     
     AgentView *view5 = [[AgentView alloc]initWithFrame:CGRectMake(10, 170, kScreenWidth - 20, 40)];
     [_scroll addSubview:view5];
     view5.titleLabel.text = @"视频介绍:";
     view5.contentLabel.text = _dataDic[@"url"];
     
     
     UIImageView *licenceImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 220, kScreenWidth/2-20, kScreenWidth/2-20)];
     [licenceImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataDic[@"licence"]]] placeholderImage:[UIImage imageNamed:@""]];
     [_scroll addSubview:licenceImg];
     
     UIImageView *coverimg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 + 10, 220, kScreenWidth/2-20, kScreenWidth/2-20)];
     [coverimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataDic[@"cover"]]] placeholderImage:[UIImage imageNamed:@""]];
     [_scroll addSubview:coverimg];
     
     
     UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(10, 210 + kScreenWidth/2, 100, 20)];
     status.text = @"商家入驻状态:";
     status.textAlignment = NSTextAlignmentRight;
     status.font = [UIFont systemFontOfSize:14];
     [_scroll addSubview:status];
     
     UIButton *statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     statusBtn.frame = CGRectMake(115, 210 + kScreenWidth/2, 80, 20);
     statusBtn.layer.borderColor = [[UIColor grayColor]CGColor];
     statusBtn.layer.borderWidth = 1.0f;
     statusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
     [statusBtn setTitle:@"待审核" forState:UIControlStateNormal];
     statusBtn.tag = 55554;
     [statusBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
     [statusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
     [_scroll addSubview:statusBtn];
     
     if ([_dataDic[@"status"]intValue] == 0) {
          [statusBtn setTitle:@"审批中" forState:UIControlStateNormal];
     }else if ([_dataDic[@"status"]intValue] == 1){
          [statusBtn setTitle:@"审批通过" forState:UIControlStateNormal];
     }else if ([_dataDic[@"status"]intValue] == 2){
          [statusBtn setTitle:@"审批不通过" forState:UIControlStateNormal];
     }else if ([_dataDic[@"status"]intValue] == 3){
          [statusBtn setTitle:@"禁用" forState:UIControlStateNormal];
     }else if ([_dataDic[@"status"]intValue] == 4){
          //申请代理
          [statusBtn setTitle:@"废弃" forState:UIControlStateNormal];
     }
     
     
     
     _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 240 + kScreenWidth/2, kScreenWidth - 20, 60)];
     [_scroll addSubview:_textView];
     _textView.backgroundColor = [UIColor backGray];
     // 设置文本字体
     _textView.font = [UIFont fontWithName:@"Arial" size:14.0f];
     // 设置文本对齐方式
     _textView.textAlignment = NSTextAlignmentLeft;
     
     
     
     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
     btn.frame = CGRectMake(10, 380 + kScreenWidth/2, kScreenWidth - 20, 50);
     btn.backgroundColor = [UIColor redColor];
     [btn setTitle:@"提交" forState:UIControlStateNormal];
     [_scroll addSubview:btn];
     [btn addTarget:self action:@selector(requestShopAgentSupplierList) forControlEvents:UIControlEventTouchUpInside];
     _scroll.contentSize = CGSizeMake(kScreenWidth, 380 + kScreenWidth/2 + 100);
}


#pragma mark - 自定义按钮
- (void)btnClick:(UIButton *)sender {
     NSArray *arr = @[@"待审批",@"审批通过",@"审批不通过",@"禁用",@"弃用"];
//     NSArray *imgArr = @[@"",@"",@"",@"",@"",@""];
//     [[JMDropMenu alloc] initWithFrame:CGRectMake(115, 300 + kScreenWidth/2, 130, 200) ArrowOffset:60.f TitleArr:arr ImageArr:imgArr Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];

     _backView = [[UIView alloc]initWithFrame:CGRectMake(sender.frame.origin.x, 210 + kScreenWidth/2, 80, 0)];
     for (int i = 0; i < arr.count; i ++) {
          UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
          [btn setTitle:arr[i] forState:UIControlStateNormal];
          [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          [_backView addSubview:btn];
          btn.titleLabel.font = [UIFont systemFontOfSize:12];
          btn.backgroundColor = [UIColor whiteColor];
          btn.tag = i;
          [btn addTarget:self action:@selector(popBtnClick:) forControlEvents:UIControlEventTouchUpInside] ;
          btn.frame = CGRectMake(0, 20 * i, 80, 20);
     }
     [_scroll addSubview:_backView];
     
     [UIView animateWithDuration:1 animations:^{
          _backView.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 20 , 80 , 100 );
     }];
}
-(void)popBtnClick:(UIButton *)sender{
     NSArray *arr = @[@"待审批",@"审批通过",@"审批不通过",@"禁用",@"弃用"];
     _indexId = sender.tag;
     UIButton *btn = [self.view viewWithTag:55554];
     [btn setTitle:arr[sender.tag] forState:UIControlStateNormal];
     
     
     [UIView animateWithDuration:0.5 animations:^{
          _backView.frame = CGRectMake(115, 210 + kScreenWidth/2 , 80 , 0 );
     } completion:^(BOOL finished) {
          [_backView removeFromSuperview];
     }];
     
     
}


-(void)requestShopAgentSupplierList{
     NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str1 forHTTPHeaderField:@"Authorization"];
     //[NSString stringWithFormat:@"%@%@",LSKurl,MerchantsInfo]
     NSString *utf8Text = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     [manager GET:[NSString stringWithFormat:LSKurl@"/api/v1/life/agent/apply?id=%@&status=%ld&desc=%@",_dataDic[@"id"],_indexId,utf8Text] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"当前代理下的商家------%@", responseObject);
          if ([responseObject[@"code"] integerValue] == 0) {
               Alert_show_pushRoot(@"完成")
          }
          
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"当前代理下的商家------%@", error);
     }];
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
