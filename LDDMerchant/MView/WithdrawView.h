//
//  WithdrawView.h
//  LSKKApp
//
//  Created by 云盛科技 on 16/3/15.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)NSArray *imageArr;
@property(nonatomic,retain)NSArray *titleArr;
@property(nonatomic,retain)NSArray *tailArr;
@property(nonatomic,retain)NSMutableArray *circleArr;
@property(nonatomic,retain)NSDictionary *cardDic;

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSArray* arrKeys;
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, copy) NSString * cardId;

-(void)getdic:(NSDictionary *)dic;

@end
