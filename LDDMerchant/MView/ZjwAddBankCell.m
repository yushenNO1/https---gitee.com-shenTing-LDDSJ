//
//  ZjwAddBankCell.m
//  LSK
//
//  Created by 张敬文 on 2017/1/17.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "ZjwAddBankCell.h"
#import "NetURL.h"
@implementation ZjwAddBankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.MidLabel];
        [self addSubview:self.LeftImageView];

    }
    return self;
}
- (UILabel *)MidLabel  {
    if (!_MidLabel)
    {
        _MidLabel =[[UILabel alloc]initWithFrame:CGRectMake(60*kScreenWidth1, 0*kScreenHeight1, 200*kScreenWidth1, 40*kScreenHeight1)];
        _MidLabel.font = [UIFont systemFontOfSize:15];
        _MidLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _MidLabel;
}
- (UIImageView *)LeftImageView  {
    if (!_LeftImageView)
    {
        _LeftImageView =[[UIImageView alloc]initWithFrame:CGRectMake(20, 10*kScreenHeight1, 20*kScreenWidth1, 20*kScreenHeight1)];
    }
    return _LeftImageView;
}

@end
