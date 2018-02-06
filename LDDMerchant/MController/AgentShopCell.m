//
//  AgentShopCell.m
//  WDHMerchant
//
//  Created by 李宇廷 on 2018/1/22.
//  Copyright © 2018年 Zjw. All rights reserved.
//

#import "AgentShopCell.h"

@implementation AgentShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
     if (self) {
          self.backgroundColor =[UIColor whiteColor];
          [self addSubview:self.centerLabel];
          [self addSubview:self.leftLabel];
          [self addSubview:self.rightBtn];;
          
          
     }
     return self;
}

- (UIButton *)rightBtn  {
     if (!_rightBtn)
     {
          _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
          _rightBtn.frame = WDH_CGRectMake(375-90, 10 , 80, 20);
          _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
          [_rightBtn setTitle:@"待审核" forState:UIControlStateNormal];
          [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
          _rightBtn.layer.borderColor = [[UIColor grayColor]CGColor];
          _rightBtn.layer.borderWidth = 1.0f;
     }
     return _rightBtn;
}


- (UILabel *)centerLabel  {
     if (!_centerLabel)
     {
          _centerLabel =[[UILabel alloc]initWithFrame:WDH_CGRectMake(375/2-50, 10 , 100, 20)];
          _centerLabel.font =[UIFont systemFontOfSize:12];
          _centerLabel.text = @"152225700234";
          _centerLabel.textAlignment = 1;
     }
     return _centerLabel;
}


- (UILabel *)leftLabel  {
     if (!_leftLabel)
     {
          _leftLabel =[[UILabel alloc]initWithFrame:WDH_CGRectMake(5, 10, 100, 20)];
          _leftLabel.textColor = [UIColor colorWithRed:130 / 255.0 green:130 / 255.0 blue:130 / 255.0 alpha:1];
          _leftLabel.textAlignment = 1;
          _leftLabel.text = @"sdsdasdasda";
          _leftLabel.font =[UIFont systemFontOfSize:15];
     }
     return _leftLabel;
}
@end
