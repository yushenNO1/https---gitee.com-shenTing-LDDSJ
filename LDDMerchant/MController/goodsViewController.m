//
//  goodsViewController.m
//  goods
//
//  Created by 王松松 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "GoodModel.h"
#import "goodsViewController.h"
#import "categoryViewController.h"
#import "packageViewController.h"
#import "buyViewController.h"
#import "earningsViewController.h"
#import "lableTableViewCell.h"
#import "NetURL.h"
#import "AFNetworking.h"
#import "UIColor+Addition.h"

@interface goodsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIView *  PickVC;

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) NSArray *detailArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImageView *imageView ;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) UILabel *shopLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UITextField *nameTf;
@property (nonatomic, strong) UITextField *describe_tf;
@property (nonatomic, strong) UITextField *priceTf;
@property (nonatomic, strong) UILabel *redTf;

@property (nonatomic, strong) NSString *proId; //编辑中项目id
@property (nonatomic, strong) NSArray *buyAry; //购买须知数组
@property (nonatomic, strong) NSString *cateId; //存储品类id
@property (nonatomic, assign) int dateNum; //存储品类id
@property (nonatomic, assign) int redNum; //存储品类id
@property (nonatomic, strong) NSString *imageStr; //tupianid
@property (nonatomic, strong) NSString *noteStr; //tupianid
//

@end

@implementation goodsViewController

- (void)viewDidLoad {
     [super viewDidLoad];
    _buyAry = @[@{@"content":@"是", @"key":@"1000", @"val":@"", @"title":@"是否支持极速退款", @"type":@"1"}, @{@"content":@"否", @"key":@"1001", @"val":@"", @"title":@"是否支持wifi", @"type":@"0"}, @{@"content":@"否", @"key":@"1002", @"val":@"", @"title":@"是否展示发票", @"type":@"0"}, @{@"content":@"否", @"key":@"1003", @"val":@"", @"title":@"是否享有优惠", @"type":@"0"}, @{@"content":@"否", @"key":@"1004", @"val":@"", @"title":@"是否预约", @"type":@"0"}, @{@"content":@"否", @"key":@"1005", @"val":@"", @"title":@"是否限制最高销量(接待量)", @"type":@"0"}, @{@"content":@"否", @"key":@"1006", @"val":@"", @"title":@"是否限购团购券", @"type":@"0"}, @{@"content":@"否", @"key":@"1007", @"val":@"", @"title":@"是否限用团购券", @"type":@"0"}, @{@"content":@"否", @"key":@"1008", @"val":@"", @"title":@"是否限制团购券使用人数", @"type":@"0"}];
    _noteStr = @"";
    _arr =@[@"品类",@"门店",@"套餐名称",@"套餐描述",@"套餐内容",@"团购价",@"积分使用",@"有效期",@"购买须知",];
    [self configView];
    [self interface];
    _dateNum = 12;
    _redNum = 0;
    self.title =@"商品上架";
    if (_idString != nil) {
        NSLog(@"执行编辑操作");
        [self requestDetail];
    } else {
        NSLog(@"执行新增操作");
    }
     NSDictionary *shopInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
    _shopLabel.text = shopInfo[@"shopName"];
//    [self regNotification];
//    [self request];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifikation:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


-(void)notifikation:(NSNotification *)sender
{
    CGRect rect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, rect.origin.y);
    NSLog(@"键盘大小------%@",sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
}


-(void)interface
{
    UIBarButtonItem *barBtn =[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnClick)];
    self.navigationItem.rightBarButtonItem =barBtn;
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = YES;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveValue:) name:@"ValuePass" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reValue:) name:@"BuyPass" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reValue1:) name:@"packagePass" object:nil];

}

- (void)receiveValue:(NSNotification* )notifi{
    _str = notifi.userInfo[@"value"];
    _cateId = notifi.userInfo[@"cateId"];
    _typeLabel.text = _str;
    NSLog(@"4444%@",_str);
    [self.tableView reloadData];
}

- (void)reValue:(NSNotification* )notifi{
    _buyAry = notifi.userInfo[@"vaue"];
    NSLog(@"修改后的数据236..%@", _buyAry);
}

- (void)reValue1:(NSNotification* )notifi{
    _noteStr = notifi.userInfo[@"jiequ"];
    NSLog(@"修改后的数据%@", _noteStr);
}

