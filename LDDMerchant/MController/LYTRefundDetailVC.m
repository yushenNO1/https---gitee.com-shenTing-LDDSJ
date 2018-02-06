//
//  LYTRefundDetailVC.m
//  WDHMerchant
//
//  Created by 李宇廷 on 2018/1/24.
//  Copyright © 2018年 Zjw. All rights reserved.
//

#import "LYTRefundDetailVC.h"

#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "JMDropMenu.h"

@interface AgentView1 : UIView
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;

@end

@implementation AgentView1
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

@interface LYTRefundDetailVC ()<JMDropMenuDelegate>
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,assign)NSInteger   indexId;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIView *backView;
@end

@implementation LYTRefundDetailVC

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
     
     AgentView1 *view1 = [[AgentView1 alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 40)];
     [_scroll addSubview:view1];
     view1.titleLabel.text = @"订单编号:";
     view1.contentLabel.text = _dataDic[@"order_no"];
     
     AgentView1 *view2 = [[AgentView1 alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth - 20, 40)];
     [_scroll addSubview:view2];
     view2.titleLabel.text = @"退款金额:";
     view2.contentLabel.text = [NSString stringWithFormat:@"%.2f",[_dataDic[@"back_money"]doubleValue]];
     
     AgentView1 *view3 = [[AgentView1 alloc]initWithFrame:CGRectMake(10, 90, kScreenWidth - 20, 40)];
     [_scroll addSubview:view3];
     view3.titleLabel.text = @"联系号码:";
     view3.contentLabel.text = _dataDic[@"mobile"];
     
     AgentView1 *view4 = [[AgentView1 alloc]initWithFrame:CGRectMake(10, 130, kScreenWidth - 20, 40)];
     [_scroll addSubview:view4];
     view4.titleLabel.text = @"退款原因:";
     view4.contentLabel.text = _dataDic[@"reason"];
     
     AgentView1 *view5 = [[AgentView1 alloc]initWithFrame:CGRectMake(10, 170, kScreenWidth - 20, 40)];
     [_scroll addSubview:view5];
     view5.titleLabel.text = @"商品状态:";
     
     if ([_dataDic[@"state"] intValue] == 0) {
          view5.contentLabel.text = @"待审核";
     }else if ([_dataDic[@"state"] intValue] == 1){
          view5.contentLabel.text = @"审核成功代发货";
     }else if ([_dataDic[@"state"] intValue] == 2){
          view5.contentLabel.text = @"已入库";
     }else if ([_dataDic[@"state"] intValue] == 3){
          view5.contentLabel.text = @"已完成";
     }else if ([_dataDic[@"state"] intValue] == 4){
          view5.contentLabel.text = @"已取消";
     }else if ([_dataDic[@"state"] intValue] == 5){
          view5.contentLabel.text = @"部分入库";
     }else if ([_dataDic[@"state"] intValue] == 6){
          view5.contentLabel.text = @"拒绝申请";
     }
     
     
     
     UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 220, kScreenWidth - 20, 20)];
     title.text = @"凭证:";
     [_scroll addSubview:title];
     
     UIImageView *coverimg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 240, kScreenWidth-20, 200)];
     [coverimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataDic[@"pics"]]] placeholderImage:[UIImage imageNamed:@""]];
     [_scroll addSubview:coverimg];
     

     UILabel *status = [[UILabel alloc]initWithFrame:CGRectMake(10, 450, 100, 20)];
     status.text = @"处理状态:";
     status.textAlignment = NSTextAlignmentRight;
     status.font = [UIFont systemFontOfSize:14];
     [_scroll addSubview:status];
     
     UIButton *statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     statusBtn.frame = CGRectMake(115, 450, 120, 20);
     statusBtn.layer.borderColor = [[UIColor grayColor]CGColor];
     statusBtn.layer.borderWidth = 1.0f;
     statusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
     [statusBtn setTitle:@"待审核" forState:UIControlStateNormal];
     if ([_dataDic[@"state"] intValue] == 0) {
          [statusBtn setTitle:@"待审核" forState:UIControlStateNormal];
     }else if ([_dataDic[@"state"] intValue] == 1){
          [statusBtn setTitle:@"审核成功代发货" forState:UIControlStateNormal];
     }else if ([_dataDic[@"state"] intValue] == 2){
          [statusBtn setTitle:@"已入库" forState:UIControlStateNormal];
     }else if ([_dataDic[@"state"] intValue] == 3){
          [statusBtn setTitle:@"已完成" forState:UIControlStateNormal];
     }else if ([_dataDic[@"state"] intValue] == 4){
          [statusBtn setTitle:@"已取消" forState:UIControlStateNormal];
     }else if ([_dataDic[@"state"] intValue] == 5){
          [statusBtn setTitle:@"部分入库" forState:UIControlStateNormal];
     }else if ([_dataDic[@"state"] intValue] == 6){
          [statusBtn setTitle:@"拒绝申请" forState:UIControlStateNormal];
     }
     statusBtn.tag = 55554;
     [statusBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
     [statusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
     [_scroll addSubview:statusBtn];
     

     
     
     
     
     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
     btn.frame = CGRectMake(10, 480, kScreenWidth - 20, 50);
     btn.backgroundColor = [UIColor AppColor];
     [btn setTitle:@"提交" forState:UIControlStateNormal];
     [_scroll addSubview:btn];
     [btn addTarget:self action:@selector(requestShopAgentSupplierList) forControlEvents:UIControlEventTouchUpInside];
     _scroll.contentSize = CGSizeMake(kScreenWidth, 260 + kScreenWidth + 200);
}


#pragma mark - 自定义按钮
- (void)btnClick:(UIButton *)sender {
     

//     [[JMDropMenu alloc] initWithFrame:CGRectMake(115, 460 , 130, 240) ArrowOffset:60.f TitleArr:arr ImageArr:imgArr Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
    NSArray *arr ;
    if ([_dataDic[@"state"] integerValue] == 0) {
        arr = @[@"审批通过代发货",@"已完成",@"已入库",@"部分入库",@"拒绝申请"];
    } else if ([_dataDic[@"state"] integerValue] == 1) {
        arr = @[@"已完成",@"已入库",@"部分入库"];
    } else if ([_dataDic[@"state"] integerValue] == 2) {
        arr = @[@"已完成"];
    } else if ([_dataDic[@"state"] integerValue] == 5) {
        arr = @[@"已完成"];
    }
     
    
     _backView = [[UIView alloc]initWithFrame:CGRectMake(115, 470 , 120 , 0 )];
     for (int i = 0; i < arr.count; i ++) {
          UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
          [btn setTitle:arr[i] forState:UIControlStateNormal];
          [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          [_backView addSubview:btn];
          btn.titleLabel.font = [UIFont systemFontOfSize:12];
          btn.backgroundColor = [UIColor whiteColor];
          btn.tag = i;
          [btn addTarget:self action:@selector(popBtnClick:) forControlEvents:UIControlEventTouchUpInside] ;
          btn.frame = CGRectMake(0, 20 * i, 120, 20);
     }
     [_scroll addSubview:_backView];
     
     [UIView animateWithDuration:1 animations:^{
          _backView.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 20 , 120 , 140 );
     }];
}

-(void)popBtnClick:(UIButton *)sender{
    
    NSArray *arr ;
    if ([_dataDic[@"state"] integerValue] == 0) {
        arr = @[@"审批通过代发货",@"已完成",@"已入库",@"部分入库",@"拒绝申请"];
    } else if ([_dataDic[@"state"] integerValue] == 1) {
        arr = @[@"已完成",@"已入库",@"部分入库"];
    } else if ([_dataDic[@"state"] integerValue] == 2) {
        arr = @[@"已完成"];
    } else if ([_dataDic[@"state"] integerValue] == 5) {
        arr = @[@"已完成"];
    }
     _indexId = sender.tag;
     UIButton *btn = [self.view viewWithTag:55554];
     [btn setTitle:arr[sender.tag] forState:UIControlStateNormal];
     
     
     [UIView animateWithDuration:0.5 animations:^{
          _backView.frame = CGRectMake(115, 470 , 120 , 0 );
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
     [manager POST:[NSString stringWithFormat:LSKurl@"/api/v1/life/mgorder/sellback/auth?sellBackId=%@&status=%ld",_dataDic[@"id"],_indexId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"当前代理下的商家------%@", responseObject);
          if ([responseObject[@"code"] integerValue] == 0) {
               Alert_show_pushRoot(@"完成")
          }
          
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"当前代理下的商家------%@", error);
     }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.5 animations:^{
        _backView.frame = CGRectMake(115, 470 , 120 , 0 );
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
    }];
}
@end
