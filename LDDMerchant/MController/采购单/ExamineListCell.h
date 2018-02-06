//
//  ExamineListCell.h
//  采购单
//
//  Created by 张敬文 on 2017/5/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamineListCell : UITableViewCell
@property (nonatomic,strong) UILabel *TopLabel;
@property (nonatomic,strong) UILabel *DownLabel;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *ImageView;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,copy) NSString * orderId;
@end
