//
//  SuppliersOverCell.h
//  供应商
//
//  Created by 张敬文 on 2017/8/4.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuppliersOverCell : UITableViewCell
@property (nonatomic,strong) UIImageView * LeftImageView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * priceLabel;
@property (nonatomic,strong) UILabel * numLabel;
@property (nonatomic,strong) UILabel * saveLabel;
@property (nonatomic,strong) UILabel * dateLabel;
@property (nonatomic,strong) UIButton * editBtn;
@property (nonatomic,strong) UIButton * downBtn;
@property (nonatomic,strong) UIButton * deleteBtn;
@property (nonatomic,strong) UILabel * lightGrayLine;
@property (nonatomic,strong) UILabel * lightGrayLabel;
@end
