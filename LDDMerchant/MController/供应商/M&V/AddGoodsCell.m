//
//  AddGoodsCell.m
//  供应商
//
//  Created by 张敬文 on 2017/7/31.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "AddGoodsCell.h"

@implementation AddGoodsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
        
        UILabel * tbackLabel_3 = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(10, 0, 355, 50)];
        tbackLabel_3.backgroundColor = [UIColor whiteColor];
        tbackLabel_3.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
        tbackLabel_3.layer.borderWidth = 1.0f;
        [self addSubview:tbackLabel_3];
        
        UILabel * tbackLabel_2 = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(10, 55, 355, 50)];
        tbackLabel_2.backgroundColor = [UIColor whiteColor];
        tbackLabel_2.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
        tbackLabel_2.layer.borderWidth = 1.0f;
        [self addSubview:tbackLabel_2];
        
        UILabel * tbackLabel_1 = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(10, 110, 355, 50)];
        tbackLabel_1.backgroundColor = [UIColor whiteColor];
        tbackLabel_1.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
        tbackLabel_1.layer.borderWidth = 1.0f;
        [self addSubview:tbackLabel_1];
         
         UILabel * tbackLabel = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(10, 165, 355, 50)];
         tbackLabel.backgroundColor = [UIColor whiteColor];
         tbackLabel.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
         tbackLabel.layer.borderWidth = 1.0f;
         [self addSubview:tbackLabel];

        UILabel * backLabel_3 = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(10, 0, 60, 50)];
        backLabel_3.text = @"规格";
        backLabel_3.textAlignment = 1;
        backLabel_3.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
        [self addSubview:backLabel_3];
        
        UILabel * backLabel_2 = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(10, 55, 60, 50)];
        backLabel_2.text = @"价格";
        backLabel_2.textAlignment = 1;
        backLabel_2.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
        [self addSubview:backLabel_2];
        
        UILabel * backLabel_1 = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(10, 110, 60, 50)];
        backLabel_1.text = @"库存";
        backLabel_1.textAlignment = 1;
        backLabel_1.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
        [self addSubview:backLabel_1];
         
         UILabel * backLabel = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(10, 165, 60, 50)];
         backLabel.text = @"成本";
         backLabel.textAlignment = 1;
         backLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
         [self addSubview:backLabel];
        
        UILabel * lineLabel_3 = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(70, 10, 1, 30)];
        lineLabel_3.backgroundColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1];
        [self addSubview:lineLabel_3];
        
        UILabel * lineLabel_2 = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(70, 65, 1, 30)];
        lineLabel_2.backgroundColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1];
        [self addSubview:lineLabel_2];
        
        UILabel * lineLabel_1 = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(70, 120, 1, 30)];
        lineLabel_1.backgroundColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1];
        [self addSubview:lineLabel_1];
         
         UILabel * lineLabel = [[UILabel alloc] initWithFrame:WDH_CGRectWidth(70, 175, 1, 30)];
         lineLabel.backgroundColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1];
         [self addSubview:lineLabel];
        
        
        [self addSubview:self.OneTf];
        [self addSubview:self.TwoTf];
        [self addSubview:self.ThreeTf];
         [self addSubview:self.FourTf];

    }
    return self;
}


- (UITextField *)OneTf  {
    if (!_OneTf)
    {
        _OneTf = [[UITextField alloc] initWithFrame:CGRectMake(81, 0, 280, 50)];
        _OneTf.placeholder = @"请填写商品规格";
    }
    return _OneTf;
}

- (UITextField *)TwoTf  {
    if (!_TwoTf)
    {
        _TwoTf = [[UITextField alloc] initWithFrame:CGRectMake(81, 55, 280, 50)];
        _TwoTf.placeholder = @"请填写商品价格";
    }
    return _TwoTf;
}

- (UITextField *)ThreeTf  {
    if (!_ThreeTf)
    {
        _ThreeTf = [[UITextField alloc] initWithFrame:CGRectMake(81, 110, 280, 50)];
        _ThreeTf.placeholder = @"请填写商品库存";
    }
    return _ThreeTf;
}

- (UITextField *)FourTf  {
     if (!_FourTf)
     {
          _FourTf = [[UITextField alloc] initWithFrame:CGRectMake(81, 165, 280, 50)];
          _FourTf.placeholder = @"请填写商品成本";
     }
     return _FourTf;
}


@end
