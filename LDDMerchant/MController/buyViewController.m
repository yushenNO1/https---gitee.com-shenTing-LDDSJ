//
//  buyViewController.m
//  goods
//
//  Created by 王松松 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "buyViewController.h"
#import "NetURL.h"

@interface buyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NSMutableArray *arr2;
@property (nonatomic, strong) NSArray *arr1;
@property (nonatomic, strong) NSArray *arr3;
@property (nonatomic, assign) BOOL i1;
@property (nonatomic, assign) BOOL i2;
@property (nonatomic, assign) BOOL i3;
@property (nonatomic, assign) BOOL i4;
@property (nonatomic, assign) BOOL i5;
@property (nonatomic, assign) BOOL i6;
@property (nonatomic, assign) BOOL i7;
@property (nonatomic, assign) BOOL i8;
@property (nonatomic, assign) NSInteger a;
@end

@implementation buyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"购买须知";
    UIBarButtonItem *barBtn =[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnClick)];
    self.navigationItem.rightBarButtonItem =barBtn;
    NSLog(@"jinrushuzu%@", _buyAry);
    if ([_buyCode intValue] == 0) {
        _arr1 =@[@"是否支持极速退款",@"是否支持wifi",@"是否展示发票",@"是否享有优惠",@"是否预约",@"是否限制最高销量(接待量)",@"是否限购团购券",@"是否限用团购券",@"是否限制团购券使用人数"];
        _arr3 =@[@"1",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
        self.arr2 = [NSMutableArray arrayWithArray:_arr3];
    } else {
        for (NSDictionary * dic in _buyAry) {
            [self.arr addObject:dic[@"title"]];
            [self.arr2 addObject:[NSString stringWithFormat:@"%@", dic[@"type"]]];
        }
    }
    [self tableView];
    [self Switchss];
}

-(void)viewWillAppear:(BOOL)animated
{
    _a = 0;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (_a == 0) {
        [self barBtnClick];
    }
}

- (void)barBtnClick
{
    _a = 1;
    NSArray * ary1 = @[@{@"content":@"", @"key":@"1000", @"val":@"", @"title":@"", @"type":@""}, @{@"content":@"", @"key":@"1001", @"val":@"", @"title":@"", @"type":@""}, @{@"content":@"", @"key":@"1002", @"val":@"", @"title":@"", @"type":@""}, @{@"content":@"", @"key":@"1003", @"val":@"", @"title":@"", @"type":@""}, @{@"content":@"", @"key":@"1004", @"val":@"", @"title":@"", @"type":@""}, @{@"content":@"", @"key":@"1005", @"val":@"", @"title":@"", @"type":@""}, @{@"content":@"", @"key":@"1006", @"val":@"", @"title":@"", @"type":@""}, @{@"content":@"", @"key":@"1007", @"val":@"", @"title":@"", @"type":@""}, @{@"content":@"", @"key":@"1008", @"val":@"", @"title":@"", @"type":@""}];
    NSMutableArray * ary2 = [NSMutableArray arrayWithArray:ary1];
    if (_buyAry.count == 0) {
        
        for (int i = 0; i < 9; i++) {
            NSDictionary * dic = ary2[i];
            NSMutableDictionary * dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
            dic1[@"title"] = _arr1[i];
            if(i == 0)
            {
            _arr2[i] = @"1";
            
            }
            if(i == 5 || i == 6 || i == 7)
            {
                _arr2[i] = @"0";
                
            }
            if ([_arr2[i] isEqualToString:@"1"]) {
                dic1[@"content"] = @"是";
            } else {
                dic1[@"content"] = @"否";
            }
            dic1[@"type"] = _arr2[i];
            ary2[i] = [NSDictionary dictionaryWithDictionary:dic1];
        }
    } else {
        for (int i = 0; i < _buyAry.count + 1; i++) {
            NSDictionary * dic = ary2[i];
            NSMutableDictionary * dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
            
            if(i == 0)
            {
                _arr2[i] = @"1";
                
            }
            if(i == 5 || i == 6 || i == 7)
            {
                _arr2[i] = @"0";
            }
            
            
            
            if (_buyAry.count == 8) {
                if ( i == 8) {
                    dic1[@"content"] = @"否";
                    dic1[@"type"] = @"0";
                    dic1[@"title"] = @"是否限制团购券使用人数";
                } else {
                    if ([_arr2[i] isEqualToString:@"1"]) {
                        dic1[@"content"] = @"是";
                    } else {
                        dic1[@"content"] = @"否";
                    }
                    dic1[@"type"] = _arr2[i];
                    dic1[@"title"] = _arr[i];
                }
            } else {
                if ([_arr2[i] isEqualToString:@"1"]) {
                    dic1[@"content"] = @"是";
                } else {
                    dic1[@"content"] = @"否";
                }
                dic1[@"type"] = _arr2[i];
                dic1[@"title"] = _arr[i];
            }
            ary2[i] = [NSDictionary dictionaryWithDictionary:dic1];
        }
    }
    NSArray * ary = [NSArray arrayWithArray:ary2];
    NSDictionary* dic =@{ @"vaue":ary};
    NSLog(@"jinrushuzu%@", ary);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BuyPass" object:nil userInfo:dic];
      Alert_show_pushRoot(@"保存成功");
}

