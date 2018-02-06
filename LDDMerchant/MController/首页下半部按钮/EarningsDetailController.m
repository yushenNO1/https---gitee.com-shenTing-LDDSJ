//
//  EarningsDetailController.m
//  LSKApp
//
//  Created by 云盛科技 on 16/2/23.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "EarningsDetailController.h"
#import "EarningsCells.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "NetURL.h"
#import "EarningFirstCell.h"
#import "EarningDetailModel.h"//收益明细Model
#import "UIColor+Addition.h"
#import "proFitModel.h"
#import "UIColor+HexString.h"//设置Picker
#import "DVYearMonthDatePicker.h"

//#import "FilterViewController.h"


#define kBI_Li          kScreenHeight / 667
#define kLeft_Picker    50 * kBI_Li
#define kHeight_Picker  200 * kBI_Li
#define kTop_Picker     200 * kBI_Li
#define kWidth_Picker   kScreenWidth - 2 * kLeft_Picker

#define K_width   [UIScreen mainScreen].bounds.size.width / 414
#define K_height   [UIScreen mainScreen].bounds.size.height / 736

@interface EarningsDetailController ()<UITableViewDelegate, UITableViewDataSource, DVYearMonthDatePickerDelegate>
{
    NSInteger _offset;
    
}
@property (nonatomic, retain) NSMutableArray *newArray;
@property (nonatomic, retain) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSArray* arrKeys;
@property (nonatomic, strong) UIDatePicker * dataPicker;//时间
@property (nonatomic, strong) UILabel * timePicLabel;
@property (nonatomic, strong) UIView * pickerVC;
@property (nonatomic, copy) NSString * year;//年
@property (nonatomic, copy) NSString * month;//月
@property (nonatomic, copy) NSString * day;//日
@property (nonatomic, copy) NSString * kUrl;//日

@property (nonatomic, strong) UIButton * cannelBtn;
@property (nonatomic, strong) UIButton * sureBtn;
@property (strong, nonatomic) UIView *backgVIew;
@property (nonatomic, strong) UIView * aVC;
@property (nonatomic, strong) DVYearMonthDatePicker *yearMonth;

@end

@implementation EarningsDetailController

//懒加载数组
-(NSMutableArray *)newArray {
     if (!_newArray) {
          self.newArray = [NSMutableArray arrayWithCapacity:1];
     }
     return _newArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
     [super viewWillAppear:YES];
     NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
     if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
          self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回@3x"] style:UIBarButtonItemStylePlain target:self action:@selector(rebackToRootViewAction)];
     }else{
          self.navigationItem.leftBarButtonItem=nil;
     }
//     NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
//     if ([[[pushJudge objectForKey:@"push"] class] isEqual:[NSNull class]]) {
//          
//     }else if ([pushJudge objectForKey:@"push"]==nil){
//          
//     }else{
//          if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
//               self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(rebackToRootViewAction)];
//               NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
//               [pushJudge setObject:@""forKey:@"push"];
//               [pushJudge synchronize];//记得立即同步
//          }else{
//               self.navigationItem.leftBarButtonItem=nil;
//          }
//     }

    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:33/255.0 green:35/255.0 blue:33/255.0 alpha:1];
    [self.tableView.mj_header beginRefreshing];
    [self.tableView reloadData];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)rebackToRootViewAction {
     NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
     [pushJudge setObject:@""forKey:@"push"];
     [pushJudge synchronize];//记得立即同步
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"账单";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.view.backgroundColor = [UIColor backGray];
//    self.navigationItem.title = @"账单";
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(shaiXvanbarBtn)];
//    self.navigationItem.rightBarButtonItem = item;
    _offset = 0;
    
    [self setupTableView];
    [self addRefreshAndLoadMore];
    [self jixizhangdan];
}
-(void)jixizhangdan{
     NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Profit" ofType:@"json"]];
         NSLog(@"sadsd-----%@",JSONData);
     NSArray *dataArray  = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
     NSLog(@"************%@", dataArray);
     for (NSDictionary *dict in dataArray) {
          proFitModel *loc = [proFitModel proFitModelWithDictionary:dict];
          [self.newArray addObject:loc];
          
     }
}
//- (void)shaiXvanbarBtn{
//    FilterViewController *filterVC = [[FilterViewController alloc]init];
//    filterVC.type = ^(NSString *type ,NSString *i){
//        _type = type;
//        _billTypeButtonTag = i;
//        NSLog(@"4444%@",_billTypeButtonTag);
//    };
//    [self.navigationController pushViewController:filterVC animated:YES];
//}
- (void)leftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableArray *)dataSource {//懒加载舒适化数组
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSArray *)arrKeys {//懒加载舒适化数组
    if (!_arrKeys) {
        self.arrKeys = [NSArray array];
    }
    return _arrKeys;
}

