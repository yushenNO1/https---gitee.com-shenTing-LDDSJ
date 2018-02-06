//
//  OrderDetailCell11.m
//  LDDMerchant
//
//  Created by 李宇廷 on 2018/1/27.
//  Copyright © 2018年 李宇廷. All rights reserved.
//

#import "OrderDetailCell11.h"

@implementation OrderDetailCell11
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backView];
        [self.backView addSubview:self.Btn];
        [self.backView addSubview:self.label];
     
        UILabel * lineLabel = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(0, 40, 375, 1)];
        lineLabel.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
        [self.backView addSubview:lineLabel];
        
        UILabel * colorLabel = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(0, 90, 375, 5)];
        colorLabel.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
        [self.backView addSubview:colorLabel];
    }
    return self;
}
- (UIView *)backView  {
    if (!_backView)
    {
        _backView = [[UIView alloc] initWithFrame:WDH_CGRectWidth(0, 0, 375, 95)];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIButton *)Btn  {
    if (!_Btn)
    {
        _Btn = [UIButton buttonWithType:UIButtonTypeSystem];
        _Btn.frame = WDH_CGRectWidth(280, 50, 80, 30);
        _Btn.layer.cornerRadius = 15;
        _Btn.layer.masksToBounds = YES;
        _Btn.layer.borderWidth = 1.0f;
        [_Btn setTitleColor:[UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1] forState:UIControlStateNormal];
        _Btn.layer.borderColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1].CGColor;
    }
    return _Btn;
}

- (UILabel *)label  {
    if (!_label)
    {
        _label = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(20, 0, 335, 50)];
        _label.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
        _label.text = @"¥98";
        _label.textAlignment = 2;
        _label.font = [UIFont systemFontOfSize:15];
    }
    return _label;
}
@end
