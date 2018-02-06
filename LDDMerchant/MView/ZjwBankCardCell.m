//
//  ZjwBankCardCell.m
//  LSK
//
//  Created by 张敬文 on 2017/1/17.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "ZjwBankCardCell.h"
#import "UIColor+Addition.h"
#import "NetURL.h"
@implementation ZjwBankCardCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.NameLabel];
        [self addSubview:self.LeftImageView];
        [self addSubview:self.LeftLabel];
        [self addSubview:self.bankNumLabel];
        [self addSubview:self.lightGrayLine];
    }
    return self;
}
- (UILabel *)NameLabel  {
    if (!_NameLabel)
    {
        _NameLabel =[[UILabel alloc]initWithFrame:CGRectMake(110*kScreenWidth1, 5*kScreenHeight1, 250*kScreenWidth1, 30*kScreenHeight1)];
        _NameLabel.font = [UIFont systemFontOfSize:17];
 
    }
    return _NameLabel;
}
- (UIImageView *)LeftImageView  {
    if (!_LeftImageView)
    {
        _LeftImageView =[[UIImageView alloc]initWithFrame:CGRectMake(35, 10*kScreenHeight1, 35*kScreenWidth1, 35*kScreenHeight1)];
    }
    return _LeftImageView;
}
    
- (UILabel *)LeftLabel  {
    if (!_LeftLabel)
    {
        _LeftLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 50*kScreenHeight1, 85*kScreenWidth1, 10*kScreenHeight1)];
        _LeftLabel.font =[UIFont systemFontOfSize:12*kScreenWidth1];
        _LeftLabel.textColor =[UIColor lightGrayColor];
        _LeftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _LeftLabel;
}
                                                             
- (UILabel *)bankNumLabel  {
    if (!_bankNumLabel)
    {
        _bankNumLabel =[[UILabel alloc]initWithFrame:CGRectMake(110, 35*kScreenHeight1, 250*kScreenWidth1, 30*kScreenHeight1)];
    }
    return _bankNumLabel;
}

- (UILabel *)lightGrayLine  {
    if (!_lightGrayLine)
    {
        _lightGrayLine =[[UILabel alloc]initWithFrame:CGRectMake(0, 69*kScreenHeight1, 375*kScreenWidth1, 1*kScreenHeight1)];
        _lightGrayLine.backgroundColor = [UIColor backGray];
    }
    return _lightGrayLine;
}


@end
