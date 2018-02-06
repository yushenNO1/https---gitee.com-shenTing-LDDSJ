//
//  WithdrawView1.m
//  LSKKApp
//
//  Created by 云盛科技 on 16/4/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "WithdrawView1.h"
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width / 375)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height / 667)
@implementation WithdrawView1

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel =  [[UILabel alloc]initWithFrame:CGRectMake(10 * kScreenWidth, 20 * kScreenHeight, 100 * kScreenWidth, 20 * kScreenHeight)];
        [self addSubview:_titleLabel];
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(120 * kScreenWidth, 20 * kScreenHeight, 245 * kScreenWidth, 20 * kScreenHeight)];
        [self addSubview:_contentLabel];
    }
    return self;
}

@end
