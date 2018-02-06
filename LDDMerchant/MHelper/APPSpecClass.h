
//整理App内文字大小,字体规格

#define FontSize(size)              [UIFont systemFontOfSize:size * kScreenHeight1]

#define FontSize_16                 [UIFont systemFontOfSize:16 * kScreenHeight1]

#define FontSize_14                 [UIFont systemFontOfSize:14 * kScreenHeight1]



//控件摆放位置适配
#define WDH_CGRectMake(x,y,width,height)        CGRectMake((x) * kScreenWidth1, (y) * kScreenHeight1, (width) * kScreenWidth1, (height) * kScreenHeight1)
#define WDH_CGRectWidth(x,y,width,height)        CGRectMake((x) * kScreenWidth1, (y) , (width) * kScreenWidth1, (height) )
//整理App内文字大小,字体规格
//整理线上线下文档

//正式上线的信息

//#define LSKurl1                 @"http://120.77.205.115"
//
//
//#define LSKurl                  @"http://120.77.205.115"
//
////蒲公英更新KEY
//#define PgyManagerId            @"7a14e70c4999386c06717d35c0d47697"
//
//#define JPUSHappKey             @"55652ee4a6e30d415e622088"
//
//
//#define JPUSHaps                1


////测试使用的信息
#define LSKurl                  @"http://192.168.50.220:80"
//
#define LSKurl1                 @"http://192.168.0.161"
//
#define PgyManagerId            @"7a14e70c4999386c06717d35c0d47697"

#define JPUSHappKey             @"55652ee4a6e30d415e622088"

#define JPUSHaps                0




