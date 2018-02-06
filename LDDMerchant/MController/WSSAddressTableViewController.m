//
//  WSSAddressTableViewController.m
//  cccc
//
//  Created by 王松松 on 2017/1/17.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "WSSAddressTableViewController.h"

@interface WSSAddressTableViewController ()
@property (nonatomic, strong)NSMutableArray * areaDic;
@property (nonatomic, strong)NSMutableArray * provinceArray;
@property (nonatomic, strong)NSMutableArray * provinceArray1;
@property (nonatomic, strong)NSMutableArray * cityArray;
@property (nonatomic, strong)NSMutableArray * cityArray1;
@property (nonatomic, strong)NSMutableArray * detailArray;
@property (nonatomic, strong)NSMutableArray * detailArray1;
@property (nonatomic, strong)NSMutableArray * ary;

@property (nonatomic, strong)UILabel * provinceLabel;
@property (nonatomic, strong)UILabel * cityLabel;
@property (nonatomic, strong)UILabel * detailLabel;
@property (nonatomic, strong)UILabel * provinceLabel1;
@property (nonatomic, strong)UILabel * cityLabel1;
@property (nonatomic, strong)UILabel * detailLabel1;

@property (nonatomic, strong)NSArray * dataArray;
@property (nonatomic, strong)NSArray * dataArray1;
@property (nonatomic, strong)NSArray * Array; //需要展示的数组

@end

@implementation WSSAddressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
    self.provinceLabel = [[UILabel alloc] init];
    self.provinceLabel1 = [[UILabel alloc] init];
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel1 = [[UILabel alloc] init];
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel1 = [[UILabel alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"11"];
    
}

- (void) loadData {
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city_full" ofType:@"json"]];
    _areaDic  = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    _provinceArray = [NSMutableArray arrayWithCapacity:1];
    _provinceArray1 = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary * dic in _areaDic) {
        [_provinceArray addObject:dic[@"name"]];
        [_provinceArray1 addObject:dic[@"id"]];
    }
    _Array = [NSArray arrayWithArray:_provinceArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------- tableView的代理 -------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _Array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"11" forIndexPath:indexPath];
    cell.textLabel.text = _Array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_Array[0]isEqualToString:@"北京市"]) {
        int a = 0;
        a = (int)indexPath.row;
        NSString * cityStr = _provinceArray[a];
        _provinceLabel.text = cityStr;   //省份名字
        _provinceLabel1.text = _provinceArray1[a];   //省份id
        
        NSDictionary * dic = _areaDic[a];
        _dataArray1 = _areaDic[a][@"city"];
        NSArray * array = dic[@"city"];
        
        _cityArray = [NSMutableArray arrayWithCapacity:1];
        _cityArray1 = [NSMutableArray arrayWithCapacity:1];
        _ary = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary * dic in array) {
            [_cityArray addObject:dic[@"name"]];
            [_cityArray1 addObject:dic[@"id"]];
            [_ary addObject:dic[@"city"]];
        }
        _Array = [NSArray arrayWithArray:_cityArray];
        
        [self.tableView reloadData];
    } else if (_ary.count != 0){
        
        int a = 0;
        a = (int)indexPath.row;
        NSString * cityStr = _cityArray[a];
        _cityLabel.text = cityStr;   //城市名字
        _cityLabel1.text = _cityArray1[a];   //城市id
        
        NSDictionary * dic = _dataArray1[a];
        NSArray * array = dic[@"city"];
        
        _detailArray = [NSMutableArray arrayWithCapacity:1];
        _detailArray1 = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary * dic in array) {
            [_detailArray addObject:dic[@"name"]];
            [_detailArray1 addObject:dic[@"id"]];
        }
        _Array = [NSArray arrayWithArray:_detailArray];
        [_ary removeAllObjects];
        [self.tableView reloadData];
    } else {
        int a = 0;
        a = (int)indexPath.row;
        NSString * cityStr = _detailArray[a];
        _detailLabel.text = cityStr;   //县区名字
        _detailLabel1.text = _detailArray1[a];   //县区id
        NSLog(@"提交id--%@.%@.%@, 展示地区名--%@.%@.%@", _provinceLabel1.text, _cityLabel1.text, _detailLabel1.text, _provinceLabel.text, _cityLabel.text, _detailLabel.text);
        
        _content(_provinceLabel1.text, _cityLabel1.text, _detailLabel1.text, _provinceLabel.text, _cityLabel.text, _detailLabel.text);
        [self.navigationController popViewControllerAnimated:YES];
       
    }
}

@end