- (void)barBtnClick{
    NSLog(@"保  存00000");
    if (_idString != nil) {
        [self requesthaveid];
    } else {
        [self requestid];
    }

}

- (void)configView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
     [_tableView registerClass:[lableTableViewCell class] forCellReuseIdentifier:@"11"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 680 )];
    view.backgroundColor =[UIColor backGray];
    view.tag =1111;
    
    UIView * aView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 230 )];
    aView.backgroundColor = [UIColor grayColor];
    [view addSubview:aView];
    
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((aView.frame.size.width/2)-40 , (aView.frame.size.height/2)-40 , 80 * kScreenWidth1, 80 * kScreenHeight1)];
    _imageView.image = [UIImage imageNamed:@"xiagnce"];
    [view addSubview:_imageView];
    
    _btn =[UIButton buttonWithType:UIButtonTypeSystem];
    _btn.frame = aView.frame;
    [_btn setTitle:@"点击上传图片" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn setBackgroundColor:[UIColor clearColor]];
    [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_btn];
    
    for (int i = 0; i < 9; i++) {
        UILabel * backLabel = [[UILabel alloc] init];
        backLabel.backgroundColor = [UIColor whiteColor];
        backLabel.frame = CGRectMake(0, 230 + i * 44 + (i + 1) * 6 , 375 * kScreenWidth1, 44 * kScreenHeight1);
        [view addSubview:backLabel];
        
        UILabel * leftLabel = [[UILabel alloc] init];
        leftLabel.text = _arr[i];
        leftLabel.frame = CGRectMake(10 , 230 + i * 44 + (i + 1) * 6 , 150 * kScreenWidth1, 44 * kScreenHeight1);
        [view addSubview:leftLabel];
    }
    
    //第一行数据
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.frame = CGRectMake((self.view.frame.size.width/2)-75 , 236 , 150 * kScreenWidth1, 44 * kScreenHeight1);
    _typeLabel.textAlignment = 0;
    [view addSubview:_typeLabel];
    UIButton * type = [UIButton buttonWithType:UIButtonTypeSystem];
    type.backgroundColor = [UIColor clearColor];
    type.tag =1;
    [type addTarget:self action:@selector(handleType:) forControlEvents:UIControlEventTouchUpInside];
    
    type.frame = CGRectMake(0, 236 , 375 * kScreenWidth1, 44 * kScreenHeight1);
    [view addSubview:type];
    
    UIImageView *img1 =[[UIImageView alloc]initWithFrame:CGRectMake( (self.view.frame.size.width-30),246, 10 * kScreenWidth1, 20 * kScreenHeight1)];
    img1.image =[UIImage imageNamed:@"arrow_right@3x"];
    [view addSubview:img1];
    
    //第二行数据
    _shopLabel = [[UILabel alloc] init];
    _shopLabel.frame = CGRectMake((self.view.frame.size.width/2)-75 * kScreenWidth1, (CGRectGetMaxY(_typeLabel.frame)+7), 200 * kScreenWidth1, 44 * kScreenHeight1);
    _shopLabel.text = @" ";
    _shopLabel.textAlignment = 0;
    [view addSubview:_shopLabel];
    
    //第三行数据
    _nameTf = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-75 , 341 , 150 * kScreenWidth1, 34 * kScreenHeight1)];
    _nameTf.textAlignment = 0;
    _nameTf.placeholder = @"输入名称";
    
    _nameTf.borderStyle =UITextBorderStyleRoundedRect;

    _nameTf.delegate = self;
    _nameTf.tag = 1315;

    [view addSubview:_nameTf];
    
    //第四行数据
    _describe_tf = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-75, 391 , 150 * kScreenWidth1, 34 * kScreenHeight1)];
    _describe_tf.textAlignment = 0;
    _describe_tf.placeholder = @"输入套餐描述";
    _describe_tf.borderStyle =UITextBorderStyleRoundedRect;
    _describe_tf.delegate = self;
    _describe_tf.tag = 1318;
    [view addSubview:_describe_tf];
    
    
    //第五行数据
    UIButton * noteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    noteBtn.tag =2;
