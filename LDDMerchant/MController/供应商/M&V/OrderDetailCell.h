//
//  OrderDetailCell.h
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/11.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCell : UITableViewCell
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) UIImageView * ImageView;
@property (nonatomic,strong) UILabel * TopLabel;
@property (nonatomic,strong) UILabel * priceLabel;
@property (nonatomic,strong) UILabel * numLabel;
@property (nonatomic,strong) UILabel * descripeLabel;
@property (nonatomic,strong) UILabel * colorLabel;
@end
