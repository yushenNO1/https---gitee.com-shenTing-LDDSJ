//
//  SuppliersOverCell.m
//  供应商
//
//  Created by 张敬文 on 2017/8/4.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "SuppliersOverCell.h"

@implementation SuppliersOverCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.LeftImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.numLabel];
        [self addSubview:self.dateLabel];
        [self addSubview:self.saveLabel];
        [self addSubview:self.editBtn];
        [self addSubview:self.downBtn];
        [self addSubview:self.deleteBtn];
        [self addSubview:self.lightGrayLine];
        [self addSubview:self.lightGrayLabel];
    }
    return self;
}

- (UIImageView *)LeftImageView  {
    if (!_LeftImageView)
    {
        _LeftImageView =[[UIImageView alloc]initWithFrame:WDH_CGRectMake(10, 20, 90, 90)];
        _LeftImageView.backgroundColor = [UIColor whiteColor];
    }
    return _LeftImageView;
}

- (UILabel *)titleLabel  {
    if (!_titleLabel)
    {
        
        _titleLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(110, 20, 255, 20)];
        _titleLabel.text = @"[商品名称]商品名称";
        _titleLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:17* kScreenHeight1];
    }
    return _titleLabel;
}



- (UILabel *)priceLabel  {
    if (!_priceLabel)
    {
        _priceLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(110, 40, 255, 30)];
        _priceLabel.text = @"¥998";
        _priceLabel.textColor = [UIColor colorWithRed:251 / 255.0 green:44 / 255.0 blue:126 / 255.0 alpha:1];
        _priceLabel.font = [UIFont systemFontOfSize:20* kScreenHeight1];
    }
    return _priceLabel;
}

- (UILabel *)numLabel  {
    if (!_numLabel)
    {
        _numLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(110, 70, 255, 20)];
        _numLabel.text = @"销量";
        _numLabel.textColor = [UIColor colorWithRed:210 / 255.0 green:210 / 255.0 blue:210 / 255.0 alpha:1];
        _numLabel.font = [UIFont systemFontOfSize:12* kScreenHeight1];
    }
    return _numLabel;
}

- (UILabel *)dateLabel  {
    if (!_dateLabel)
    {
        _dateLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(210, 90, 155, 20)];
        _dateLabel.text = @"添加:2017-17-15";
        _dateLabel.textColor = [UIColor colorWithRed:210 / 255.0 green:210 / 255.0 blue:210 / 255.0 alpha:1];
        _dateLabel.font = [UIFont systemFontOfSize:12* kScreenHeight1];
    }
    return _dateLabel;
}

- (UILabel *)saveLabel  {
    if (!_saveLabel)
    {
        _saveLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(110, 90, 100, 20)];
        _saveLabel.text = @"库存";
        _saveLabel.textColor = [UIColor colorWithRed:210 / 255.0 green:210 / 255.0 blue:210 / 255.0 alpha:1];
        _saveLabel.font = [UIFont systemFontOfSize:12];
    }
    return _saveLabel;
}

- (UIButton *)deleteBtn  {
    if (!_deleteBtn)
    {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteBtn.frame = WDH_CGRectMake(375 / 3 * 2, 126, 375 / 3, 50);
         [_deleteBtn setTintColor:[UIColor blackColor]];
    }
    return _deleteBtn;
}

- (UIButton *)editBtn  {
    if (!_editBtn)
    {
        _editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _editBtn.frame = WDH_CGRectMake(0, 126, 375 / 3, 50);
         [_editBtn setTintColor:[UIColor blackColor]];
    }
    return _editBtn;
}

- (UIButton *)downBtn  {
    if (!_downBtn)
    {
        _downBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _downBtn.frame = WDH_CGRectMake(375 / 3, 126, 375 / 3, 50);
         [_downBtn setTintColor:[UIColor blackColor]];
    }
    return _downBtn;
}

- (UILabel *)lightGrayLine  {
    if (!_lightGrayLine)
    {
        _lightGrayLine =[[UILabel alloc]initWithFrame:WDH_CGRectMake(0, 125, 375, 1)];
        _lightGrayLine.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    }
    return _lightGrayLine;
}

- (UILabel *)lightGrayLabel  {
    if (!_lightGrayLabel)
    {
        _lightGrayLabel =[[UILabel alloc]initWithFrame:WDH_CGRectMake(0, 0, 375, 5)];
        _lightGrayLabel.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
    }
    return _lightGrayLabel;
}


@end
