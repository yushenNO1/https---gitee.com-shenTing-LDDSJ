//
//  TextDetailCell.h
//  供应商
//
//  Created by 张敬文 on 2017/8/1.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloverText.h"
@interface TextDetailCell : UITableViewCell
@property (nonatomic, strong) CloverText * Tf;
@property (nonatomic,strong) UIButton * deleteBtn;
@property (nonatomic,strong) UIButton * moveBtn;
@end
