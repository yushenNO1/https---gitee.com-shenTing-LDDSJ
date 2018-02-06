//
//  FreightCell.h
//  供应商
//
//  Created by 张敬文 on 2017/7/27.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreightCell : UITableViewCell
@property (nonatomic,strong) UIImageView * LeftImageView;
@property (nonatomic,strong) UILabel * TopLabel;
@property (nonatomic,strong) UILabel * DownLabel;
@property (nonatomic,strong) UIButton * deleteBtn;
@property (nonatomic,strong) UILabel * lightGrayLine;
@end