- (void)handleData:(NSDictionary *)dic
{//封装对象
    NSDictionary * dataDic = dic[@"data"];
    NSArray * dataAry = dataDic[@"list"];
    if (dataAry != nil){
         if (dataAry.count == 0) {
              [self.tableView.mj_footer endRefreshingWithNoMoreData];
         }else{
              NSLog(@"-----%@----%@", _newArray, dataAry);
              for (NSDictionary * tempDic in dataAry){
                   for (proFitModel *model1 in _newArray){
                        if ([tempDic[@"profitType"] integerValue] ==  model1.typeId){
                             EarningDetailModel * model = [[EarningDetailModel alloc]init];
                             [model setValuesForKeysWithDictionary:tempDic];
                             [self.dataSource addObject:model];
                        }
                   }
              }
              [self.tableView.mj_footer endRefreshing];
         }
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
    }
}

#pragma mark
#pragma mark ------------ 设置时间dataPicer ----------
- (void)setTimerDataPicker {
    _pickerVC = [[UIView alloc]initWithFrame:self.view.bounds];
    _pickerVC.backgroundColor = [UIColor blackColor];
    _pickerVC.alpha = 0.85;
    [self.view  addSubview:_pickerVC];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewAction)];
    [_pickerVC addGestureRecognizer:tap];
    _dataPicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(kLeft_Picker, kTop_Picker, kWidth_Picker , kHeight_Picker)];
    _dataPicker.backgroundColor = [UIColor whiteColor];
    _dataPicker.alpha = 1;
    _dataPicker.datePickerMode = UIDatePickerModeDate;//年月日
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"year"]) {
        NSUserDefaults * year = [NSUserDefaults standardUserDefaults];
        NSString * yearStr = [year objectForKey:@"year"];
        NSUserDefaults * month = [NSUserDefaults standardUserDefaults];
        NSString * mothStr = [month objectForKey:@"month"];
        NSUserDefaults * day = [NSUserDefaults standardUserDefaults];
        NSString * dayStr = [day objectForKey:@"day"];
        NSString * defaultTime = [NSString stringWithFormat:@"%@-%@-%@", yearStr , mothStr, dayStr];
        [_dataPicker setDate:[self dateFromString:defaultTime]animated:YES];
    }
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    _dataPicker.locale = locale;
    _dataPicker.layer.cornerRadius = 10;
    _dataPicker.layer.masksToBounds = YES;
    _dataPicker.tag = 101;
    [_dataPicker addTarget:self action:@selector(dataPickerAction:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:_dataPicker];
}

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
- (void)pickerViewAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.6), dispatch_get_main_queue(), ^{
        [[self.view viewWithTag:101] removeFromSuperview];
        [_pickerVC removeFromSuperview];
    });
}
-  (void)dataPickerAction:(UIDatePicker *)sender {
    NSString * strUrl = [self Formatter:sender.date];
    NSArray *array = [strUrl componentsSeparatedByString:@"-"];
    self.year = array[0];
    if ([array[1] intValue] > 9){
        self.month = array[1];
    }else{
        NSArray *arr = [array[1] componentsSeparatedByString:@"0"];
        self.month = arr[0];
    }
    self.kUrl= [NSString stringWithFormat:Earning, _offset,_year, _month];
    NSUserDefaults * yearDefault = [NSUserDefaults standardUserDefaults];
    [yearDefault setObject:_year forKey:@"year"];
    NSUserDefaults * monthDefault = [NSUserDefaults standardUserDefaults];
    [monthDefault setObject:_month forKey:@"month"];
    NSUserDefaults * datyDefault = [NSUserDefaults standardUserDefaults];
    [datyDefault setObject:_day forKey:@"day"];
    
    
    [self.tableView reloadData];
}
- (NSString *)Formatter:(NSDate *)data {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM";
    return [dateFormatter stringFromDate:data];
}
#pragma mark
#pragma mark -------- 只显示年月的picker ------------
- (void)setupDateView {
    self.aVC = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _aVC.backgroundColor = [UIColor blackColor];
    _aVC.alpha = 0.75;
    [self.view addSubview:_aVC];
    self.backgVIew = [[UIView alloc]initWithFrame:CGRectMake(30*K_width, 180*K_height, self.view.frame.size.width-60*K_width, 240*K_height)];
    self.backgVIew.backgroundColor = [UIColor whiteColor];
    self.backgVIew.layer.cornerRadius = 5;
    self.backgVIew.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.backgVIew.layer.masksToBounds = YES;
    [self.view addSubview:_backgVIew];
    [self inintViewAll];
    
    UILabel * topBackgView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.backgVIew.frame.size.width, 40*K_height)];
    topBackgView.text = @"请选择时间";
    topBackgView.textColor = [UIColor whiteColor];
    topBackgView.textAlignment = NSTextAlignmentCenter;
    topBackgView.backgroundColor = [UIColor colorWithRed:55/255.0 green:183/255.0 blue:230/255.0 alpha:1];
    [self.backgVIew addSubview:topBackgView];
    self.yearMonth = [[DVYearMonthDatePicker alloc] initWithFrame:CGRectMake(0, 40*K_height, self.view.frame.size.width-60*K_width, 150*K_height)];;
    [self.yearMonth setBackgroundColor:[UIColor whiteColor]];
    _yearMonth.rowHeight = 40*K_height;
    self.yearMonth.dvDelegate = self;

    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"years"]) {
        NSUserDefaults * year = [NSUserDefaults standardUserDefaults];
        NSString * yearStr = [year objectForKey:@"years"];
        NSUserDefaults * month = [NSUserDefaults standardUserDefaults];
        NSString * mothStr = [month objectForKey:@"months"];

        NSString * defaultTime = [NSString stringWithFormat:@"%@-%@", yearStr , mothStr];
        [_yearMonth selectDate:[self dateFromString:defaultTime]];
    } else {
        [_yearMonth selectToday];
    }
    [self.backgVIew addSubview:self.yearMonth];
    
}
- (void)inintViewAll {
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn.frame = CGRectMake(self.backgVIew.frame.size.width - 130*K_width, 190*K_height, 100*K_width, 30*K_height);
    self.sureBtn.layer.cornerRadius = 3;
    self.sureBtn.layer.borderWidth = 1;
    self.sureBtn.backgroundColor = [UIColor colorWithRed:55/255.0 green:183/255.0 blue:230/255.0 alpha:1];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.sureBtn.layer.borderColor = [[UIColor colorwithHexString:@"BAB9B9"] CGColor];
    self.sureBtn.layer.masksToBounds = YES;
    [self.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgVIew addSubview:_sureBtn];
    self.cannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cannelBtn.frame = CGRectMake(30*K_width, 190*K_height, 100*K_width, 30*K_height);
    self.cannelBtn.layer.cornerRadius = 3;
    self.cannelBtn.layer.borderWidth = 1;
    self.cannelBtn.layer.borderColor = [[UIColor colorwithHexString:@"BAB9B9"] CGColor];
    self.cannelBtn.layer.masksToBounds = YES;
    [self.cannelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cannelBtn setTitleColor:[UIColor colorWithRed:55/255.0 green:183/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
    [self.cannelBtn addTarget:self action:@selector(removeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgVIew addSubview:self.cannelBtn];
}
- (void)sureBtnClick:(UIButton *)sender {
    [self animationbegin:sender];
     _offset = 0;
    self.kUrl= [NSString stringWithFormat:Earning, _offset,_year, _month];
    [self.dataSource removeAllObjects];
    [self loadData:_kUrl];
    [self.tableView reloadData];
    [self removeBtnClick:nil];
}
- (NSString *)timeFormat{
    NSDate *selected = [self.yearMonth date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}
- (void)yearMonthDatePicker:(DVYearMonthDatePicker *)yearMonthDatePicker didSelectedDate:(NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"M月"];
    NSString * strUrl = [self  Formatter:date];
    NSArray *array = [strUrl componentsSeparatedByString:@"-"];
    self.year = array[0];
    if ([array[1] intValue] > 9){
        self.month = array[1];
    }else{
        NSArray *arr = [array[1] componentsSeparatedByString:@"0"];
        self.month = arr[1];
    }
    self.kUrl= [NSString stringWithFormat:Earning, _offset,_year, _month];
    NSUserDefaults * yearDefault = [NSUserDefaults standardUserDefaults];
    [yearDefault setObject:_year forKey:@"years"];
    NSUserDefaults * monthDefault = [NSUserDefaults standardUserDefaults];
    [monthDefault setObject:_month forKey:@"months"];
}

#pragma mark
#pragma mark ----------- 动画和按钮响应时间 ---------
- (void)animationbegin:(UIView *)view {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.1; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    [view.layer addAnimation:animation forKey:@"scale-layer"];
}
- (void)removeBtnClick:(UIButton *)sender {
    [self animationbegin:sender];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgVIew.alpha = 0;
        self.aVC.alpha = 0;
    } completion:^(BOOL finished) {
        [self.backgVIew removeFromSuperview];
        [self.aVC removeFromSuperview];
    }];
}
#pragma mark
#pragma mark ---------- handle refresh and load more -----------
- (void)addRefreshAndLoadMore {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(handleRefresh)];
    //添加上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(handleLoadMore)];
}
- (void)handleRefresh {//刷新
    _offset = 0;
    [self.dataSource removeAllObjects];
     if (_year != nil) {
          [self loadData:[NSString stringWithFormat:Earning,_offset, _year, _month]];//重新加载网络请求
     }else{
          [self loadData:[NSString stringWithFormat:@"/api/v1/user/msg/profitLog/records?count=10&cursor=%ld&accTypes=20",_offset]];//重新加载网络请求
     }
     
}
- (void)handleLoadMore {//加载更多
    _offset+=10;
//    _offset = self.dataSource.count;
     
     if (_year != nil) {
          [self loadData:[NSString stringWithFormat:Earning,_offset, _year, _month]];//重新加载网络请求
     }else{
          [self loadData:[NSString stringWithFormat:@"/api/v1/user/msg/profitLog/records?count=10&cursor=%ld&accTypes=20",_offset]];//重新加载网络请求
     }
}
#pragma mark
#pragma mark ----------- TableView ------------
- (void)setupTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height+44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor =[UIColor backGray];
    [self.view addSubview:_tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"EarningFirstCell" bundle:nil] forCellReuseIdentifier:@"shouyi"];
    [self.tableView registerClass:[EarningsCells class] forCellReuseIdentifier:@"earnings"];
}
#pragma mark
#pragma mark ----------- UITableView的代理 ------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count+1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 35;
    }
    return  60 *kScreenWidth1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EarningFirstCell * cell = [tableView dequeueReusableCellWithIdentifier:@"shouyi" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.backgroundColor = [UIColor backGray];
        cell.timeLabel.text = @"本月";
        cell.timeLabel.font = [UIFont systemFontOfSize:15];
        cell.MonthlyBillLabel.text = @"查看账单";
        cell.MonthlyBillLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    } else {
        EarningDetailModel * model = self.dataSource[indexPath.section-1];
        EarningsCells * cell = [tableView dequeueReusableCellWithIdentifier:@"earnings"];
        NSString *str =[NSString stringWithFormat:@"%@",model.type];
        for (proFitModel *model1 in _newArray) {
            if ([str isEqualToString:[NSString stringWithFormat:@"%ld",model1.typeId]]) {
                cell.nameLabel.text = model1.typeText;
                if ([model1.typeText isEqualToString:@"提"]) {
                    cell.nameLabel.textColor = [UIColor colorWithRed:76/255.0 green:191/255.0 blue:154/255.0 alpha:1];
                }else if ([model1.typeText isEqualToString:@"转"]){
                    cell.nameLabel.textColor = [UIColor colorWithRed:108/255.0 green:190/255.0 blue:195/255.0 alpha:1];
                }else if ([model1.typeText isEqualToString:@"购"]){
                    cell.nameLabel.textColor = [UIColor colorWithRed:225/255.0 green:37/255.0 blue:38/255.0 alpha:1];
                }else if ([model1.typeText isEqualToString:@"赠"]){
                    cell.nameLabel.textColor = [UIColor colorWithRed:163/255.0 green:108/255.0 blue:195/255.0 alpha:1];
                }else if ([model1.typeText isEqualToString:@"得"]){
                    cell.nameLabel.textColor = [UIColor colorWithRed:203/255.0 green:95/255.0 blue:161/255.0 alpha:1];
                }else if ([model1.typeText isEqualToString:@"增"]){
                    cell.nameLabel.textColor = [UIColor colorWithRed:219/255.0 green:81/255.0 blue:100/255.0 alpha:1];
                }else if ([model1.typeText isEqualToString:@"拆"]){
                    cell.nameLabel.textColor = [UIColor colorWithRed:105/255.0 green:178/255.0 blue:80/255.0 alpha:1];
                }else if ([model1.typeText isEqualToString:@"支"]){
                    cell.nameLabel.textColor = [UIColor colorWithRed:106/255.0 green:122/255.0 blue:136/255.0 alpha:1];
                }else if ([model1.typeText isEqualToString:@"退"]){
                    cell.nameLabel.textColor = [UIColor colorWithRed:227/255.0 green:121/255.0 blue:99/255.0 alpha:1];
                }else if ([model1.typeText isEqualToString:@"充"]){
                    cell.nameLabel.textColor = [UIColor colorWithRed:76/255.0 green:191/255.0 blue:154/255.0 alpha:1];
                }else if ([model1.typeText isEqualToString:@"扣"]){
                    cell.nameLabel.textColor = [UIColor colorWithRed:106/255.0 green:122/255.0 blue:136/255.0 alpha:1];
                }
                if (model1.isProfit == 0) {
                    cell.vMoneyLabel.text =[NSString stringWithFormat:@"-%.2f", [model.amount floatValue]];
                    cell.vMoneyLabel.textColor =[UIColor greenColor];
                }else{
                    cell.vMoneyLabel.text =[NSString stringWithFormat:@"+%.2f", [model.amount floatValue]];
                    cell.vMoneyLabel.textColor =[UIColor redColor];
                }
                cell.weekLabel.text = model1.showText;
                cell.timeLabel.text = model.createTime;
                return cell;
            }
        }
        return cell;
        }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self setupDateView];//显示年月设置
    }
}
#pragma mark
#pragma mark ------------ 请求 >>> ----------
- (void)loadData:(NSString *)url {//从网络中获取数据
     NSLog(@"商家账单---%@",url);
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str  forHTTPHeaderField:@"Authorization"];
    [manager POST:[NSString stringWithFormat:@"%@%@",LSKurl,url] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@******%@",responseObject,url);
        [self handleData:responseObject];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self.tableView.mj_header endRefreshing];
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


@end
