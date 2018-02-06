//
//  ViewTableCell.m
//  LSKKApp
//
//  Created by 云盛科技 on 16/3/15.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "ViewTableCell.h"
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width / 375)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height / 667)
@implementation ViewTableCell

- (void)awakeFromNib {
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubview:self.headerImage];
        [self addSubview:self.titleLabel];
        [self addSubview:self.ID];
        [self addSubview:self.circleImage];
    }
    return self;
}
-(UIImageView *)headerImage
{
    if (!_headerImage)
    {
        _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 * kScreenWidth, 15 * kScreenHeight, 40 * kScreenWidth, 30  *kScreenHeight)];
        
    }
    return _headerImage;
}
-(UIImageView *)circleImage
{
    if (!_circleImage)
    {
        _circleImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-20 * kScreenWidth, 20 * kScreenHeight, 20 * kScreenWidth, 20 * kScreenHeight)];
    }
    return _circleImage;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * kScreenWidth, 10 * kScreenHeight, 250 * kScreenWidth, 20 * kScreenHeight)];
    }
    return _titleLabel;
}

-(UILabel *)ID
{
    if (!_ID)
    {
        _ID = [[UILabel alloc]initWithFrame:CGRectMake(60 * kScreenWidth, 35 * kScreenHeight, 200 *kScreenWidth, 20 * kScreenHeight)];
    }
    return _ID;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
