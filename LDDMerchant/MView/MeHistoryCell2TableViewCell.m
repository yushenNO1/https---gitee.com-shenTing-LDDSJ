//
//  MeHistoryCell2TableViewCell.m
//  YSApp
//
//  Created by 张敬文 on 2017/1/9.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "MeHistoryCell2TableViewCell.h"
#import "NetURL.h"
@implementation MeHistoryCell2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

        [self addSubview:self.dateLabel];
        [self addSubview:self.numLabel];
    }
    return self;
}

-(UILabel *)numLabel
{
    if (!_numLabel)
    {
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * kScreenWidth1,10 * kScreenHeight1, 330 * kScreenWidth1, 50 * kScreenHeight1)];
        _numLabel.font = [UIFont systemFontOfSize:17];
        _numLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numLabel;
}

-(UILabel *)dateLabel
{
    if (!_dateLabel)
    {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * kScreenWidth1,10 * kScreenHeight1, 170 * kScreenWidth1, 50 * kScreenHeight1)];
        _dateLabel.font = [UIFont systemFontOfSize:15];
        _dateLabel.textColor = [UIColor blackColor];
    }
    return _dateLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
