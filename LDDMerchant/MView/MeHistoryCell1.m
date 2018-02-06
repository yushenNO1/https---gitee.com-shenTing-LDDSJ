//
//  MeHistoryCell1.m
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "MeHistoryCell1.h"
#import "NetURL.h"
@implementation MeHistoryCell1

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
        [self addSubview:self.numLabel];
        [self addSubview:self.dateLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.priceLabel];
    }
    return self;
}

-(UIImageView *)leftImage
{
    if (!_leftImage)
    {
        _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 * kScreenWidth1, 5 * kScreenHeight1, 60 * kScreenWidth1, 60 * kScreenHeight1)];
    }
    return _leftImage;
}

-(UILabel *)numLabel
{
    if (!_numLabel)
    {
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * kScreenWidth1,45 * kScreenHeight1, 330 * kScreenWidth1, 20 * kScreenHeight1)];
        _numLabel.font = [UIFont systemFontOfSize:14];
        _numLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numLabel;
}

-(UILabel *)dateLabel
{
    if (!_dateLabel)
    {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(80 * kScreenWidth1,45 * kScreenHeight1, 150 * kScreenWidth1, 20 * kScreenHeight1)];
        _dateLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.textColor = [UIColor lightGrayColor];
        
    }
    return _dateLabel;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80 * kScreenWidth1, 5 * kScreenHeight1, 250 * kScreenWidth1, 20 * kScreenHeight1)];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor lightGrayColor];
    }
    return _nameLabel;
}

-(UILabel *)priceLabel
{
    if (!_priceLabel)
    {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(80 * kScreenWidth1,25 * kScreenHeight1, 250 * kScreenWidth1, 20 * kScreenHeight1)];
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.textColor = [UIColor lightGrayColor];
    }
    return _priceLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
