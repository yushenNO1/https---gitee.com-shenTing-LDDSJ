//
//  ChooseProCell.m
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/15.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "ChooseProCell.h"

@implementation ChooseProCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
     if (self) {
          self.backgroundColor = [UIColor whiteColor];
          [self addSubview:self.DownLabel];
          [self addSubview:self.deleteBtn];
          [self addSubview:self.lightGrayLine];
     }
     return self;
}


- (UILabel *)DownLabel  {
     if (!_DownLabel)
     {
          _DownLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(40, 0, 200, 40)];
          _DownLabel.text = @"";
          _DownLabel.textColor = [UIColor colorWithRed:210 / 255.0 green:210 / 255.0 blue:210 / 255.0 alpha:1];
          _DownLabel.font = [UIFont systemFontOfSize:12* kScreenHeight1];
     }
     return _DownLabel;
}

- (UIButton *)deleteBtn  {
     if (!_deleteBtn)
     {
          _deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
          _deleteBtn.frame = WDH_CGRectMake(20, 14, 12, 12);
          [_deleteBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
     }
     return _deleteBtn;
}

- (UILabel *)lightGrayLine  {
     if (!_lightGrayLine)
     {
          _lightGrayLine =[[UILabel alloc]initWithFrame:WDH_CGRectMake(0, 40, 295, 1)];
          _lightGrayLine.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
     }
     return _lightGrayLine;
}

@end
