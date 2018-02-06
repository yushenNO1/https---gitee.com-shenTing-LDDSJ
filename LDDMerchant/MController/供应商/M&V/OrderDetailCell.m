//
//  OrderDetailCell.m
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/11.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
     if (self) {
          self.backgroundColor = [UIColor whiteColor];
          [self addSubview:self.backView];
          [self addSubview:self.ImageView];
          [self addSubview:self.TopLabel];
          [self addSubview:self.priceLabel];
          [self addSubview:self.numLabel];
          [self addSubview:self.colorLabel];
          [self addSubview:self.descripeLabel];
     }
     return self;
}

- (UIImageView *)ImageView  {
     if (!_ImageView)
     {
          self.ImageView = [[UIImageView alloc]initWithFrame:WDH_CGRectMake(15, 10, 80, 80)];
     }
     return _ImageView;
}

- (UIView *)backView  {
     if (!_backView)
     {
          self.backView = [[UIView alloc] initWithFrame:WDH_CGRectMake(-1, 0, 377, 100)];
          _backView.layer.borderColor = [UIColor whiteColor].CGColor;
          _backView.layer.borderWidth = 1.0f;
          _backView.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
     }
     return _backView;
}

- (UILabel *)TopLabel  {
     if (!_TopLabel)
     {
          self.TopLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(105, 10, 200, 30)];
          _TopLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
          _TopLabel.text = @"零食零食零食";
          _TopLabel.font = [UIFont systemFontOfSize:14* kScreenHeight1];
     }
     return _TopLabel;
}

- (UILabel *)priceLabel  {
     if (!_priceLabel)
     {
          self.priceLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(255, 50, 100, 20)];
          _priceLabel.textColor = [UIColor colorWithRed:250 / 255.0 green:41 / 255.0 blue:101 / 255.0 alpha:1];
          _priceLabel.text = @"¥98";
          _priceLabel.textAlignment = 2;
          _priceLabel.font = [UIFont systemFontOfSize:13* kScreenHeight1];
     }
     return _priceLabel;
}

- (UILabel *)numLabel  {
     if (!_numLabel)
     {
          self.numLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(255, 70, 100, 20)];
          _numLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
          _numLabel.text = @"数量:1";
          _numLabel.textAlignment = 2;
          _numLabel.font = [UIFont systemFontOfSize:12* kScreenHeight1];
     }
     return _numLabel;
}

- (UILabel *)descripeLabel  {
     if (!_descripeLabel)
     {
          self.descripeLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(105, 40, 200, 25)];
          _descripeLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
          _descripeLabel.text = @"零食零食";
          _descripeLabel.font = [UIFont systemFontOfSize:14* kScreenHeight1];
     }
     return _descripeLabel;
}

- (UILabel *)colorLabel  {
     if (!_colorLabel)
     {
          self.colorLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(105, 65, 200, 25)];
          _colorLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
          _colorLabel.text = @"颜色:白色";
          _colorLabel.font = [UIFont systemFontOfSize:12* kScreenHeight1];
     }
     return _colorLabel;
}



@end
