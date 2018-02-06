//
//  LYTManagementCell.h
//  满意
//
//  Created by 云盛科技 on 2017/5/26.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYTManagementCell : UITableViewCell
@property(nonatomic,strong)UIImageView *leftImage;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIButton * upBtn;
@property(nonatomic,strong)UIButton * editBtn;
@property(nonatomic,strong)UIButton * downBtn;
@property(nonatomic,strong)UIButton * deleBtn;
@property(nonatomic,strong)UIButton * shareBtn;
@end
