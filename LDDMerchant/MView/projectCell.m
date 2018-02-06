//
//  projectCell.m
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "projectCell.h"
#import "NetURL.h"

@implementation projectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubview:self.leftImage];
        [self addSubview:self.upBtn];
        [self addSubview:self.dateLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.editBtn];
        [self addSubview:self.downBtn];
        [self addSubview:self.deleBtn];
        [self addSubview:self.shareBtn];
    }
    return self;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * kScreenWidth1, 0, 200 * kScreenWidth1, 35 * kScreenHeight1)];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

-(UIImageView *)leftImage
{
    if (!_leftImage)
    {
        _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 * kScreenWidth1, 30 * kScreenHeight1, 80 * kScreenWidth1, 80 * kScreenHeight1)];
        _leftImage.image = [UIImage imageNamed:@"lxiagnce"];
    }
    return _leftImage;
}

-(UIButton *)shareBtn
{
    if (!_shareBtn)
    {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _shareBtn.frame = CGRectMake(100 * kScreenWidth1, 30 * kScreenHeight1, 20 * kScreenWidth1, 70 * kScreenHeight1);
        
    }
    return _shareBtn;
}

-(UILabel *)dateLabel
{
    if (!_dateLabel)
    {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(210 * kScreenWidth1, 0, 150 * kScreenWidth1, 35 * kScreenHeight1)];
        _dateLabel.font = [UIFont systemFontOfSize:13* kScreenWidth1];
        _dateLabel.textColor = [UIColor lightGrayColor];
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}

-(UIButton *)upBtn
{
    if (!_upBtn)
    {
        _upBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _upBtn.frame = CGRectMake(280 * kScreenWidth1, 30 * kScreenHeight1, 60 * kScreenWidth1, 25 * kScreenHeight1);
        _upBtn.layer.cornerRadius = 5;
        _upBtn.layer.masksToBounds = YES;
        _upBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
        [_upBtn setTitle:@"上线" forState:UIControlStateNormal];
        [_upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _upBtn;
}

-(UIButton *)editBtn
{
    if (!_editBtn)
    {
        _editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _editBtn.frame = CGRectMake(165 * kScreenWidth1, 30 * kScreenHeight1, 60 * kScreenWidth1, 25 * kScreenHeight1);
        _editBtn.layer.cornerRadius = 5;
        _editBtn.layer.masksToBounds = YES;
        _editBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    return _editBtn;
}

-(UIButton *)downBtn
{
    if (!_downBtn)
    {
        _downBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _downBtn.frame = CGRectMake(165 * kScreenWidth1, 75 * kScreenHeight1, 60 * kScreenWidth1, 25 * kScreenHeight1);
        _downBtn.layer.cornerRadius = 5;
        _downBtn.layer.masksToBounds = YES;
        _downBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
        [_downBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    return _downBtn;
}

-(UIButton *)deleBtn
{
    if (!_deleBtn)
    {
        _deleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleBtn.frame = CGRectMake(280 * kScreenWidth1, 75 * kScreenHeight1, 60 * kScreenWidth1, 25 * kScreenHeight1);
        _deleBtn.layer.cornerRadius = 5;
        _deleBtn.layer.masksToBounds = YES;
        _deleBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:85 / 255.0 blue:73 / 255.0 alpha:1];
        [_deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    return _deleBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
