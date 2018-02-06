//
//  GoodsTableViewCell.m
//  YSApp
//
//  Created by 王松松 on 2016/11/16.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "GoodsTableViewCell.h"
#import "NetURL.h"

@implementation GoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.centerLabel];
        [self addSubview:self.leftLabel];
        [self addSubview:self.leftImgBut];
        [self addSubview:self.num_tf];
        [self addSubview:self.deleteBtn];
        [self addSubview:self.addBtn];
        [self addSubview:self.clearBtn];
        [self addSubview:self.clearBtn1];

    }
    return self;
}
- (UILabel *)centerLabel  {
    if (!_centerLabel)
    {
        _centerLabel =[[UILabel alloc]initWithFrame:CGRectMake(160 * kScreenWidth1, 0 , 70 * kScreenWidth1, 44 * kScreenHeight1)];
        _centerLabel.textAlignment =NSTextAlignmentLeft;
        _centerLabel.font =[UIFont systemFontOfSize:16*kScreenWidth1];
    }
    return _centerLabel;
}

- (UILabel *)leftLabel  {
    if (!_leftLabel)
    {
        _leftLabel =[[UILabel alloc]initWithFrame:CGRectMake(40 * kScreenWidth1, 0, 110 * kScreenWidth1, 44 * kScreenHeight1)];
        _leftLabel.textAlignment =NSTextAlignmentLeft;
        _leftLabel.font =[UIFont systemFontOfSize:16*kScreenWidth1];
    }
    return _leftLabel;
}

-(UIButton *)clearBtn1
{
    if (!_clearBtn1)    {
        _clearBtn1 =[UIButton buttonWithType:UIButtonTypeCustom];
        _clearBtn1.frame = CGRectMake(10* kScreenWidth1, 0*kScreenHeight1, 44*kScreenHeight1, 44*kScreenHeight1);
        _clearBtn1.backgroundColor = [UIColor clearColor];
    }
    return _clearBtn1;
}
-(UIButton *)leftImgBut
{
    if (!_leftImgBut)    {
        _leftImgBut =[UIButton buttonWithType:UIButtonTypeCustom];
        _leftImgBut.frame =CGRectMake(10* kScreenWidth1, 9*kScreenHeight1, 25*kScreenHeight1, 25*kScreenHeight1);
        [_leftImgBut setBackgroundImage:[UIImage imageNamed:@"yuan@3x"] forState:UIControlStateNormal];
        }
    return _leftImgBut;
}


-(UIButton *)clearBtn
{
    if (!_clearBtn)    {
        _clearBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _clearBtn.frame = CGRectMake(270*kScreenWidth1, 7*kScreenHeight1, 30*kScreenWidth1, 30*kScreenHeight1);
        _clearBtn.backgroundColor = [UIColor clearColor];
        }
    return _clearBtn;
}

- (UITextField *)num_tf
{
    if (!_num_tf) {
        _num_tf = [[UITextField alloc]initWithFrame:CGRectMake(270*kScreenWidth1 , 7*kScreenHeight1, 30*kScreenWidth1 , 30*kScreenHeight1)];
        _num_tf.text = @"1";
        _num_tf.delegate = self;
        _num_tf.textAlignment = NSTextAlignmentCenter;
        _num_tf.borderStyle =UITextBorderStyleRoundedRect;
        _num_tf.userInteractionEnabled = NO;
    }
    return _num_tf;
}

-(UIButton *)deleteBtn
{
    if (!_deleteBtn)    {
        _deleteBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame =CGRectMake(240*kScreenWidth1, 7*kScreenHeight1, 30*kScreenWidth1, 30*kScreenHeight1);
        _deleteBtn.backgroundColor =[UIColor brownColor];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"productDetail_delete_enabled@2x"] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"productDetail_delete_enabled@2x"] forState:UIControlStateDisabled];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"productDetail_delete_enabled@2x"] forState:UIControlStateHighlighted];
    }
    return _deleteBtn;
}

-(UIButton *)addBtn
{
    if (!_addBtn)    {
        _addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(300*kScreenWidth1, 7*kScreenHeight1, 30*kScreenWidth1, 30*kScreenHeight1);
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"productDetail_add_enabled@2x"] forState:UIControlStateNormal];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"productDetail_add_enabled@2x"] forState:UIControlStateDisabled];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"productDetail_add_enabled@2x"] forState:UIControlStateHighlighted];
    }
    return _addBtn;
}

@end