//    noteBtn.backgroundColor = [UIColor redColor];
    [noteBtn addTarget:self action:@selector(handleType:) forControlEvents:UIControlEventTouchUpInside];
    noteBtn.backgroundColor = [UIColor clearColor];
    noteBtn.frame = CGRectMake((self.view.frame.size.width/2)-75 , 441 , 250 * kScreenWidth1, 34 * kScreenHeight1);
    [view addSubview:noteBtn];
    
    UIImageView *img2 =[[UIImageView alloc]initWithFrame:CGRectMake( (self.view.frame.size.width-30),451, 10 * kScreenWidth1, 20 * kScreenHeight1)];
    img2.image =[UIImage imageNamed:@"arrow_right@3x"];
    [view addSubview:img2];
    
    //第六行数据
    _priceTf = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-75 , 491 , 150 * kScreenWidth1, 34 * kScreenHeight1)];
    _priceTf.placeholder = @"输入价格";
    _priceTf.textAlignment = 0;
    _priceTf.delegate = self;
    _priceTf.borderStyle =UITextBorderStyleRoundedRect;
    _priceTf.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTf.tag = 1316;

    [view addSubview:_priceTf];
    
    //第七行数据
    _redTf = [[UILabel alloc] init];
    _redTf.frame = CGRectMake((self.view.frame.size.width/2)-75 , 541 , 150 * kScreenWidth1, 34 * kScreenHeight1);
    _redTf.text = @"不使用积分";
    _redTf.textAlignment = 0;
    [view addSubview:_redTf];

    
    UIButton * knowBtn5 = [UIButton buttonWithType:UIButtonTypeSystem];
    [knowBtn5 addTarget:self action:@selector(handleAction9) forControlEvents:UIControlEventTouchUpInside];
    knowBtn5.backgroundColor = [UIColor clearColor];
    knowBtn5.frame = CGRectMake(0, 540 , 375 * kScreenWidth1, 44 * kScreenHeight1);
    [view addSubview:knowBtn5];
    
    UIImageView *img9 =[[UIImageView alloc]initWithFrame:CGRectMake( (self.view.frame.size.width-30),551, 10 * kScreenWidth1, 20 * kScreenHeight1)];
    img9.image =[UIImage imageNamed:@"arrow_right@3x"];
    [view addSubview:img9];
    
    //第八行数据
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.frame = CGRectMake((self.view.frame.size.width/2)-75, 586 , 375 * kScreenWidth1, 44 * kScreenHeight1);
    _dateLabel.text = @"12个月";
    _dateLabel.textAlignment = 0;
    [view addSubview:_dateLabel];
    
    UIButton * knowBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [knowBtn1 addTarget:self action:@selector(handleAction1) forControlEvents:UIControlEventTouchUpInside];
    knowBtn1.backgroundColor = [UIColor clearColor];
    knowBtn1.frame = CGRectMake(0, 586 , 375 * kScreenWidth1, 44 * kScreenHeight1);
    [view addSubview:knowBtn1];
    
    UIImageView *img3 =[[UIImageView alloc]initWithFrame:CGRectMake( (self.view.frame.size.width-30),596, 10 * kScreenWidth1, 20 * kScreenHeight1)];
    img3.image =[UIImage imageNamed:@"arrow_right@3x"];
    [view addSubview:img3];
    
    
    //第九行数据
    UIButton * knowBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    knowBtn.tag =3;
    [knowBtn addTarget:self action:@selector(handleType:) forControlEvents:UIControlEventTouchUpInside];
    knowBtn.backgroundColor = [UIColor clearColor];
    knowBtn.frame = CGRectMake(0, 636 , 375 * kScreenWidth1, 44 * kScreenHeight1);
    [view addSubview:knowBtn];
    
    UIImageView *img4 =[[UIImageView alloc]initWithFrame:CGRectMake( (self.view.frame.size.width-30),646, 10 * kScreenWidth1, 20 * kScreenHeight1)];
    img4.image =[UIImage imageNamed:@"arrow_right@3x"];
    [view addSubview:img4];
    
    _tableView.tableHeaderView = view;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}

- (void)handleAction9 {
    _PickVC = [[UIView alloc]initWithFrame:self.view.bounds];
    _PickVC.backgroundColor = [UIColor blackColor];
    _PickVC.alpha = 0.5;
    _PickVC.userInteractionEnabled = YES;
    [self.view  addSubview:_PickVC];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleAction11)];
    [_PickVC addGestureRecognizer:tap];
    
    
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(50 * kScreenWidth1, 200 * kScreenHeight1, 275 * kScreenWidth1, 300 * kScreenHeight1) style:UITableViewStylePlain];
    tableView.dataSource =self;
    tableView.delegate =self;
    tableView.separatorStyle =NO;
    tableView.layer.cornerRadius = 5* kScreenWidth1;
    tableView.layer.masksToBounds = YES;
    tableView.tag = 10086;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"11"];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 275, 50)];
    label.text = @"积分使用";
    label.textAlignment = NSTextAlignmentCenter;
    tableView.tableHeaderView = label;
    [self.view addSubview:tableView];

}

