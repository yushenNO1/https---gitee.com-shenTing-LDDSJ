//
//  BankCardCell.h
//  LSKKApp
//
//  Created by 云盛科技 on 16/2/29.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
