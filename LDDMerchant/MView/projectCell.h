//
//  projectCell.h
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface projectCell : UITableViewCell
@property(nonatomic,strong)UIImageView *leftImage;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIButton * upBtn;
@property(nonatomic,strong)UIButton * editBtn;
@property(nonatomic,strong)UIButton * downBtn;
@property(nonatomic,strong)UIButton * deleBtn;
@property(nonatomic,strong)UIButton * shareBtn;
@end