- (void)handleAction11 { //
    [[self.view viewWithTag:10086] removeFromSuperview];
    //_aView.tag = 102;
    [_PickVC removeFromSuperview];
}

//第一行数据响应记录
- (void)handleType:(UIButton *)sender
{
    if (sender.tag ==1)
    {
        categoryViewController * caVC = [[categoryViewController alloc] init];
         caVC.typeId = 1;
        [self.navigationController pushViewController:caVC animated:YES];
    }else if (sender.tag ==2)
    {
        packageViewController *pVC = [[packageViewController alloc] init];
        [self.navigationController pushViewController:pVC animated:YES];
    }
    else if (sender.tag ==3)
    {
        buyViewController *bVC = [[buyViewController alloc] init];
         
         if (_idString != nil) {
              NSLog(@"执行编辑操作");
              bVC.buyCode = @"1";
         } else {
              NSLog(@"执行新增操作");
              bVC.buyCode = @"0";
              
         }
        [self.navigationController pushViewController:bVC animated:YES];
        
    }
}





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1010) {
        return 1;
    } else if (tableView.tag == 10086 ) {
        return 1;
    }else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1010) {
        return 7;
    } else if (tableView.tag == 10086 ){
        return 5;
    }else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"11"];
    if (tableView.tag == 1010 ) {
    NSArray * ary = @[@"6个月", @"7个月", @"8个月", @"9个月", @"10个月", @"11个月", @"12个月"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = ary[indexPath.section];
        return cell;
    } else if (tableView.tag == 10086 ){
        NSArray * ary = @[@"10%", @"20%", @"30%", @"40%", @"50%"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = ary[indexPath.section];
        return cell;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1010) {
        if (indexPath.section == 0) {
            _dateLabel.text = @"6个月";
            _dateNum = 6;
        } else if (indexPath.section == 1) {
            _dateLabel.text = @"7个月";
            _dateNum = 7;
        } else if (indexPath.section == 2) {
            _dateLabel.text = @"8个月";
            _dateNum = 8;
        } else if (indexPath.section == 3) {
            _dateLabel.text = @"9个月";
            _dateNum = 9;
        } else if (indexPath.section == 4) {
            _dateLabel.text = @"10个月";
            _dateNum = 10;
        } else if (indexPath.section == 5) {
            _dateLabel.text = @"11个月";
            _dateNum = 11;
        } else if (indexPath.section == 6) {
            _dateLabel.text = @"12个月";
            _dateNum = 12;
        }
        [self handleAction4];
    } else if (tableView.tag == 10086 ){
        if (indexPath.section == 0) {
            _redTf.text = @"10%";
            _redNum = 10;
        } else if (indexPath.section == 1) {
            _redTf.text = @"20%";
            _redNum = 20;
        } else if (indexPath.section == 2) {
            _redTf.text = @"30%";
            _redNum = 30;
        } else if (indexPath.section == 3) {
            _redTf.text = @"40%";
            _redNum = 40;
        } else if (indexPath.section == 4) {
            _redTf.text = @"50%";
            _redNum = 50;
        }
        [self handleAction11];
    }
    
}

- (void) handleAction1 {
    _PickVC = [[UIView alloc]initWithFrame:self.view.bounds];
    _PickVC.backgroundColor = [UIColor blackColor];
    _PickVC.alpha = 0.5;
    _PickVC.userInteractionEnabled = YES;
    [self.view  addSubview:_PickVC];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleAction4)];
    [_PickVC addGestureRecognizer:tap];
    
    
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(20 * kScreenWidth1, 200 * kScreenHeight1, 335 * kScreenWidth1, 300 * kScreenHeight1) style:UITableViewStylePlain];
    tableView.dataSource =self;
    tableView.delegate =self;
    tableView.separatorStyle =NO;
    tableView.layer.cornerRadius = 5* kScreenWidth1;
    tableView.layer.masksToBounds = YES;
    tableView.tag = 1010;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"11"];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 335, 50)];
    label.text = @"有效期选择";
    label.textAlignment = NSTextAlignmentCenter;
    tableView.tableHeaderView = label;
    [self.view addSubview:tableView];
}

