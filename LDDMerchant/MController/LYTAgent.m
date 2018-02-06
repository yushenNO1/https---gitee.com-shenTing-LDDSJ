//
//  LYTAgent.m
//  LYTCoreDate
//
//  Created by 云盛科技 on 2017/5/25.
//  Copyright © 2017年 神廷. All rights reserved.
//






#import "LYTAgent.h"
#import "AFNetworking.h"
@interface contentView : UIView
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextField *textFiled;
@property(nonatomic,strong)UILabel *xingLabel;
@property(nonatomic,strong)UIButton *textBtn;
@end
@implementation contentView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.xingLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.textFiled];
        [self addSubview:self.textBtn];
    }
    return self;
}

-(UILabel *)xingLabel{
    if (!_xingLabel) {
        _xingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 20, 10)];
        _xingLabel.font = [UIFont systemFontOfSize:16*kScreenHeight1];
        _xingLabel.textColor = [UIColor redColor];
        _xingLabel.textAlignment = NSTextAlignmentCenter;
        _xingLabel.text = @" *";
    }
    return _xingLabel;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*kScreenWidth1, 15*kScreenHeight1, 80*kScreenWidth1, 20*kScreenHeight1)];
        _titleLabel.font = [UIFont systemFontOfSize:16*kScreenHeight1];
    }
    return _titleLabel;
}

-(UITextField *)textFiled{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(100*kScreenWidth1, 15*kScreenHeight1, self.bounds.size.width - 110*kScreenWidth1, 20*kScreenHeight1)];
        _textFiled.font = [UIFont systemFontOfSize:16*kScreenHeight1];
    }
    return _textFiled;
}

-(UIButton *)textBtn{
    if (!_textBtn) {
        _textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _textBtn.frame = CGRectMake(50*kScreenWidth1, 0*kScreenHeight1, self.bounds.size.width - 110*kScreenWidth1, 50*kScreenHeight1);
        _textBtn.hidden = YES;
    }
    return _textBtn;
}
@end




@interface LYTAgent ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger index;//记录点击行
    
    NSInteger didSelectId;//记录城市id
    
    NSInteger didSelectRow;//记录选择行号
    
    NSString *finishCityId ;
     
     NSArray *finishCityArr;
     
     int addBtnClick ;
}
@property(nonatomic,retain)NSArray   *allArr;          //保存所有地址数据
@property(nonatomic,retain)NSMutableArray *titleArr;        //保存地址标题
@property(nonatomic,retain)NSMutableArray *IDArr;           //保存地址ID

@property(nonatomic,retain)NSArray   *allArr2;          //保存所有二级地址数据
@property(nonatomic,retain)NSMutableArray *titleArr2;        //保存二级地址标题
@property(nonatomic,retain)NSMutableArray *IDArr2;           //保存二级地址ID

@property(nonatomic,retain)NSArray   *allArr3;          //保存所有三级地址数据
@property(nonatomic,retain)NSMutableArray *titleArr3;        //保存三级地址标题
@property(nonatomic,retain)NSMutableArray *IDArr3;           //保存三级地址ID



@end
@implementation LYTAgent
-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _titleArr;
}
-(NSMutableArray *)IDArr{
    if (!_IDArr) {
        _IDArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _IDArr;
}

-(NSMutableArray *)titleArr2{
     if (!_titleArr2) {
          _titleArr2 = [NSMutableArray arrayWithCapacity:0];
     }
     return _titleArr2;
}
-(NSMutableArray *)IDArr2{
     if (!_IDArr2) {
          _IDArr2 = [NSMutableArray arrayWithCapacity:0];
     }
     return _IDArr2;
}
-(NSMutableArray *)titleArr3{
     if (!_titleArr3) {
          _titleArr3 = [NSMutableArray arrayWithCapacity:0];
     }
     return _titleArr3;
}
-(NSMutableArray *)IDArr3{
     if (!_IDArr3) {
          _IDArr3 = [NSMutableArray arrayWithCapacity:0];
     }
     return _IDArr3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
     addBtnClick = 0;
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city_full" ofType:@"json"]];
    _allArr  = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary * dic in _allArr) {
        [self.titleArr addObject:dic[@"name"]];
        [self.IDArr addObject:dic[@"id"]];
    }
    
    [self configView];
}


