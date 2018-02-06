//
//  LYTPurchaseCell.m
//  满意
//
//  Created by 云盛科技 on 2017/5/25.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "LYTPurchaseCell.h"

@implementation LYTPurchaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.yuanBtn];
        [self addSubview:self.yuanImgView];
        [self addSubview:self.imgView];
        [self addSubview:self.completeStateView];
        [self addSubview:self.editStateView];
        [self addSubview:self.changeBtn];
    }
    return self;
}
-(UIButton *)yuanBtn{
    if (!_yuanBtn) {
        _yuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _yuanBtn.frame = CGRectMake(0, 0, 40*kScreenWidth1, 100*kScreenHeight1);
        
    }
    return _yuanBtn;
}
-(UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.frame = CGRectMake(295*kScreenWidth1, 5*kScreenHeight1, 70*kScreenWidth1, 20*kScreenHeight1);
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:13*kScreenHeight1];
        [_changeBtn setTitleColor:[UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1] forState:UIControlStateNormal];
    }
    return _changeBtn;
}

-(UIImageView *)yuanImgView{
    if (!_yuanImgView) {
        _yuanImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 42*kScreenHeight1, 16, 16)];
    }
    return _yuanImgView;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(35*kScreenWidth1, 15*kScreenHeight1, 70, 70)];
    }
    return _imgView;
}


//完成更状态
-(UIView *)completeStateView{
    if (!_completeStateView) {
        _completeStateView = [[UIView alloc]initWithFrame:CGRectMake(110*kScreenWidth1, 0, 265*kScreenWidth1, 100*kScreenHeight1)];
        _completeStateView.hidden = YES;
        [_completeStateView addSubview:self.titleLabel];
        [_completeStateView addSubview:self.contentLabel];
        [_completeStateView addSubview:self.moneyLabel];
        [_completeStateView addSubview:self.countLabel];
    }
    return _completeStateView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 30*kScreenHeight1, self.bounds.size.width-150*kScreenWidth1, 20*kScreenHeight1)];
        _titleLabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
        _titleLabel.textColor = [UIColor blackColor];
        
    }
    return _titleLabel;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 50*kScreenHeight1, self.frame.size.width-150*kScreenWidth1, 20*kScreenHeight1)];
        _contentLabel.font = [UIFont systemFontOfSize:12*kScreenHeight1];
        _contentLabel.textColor = [UIColor colorWithRed:118/255.0 green:118/255.0 blue:118/255.0 alpha:1];
        
    }
    return _contentLabel;
}
-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*kScreenWidth1, 70*kScreenHeight1, self.frame.size.width-150*kScreenWidth1, 20*kScreenHeight1)];
        _moneyLabel.font = [UIFont systemFontOfSize:12*kScreenHeight1];
        _moneyLabel.textColor = [UIColor colorWithRed:239/255.0 green:37/255.0 blue:71/255.0 alpha:1];
        
    }
    return _moneyLabel;
}
-(UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(_completeStateView.frame.size.width-150*kScreenWidth1, 70*kScreenHeight1, 140*kScreenWidth1, 20*kScreenHeight1)];
        _countLabel.font = [UIFont systemFontOfSize:14*kScreenHeight1];
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}





//编辑更状态
-(UIView *)editStateView{
    if (!_editStateView) {
        _editStateView = [[UIView alloc]initWithFrame:CGRectMake(110*kScreenWidth1, 0, 265*kScreenWidth1, 100*kScreenHeight1)];
        _editStateView.hidden = YES;
        [_editStateView addSubview:self.jiaBtn];
        [_editStateView addSubview:self.jianBtn];
        [_editStateView addSubview:self.deleteBtn];
        [_editStateView addSubview:self.countTextFiled];
    }
    return _editStateView;
}


-(UIButton *)jiaBtn{
    if (!_jiaBtn) {
        _jiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jiaBtn.frame = CGRectMake(_editStateView.frame.size.width-120*kScreenWidth1, 35*kScreenHeight1, 40, 40);
        [_jiaBtn setTitle:@"+" forState:UIControlStateNormal];
        [_jiaBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _jiaBtn.layer.borderColor = [[UIColor grayColor]CGColor];
        _jiaBtn.layer.borderWidth = 1.0;
    }
    return _jiaBtn;
}
-(UIButton *)jianBtn{
    if (!_jianBtn) {
        _jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jianBtn.frame = CGRectMake(10*kScreenWidth1, 35*kScreenHeight1, 40, 40);
        [_jianBtn setTitle:@"-" forState:UIControlStateNormal];
        [_jianBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _jianBtn.layer.borderColor = [[UIColor grayColor]CGColor];
        _jianBtn.layer.borderWidth = 1.0;
    }
    return _jianBtn;
}
-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(_editStateView.frame.size.width-80*kScreenWidth1, 35*kScreenHeight1, 80*kScreenWidth1, 40*kScreenHeight1);
        _deleteBtn.backgroundColor = [UIColor redColor];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];

    }
    return _deleteBtn;
}
-(UITextField *)countTextFiled{
    if (!_countTextFiled) {
        _countTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(50*kScreenWidth1, 35*kScreenHeight1, _editStateView.frame.size.width-170, 40)];
         _countTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _countTextFiled.layer.borderWidth = 1.0;
        _countTextFiled.layer.borderColor = [[UIColor grayColor]CGColor];
        _countTextFiled.textAlignment = NSTextAlignmentCenter;
        
    }
    return _countTextFiled;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
