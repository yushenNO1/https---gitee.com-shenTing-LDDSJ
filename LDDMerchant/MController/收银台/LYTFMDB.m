//
//  LYTFMDB.m
//  LYTCoreDate
//
//  Created by shenTing on 2017/5/23.
//  Test Change This
//  博客:http://www.cnblogs.com/yuShen
//  Copyright © 2017年 神廷. All rights reserved.
//

#import "LYTFMDB.h"
@implementation LYTFMDB
- (id)init
{
    if (self = [super init]) {
        //初始化数据库对象 并打开
        _database = [FMDatabase databaseWithPath:[LYTFMDB getDataBasePath]];
        //如果数据库打开失败返回空值
        if (![_database open]) {
            return nil;
        }
    }
    
    
    
//    NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", @"Member" ];
//    FMResultSet *rs = [_database executeQuery:existsSql];
//    
//    if ([rs next]) {
//        NSInteger count = [rs intForColumn:@"countNum"];
//        NSLog(@"The table count: %li", count);
//        if (count == 1) {
//            NSLog(@"存在");
//        }
//    }
    
    //如果数据库打开成功 创建表
    //创建搜索历史记录表
    NSString *sql = @"create table if not exists tb_history(barCode text primary key, shopId integer,shopName text ,shopMoney integer)";
    
    BOOL is = [_database executeUpdate:sql];
    if (is) {
        NSLog(@"创建表成功！");
    }
    return self;
}
//获取数据库管理对象单例的方法
+ (LYTFMDB *)sharedDataBase
{
    static LYTFMDB *wydatase = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        wydatase = [[LYTFMDB alloc]init];
    });
    
    return wydatase;
}
//返回数据库的路径
+ (NSString *)getDataBasePath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //    NSLog(@"home:%@",path);
    return [path stringByAppendingPathComponent:@"wdh.db"];
}
//查询数据库中是否包含当前搜索记录
- (BOOL)isExistSeachText:(NSString *)seachText
{
    NSString *sql = @"select * from tb_history";
    FMResultSet *results = [_database executeQuery:sql];
    
    while (results.next) {
        if ([seachText isEqualToString:[results stringForColumn:@"barCode"]]) {
            return YES;
        }
    }
    return NO;
}
//插入新纪录
- (BOOL)insertPdcToCarWithModel:(GoodsInfoModel *)model
{
    
    
    if ([self isExistSeachText:[NSString stringWithFormat:@"%@",model.barCode]]) {
        //        [self deletePdcInCarById:[model.car_id intValue]];
        return NO;
    }
    
    /***************如果该产品在购物车中不存在，加入购物车*******************/
    NSString *sql = @"insert into tb_history(barCode,shopId,shopName,shopMoney) values (?,?,?,?)";
    NSLog(@"---%@---",model.barCode);
    BOOL isInsertOK = [_database executeUpdate:sql,model.barCode, [NSNumber numberWithInteger:model.shopId],model.name, [NSNumber numberWithInteger:model.price]];
    NSLog(@"---%@---%d",model.barCode,isInsertOK);
    if (isInsertOK) {
        NSLog(@"%@-->插入成功",model.barCode);
        return YES;
    }  
    return NO;  
}


//获取所有的消息记录
- (NSArray *)getAllNews
{
    NSString *sql = @"select * from tb_history order by shopId desc";
    FMResultSet *results = [_database executeQuery:sql];
    NSMutableArray *arr = [NSMutableArray array];
    while (results.next) {
        GoodsInfoModel *model = [[GoodsInfoModel alloc]init];
        model.barCode = [results stringForColumn:@"barCode"];
        model.shopId = [results intForColumn:@"shopId"];
        model.name = [results stringForColumn:@"shopName"];
        model.price = [results intForColumn:@"shopMoney"];
        [arr addObject:model];
    }
    
    return arr;
}

//删除所有搜索记录
- (BOOL)deleAllSeachText
{
    NSString *sql = @"delete from tb_history";
    BOOL isDeleteOK = [_database executeUpdate:sql];
    
    if (isDeleteOK) {
          NSLog(@"删除成功");
        return YES;
    }
    return NO;
}


//获取一个model比对
- (GoodsInfoModel *)getNewsModelById:(NSString *)newId
{
    NSString *sql = @"select * from tb_history where barCode = ?";
    FMResultSet *results = [_database executeQuery:sql,newId];
    while (results.next) {
        GoodsInfoModel *model = [[GoodsInfoModel alloc]init];
        model.barCode = [results stringForColumn:@"barCode"];
        model.shopId = [results intForColumn:@"shopId"];
        model.name = [results stringForColumn:@"shopName"];
        model.price = [results intForColumn:@"shopMoney"];
        return model;
    }
    
    return nil;
    
}

//清空数据库
- (BOOL)deleteDatabase
{
    NSString *sql1 = @"delete from tb_car";

    BOOL isOK1 = [_database executeUpdate:sql1];

    if (isOK1) {
        return YES;
    }
    return NO;
}
//关闭数据库
- (void)closeDataBase
{
    if (_database) {
        [_database close];
    }
}
@end
