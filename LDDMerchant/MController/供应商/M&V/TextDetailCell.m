//
//  TextDetailCell.m
//  供应商
//
//  Created by 张敬文 on 2017/8/1.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "TextDetailCell.h"

@implementation TextDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.Tf];
        [self addSubview:self.deleteBtn];
        [self addSubview:self.moveBtn];
    }
    return self;
}

- (CloverText *)Tf  {
    if (!_Tf)
    {
        self.Tf = [[CloverText alloc]initWithFrame:WDH_CGRectMake(15, 10, 345, 100) placeholder:@"请填写内容"];
        _Tf.font = [UIFont systemFontOfSize:15* kScreenHeight1];
        _Tf.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
        _Tf.layer.borderWidth = 1.0f;
    }
    return _Tf;
}

- (UIButton *)deleteBtn  {
    if (!_deleteBtn)
    {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteBtn.frame = WDH_CGRectMake(310, 110, 50, 22);
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除2"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

- (UIButton *)moveBtn  {
    if (!_moveBtn)
    {
        _moveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _moveBtn.frame = WDH_CGRectMake(260, 110, 50, 22);
         [_moveBtn setBackgroundImage:[UIImage imageNamed:@"上移"] forState:UIControlStateNormal];
    }
    return _moveBtn;
}


@end
