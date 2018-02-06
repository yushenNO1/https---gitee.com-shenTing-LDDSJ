//
//  LYTRefundCell.m
//  WDHMerchant
//
//  Created by 李宇廷 on 2018/1/24.
//  Copyright © 2018年 Zjw. All rights reserved.
//

#import "LYTRefundCell.h"

@implementation LYTRefundCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
     if (self) {
          self.backgroundColor = [UIColor whiteColor];
          [self addSubview:self.orderLabel];
          [self addSubview:self.timeLabel];
          [self addSubview:self.stateBtn];
          [self addSubview:self.stateLable];
     }
     return self;
}

- (UILabel *)orderLabel  {
     if (!_orderLabel)
     {
          _orderLabel = [[UILabel alloc] initWithFrame:WDH_CGRectMake(10, 10, 300, 20)];
          _orderLabel.text = @"订单";
          _orderLabel.textColor = [UIColor blackColor];
          _orderLabel.font = [UIFont systemFontOfSize:14];
     }
     return _orderLabel;
}


- (UILabel *)stateLable  {
     if (!_stateLable)
     {
          _stateLable = [[UILabel alloc] initWithFrame:WDH_CGRectMake(10, 35, 300, 20)];
          _stateLable.text = @"用户状态";
          _stateLable.textColor = [UIColor grayColor];
          _stateLable.font = [UIFont systemFontOfSize:12];
     }
     return _stateLable;
}

- (UIButton *)stateBtn  {
     if (!_stateBtn)
     {
          _stateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
          _stateBtn.frame = CGRectMake(kScreenWidth - 130, 90, 120, 20);
          [_stateBtn setTitle:@"待审核" forState:UIControlStateNormal];
          [_stateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          _stateBtn.layer.borderColor = [[UIColor colorWithRed:207/255.0 green:103/255.0 blue:101/255.0 alpha:1]CGColor];
          _stateBtn.layer.borderWidth = 1.0f;
     }
     return _stateBtn;
}

- (UILabel *)timeLabel  {
     if (!_timeLabel)
     {
          _timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 150, 65, 140, 20)];
          _timeLabel.font = [UIFont systemFontOfSize:10];
          _timeLabel.textAlignment = NSTextAlignmentRight;
     }
     return _timeLabel;
}

@end
