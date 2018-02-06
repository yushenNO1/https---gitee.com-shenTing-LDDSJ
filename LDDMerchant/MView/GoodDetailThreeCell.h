//
//  GoodDetailThreeCell.h
//  FUll
//
//  Created by july on 16/11/7.
//  Copyright © 2016年 july. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodDetailThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonImageView;

@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;

@end
