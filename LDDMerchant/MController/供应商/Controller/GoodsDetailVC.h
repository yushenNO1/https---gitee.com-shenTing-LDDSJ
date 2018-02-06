//
//  GoodsDetailVC.h
//  供应商
//
//  Created by 张敬文 on 2017/8/1.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailVC : UIViewController
@property (nonatomic, copy) NSString * goodId;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, strong) NSArray * dataAry;
@end