#pragma mark ------------------ 取消弹出视图 ----------------
- (void)handleAction4 { //
    [[self.view viewWithTag:1010] removeFromSuperview];
    [_PickVC removeFromSuperview];
}

#pragma mark ------------------ 加id保存 ----------------
- (void) requesthaveid {
    
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    NSLog(@"----%d", _redNum);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_buyAry
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     NSLog(@"adsasd----%@",[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:new_Project,[_idString intValue], _cateId, _shopLabel.text, _nameTf.text, _noteStr, [_priceTf.text doubleValue], _redNum, _dateNum, jsonStr, _imageStr,_describe_tf.text]]);
    NSString *str2 = [[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:new_Project,[_idString intValue], _cateId, _shopLabel.text, _nameTf.text, _noteStr, [_priceTf.text doubleValue], _redNum, _dateNum, jsonStr, _imageStr,_describe_tf.text]]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    if ([_priceTf.text floatValue] >= [_redTf.text floatValue] && [_priceTf.text floatValue] >= 0 && [_redTf.text floatValue] >= 0) {
        [manager POST:str2 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"参数错误输出%@", responseObject);
            if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
                Alert_show_pushRoot(@"保存成功")
            } else {
                Alert_Show(@"参数错误, 保存失败")
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if ([error code] == -1009) {
                  NSString *errorStr = [IsLogin requestErrorCode:[error code]];
                  Alert_Show(errorStr)
             }else if ([error code] == -1001) {
                  Alert_Show(@"请求超时")
             }else{
                  if([[error localizedDescription] rangeOfString:@"("].location !=NSNotFound){
                       NSArray *arr = [[error localizedDescription] componentsSeparatedByString:@"("];
                       NSArray *arr1 = [arr[1] componentsSeparatedByString:@")"];
                       if ([arr1[0] integerValue] == 500) {
                            Alert_Show(@"服务器忙,请稍后再试")
                       }else if ([arr1[0] integerValue] == 401){
                            
                            Alert_Show(@"网络请求错误, 请重试")
                            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                            manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
                            manager.requestSerializer = [AFJSONRequestSerializer serializer];
                            manager.responseSerializer = [AFJSONResponseSerializer serializer];
                            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                            [manager.requestSerializer setValue:@"Basic bW9iaWxlOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
                            NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"];
                            NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PwdID"];
                            [manager POST:[NSString stringWithFormat:loginUrl,login,password] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 NSString *tokenStr = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
                                 
                                 //                             [[LYTFMDB sharedDataBase]deleAllSeachText];
                                 if (responseObject[@"access_token"] != nil) {
                                      [[NSUserDefaults standardUserDefaults]setObject:tokenStr  forKey:@"token"];
                                      [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"LoginID"];
                                      [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"PwdID"];
                                 } else {
                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
                                 }
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 
                            }];
                       }
                  }
             }
        }];
//    } else {
//        Alert_Show(@"请重新设置您的商品价格与赠送红包")
//    }
}

