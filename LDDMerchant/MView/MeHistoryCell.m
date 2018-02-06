//
//  MeHistoryCell.m
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "MeHistoryCell.h"
#import "NetURL.h"
@implementation MeHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubview:self.codeLabel];
        [self addSubview:self.dateLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.leftImage];
        [self addSubview:self.acciLabel];
        
    }
    return self;
}

-(UIImageView *)leftImage
{
    if (!_leftImage)
    {
        _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 * kScreenWidth1, 5 * kScreenHeight1, 60 * kScreenWidth1, 60 * kScreenHeight1)];
    }
    return _leftImage;
}

-(UILabel *)codeLabel
{
    if (!_codeLabel)
    {
        _codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80 * kScreenWidth1,5 * kScreenHeight1, 190 * kScreenWidth1, 20 * kScreenHeight1)];
        _codeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _codeLabel;
}

-(UILabel *)dateLabel
{
    if (!_dateLabel)
    {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(265 * kScreenWidth1,5 * kScreenHeight1, 100 * kScreenWidth1, 30 * kScreenHeight1)];
        _dateLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.textColor = [UIColor colorWithRed:218 / 255.0 green:68 / 255.0 blue:55 / 255.0 alpha:1];
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80 * kScreenWidth1,25 * kScreenHeight1, 190 * kScreenWidth1, 20 * kScreenHeight1)];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor lightGrayColor];
    }
    return _nameLabel;
}

-(UILabel *)priceLabel
{
    if (!_priceLabel)
    {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(80 * kScreenWidth1,45 * kScreenHeight1, 190 * kScreenWidth1, 20 * kScreenHeight1)];
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.textColor = [UIColor lightGrayColor];
    }
    return _priceLabel;
}

-(UILabel *)acciLabel
{
    if (!_acciLabel)
    {
        _acciLabel = [[UILabel alloc]initWithFrame:CGRectMake(265 * kScreenWidth1,35 * kScreenHeight1, 100 * kScreenWidth1, 30 * kScreenHeight1)];
        _acciLabel.font = [UIFont systemFontOfSize:13];
        _acciLabel.textColor = [UIColor colorWithRed:218 / 255.0 green:68 / 255.0 blue:55 / 255.0 alpha:1];
        _acciLabel.textAlignment = NSTextAlignmentRight;
    }
    return _acciLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
