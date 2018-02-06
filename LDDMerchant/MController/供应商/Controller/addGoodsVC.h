//
//  addGoodsVC.h
//  供应商
//
//  Created by 张敬文 on 2017/7/26.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addGoodsVC : UIViewController
@property (nonatomic, strong) NSString * millId;
@property (nonatomic, strong) NSString * goodId;

@property (nonatomic, strong) NSString *typeStr;            //0 表示直供商品     1 表示积分商品
@end
