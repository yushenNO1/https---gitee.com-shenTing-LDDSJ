//
//  OrderInfoCell.m
//  收银台
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "OrderInfoCell.h"

@implementation OrderInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.centerLabel];
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];;
        
        
    }
    return self;
}
- (UILabel *)centerLabel  {
    if (!_centerLabel)
    {
        _centerLabel =[[UILabel alloc]initWithFrame:WDH_CGRectMake(375 / 3 + 20, 0 , 375 / 3 - 40, 40)];
        _centerLabel.font =[UIFont systemFontOfSize:15];
        _centerLabel.textAlignment = 1;
    }
    return _centerLabel;
}

- (UILabel *)rightLabel  {
    if (!_rightLabel)
    {
        _rightLabel =[[UILabel alloc]initWithFrame:WDH_CGRectMake(375 / 3 * 2, 0 , 375 / 3, 40)];
        _rightLabel.textAlignment = 1;
        _rightLabel.font =[UIFont systemFontOfSize:15];
    }
    return _rightLabel;
}

- (UILabel *)leftLabel  {
    if (!_leftLabel)
    {
        _leftLabel =[[UILabel alloc]initWithFrame:WDH_CGRectMake(0, 0, 375 / 3, 40)];
        _leftLabel.textColor = [UIColor colorWithRed:130 / 255.0 green:130 / 255.0 blue:130 / 255.0 alpha:1];
        _leftLabel.textAlignment = 1;
        _leftLabel.font =[UIFont systemFontOfSize:15];
    }
    return _leftLabel;
}



@end
