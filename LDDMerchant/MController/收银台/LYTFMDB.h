//
//  LYTFMDB.h
//  LYTCoreDate
//
//  Created by 云盛科技 on 2017/5/23.
//  Copyright © 2017年 神廷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "GoodsInfoModel.h"
@interface LYTFMDB : NSObject
{
    //数据库
    FMDatabase *_database;
}
//获取数据库管理对象单例的方法
+ (LYTFMDB *)sharedDataBase;
//返回数据的路径
+ (NSString *)getDataBasePath;
//关闭数据库
- (void)closeDataBase;
//清空数据库
- (BOOL)deleteDatabase;
/***********
 *搜索记录模块
 **************/
//向搜索记录表中插入新记录
- (BOOL)insertSeachText:(NSString *)seachText;
//查询数据库中是否包含当前搜索记录
- (BOOL)isExistSeachText:(NSString *)seachText;
//获取所有搜索记录
- (NSArray *)getAllNews;
//删除所有搜索记录
- (BOOL)deleAllSeachText;

//获取一个model比对
- (GoodsInfoModel *)getNewsModelById:(NSString *)newId;
- (BOOL)insertPdcToCarWithModel:(GoodsInfoModel *)model;
@end
