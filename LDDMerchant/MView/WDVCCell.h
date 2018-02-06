//
//  WDVCCell.h
//  LSKKApp
//
//  Created by 云盛科技 on 16/4/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDModel;
@interface WDVCCell : UITableViewCell
@property(nonatomic,retain)UILabel *weekLabel;
@property(nonatomic,retain)UILabel *dataLabel;
@property(nonatomic,retain)UILabel *titleLaebl;
@property(nonatomic,retain)UILabel *numLabel;
@property (retain, nonatomic)WDModel * wdm;
@end
