//
//  GoodsTableViewCell.h
//  YSApp
//
//  Created by 王松松 on 2016/11/16.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *centerLabel;
@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UIButton *leftImgBut;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *clearBtn;
@property (nonatomic,strong) UIButton *clearBtn1;
@property (nonatomic,strong) UITextField *num_tf;
@property (nonatomic,strong) UIView *numView;
@end
