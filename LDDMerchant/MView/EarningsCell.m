//
//  EarningsCell.m
//  YSApp
//
//  Created by 王松松 on 2016/11/10.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#define kScreenWidth1  ([UIScreen mainScreen].bounds.size.width / 375)
#define kScreenHeight1  ([UIScreen mainScreen].bounds.size.height / 667)
#import "EarningsCell.h"

@implementation EarningsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.dateLabel];
    }
    return self;
}
-(UILabel *)leftLabel
{
    if (!_leftLabel)
    {
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 * kScreenWidth1, 10 * kScreenHeight1, 375 / 3 * kScreenWidth1, 40 * kScreenHeight1)];
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}
-(UILabel *)rightLabel
{
    if (!_rightLabel)
    {
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(375 / 3 * kScreenWidth1, 10 * kScreenHeight1, 375 / 3 * kScreenWidth1, 40 * kScreenHeight1)];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.font = [UIFont systemFontOfSize:15];
    }
    return _rightLabel;
}
-(UILabel *)dateLabel {
    if (!_dateLabel)
    {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(375 / 3 * 2 * kScreenWidth1, 10 * kScreenHeight1, 375 / 3 * kScreenWidth1, 40 * kScreenHeight1)];
        _dateLabel.textColor = [UIColor colorWithRed:218 / 255.0 green:68 / 255.0 blue:55 / 255.0 alpha:1];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:15];
    }
    return _dateLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
