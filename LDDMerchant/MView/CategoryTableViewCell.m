//
//  CategoryTableViewCell.m
//  YSApp
//
//  Created by 王松松 on 2016/11/11.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "NetURL.h"
@implementation CategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubview:self.label];
    }
    return self;
}
-(UILabel *)label
{
    if (!_label)
    {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(20 * kScreenWidth1, 10 * kScreenHeight1, 200 * kScreenWidth1, 24 * kScreenHeight1)];
//        _label.backgroundColor =[UIColor redColor];
    }
    return _label;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
