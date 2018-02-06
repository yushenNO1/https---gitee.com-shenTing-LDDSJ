//
//  GoodHeardView.m
//  FUll
//
//  Created by july on 16/11/7.
//  Copyright © 2016年 july. All rights reserved.
//

#import "GoodHeardView.h"

@implementation GoodHeardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backgroundImageView];
        [self.backgroundImageView addSubview:self.titleView];
        [self.titleView addSubview:self.titleLabel];
        [self.titleView addSubview:self.describeLabel];
    }
    return self;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _backgroundImageView.userInteractionEnabled = YES;
        _backgroundImageView.image = [UIImage imageNamed:@"huoguo.jpg"];
    }
    return _backgroundImageView;
}
- (UIView *)titleView {
    if (!_titleView) {
        self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 180, kScreenWidth, 70)];
        _titleView.backgroundColor = [UIColor blackColor];
        _titleView.userInteractionEnabled = YES;
        _titleView.alpha = 0.6;
        
    }
    return _titleView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 30)];
        _titleLabel.textColor = [UIColor whiteColor];
        //_titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.text = @"";
    }
    return _titleLabel;
}

- (UILabel *)describeLabel {
    if (!_describeLabel) {
        self.describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, kScreenWidth - 20, 40)];
        _describeLabel.textColor = [UIColor whiteColor];
        _describeLabel.font = [UIFont systemFontOfSize:13];
        _describeLabel.numberOfLines = 0;
        _describeLabel.text = @"";
    }
    return _describeLabel;
}
@end
