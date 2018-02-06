//
//  CheckStandCell.m
//  收银台
//
//  Created by 张敬文 on 2017/5/25.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "CheckStandCell.h"

@implementation CheckStandCell
//重写initWithFrame:初始化方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview: self.backImageView];
        [self addSubview: self.MidTitleLabel];
        [self addSubview: self.TopTitleLabel];
        [self addSubview: self.leftBtn];
        [self addSubview: self.rightBtn];
         
         UIView * deleteView =[[UIView alloc]initWithFrame:WDH_CGRectMake(375, 0, 375, 155)];
         deleteView.backgroundColor = [UIColor whiteColor];
        [self addSubview: deleteView];
         [deleteView addSubview:self.TopBtn];
    }
    return self;
}


- (UIImageView *)backImageView
{
    if (!_backImageView) {
        CGRect frame = WDH_CGRectMake(22.5, 15, 330, 140);
        self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _backImageView.backgroundColor = [UIColor cyanColor];
        _backImageView.frame = frame;
    }
    return _backImageView;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        CGRect frame = WDH_CGRectMake(150, 100, 132, 25);
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _leftBtn.backgroundColor = [UIColor colorWithRed:32 / 255.0 green:178 / 255.0 blue:255 / 255.0 alpha:1];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftBtn.layer.cornerRadius = 2;
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.frame = frame;
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        CGRect frame = WDH_CGRectMake(290, 100, 30, 25);
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightBtn.frame = frame;
    }
    return _rightBtn;
}

- (UIButton *)TopBtn
{
     if (!_TopBtn) {
          CGRect frame = WDH_CGRectMake(0, 60, 50, 50);
          self.TopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
          [_TopBtn setBackgroundImage:[UIImage imageNamed:@"iOS删除"] forState:UIControlStateNormal];
          _TopBtn.frame = frame;
     }
     return _TopBtn;
}


- (UILabel *)MidTitleLabel {
    if (!_MidTitleLabel) {
        //        (60+15/2)/2
        CGRect frame = WDH_CGRectMake(155, 53, 150, 40);
        _MidTitleLabel = [[UILabel alloc]initWithFrame:frame];
        _MidTitleLabel.font = [UIFont systemFontOfSize:18];
        //        _MidTitleLabel.backgroundColor = [UIColor backGray];
    }
    return _MidTitleLabel;
}

- (UILabel *)TopTitleLabel {
    if (!_TopTitleLabel) {
        //        (60+15/2)/2
        CGRect frame = WDH_CGRectMake(0, 31, 325, 20);
        _TopTitleLabel = [[UILabel alloc]initWithFrame:frame];
        _TopTitleLabel.font = [UIFont systemFontOfSize:12];
        _TopTitleLabel.textAlignment = 2;
        _TopTitleLabel.textColor = [UIColor lightGrayColor];
        //        _MidTitleLabel.backgroundColor = [UIColor backGray];
    }
    return _TopTitleLabel;
}


@end
