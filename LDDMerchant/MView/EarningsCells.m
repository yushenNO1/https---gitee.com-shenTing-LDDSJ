//
//  EarningsCells.m
//  YSApp
//
//  Created by 云盛科技 on 16/6/23.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "EarningsCells.h"
#import "UIColor+Addition.h"
#import "NetURL.h"

@implementation EarningsCells

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
        [self addSubview:self.weekLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.vMoneyLabel];
    }
    return self;
}
- (UILabel *)nameLabel  {
    if (!_nameLabel)
    {
        _nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 5*kScreenHeight1, 50*kScreenWidth1, 50*kScreenHeight1)];
        _nameLabel.backgroundColor = [UIColor backGray];
        _nameLabel.font = [UIFont boldSystemFontOfSize:25*kScreenWidth1];
        _nameLabel.textAlignment =NSTextAlignmentCenter;
        _nameLabel.clipsToBounds = YES;
        _nameLabel.layer.cornerRadius = 10*kScreenWidth1;
    }
    return _nameLabel;
}
- (UILabel *)weekLabel  {
    if (!_weekLabel)
    {
        _weekLabel =[[UILabel alloc]initWithFrame:CGRectMake((CGRectGetMaxX(_nameLabel.frame)+15), 5*kScreenHeight1, 220*kScreenWidth1, 25*kScreenHeight1)];
        _weekLabel.font =[UIFont systemFontOfSize:15*kScreenWidth1];
    }
    return _weekLabel;
}
- (UILabel *)timeLabel  {
    if (!_timeLabel)
    {
        _timeLabel =[[UILabel alloc]initWithFrame:CGRectMake((CGRectGetMaxX(_nameLabel.frame)+15), 30*kScreenHeight1, 170*kScreenWidth1, 25*kScreenHeight1)];
         _timeLabel.font =[UIFont systemFontOfSize:15*kScreenWidth1];
        _timeLabel.textColor =[UIColor lightGrayColor];
    }
    return _timeLabel;
}
- (UILabel *)vMoneyLabel  {
    if (!_vMoneyLabel)
    {
        _vMoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake((CGRectGetMaxX(_timeLabel.frame)-25), 5*kScreenHeight1, 140*kScreenWidth1, 50*kScreenHeight1)];
        _vMoneyLabel.numberOfLines =0;
        _vMoneyLabel.textAlignment =2;
    }
    return _vMoneyLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
