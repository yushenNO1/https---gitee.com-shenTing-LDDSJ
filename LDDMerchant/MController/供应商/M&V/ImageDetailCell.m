//
//  ImageDetailCell.m
//  供应商
//
//  Created by 张敬文 on 2017/8/1.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "ImageDetailCell.h"

@implementation ImageDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.addImageView];
        [self addSubview:self.deleteBtn];
        [self addSubview:self.addBtn];
        [self addSubview:self.moveBtn];
    }
    return self;
}

- (UIImageView *)addImageView  {
    if (!_addImageView)
    {
        self.addImageView = [[UIImageView alloc]initWithFrame:WDH_CGRectMake(15, 10, 345, 157)];
        _addImageView.layer.borderColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1].CGColor;
        _addImageView.layer.borderWidth = 1.0f;
    }
    return _addImageView;
}

- (UIButton *)deleteBtn  {
    if (!_deleteBtn)
    {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteBtn.frame = WDH_CGRectMake(310, 167, 50, 23);
         [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除2"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

- (UIButton *)addBtn  {
    if (!_addBtn)
    {
        _addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _addBtn.frame = WDH_CGRectMake(260, 167, 50, 23);
         [_addBtn setBackgroundImage:[UIImage imageNamed:@"插入"] forState:UIControlStateNormal];
    }
    return _addBtn;
}

- (UIButton *)moveBtn  {
    if (!_moveBtn)
    {
        _moveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _moveBtn.frame = WDH_CGRectMake(210, 167, 50, 23);
         [_moveBtn setBackgroundImage:[UIImage imageNamed:@"上移"] forState:UIControlStateNormal];
    }
    return _moveBtn;
}

@end
