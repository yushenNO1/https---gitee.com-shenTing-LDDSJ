//
//  ScanAddeleteCell.m
//  收银台
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "ScanAddeleteCell.h"

@implementation ScanAddeleteCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.centerLabel];
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];;
        [self addSubview:self.deleteBtn];
        [self addSubview:self.addBtn];

        
    }
    return self;
}
- (UILabel *)centerLabel  {
    if (!_centerLabel)
    {
        _centerLabel =[[UILabel alloc]initWithFrame:CGRectMake(375 / 3 + 37.5, 0 , 50, 40)];
        _centerLabel.textAlignment =1;
        _centerLabel.font =[UIFont systemFontOfSize:15];
    }
    return _centerLabel;
}

- (UILabel *)rightLabel  {
    if (!_rightLabel)
    {
        _rightLabel =[[UILabel alloc]initWithFrame:CGRectMake(375 / 3 * 2, 0 , 375 / 3, 40)];
        _rightLabel.textAlignment =1;
        _rightLabel.font =[UIFont systemFontOfSize:15];
    }
    return _rightLabel;
}

- (UILabel *)leftLabel  {
    if (!_leftLabel)
    {
        _leftLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 375 / 3, 40)];
        _leftLabel.textAlignment =1;
        _leftLabel.textColor = [UIColor colorWithRed:130 / 255.0 green:130 / 255.0 blue:130 / 255.0 alpha:1];
        _leftLabel.font =[UIFont systemFontOfSize:15];
    }
    return _leftLabel;
}


-(UIButton *)deleteBtn
{
    if (!_deleteBtn)    {
        _deleteBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame =CGRectMake(375 / 3 + 17.5, 10, 20, 20);
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"减去_light"] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"减去_light"] forState:UIControlStateDisabled];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"减去_light"] forState:UIControlStateHighlighted];
    }
    return _deleteBtn;
}

-(UIButton *)addBtn
{
    if (!_addBtn)    {
        _addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(375 / 3 + 87.5, 10, 20, 20);
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"添加icon"] forState:UIControlStateNormal];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"添加icon"] forState:UIControlStateDisabled];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"添加icon"] forState:UIControlStateHighlighted];
    }
    return _addBtn;
}


@end