#pragma mark ------------------ 无id保存 ----------------
- (void) requestid {
    
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];

     NSLog(@"----%d", _redNum);
     
    if (_nameTf.text == nil || _priceTf.text == nil || _redTf.text == nil || _imageStr == nil || _cateId == nil ||_describe_tf.text == nil) {
        Alert_Show(@"新增项目信息不完整,请补充填写")
    } else {
        if (_buyAry.count == 0) {
            Alert_Show(@"请选择商品上架的购买须知");
        } else {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_buyAry
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            
            NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSString *str2 = [[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:new_Project1, _cateId, _shopLabel.text, _nameTf.text, _noteStr, [_priceTf.text doubleValue], _redNum, _dateNum, jsonStr, _imageStr,_describe_tf.text]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         NSLog(@"adsasd----%@",[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:new_Project1, _cateId, _shopLabel.text, _nameTf.text, _noteStr, [_priceTf.text doubleValue], _redNum, _dateNum, jsonStr, _imageStr,_describe_tf.text]]);
//            if ([_priceTf.text floatValue] >= [_redTf.text floatValue] && [_priceTf.text floatValue] >= 0 && [_redTf.text floatValue] >= 0) {
                [manager POST:str2 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"参数错误输出%@", responseObject);
                    if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
                        Alert_show_pushRoot(@"保存成功")
                    } else {
                        Alert_Show(@"参数错误, 保存失败")
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if ([error code] == -1009) {
                          NSString *errorStr = [IsLogin requestErrorCode:[error code]];
                          Alert_Show(errorStr)
                     }else if ([error code] == -1001) {
                          Alert_Show(@"请求超时")
                     }else{
                          if([[error localizedDescription] rangeOfString:@"("].location !=NSNotFound){
                               NSArray *arr = [[error localizedDescription] componentsSeparatedByString:@"("];
                               NSArray *arr1 = [arr[1] componentsSeparatedByString:@")"];
                               if ([arr1[0] integerValue] == 500) {
                                    Alert_Show(@"服务器忙,请稍后再试")
                               }else if ([arr1[0] integerValue] == 401){
                                    
                                    Alert_Show(@"网络请求错误, 请重试")
                                    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                                    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
                                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
                                    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                                    [manager.requestSerializer setValue:@"Basic bW9iaWxlOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
                                    NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"];
                                    NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PwdID"];
                                    [manager POST:[NSString stringWithFormat:loginUrl,login,password] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                         NSString *tokenStr = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
                                         
                                         //                             [[LYTFMDB sharedDataBase]deleAllSeachText];
                                         if (responseObject[@"access_token"] != nil) {
                                              [[NSUserDefaults standardUserDefaults]setObject:tokenStr  forKey:@"token"];
                                              [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"LoginID"];
                                              [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"PwdID"];
                                         } else {
                                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
                                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
                                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
                                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
                                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
                                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
                                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
                                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
                                         }
                                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                         
                                    }];
                               }
                          }
                     }
                }];
//            } else {
//                Alert_Show(@"请重新设置您的商品价格与赠送红包")
//            }

        }
    }
}
#pragma mark ------------------ 修改 ----------------
- (void) requestDetail {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:Modify, _idString]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"adsasd-----jie结果-----%@",responseObject);
        NSString * str = responseObject[@"data"][@"purchaseNote"];
        NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
        _buyAry = [NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSDictionary * dic = responseObject[@"data"];
         NSLog(@"xinxi%@", dic);
        SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
        [downloader downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dic[@"coverAndUrl"]]]
                                 options:0
                                progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                     
                                     
                                } 
                               completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                   if (image && finished) {
                                       // do something with image
                                       [_btn setBackgroundImage:image forState:UIControlStateNormal];
                                   }
                               }];
        
        
        _typeLabel.text = [NSString stringWithFormat:@"%@", dic[@"localLifeCategory"][@"name"]];
        _shopLabel.text = [NSString stringWithFormat:@"%@", dic [@"localShop"][@"shopName"]];
        _nameTf.text = [NSString stringWithFormat:@"%@", dic[@"name"]];
        _priceTf.text = [NSString stringWithFormat:@"%.2f", [dic[@"teamBuyPrice"] floatValue]];
        if ([[NSString stringWithFormat:@"%@", dic[@"cloudIntPercent"]] isEqualToString:@"0"]) {
            _redTf.text = @"不使用积分";
            _redNum = 0;
        } else {
            _redTf.text = [NSString stringWithFormat:@"%@%%", dic[@"cloudIntPercent"]];
            _redNum = [dic[@"cloudIntPercent"] intValue];
        }
        _dateLabel.text = [NSString stringWithFormat:@"%d个月", [dic[@"validityPeriod"] intValue]];
        _dateNum = [dic[@"validityPeriod"] intValue];
        _imageStr = [NSString stringWithFormat:@"%@", dic[@"cover"]];
        _cateId = [NSString stringWithFormat:@"%@", dic[@"localLifeCategory"][@"id"]];
        _describe_tf.text = dic[@"profile"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if ([error code] == -1009) {
              NSString *errorStr = [IsLogin requestErrorCode:[error code]];
              Alert_Show(errorStr)
         }else if ([error code] == -1001) {
              Alert_Show(@"请求超时")
         }else{
              if([[error localizedDescription] rangeOfString:@"("].location !=NSNotFound){
                   NSArray *arr = [[error localizedDescription] componentsSeparatedByString:@"("];
                   NSArray *arr1 = [arr[1] componentsSeparatedByString:@")"];
                   if ([arr1[0] integerValue] == 500) {
                        Alert_Show(@"服务器忙,请稍后再试")
                   }else if ([arr1[0] integerValue] == 401){
                        
                        Alert_Show(@"网络请求错误, 请重试")
                        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
                        manager.requestSerializer = [AFJSONRequestSerializer serializer];
                        manager.responseSerializer = [AFJSONResponseSerializer serializer];
                        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                        [manager.requestSerializer setValue:@"Basic bW9iaWxlOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
                        NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"];
                        NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PwdID"];
                        [manager POST:[NSString stringWithFormat:loginUrl,login,password] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             NSString *tokenStr = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
                             
                             //                             [[LYTFMDB sharedDataBase]deleAllSeachText];
                             if (responseObject[@"access_token"] != nil) {
                                  [[NSUserDefaults standardUserDefaults]setObject:tokenStr  forKey:@"token"];
                                  [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"LoginID"];
                                  [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"PwdID"];
                             } else {
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
                                  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
                             }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                        }];
                   }
              }
         }
    }];
}

