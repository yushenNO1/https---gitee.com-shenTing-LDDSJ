//
//  LYTPurchaseCell.h
//  满意
//
//  Created by 云盛科技 on 2017/5/25.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYTPurchaseCell : UITableViewCell
//完成状态
@property(nonatomic,strong)UIButton *yuanBtn;           //圆圈按钮
@property(nonatomic,strong)UIImageView *yuanImgView;    //圆圈图片
@property(nonatomic,strong)UIImageView *imgView;        //大图
@property(nonatomic,strong)UIButton *changeBtn;         //编辑按钮


@property(nonatomic,strong)UIView *completeStateView;   //完成状态的view
@property(nonatomic,strong)UILabel *titleLabel;         //标题
@property(nonatomic,strong)UILabel *contentLabel;       //内容
@property(nonatomic,strong)UILabel *moneyLabel;         //金额
@property(nonatomic,strong)UILabel *countLabel;         //数量


//编辑状态
@property(nonatomic,strong)UIView *editStateView;       //编辑状态的view
@property(nonatomic,strong)UIButton *jiaBtn;            //+按钮
@property(nonatomic,strong)UIButton *jianBtn;           //-按钮
@property(nonatomic,strong)UITextField *countTextFiled; //数量框
@property(nonatomic,strong)UIButton *deleteBtn;         //-按钮
@end