- (NSMutableArray *)arr {
    if (!_arr) {
        self.arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr;
}

- (NSMutableArray *)arr2 {
    if (!_arr2) {
        self.arr2 = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr2;
}

-(void)tableView
{
    UITableView *tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate =self;
    tableView.dataSource =self;
    tableView.separatorStyle = NO;
    tableView.scrollEnabled =NO;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_buyAry.count == 0) {
        return 9;
    } else {
        return _buyAry.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellView =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (_buyAry.count == 0) {
        cellView.textLabel.text =self.arr1[indexPath.section];
    } else {
        cellView.textLabel.text =self.arr[indexPath.section];
    }
    cellView.selectionStyle =UITableViewCellSelectionStyleNone;
    return cellView;
}

- (void)Switchss
{
     if (_buyAry.count == 0) {
         for (int i =0; i<9; i++)
         {
             int row =i/1;
             float y = 75+row*(20+30);
             UISwitch *Switch1 =[[UISwitch alloc]initWithFrame:CGRectMake(300 * kScreenWidth1, y, 50 * kScreenWidth1, 20 * kScreenHeight1)];
             Switch1.tintColor =[UIColor grayColor];
             Switch1.onTintColor =[UIColor greenColor];
             Switch1.thumbTintColor =[UIColor whiteColor];
             if ([_arr3[i] isEqualToString:@"1"]) {
                 Switch1.on=YES;
             } else if ([_arr3[i] isEqualToString:@"0"]) {
                 Switch1.on=NO;
             } else {
                 //type = -1 状态不明 默认关闭
                 Switch1.on=NO;
             }
             Switch1.tag =i+1;
             [Switch1 addTarget:self action:@selector(switchOn:) forControlEvents:UIControlEventValueChanged];
             [self.view addSubview:Switch1];
         }
     } else {
         for (int i =0; i < _buyAry.count; i++) {
             int row =i/1;
             float y = 75+row*(20+30);
             UISwitch *Switch1 =[[UISwitch alloc]initWithFrame:CGRectMake(300 * kScreenWidth1, y, 50 * kScreenWidth1, 20 * kScreenHeight1)];
             Switch1.tintColor =[UIColor grayColor];
             Switch1.onTintColor =[UIColor greenColor];
             Switch1.thumbTintColor =[UIColor whiteColor];
             if ([self.arr2[i] isEqualToString:@"1"]) {
                 Switch1.on=YES;
             } else if ([self.arr2[i] isEqualToString:@"0"]) {
                 Switch1.on=NO;
             } else {
                 Switch1.on=NO;
             }
             Switch1.tag =i+1;
             [Switch1 addTarget:self action:@selector(switchOn:) forControlEvents:UIControlEventValueChanged];
             [self.view addSubview:Switch1];
        }
    }
}


-(void)switchOn:(UISwitch *)Switch
{
    if (Switch.tag == 1)
    {
        if ([_arr2[0] isEqualToString:@"1"]) {
            _arr2[0] = @"1";
        } else {
            _arr2[0] = @"1";
        }
        
        
    }
    else if (Switch.tag == 2)
    {
        if ([_arr2[1] isEqualToString:@"1"]) {
            _arr2[1] = @"0";
        } else {
            _arr2[1] = @"1";
        }
        
    }
    else if (Switch.tag == 3)
    {
        if ([_arr2[2] isEqualToString:@"1"]) {
            _arr2[2] = @"0";
        } else {
            _arr2[2] = @"1";
        }
    }
    else if (Switch.tag == 4)
    {
        if ([_arr2[3] isEqualToString:@"1"]) {
            _arr2[3] = @"0";
        } else {
            _arr2[3] = @"1";
        }
    }
    else if (Switch.tag == 5)
    {
        if ([_arr2[4] isEqualToString:@"1"]) {
            _arr2[4] = @"0";
        } else {
            _arr2[4] = @"1";
        }
        
    }
    else if (Switch.tag == 6)
    {
        if ([_arr2[5] isEqualToString:@"1"]) {
            _arr2[5] = @"0";
        } else {
            _arr2[5] = @"0";
        }
        
    }
    else if (Switch.tag == 7)
    {
        if ([_arr2[6] isEqualToString:@"1"]) {
            _arr2[6] = @"0";
        } else {
            _arr2[6] = @"0";
        }    }
    else if (Switch.tag == 8)
    {
        if ([_arr2[7] isEqualToString:@"1"]) {
            _arr2[7] = @"0";
        } else {
            _arr2[7] = @"0";
        }
    }
    else if (Switch.tag == 9)
    {
        if ([_arr2[8] isEqualToString:@"1"]) {
            _arr2[8] = @"0";
        } else {
            _arr2[8] = @"1";
        }
    }
}



@end