#pragma mark
#pragma mark ------------------ 请求 >>> 上传图片 ----------------
- (void)shopsApplicationWithRequest:(NSData *)str{
    NSString * str22 = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str22 forHTTPHeaderField:@"Authorization"];
    [manager POST:[NSString stringWithFormat:@"%@%@",LSKurl,[NSString stringWithFormat:upload_Mage]] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         if (str != NULL){
             [formData appendPartWithFileData:str name:@"files" fileName:@"files.jpg" mimeType:@"image/jpeg"];
         }else{
             Alert_Show(@"请上传图片");
         }
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 
         if ([[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
             NSArray * ary = responseObject[@"data"];
             _imageStr = [NSString stringWithFormat:@"%@", [ary firstObject]];
         } else {
             Alert_Show(responseObject[@"message"]);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if ([error code] == -1009) {
               NSString *errorStr = [IsLogin requestErrorCode:[error code]];
               Alert_Show(errorStr)
          }else if ([error code] == -1001) {
               Alert_Show(@"请求超时")
          }else{
               if([[error localizedDescription] rangeOfString:@"("].location !=NSNotFound){
                    NSArray *arr = [[error localizedDescription] componentsSeparatedByString:@"("];
                    NSArray *arr1 = [arr[1] componentsSeparatedByString:@")"];
                    if ([arr1[0] integerValue] == 500) {
                         Alert_Show(@"服务器忙,请稍后再试")
                    }else if ([arr1[0] integerValue] == 401){
                         
                         Alert_Show(@"网络请求错误, 请重试")
                         AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                         manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
                         manager.requestSerializer = [AFJSONRequestSerializer serializer];
                         manager.responseSerializer = [AFJSONResponseSerializer serializer];
                         [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                         [manager.requestSerializer setValue:@"Basic bW9iaWxlOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
                         NSString * login = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"];
                         NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PwdID"];
                         [manager POST:[NSString stringWithFormat:loginUrl,login,password] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSString *tokenStr = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
                              
                              //                             [[LYTFMDB sharedDataBase]deleAllSeachText];
                              if (responseObject[@"access_token"] != nil) {
                                   [[NSUserDefaults standardUserDefaults]setObject:tokenStr  forKey:@"token"];
                                   [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"LoginID"];
                                   [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"PwdID"];
                              } else {
                                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginID"];
                                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PwdID"];
                                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
                                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infoMy"];
                                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyInfo"];
                                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refresh_token"];
                                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SKMVCQRCode"];
                                   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DetectionVCQRCode"];
                              }
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              
                         }];
                    }
               }
          }
         
     }];
}



- (void)btnClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *hidAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:hidAlert];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark
#pragma mark ----------- imagePickerControllerDelegate -----
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [picker dismissViewControllerAnimated:YES completion:^{
//        _image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData * str = [self Image_TransForm_Data:image];
        [self shopsApplicationWithRequest:str];
        [_btn setBackgroundImage:image forState:UIControlStateNormal];
       [self archiveImage];//归档
    }];
}
- (void)archiveImage {
    NSMutableData *data = [NSMutableData dataWithCapacity:1];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_image forKey:@"头像"];
    [archiver finishEncoding];
    [data writeToFile:[self geArrayImageFilePath] atomically:YES];
}
//获取文件路径
- (NSString *)geArrayImageFilePath {
    NSString * docuPathh = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [docuPathh stringByAppendingPathComponent:@"tx.txt"];
}
//类方法  图片 转换为二进制
-(NSData *)Image_TransForm_Data:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image , 0.5);
    //几乎是按0.5图片大小就降到原来的一半 比如这里 24KB 降到11KB
    return imageData;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
