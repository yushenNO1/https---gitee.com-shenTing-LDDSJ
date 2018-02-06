//
//  FreightEditCell.m
//  供应商
//
//  Created by 张敬文 on 2017/7/28.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "FreightEditCell.h"

@implementation FreightEditCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
        
        UILabel * tbackLabel_3 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 151, 375, 5)];
        tbackLabel_3.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
        [self addSubview:tbackLabel_3];
        
        UILabel * backLabel_2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 0, 375, 50)];
        backLabel_2.backgroundColor = [UIColor whiteColor];
        [self addSubview:backLabel_2];
        
        UILabel * dbackLabel_2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 51, 375, 100)];
        dbackLabel_2.backgroundColor = [UIColor whiteColor];
        [self addSubview:dbackLabel_2];
        
        UILabel * OneLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(70, 10 + 51, 50, 30)];
        OneLabel.text = @"件内";
        OneLabel.textAlignment = 1;
        OneLabel.textColor = [UIColor colorWithRed:170 / 255.0 green:170 / 255.0 blue:170 / 255.0 alpha:1];
        [self addSubview:OneLabel];
        
        UILabel * TwoLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(170, 10 + 51, 35, 30)];
        TwoLabel.text = @"元";
        TwoLabel.textAlignment = 1;
        TwoLabel.textColor = [UIColor colorWithRed:170 / 255.0 green:170 / 255.0 blue:170 / 255.0 alpha:1];
        [self addSubview:TwoLabel];
        
        UILabel * ThreeLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(20, 0 + 112, 60, 30)];
        ThreeLabel.text = @"每增加";
        ThreeLabel.textAlignment = 1;
        ThreeLabel.textColor = [UIColor colorWithRed:170 / 255.0 green:170 / 255.0 blue:170 / 255.0 alpha:1];
        [self addSubview:ThreeLabel];

        UILabel * FourLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(130, 0 + 112, 110, 30)];
        FourLabel.text = @"件, 运费增加";
        FourLabel.textAlignment = 1;
        FourLabel.textColor = [UIColor colorWithRed:170 / 255.0 green:170 / 255.0 blue:170 / 255.0 alpha:1];
        [self addSubview:FourLabel];
        
        UILabel * FiveLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(290, 0 + 112, 35, 30)];
        FiveLabel.text = @"元";
        FiveLabel.textAlignment = 1;
        FiveLabel.textColor = [UIColor colorWithRed:170 / 255.0 green:170 / 255.0 blue:170 / 255.0 alpha:1];
        [self addSubview:FiveLabel];
        
        [self addSubview:self.proLabel_2];
        [self addSubview:self.OneTf];
        [self addSubview:self.TwoTf];
        [self addSubview:self.ThreeTf];
        [self addSubview:self.FourTf];
         [self addSubview:self.proBtn];
    }
    return self;
}

- (UILabel *)proLabel_2  {
    if (!_proLabel_2)
    {
        _proLabel_2 = [[UILabel alloc] initWithFrame:WDH_CGRectMake(20, 0, 300, 50)];
        _proLabel_2.text = @"选择地区";
        _proLabel_2.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
    }
    return _proLabel_2;
}

- (UIButton *)proBtn  {
     if (!_proBtn)
     {
          _proBtn = [UIButton buttonWithType:UIButtonTypeSystem];
          _proBtn.frame = WDH_CGRectMake(20, 0, 300, 50);
          _proBtn.backgroundColor = [UIColor clearColor];
     }
     return _proBtn;
}

- (UITextField *)OneTf  {
    if (!_OneTf)
    {
        _OneTf = [[UITextField alloc] initWithFrame:WDH_CGRectMake(20, 10 + 51, 50, 30)];
        _OneTf.layer.borderWidth = 1.0f;
        _OneTf.layer.borderColor = [UIColor colorWithRed:170 / 255.0 green:170 / 255.0 blue:170 / 255.0 alpha:1].CGColor;
        _OneTf.textAlignment = 1;
    }
    return _OneTf;
}

- (UITextField *)TwoTf  {
    if (!_TwoTf)
    {
        _TwoTf = [[UITextField alloc] initWithFrame:WDH_CGRectMake(120, 10 + 51, 50, 30)];
        _TwoTf.layer.borderWidth = 1.0f;
        _TwoTf.layer.borderColor = [UIColor colorWithRed:170 / 255.0 green:170 / 255.0 blue:170 / 255.0 alpha:1].CGColor;
        _TwoTf.textAlignment = 1;
    }
    return _TwoTf;
}

- (UITextField *)ThreeTf  {
    if (!_ThreeTf)
    {
        _ThreeTf = [[UITextField alloc] initWithFrame:WDH_CGRectMake(80, 0 + 112, 50, 30)];
        _ThreeTf.layer.borderWidth = 1.0f;
        _ThreeTf.layer.borderColor = [UIColor colorWithRed:170 / 255.0 green:170 / 255.0 blue:170 / 255.0 alpha:1].CGColor;
        _ThreeTf.textAlignment = 1;
    }
    return _ThreeTf;
}

- (UITextField *)FourTf  {
    if (!_FourTf)
    {
        _FourTf = [[UITextField alloc] initWithFrame:WDH_CGRectMake(240, 0 + 112, 50, 30)];
        _FourTf.layer.borderWidth = 1.0f;
        _FourTf.layer.borderColor = [UIColor colorWithRed:170 / 255.0 green:170 / 255.0 blue:170 / 255.0 alpha:1].CGColor;
        _FourTf.textAlignment = 1;
    }
    return _FourTf;
}

@end
