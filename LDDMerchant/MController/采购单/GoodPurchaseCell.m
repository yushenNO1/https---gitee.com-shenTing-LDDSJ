//
//  GoodPurchaseCell.m
//  采购单
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "GoodPurchaseCell.h"

@implementation GoodPurchaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.TopLabel];
        [self addSubview:self.DownLabel];
        [self addSubview:self.Btn];
        [self addSubview:self.leftImageView];
        
    }
    return self;
}

- (UIButton *)Btn
{
    if (!_Btn) {
        CGRect frame = WDH_CGRectMake(270, 25, 80, 25);
        self.Btn = [UIButton buttonWithType:UIButtonTypeSystem];
        _Btn.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:56 / 255.0 blue:84 / 255.0 alpha:1.0];
         _Btn.layer.cornerRadius = 3;
         _Btn.layer.masksToBounds = YES;
        [_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _Btn.frame = frame;
    }
    return _Btn;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        CGRect frame = WDH_CGRectMake(20, 20, 40, 40);
        self.leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
//        _leftImageView.backgroundColor = [UIColor cyanColor];
        _leftImageView.layer.cornerRadius = 20;
        _leftImageView.layer.masksToBounds = YES;
        _leftImageView.frame = frame;
    }
    return _leftImageView;
}

- (UILabel *)TopLabel  {
    if (!_TopLabel)
    {
        _TopLabel =[[UILabel alloc]initWithFrame:WDH_CGRectMake(80, 15 , 150, 25)];
        _TopLabel.textAlignment =NSTextAlignmentLeft;
        _TopLabel.font =[UIFont systemFontOfSize:15];
    }
    return _TopLabel;
}

- (UILabel *)DownLabel  {
    if (!_DownLabel)
    {
        _DownLabel =[[UILabel alloc]initWithFrame:WDH_CGRectMake(80, 40 , 150, 25)];
        _DownLabel.textAlignment =NSTextAlignmentLeft;
        _DownLabel.textColor = [UIColor lightGrayColor];
        _DownLabel.font =[UIFont systemFontOfSize:13];
    }
    return _DownLabel;
}

@end
