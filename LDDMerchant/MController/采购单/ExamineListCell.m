//
//  ExamineListCell.m
//  采购单
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "ExamineListCell.h"

@implementation ExamineListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.TopLabel];
        [self addSubview:self.DownLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.leftImageView];
        [self addSubview:self.ImageView];
    }
    return self;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel =[[UILabel alloc]initWithFrame:WDH_CGRectMake(250, 40 , 100, 30)];
        _rightLabel.textAlignment =NSTextAlignmentRight;
        _rightLabel.font =[UIFont systemFontOfSize:13];
    }
    return _rightLabel;
}

- (UIImageView *)ImageView
{
    if (!_ImageView) {
        CGRect frame = WDH_CGRectMake(230, 40, 40, 34);
        self.ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _ImageView.image = [UIImage imageNamed:@"审核未通过 "];
        _ImageView.frame = frame;
    }
    return _ImageView;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        CGRect frame = WDH_CGRectMake(10, 10, 80, 80);
        self.leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _leftImageView.frame = frame;
    }
    return _leftImageView;
}

- (UILabel *)TopLabel  {
    if (!_TopLabel)
    {
        _TopLabel =[[UILabel alloc]initWithFrame:WDH_CGRectMake(100, 10 , 250, 30)];
        _TopLabel.textAlignment =NSTextAlignmentLeft;
        _TopLabel.font =[UIFont systemFontOfSize:15];
    }
    return _TopLabel;
}

- (UILabel *)DownLabel  {
    if (!_DownLabel)
    {
        _DownLabel =[[UILabel alloc]initWithFrame:WDH_CGRectMake(100, 50 , 150, 30)];
        _DownLabel.textAlignment =NSTextAlignmentLeft;
        _DownLabel.textColor = [UIColor colorWithRed:247 / 255.0 green:48 / 255.0 blue:75 / 255.0 alpha:1];
        _DownLabel.font =[UIFont systemFontOfSize:13];
    }
    return _DownLabel;
}


@end
