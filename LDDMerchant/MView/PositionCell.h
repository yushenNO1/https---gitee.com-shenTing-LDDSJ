//
//  PositionCell.h
//  FUll
//
//  Created by july on 16/11/5.
//  Copyright © 2016年 july. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceaLabel;

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *menPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;

@property (weak, nonatomic) IBOutlet UILabel *AdressLab;


@end
