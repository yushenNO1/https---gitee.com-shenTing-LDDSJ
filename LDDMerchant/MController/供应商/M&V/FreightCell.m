//
//  FreightCell.m
//  供应商
//
//  Created by 张敬文 on 2017/7/27.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "FreightCell.h"

@implementation FreightCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.TopLabel];
        [self addSubview:self.LeftImageView];
        [self addSubview:self.DownLabel];
        [self addSubview:self.deleteBtn];
        [self addSubview:self.lightGrayLine];
    }
    return self;
}

- (UILabel *)TopLabel  {
    if (!_TopLabel)
    {
        
        _TopLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(45, 5, 300, 30)];
        _TopLabel.text = @"默认运费模板";
        _TopLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
        _TopLabel.font = [UIFont systemFontOfSize:15* kScreenHeight1];
    }
    return _TopLabel;
}

- (UIImageView *)LeftImageView  {
    if (!_LeftImageView)
    {
        _LeftImageView =[[UIImageView alloc]initWithFrame:WDH_CGRectMake(15, 20, 20, 20)];
        _LeftImageView.backgroundColor = [UIColor whiteColor];
    }
    return _LeftImageView;
}

- (UILabel *)DownLabel  {
    if (!_DownLabel)
    {
        _DownLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(45, 35, 300, 20)];
        _DownLabel.text = @"默认运费模板";
        _DownLabel.textColor = [UIColor colorWithRed:210 / 255.0 green:210 / 255.0 blue:210 / 255.0 alpha:1];
        _DownLabel.font = [UIFont systemFontOfSize:12* kScreenHeight1];
    }
    return _DownLabel;
}

- (UIButton *)deleteBtn  {
    if (!_deleteBtn)
    {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteBtn.frame = WDH_CGRectMake(330, 20, 20, 20);
         [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"运费编辑"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

- (UILabel *)lightGrayLine  {
    if (!_lightGrayLine)
    {
        _lightGrayLine =[[UILabel alloc]initWithFrame:WDH_CGRectMake(0, 60, 375, 1)];
        _lightGrayLine.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    }
    return _lightGrayLine;
}

@end
