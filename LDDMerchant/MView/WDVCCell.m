//
//  WDVCCell.m
//  LSKKApp
//
//  Created by 云盛科技 on 16/4/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "WDVCCell.h"
#import "WDModel.h"
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width / 375)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height / 667)
@implementation WDVCCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.weekLabel];
        [self.contentView addSubview:self.titleLaebl];
        [self.contentView addSubview:self.numLabel];
        [self.contentView addSubview:self.dataLabel];
    }
    return self;
}

- (void)setWdm:(WDModel *)wdm {
    if (_wdm != wdm) {
        _wdm = wdm;
    }
    self.weekLabel.text = wdm.createTime;
    if (wdm.cardNo.length == 11){
        self.titleLaebl.text = [NSString stringWithFormat:@"%@",wdm.cardNo];
    }else{
        NSString *string =[NSString stringWithFormat:@"%@",wdm.cardNo];
//        NSString *telStr =[string stringByReplacingCharactersInRange:NSMakeRange(0, 15) withString:@"**********"];
        self.titleLaebl.text =string;   //wdm.cardNo;
    }
    self.numLabel.text =[NSString stringWithFormat:@"￥%.2f", wdm.amount];
}

-(UILabel *)weekLabel
{
    if (!_weekLabel)
    {
        _weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * kScreenWidth, 5 * kScreenHeight, 100 * kScreenWidth, 50 * kScreenHeight)];
        _weekLabel.font = [UIFont systemFontOfSize:15];
        _weekLabel.numberOfLines = 0;
        _weekLabel.textColor = [UIColor grayColor];
        
    }
    return _weekLabel;
}
-(UILabel *)dataLabel
{
    if (!_dataLabel)
    {
        _dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(125 * kScreenWidth, 10 * kScreenHeight, 55 * kScreenWidth, 20 * kScreenHeight)];
        _dataLabel.font = [UIFont systemFontOfSize:12];
        _dataLabel.textColor = [UIColor grayColor];
    }
    return _dataLabel;
}
-(UILabel *)titleLaebl
{
    if (!_titleLaebl)
    {
        _titleLaebl = [[UILabel alloc]initWithFrame:CGRectMake(125 * kScreenWidth,30 * kScreenHeight, 180 * kScreenWidth, 20 * kScreenHeight)];
        _titleLaebl.font = [UIFont systemFontOfSize:15];
        _titleLaebl.textColor = [UIColor blackColor];
        
    }
    return _titleLaebl;
}
-(UILabel *)numLabel
{
    if (!_numLabel)
    {
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(295 * kScreenWidth, 15 * kScreenHeight, 80 * kScreenWidth, 30 * kScreenHeight)];
        _numLabel.font = [UIFont systemFontOfSize:18];
        _numLabel.textColor = [UIColor redColor];
        
    }
    return _numLabel;
}


@end
