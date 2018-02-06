//
//  DLPrefix.h
//  DL_WDH
//
//  Created by 李宇廷 on 2017/12/29.
//  Copyright © 2017年 李宇廷. All rights reserved.
//

#ifndef DLPrefix_h
#define DLPrefix_h

//系统库
#import <UIKit/UIKit.h>

//添加经常用到的第三方库
#import <AFNetworking.h>            //网络加载
#import <MJRefresh.h>               //刷新加载
#import <UIImageView+WebCache.h>    //图片加载
#import <SVProgressHUD.h>           //加载时的菊花圈
#import <SDCycleScrollView.h>       //轮播图
#import <ReactiveCocoa.h>           //RAC
#import <SDAutoLayout.h>            //自动布局
#import <YYModel.h>                 //转模型
#import <FMDB.h>

#import "APPSpecClass.h"            //转换上线测试的数据
#import "NetURL.h"                  //接口存放
#import "UIColor+Addition.h"        //颜色管理
#import "ErrorCode.h"               //错误码管理
#import "IsLogin.h"
//#import "DLConsts.h"
//
//#import "DLFMDB.h"                  //数据库使用
//#import "DLButton.h"                //上图下字按钮
//#import "DLHomeHeader.h"



//数据库用到的宏
#define Search_history          @"Search_history"


//添加常用的宏

#define kScreenWidth        [[UIScreen mainScreen] bounds].size.width           //屏宽
#define kScreenHeight       [[UIScreen mainScreen] bounds].size.height          //屏高
#define kScreenWidth1       ([UIScreen mainScreen].bounds.size.width / 375)     //适配宽度
#define kScreenHeight1      (kScreenHeight == 812.0 ? 667.0/667.0 : kScreenHeight/667.0)



#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

#endif /* DLPrefix_h */
