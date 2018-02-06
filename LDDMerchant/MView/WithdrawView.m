//
//  WithdrawView.m
//  LSKKApp
//
//  Created by 云盛科技 on 16/3/15.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "WithdrawView.h"
#import "ViewTableCell.h"
#import "AFNetworking.h"
#import "ShowCardModel.h"
#import "NetURL.h"




@implementation WithdrawView

-(void)getdic:(NSDictionary *)dic
{

    self.dataDic = dic;

    [self handleData:dic];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.alpha = 0.5;
        [self configTable];
       
    }
    return self;
}
-(void)configTable
{
    
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    aView.backgroundColor = [UIColor grayColor];
    aView.alpha = 0.5;
    [self addSubview:aView];
    
    UIView *view= [[UIView alloc]initWithFrame:CGRectMake(20 * kScreenWidth1, 150 * kScreenHeight1, 335 * kScreenWidth1, 250 * kScreenHeight1)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(20 * kScreenWidth1, 5 * kScreenHeight1, 200 * kScreenWidth1, 20 * kScreenHeight1)];
    l.text = @"请选择提现银行卡";
    [view addSubview:l];
    _circleArr = [NSMutableArray arrayWithCapacity:0];
    
    _imageArr = @[@"logo_01@3x.png",@"logo_02@3x.png",@"logo@3x.png"];
    _titleArr = @[@"支付宝账号",@"微信账号",@"中国工商银行储蓄账户"];
    _tailArr = @[@"180*****598",@"180*****598",@"9558**********5689"];
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 30 * kScreenHeight1, view.bounds.size.width, view.bounds.size.height-30 * kScreenHeight1)];
    _table.delegate = self;
    _table.dataSource = self;
    _table.rowHeight = 60 * kScreenHeight1;
    [_table registerClass:[ViewTableCell class] forCellReuseIdentifier:@"cell"];
    [view addSubview:_table];
    
    [self handleData:self.cardDic];

}



#pragma mark -  网络请求数据

- (NSMutableArray *)dataSource {//懒加载初始化数组
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)handleData:(NSDictionary *)dic {//封装对象
    [self.dataSource removeAllObjects];
    NSDictionary * dataDic = dic[@"data"];
    NSArray * dataAry = dataDic[@"card"];
    if ([dataAry count] != 0) {
        for (NSDictionary * tempDic in dataAry) {
            ShowCardModel * model = [[ShowCardModel alloc]init];
            [model setValuesForKeysWithDictionary:tempDic];
            [self.dataSource addObject:model];
        }
        
        [self loadcircleArr];

        [self.table reloadData];
        
    }
    else
    {
        [self removeFromSuperview];
    }
}


-(void)loadcircleArr
{

    
    
    for (int i = 0; i < _dataSource.count; i ++) {
        [_circleArr addObject:@"yuan@3x"];
    }
    
    [_circleArr  replaceObjectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"circle"] withObject:@"quan@3x"];
    


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60 * kScreenHeight1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (self.dataSource.count > 0)
    {
        ShowCardModel * model = self.dataSource[indexPath.row];
        //    logo_01@3x.png
        if ([model.bank isEqualToString:@"支付宝账号"])
        {
            cell.headerImage.image = [UIImage imageNamed:@"logo_01@3x.png"];
            cell.ID.text = [NSString stringWithFormat:@"%@",model.cardNo];
        }
        else
        {
            cell.headerImage.image = [UIImage imageNamed:@"bankCard"];
            NSString *str =[NSString stringWithFormat:@"%@",model.cardNo];
//            NSString *tel =[str stringByReplacingCharactersInRange:NSMakeRange(0, 15) withString:@"***************"];
            cell.ID.text = str;
            
            //cell.ID.text = [NSString stringWithFormat:@"%@",model.cardNo];
        }
        
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.bank];
        
        cell.circleImage.image = [UIImage imageNamed:[_circleArr objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i < _dataSource.count; i ++)
    {
        [_circleArr  replaceObjectAtIndex:i withObject:@"quan@3x"];
    }
    [_circleArr  replaceObjectAtIndex:indexPath.row withObject:@"yuan@3x"];
    [tableView reloadData];
    
    [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row forKey:@"circle"];
    
    [self removeFromSuperview];
    ShowCardModel * model = self.dataSource[indexPath.row];
    NSString *image = @"bankCard";
    NSString *titleLabel =[NSString stringWithFormat:@"%@",model.bank];
    NSString *detailsLabel =[NSString stringWithFormat:@"%@",model.cardNo];
    NSString *cardID = [NSString stringWithFormat:@"%@",model.cardId];
    if ([model.bank isEqualToString:@"支付宝账号"]){
        image = @"logo_01@3x.png";
    }
    else{
        image = @"bankCard";
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"withdrawal" object:self userInfo:@{@"image":image,@"titleLabel":titleLabel,@"tailLabel":detailsLabel,@"cardId":cardID}];
}

@end