-(void)configView{
     if (_typeCode == 1) {
          [self requestDaiLiDetail];
     }
     
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64*kScreenHeight1, self.view.bounds.size.width, 130*kScreenHeight1)];
    imgView.backgroundColor = [UIColor redColor];
     imgView.image = [UIImage imageNamed:@"招募banner"];
    [self.view addSubview:imgView];
    
    NSArray *arr = @[@"代理姓名",@"简介",@"意向省份",@"意向城市",@"意向区县"];
    for (int i = 0; i < 5; i ++) {
        
        contentView *view = [[contentView alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 210*kScreenHeight1 + 60 *kScreenHeight1 * i, self.view.bounds.size.width - 20*kScreenWidth1, 50*kScreenHeight1)];
        [self.view addSubview:view];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = [[UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1]CGColor];
        view.titleLabel.text = arr[i];
        view.textFiled.tag = 100+i;
        view.tag = 1000 + i;
        view.textBtn.tag = i;
        if (i <= 1) {
            view.textBtn.hidden = YES;
            view.textFiled.enabled = YES;
            [view.textFiled addTarget: self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
        }else{
            
            view.textFiled.enabled = NO;
            view.textBtn.hidden = NO;
            [view.textBtn addTarget:self action:@selector(textBtnTouchBegin:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
     
     UIView *jiaView = [[UIView alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 210*kScreenHeight1 + 60 *kScreenHeight1 * 5, self.view.bounds.size.width - 20*kScreenWidth1, 50*kScreenHeight1)];
     [self.view addSubview:jiaView];
     jiaView.layer.cornerRadius = 5;
     jiaView.layer.masksToBounds = YES;
     jiaView.layer.borderWidth = 1.0;
     jiaView.layer.borderColor = [[UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1]CGColor];
     UILabel *img = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
     img.text = @"+";
     img.textAlignment = NSTextAlignmentCenter;
//     img.backgroundColor = [UIColor redColor];
     img.font = [UIFont systemFontOfSize:18];
     [jiaView addSubview:img];
     img.layer.cornerRadius = 10;
     img.layer.masksToBounds = YES;
     img.layer.borderWidth = 1.0;
     img.layer.borderColor = [[UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1]CGColor];
     
     UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 200, 20)];
     title.text = @"添加";
     title.font = [UIFont systemFontOfSize:16];
     [jiaView addSubview:title];
     
     UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     addBtn.frame = CGRectMake(10*kScreenWidth1, 210*kScreenHeight1 + 60 *kScreenHeight1 * 5, self.view.bounds.size.width - 20*kScreenWidth1, 50*kScreenHeight1);
     [jiaView addSubview:addBtn];
     [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:addBtn];
     
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(30*kScreenWidth1, self.view.bounds.size.height - 80*kScreenHeight1, self.view.bounds.size.width - 60*kScreenWidth1, 50*kScreenHeight1);
    sendBtn.layer.cornerRadius = 5;
    sendBtn.layer.masksToBounds = YES;
    [sendBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [self.view addSubview:sendBtn];
    sendBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:67/255.0 blue:90/255.0 alpha:1];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)addBtnClick{
     addBtnClick = 1;
     index = 4;
     contentView *view1 = [self.view viewWithTag:1002];
     contentView *view2 = [self.view viewWithTag:1003];
     contentView *view3 = [self.view viewWithTag:1004];
     if (view1.textFiled.text.length <= 0 || view2.textFiled.text.length <= 0 || view3.textFiled.text.length <= 0) {
          //弹窗
          NSLog(@"请检查省份或者城市信息");
          view1.textBtn.enabled = YES;
          view2.textBtn.enabled = YES;
          view3.textBtn.enabled = YES;
     }else{
          [self tanchuAdress:4];
     }
}
-(void)textValueChange:(UITextField *)textFiled{
    NSLog(@"textFiled变化了----%ld",textFiled.tag);
}
-(void)textBtnTouchBegin:(UIButton *)sender{
    NSLog(@"view点击了-----%ld",sender.tag);
    
    index = sender.tag;
     contentView *view = [self.view viewWithTag:1000];
     contentView *view0 = [self.view viewWithTag:1001];
    contentView *view1 = [self.view viewWithTag:1002];
    contentView *view2 = [self.view viewWithTag:1003];
    contentView *view3 = [self.view viewWithTag:1004];
    view1.textBtn.enabled = NO;
    view2.textBtn.enabled = NO;
    view3.textBtn.enabled = NO;
    
     
     [view resignFirstResponder];
     [view0 resignFirstResponder];
    if (sender.tag == 2) {
        [self tanchuAdress:2];
    }else if (sender.tag == 3){
        
        if (view1.textFiled.text.length <= 0) {
            //弹窗
            NSLog(@"请先选择省份");
            view1.textBtn.enabled = YES;
            view2.textBtn.enabled = YES;
            view3.textBtn.enabled = YES;
        }else{
           [self tanchuAdress:3];
        }
    }else if (sender.tag == 4){
        if (view1.textFiled.text.length <= 0 || view2.textFiled.text.length <= 0) {
            //弹窗
            NSLog(@"请检查省份或者城市信息");
            view1.textBtn.enabled = YES;
            view2.textBtn.enabled = YES;
            view3.textBtn.enabled = YES;
        }else{
            [self tanchuAdress:4];
        }
    }
    
}



-(void)tanchuAdress:(NSInteger)indexId{
    didSelectRow = 0;
    if (indexId == 2) {
        didSelectId = [self.IDArr[0] integerValue];
    }else if (indexId == 3){
        didSelectId = [self.IDArr2[0] integerValue];
    }else if (indexId == 4){
        didSelectId = [self.IDArr3[0] integerValue];
    }
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 230, self.view.bounds.size.width, 230)];
    backView.tag = 995544;
    [self.view addSubview:backView];
    
    UIView *anniuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    anniuView.backgroundColor = [UIColor grayColor];
    [backView addSubview:anniuView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 60, 30);
    btn.tag = 1;
    [btn addTarget:self action:@selector(tanChuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [anniuView addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"确定" forState:UIControlStateNormal];
    btn1.tag = 2;
    [btn1 addTarget:self action:@selector(tanChuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(self.view.bounds.size.width - 60, 0, 60, 30);
    [anniuView addSubview:btn1];
    
    UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,  30, self.view.bounds.size.width, 200)];
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.showsSelectionIndicator=YES;
    pickView.delegate = self;
    pickView.dataSource = self;
    [backView addSubview:pickView];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (index == 2) {
        return self.titleArr.count;
    }else if (index == 3){
        return self.titleArr2.count;
    }else if (index == 4){
        return self.titleArr3.count;
    }
    
    return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (index == 2) {
        return self.titleArr[row];
    }else if (index == 3){
        return self.titleArr2[row];
    }else if (index == 4){
        return self.titleArr3[row];
    }
    return 0;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"asdasd----%ld-----%@",row,self.titleArr[row]);
    didSelectId = [self.IDArr[row] integerValue];
    didSelectRow = row;
}


-(void)tanChuBtnClick:(UIButton *)sender{
    
    
    UIView *view = [self.view viewWithTag:995544];
    [view removeFromSuperview];
    
    contentView *view1 = [self.view viewWithTag:1002];
    contentView *view2 = [self.view viewWithTag:1003];
    contentView *view3 = [self.view viewWithTag:1004];
    view1.textBtn.enabled = YES;
    view2.textBtn.enabled = YES;
    view3.textBtn.enabled = YES;
    
     if (_typeCode == 1){
          if (sender.tag == 2) {
               //点击确定执行
               if (index == 2) {//点击省份选择
                    view2.textFiled.text = @"";
                    view3.textFiled.text = @"";
                    view1.textFiled.text = self.titleArr[didSelectRow];
                    
                    
                    
               }else if (index == 3){//点击城市选择
                    view2.textFiled.text = self.titleArr2[didSelectRow];
                    view3.textFiled.text = @"";
               }else if (index == 4){//点击区县选择
                    if (addBtnClick == 1) {
                         addBtnClick = 0;
                         if (view3.textFiled.text.length <= 0) {
                              view3.textFiled.text = self.titleArr3[didSelectRow];
                              finishCityId = [NSString stringWithFormat:@"%@",self.IDArr3[didSelectRow]];
                         }else{
                              if ([view3.textFiled.text rangeOfString:[NSString stringWithFormat:@"%@",self.titleArr3[didSelectRow]]].location !=NSNotFound) {
                                   Alert_Show(@"不能添加形同的区域")
                              }else{
                                   view3.textFiled.text = [view3.textFiled.text stringByAppendingPathComponent:[NSString stringWithFormat:@",%@",self.titleArr3[didSelectRow]]];
                                   finishCityId = [NSString stringWithFormat:@"%@,%@",finishCityId,self.IDArr3[didSelectRow]];
                              }
                         }
                         NSLog(@"两个东西道理拼接没有----%@------%@----",view3.textFiled.text,finishCityId);
                    }else{
                         if ([view3.textFiled.text rangeOfString:@","].location !=NSNotFound) {
                              NSArray *textArr = [view3.textFiled.text componentsSeparatedByString:@","];
                              NSMutableArray *arr = [NSMutableArray arrayWithArray:textArr];
                              [arr removeLastObject];
                              [arr addObject:self.titleArr3[didSelectRow]];
                              
                              NSArray *idArr = [finishCityId componentsSeparatedByString:@","];
                              NSMutableArray *arr1 = [NSMutableArray arrayWithArray:idArr];
                              [arr1 removeLastObject];
                              [arr1 addObject:self.IDArr3[didSelectRow]];
                              
                              for (int i = 0; i < arr.count ; i ++) {
                                   if ( i == 0) {
                                        view3.textFiled.text = arr[i];
                                        finishCityId = arr1[i];
                                   }else{
                                        view3.textFiled.text = [NSString stringWithFormat:@"%@,%@",view3.textFiled.text,arr[i]];
                                        finishCityId = [NSString stringWithFormat:@"%@,%@",finishCityId,arr1[i]];
                                   }
                              }
                         }else{
                              view3.textFiled.text = self.titleArr3[didSelectRow];
                              finishCityId = [NSString stringWithFormat:@"%@",self.IDArr3[didSelectRow]];;
                              
                              
                         }
                    }
                    
               }
          }
     }else{
          if (sender.tag == 2) {
               //点击确定执行
               if (index == 2) {//点击省份选择
                    view2.textFiled.text = @"";
                    view3.textFiled.text = @"";
                    view1.textFiled.text = self.titleArr[didSelectRow];
                    NSDictionary *dic = _allArr[didSelectRow];
                    self.allArr2 = dic[@"city"];
                    
                    for (NSDictionary * dic in _allArr2) {
                         [self.titleArr2 addObject:dic[@"name"]];
                         [self.IDArr2 addObject:dic[@"id"]];
                    }
               }else if (index == 3){//点击城市选择
                    view2.textFiled.text = self.titleArr2[didSelectRow];
                    view3.textFiled.text = @"";
                    NSDictionary *dic = _allArr2[didSelectRow];
                    self.allArr3 = dic[@"city"];
                    
                    for (NSDictionary * dic in _allArr3) {
                         [self.titleArr3 addObject:dic[@"name"]];
                         [self.IDArr3 addObject:dic[@"id"]];
                    }
               }else if (index == 4){//点击区县选择
                    if (addBtnClick == 1) {
                         addBtnClick = 0;
                         if (view3.textFiled.text.length <= 0) {
                              view3.textFiled.text = self.titleArr3[didSelectRow];
                              finishCityId = [NSString stringWithFormat:@"%@",self.IDArr3[didSelectRow]];
                         }else{
                              if ([view3.textFiled.text rangeOfString:[NSString stringWithFormat:@"%@",self.titleArr3[didSelectRow]]].location !=NSNotFound) {
                                   Alert_Show(@"不能添加形同的区域")
                              }else{
                                   view3.textFiled.text = [view3.textFiled.text stringByAppendingPathComponent:[NSString stringWithFormat:@",%@",self.titleArr3[didSelectRow]]];
                                   finishCityId = [NSString stringWithFormat:@"%@,%@",finishCityId,self.IDArr3[didSelectRow]];
                              }
                         }
                         NSLog(@"两个东西道理拼接没有----%@------%@----",view3.textFiled.text,finishCityId);
                    }else{
                         if ([view3.textFiled.text rangeOfString:@","].location !=NSNotFound) {
                              NSArray *textArr = [view3.textFiled.text componentsSeparatedByString:@","];
                              NSMutableArray *arr = [NSMutableArray arrayWithArray:textArr];
                              [arr removeLastObject];
                              [arr addObject:self.titleArr3[didSelectRow]];
                              
                              NSArray *idArr = [finishCityId componentsSeparatedByString:@","];
                              NSMutableArray *arr1 = [NSMutableArray arrayWithArray:idArr];
                              [arr1 removeLastObject];
                              [arr1 addObject:self.IDArr3[didSelectRow]];
                              
                              for (int i = 0; i < arr.count ; i ++) {
                                   if ( i == 0) {
                                        view3.textFiled.text = arr[i];
                                        finishCityId = arr1[i];
                                   }else{
                                        view3.textFiled.text = [NSString stringWithFormat:@"%@,%@",view3.textFiled.text,arr[i]];
                                        finishCityId = [NSString stringWithFormat:@"%@,%@",finishCityId,arr1[i]];
                                   }
                              }
                         }else{
                              view3.textFiled.text = self.titleArr3[didSelectRow];
                              finishCityId = [NSString stringWithFormat:@"%@",self.IDArr3[didSelectRow]];;
                              
                              
                         }
                    }
                    
               }
          }
     }
    
}

-(void)sendBtnClick{
    contentView *view1 = [self.view viewWithTag:1000];
    contentView *view2 = [self.view viewWithTag:1001];
    contentView *view3 = [self.view viewWithTag:1002];
    contentView *view4 = [self.view viewWithTag:1003];
    contentView *view5 = [self.view viewWithTag:1004];
    if (view1.textFiled.text.length > 0 && view2.textFiled.text.length > 0 && view3.textFiled.text.length > 0 && view4.textFiled.text.length > 0 && view5.textFiled.text.length > 0 ) {
        [self requestAgent];
    }else if (view1.textFiled.text.length <= 0){
        
    }else if (view2.textFiled.text.length <= 0){
        
    }else if (view3.textFiled.text.length <= 0){
        
    }else if (view4.textFiled.text.length <= 0){
        
    }else if (view5.textFiled.text.length <= 0){
        
    }
    
}

#pragma mark--------request------
-(void)requestAgent{
    contentView *view1 = [self.view viewWithTag:1000];
    contentView *view2 = [self.view viewWithTag:1001];
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     finishCityArr = [finishCityId componentsSeparatedByString:@","];
     NSString *presentStr = @"";
     for (int i = 0; i < finishCityArr.count; i ++) {
          if ( i == 0) {
               presentStr = [NSString stringWithFormat:@"areaId=%@",finishCityArr[0]];
          }else{
               presentStr = [NSString stringWithFormat:@"%@&areaId=%@",presentStr,finishCityArr[i]];
          }
     }
    NSLog(@"aasdasd-----%@-----",[NSString stringWithFormat:@"%@/api/v1/life/agent/save?name=%@&%@&profile=%@",LSKurl,view1.textFiled.text,presentStr,view2.textFiled.text]);
     
     NSString *urlStr = [[NSString stringWithFormat:@"%@/api/v1/life/agent/save?name=%@&%@&profile=%@",LSKurl,view1.textFiled.text,presentStr,view2.textFiled.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"申请代理:%@", responseObject);
         if ([responseObject[@"code"] intValue] == 0) {
              
              UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"入驻申请已提交,等待审核" preferredStyle:(UIAlertControllerStyleAlert)];
              UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {[self.navigationController popToRootViewControllerAnimated:YES];}];
              [alertVC addAction:okAction];
              [self presentViewController:alertVC animated:YES completion:nil];
         }else if ([responseObject[@"code"] intValue] == 935){
              Alert_Show(@"申请区域已被申请代理")
         }else if ([responseObject[@"code"] intValue] == 936){
              Alert_Show(@"申请区域必须为同级地区")
         }else if ([responseObject[@"code"] intValue] == 1016){
              Alert_Show(@"申请代理区域过大")
         }else if ([responseObject[@"code"] intValue] == 1017){
              Alert_Show(@"申请的代理区域不在同一地区")
         }else if ([responseObject[@"code"] intValue] == 1018){
              Alert_Show(@"代理申请地区必须包含自己商家地址")
         }else if ([responseObject[@"code"] intValue] == 933){
              Alert_Show(@"您已是本地区域代理")
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"申请代理shibai :%@", error);
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

-(void)requestDaiLiDetail{
     
     NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     NSLog(@"aasdasd-----%@------",[NSString stringWithFormat:@"%@/api/v1/life/agent/detail",LSKurl1]);
     NSString *urlStr = [[NSString stringWithFormat:@"%@/api/v1/life/agent/detail",LSKurl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"申请代理详情:%@", responseObject);
          contentView *view = [self.view viewWithTag:1000];
          contentView *view0 = [self.view viewWithTag:1001];
          contentView *view1 = [self.view viewWithTag:1002];
          contentView *view2 = [self.view viewWithTag:1003];
          contentView *view3 = [self.view viewWithTag:1004];
          
          view.textFiled.text = responseObject[@"data"][@"name"];
          view0.textFiled.text = responseObject[@"data"][@"profile"];
          
          self.allArr3 = @[];
          
          NSArray *arr = responseObject[@"data"][@"parentId"];
          for (int i = 0; i < arr.count; i ++) {
               if (i == 0) {
                    NSArray *titleArr = [arr[0] componentsSeparatedByString:@","];
                    view1.textFiled.text = titleArr[1];
                    for (int i = 0; i < _allArr.count; i ++) {
                         if ([titleArr[1] isEqualToString:_allArr[i][@"name"]]) {
                              self.allArr2 = _allArr[i][@"city"];
                         }
                    }
                    for (NSDictionary * dic in _allArr2) {
                         [self.titleArr2 addObject:dic[@"name"]];
                         [self.IDArr2 addObject:dic[@"id"]];
                    }
                    
               }else{
                    NSArray *titleArr = [arr[i] componentsSeparatedByString:@","];
                    view2.textFiled.text = titleArr[1];
                    for (int i = 0; i < _allArr2.count; i ++) {
                         if ([titleArr[1] isEqualToString:_allArr2[i][@"name"]]) {
                              self.allArr3 = _allArr2[i][@"city"];
                         }
                    }
                    for (NSDictionary * dic in _allArr3) {
                         [self.titleArr3 addObject:dic[@"name"]];
                         [self.IDArr3 addObject:dic[@"id"]];
                    }
               }
          }
          NSArray *arr1 = responseObject[@"data"][@"areaId"];
          for (int i = 0; i < arr1.count; i ++){
               if (i == 0) {
                    NSArray *titleArr = [arr1[0] componentsSeparatedByString:@","];
                    view3.textFiled.text = titleArr[1];
                    finishCityId = [NSString stringWithFormat:@"%@",titleArr[0]];
               }else{
                    NSArray *titleArr = [arr1[i] componentsSeparatedByString:@","];
                    view3.textFiled.text = [view3.textFiled.text stringByAppendingPathComponent:[NSString stringWithFormat:@"/,%@",titleArr[1]]];
                    finishCityId = [NSString stringWithFormat:@"%@,%@",finishCityId,titleArr[0]];
               }
          }
          
          
          
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"申请代理shibai :%@", error);
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.view endEditing:YES];
}
@end
