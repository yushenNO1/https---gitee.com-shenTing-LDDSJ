//
//  NetURL.h
//  YSApp
//
//  Created by 云盛科技 on 16/4/28.
//  Copyright © 2016年 云盛科技. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "WKProgressHUD.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "ErrorCode.h"
#import "PublicToors.h"
#define Alert_Show(str) UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];[alert addAction:action];[self presentViewController:alert animated:YES completion:nil];

#define Alert_show_pushRoot(str) UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:(UIAlertControllerStyleAlert)];UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {[self.navigationController popViewControllerAnimated:YES];}];[alertVC addAction:okAction];[self presentViewController:alertVC animated:YES completion:nil];

#define Connect_Net  GetToken *token = [[GetToken alloc]init];[token getNetWorkStates];


#define Width  ([UIScreen mainScreen].bounds.size.width)
#define Height  ([UIScreen mainScreen].bounds.size.height)






#define loginUrl                        LSKurl@"/api/v1/auth/oauth/token?grant_type=password&username=%@&password=%@"
//服务器地址
//服务器地址
//Web服务器 不加端口号


//刷新token
#define refreshTokenUrl                        LSKurl@"/api/v1/auth/oauth/token?grant_type=refresh_token&refresh_token=%@"

//获取token
#define GET_Token              @"/api/login"

#pragma mark -------- 商家
/* *服务项目
 项目新增
 
 修改接口

 上传图片
 
 分类查询
 
 套餐条目
 
 新增
 
 更新套餐
 
 商家信息
 
 验证历史

 */
#define new_Project            @"/api/v1/life/shop/item/save?lifeId=%d&categoryId=%@&shopName=%@&name=%@&mealIds=%@&teamBuyPrice=%.2f&cloudIntPercent=%d&validityPeriod=%d&purchaseNote=%@&cover=%@&consumeStartTime=0&consumeEndTime=23&profile=%@&goodsType=1"
#define new_Project1            @"/api/v1/life/shop/item/save?categoryId=%@&shopName=%@&name=%@&mealIds=%@&teamBuyPrice=%.2f&cloudIntPercent=%d&validityPeriod=%d&purchaseNote=%@&cover=%@&consumeStartTime=0&consumeEndTime=23&profile=%@&goodsType=1"


#define UpStraightGoods            @"/api/v1/life/shop/item/save?lifeId=%d&categoryId=%@&name=%@&teamBuyPrice=%.2f&purchaseNote=%@&cover=%@&profile=%@&barCode=%@&goodsInTrade=%@&mAccount=%@&goodsType=2"
#define UpStraightGoods1           @"/api/v1/life/shop/item/save?categoryId=%@&name=%@&teamBuyPrice=%.2f&purchaseNote=%@&cover=%@&profile=%@&barCode=%@&goodsInTrade=%@&mAccount=%@&goodsType=2"

#define Modify                 @"/api/v1/life/shop/item/detail?lifeId=%@"
#define upload_Mage            @"/api/v1/mgs/file/imageUpload"
#define classification         @"/api/v1/life/category/list?type=%d"

#define setEntry               @"/api/v1/life/shop/setMeal/records"
#define new_Package            @"/api/v1/life/shop/setMeal/save?name=%@&price=%.2f"
#define update_Package         @"/api/v1/life/shop/setMeal/save?id=%@&name=%@&price=%.2f"
#define businessInformation    @"/v1/api/business"

#define verifyHistory          @"/v1/api/consumecoupon/showlocalLifeNums?locallifeid=%@"
#define History          @"/v1/api/consumecoupon/showlocalLifeNums"
//MeHistoryVC
#define ww      @"/v1/api/consumecoupon/query?starttime=%@&endtime=%@&count=100&cursor=0"
#define sss     @"/v1/api/consumecoupon/query?count=100&cursor=0"

#pragma mark -------- 供应商
//供应商
#define GYSPerfectInfo       LSKurl@"/api/v1/life/mill/apply?content=%@&url=%@&largeOrderLimit=%@"
#define GYSLogisticsInfo     LSKurl@"/api/v1/life/mgorder/completeTransport"
#define GYSOrderList         LSKurl@"/api/v1/life/mgorder/millOrderlist?orderStatus=%@&count=10&cursor=%ld"
#define GYSOrderCount        LSKurl@"/api/v1/life/mgorder/countOrder"
#define GYSOrderDetail       LSKurl@"/api/v1/life/mgorder/millOrderdetail?orderId=%@"
#define GYSImageUpload       LSKurl@"/api/v1/mgs/goodImage/upload"
#define GYSImageDetailUpload LSKurl@"/api/v1/mgs/goodImage/contentImgUpload"
#define GYSGoodList          LSKurl@"/api/v1/life/shopGood/goodsPageList"
#define GYSGoodQuery         LSKurl@"/api/v1/life/shopGood/goodsContentPage"
#define GYSGoodContent       LSKurl@"/api/v1/life/shopGood/goodContentEdit"
#define GYSGoodStatusChange  LSKurl@"/api/v1/life/shopGood/goodStatusChange"
#define GYSInfo              LSKurl@"/api/v1/life/mill/info"
#define GYSInCome            LSKurl@"/api/v1/user/msg/profitLog/getProfitAmountByUser"
#define GYSFreEdit           LSKurl@"/api/v1/life/shopGood/transportEdit"
#define GYSFre               LSKurl@"/api/v1/life/shopGood/goodsTransportPageList"
#define GYSGoodDetail        LSKurl@"/api/v1/life/shopGood/goodsDetail"
#define GYSGoodAll           LSKurl@"/api/v1/life/shopGood/goodAdd"
#define GYSGoodCate          LSKurl@"/api/v1/life/shopGood/goodsCategory"
#define GYSOrderSend         LSKurl@"/api/v1/life/mgorder/completeTransport"
#define GYSCateList          LSKurl@"/api/v1/life/goodsCate/list"
#define GYSFreDetail         LSKurl@"/api/v1/life/shopGood/millTransportDetail"
#pragma mark -------- 商家 ~ 项目管理

/* * 项目管理
 
 申请上线
 
 申请下线
 
 项目删除
 
 项目列表查询
 
 上线项目列表
 
 下线项目列表
 
 */
#define projectManagement       @"/api/v1/life/shop/item/online?lifeId=%@&status=1"
#define applyOffline            @"/api/v1/life/shop/item/online?lifeId=%@&status=0"
#define applyDelete             @"/api/v1/life/shop/item/del?lifeId=%@"

#define listQuery               @"/api/v1/life/shop/item/records?count=100"
#define OnlineListItems         @"/api/v1/life/shop/item/records?status=2&count=100"
#define offlineProjectList      @"/api/v1/life/shop/item/records?status=4&count=100"
#define shutProject             @"/api/v1/life/shop/item/records?status=5&count=100"

//本地商家接口
#define MyInfo                    @"/api/v1/life/supplier/info"

#define Info                      @"/api/v1/user/getInfo"


//项目管理
//项目列表查询
#define ProjectList               @"/v1/api/lifeItem/getList"

//项目删除
#define ProjectDel                @"/v1/api/lifeItem/del"

//项目详情查询
#define ProjectGetDrtail          @"/v1/api/lifeItem/del"

//项目申请上下线接口
#define ProjectChange             @"/v1/api/lifeItem/changeStatus"

//项目增改接口
#define ProjectNew                @"/v1/api/lifeItem/merge"
#pragma mark---------  获取验证码接口

//获取验证码
/*
 
 //添加银行卡
 
 //更新支付密码
 
 //更新登录密码
 
 //注册验证码
 
 //对比银行卡是否重复
 
 //注册用户
 
 //验证手机号和验证码
 */
#define Verifi_Code             @"/api/sms?mobile=%@&type=3"
#define ZFPwd_Code              @"/api/sms?mobile=%@&type=5"
#define Update_Pwd              @"/api/sms?mobile=%@&type=2"
#define Regist_Code             @"/api/sms?mobile=%@&type=1"
#define Comparison_bank         @"/v1/api/card/%@"
#define Registered_Users        @"/api/register?mobile=%@&type=1&spreader=%@"
#define Validation_Users        @"/api/register?mobile=%@&code=%@"

#pragma mark---------  验证接口

//验证验证码
/*
 
 //银行卡
 
 //支付密码
 
 //验证登录密码
 
 //验证手机号
 
 //验证注册验证码
 
 //验证支付密码
 
 //验证身份证
 
 //验证旧支付密码
 
 */
#define Val_Phone_Code        @"/api/register?mobile=%@&code=%@&type=3"
#define ZF_Phone_Code         @"/v1/api/check_sms_code?mobile=%@&code=%@&type=5"
#define DL_Phone_Code         @"/v1/api/check_sms_code?mobile=%@&code=%@&type=2"
#define Verify_PhoneNum       @"/api/register/mobile?mobile=%@"
#define Verify_Regist_Code    @"/api/register?mobile=%@&code=%@"
#define verify_ZF_Pwd         @"/v1/api/user/check_account_password?password=%@"
#define Verify_OldPwd         @"/v1/api/user/check_account_password?password=%@"

#define Val_Phone_Code111     @"/api/sms?mobile=%@&type=6"//sy
#define Verify_VerifyCode     @"/v1/api/check_sms_code?mobile=%@&code=%@&type=6"//sy


/*
 
 //转账接口
 
 //转账记录
 
 */
#define TransferURL         @"/v1/api/transfer?mobile=%@&amount=%@&password=%@"
#define TRecordURL          @"/v1/api/transfer?cursor=%ld"

#pragma mark---------  支付接口
/*
 
 //支付宝支付
 
 //微信支付
 
//银联支付
 
 */
#define URL_ZFB            @"/v1/api/aliPay?price=%@"
#define URL_WX             @"/v1/api/wxPay?price=%@"
#define unionpay           @"/v1/api/unionPay?price=%@"

#define red_ZFB            @"/v1/api/aliPay?price=%@&type=1"
#define red_WX             @"/v1/api/wxPay?price=%@&type=1"

#pragma mark---------  提现接口

/*
 
 //提现接口
 
 //提现记录
 
 //提现限额
 
 */
#define WithdrawUrl      @"/v1/api/drawal?cardId=%@&amount=%@&password=%@"
#define BusinisWithdrawUrl      @"/api/v1/user/withdraw/apply?cardId=%@&amount=%@&paymentPwd=%@&type=1"
#define WRecordURL       @"/api/v1/user/withdraw/records?type=1&cursor=%ld&count=10"
#define WRecord_limit    @"/v1/api/showDrawLimit"

//银行卡列表
#define bankCardList                LSKurl@"/api/v1/user/bank/list"

//添加银行卡
#define addBankCard                 LSKurl@"/api/v1/user/card/save?bank=%@&cardNo=%@&name=%@&cardType=%@"

//更新银行卡
#define updateBankCard              LSKurl@"/api/v1/user/card/updateById?bank=%@&cardNo=%@&name=%@&cardType=%@&cardId=%@"

//查询银行卡信息
#define GetBankCardInfo             LSKurl@"/api/v1/user/card/findById/%@"

//删除银行卡
#define deleteBankCard              LSKurl@"/api/v1/user/card/deleteById?id=%@"

/*
 
 //今日收益
 
 //收益详情
 
 */
#define Profit        @"/v1/api/profits"
#define Earning       @"/api/v1/user/msg/profitLog/records?count=10&cursor=%ld&year=%@&month=%@&accTypes=20"
//#define Earning @"/v1/api/profits?max=10&offset=%ld&year=%@&month=%@&type=%@&billType=%@"

#pragma mark -----------------------采购单
//采购单列表
#define CGDList                     LSKurl@"/api/v1/life/purchase/list?roleType=%@&type=1&status=%@"

//采购单取消
#define CGDCancel                   LSKurl@"/api/v1/life/purchase/cancel?orderId=%@&type=1"

//采购单审核
#define CGDOk                       LSKurl@"/api/v1/life/purchase/check?orderId=%@&type=3&result=%@&remark=%@"
//采购单列表
#define CGDDetail                   LSKurl@"/api/v1/life/purchase/detail?orderId=%@"


#pragma mark -----------------------收银台
//收银台未付款列表
#define SYTWList                     LSKurl@"/api/v1/life/goodOrder/list?status=0"

//收银台已付款列表
#define SYTYList                     LSKurl@"/api/v1/life/goodOrder/list?status=2"

//收银台创建订单
#define SYTOrderId                   LSKurl@"/api/v1/life/goodOrder/billing?orderId=%@&orderName=%@&extAmount=%@"

//收银台创建订单
#define SYTOrderNoId                  LSKurl@"/api/v1/life/goodOrder/billing?orderName=%@&extAmount=%@&orderType=1"

//收银台订单详情
#define SYTOrderDetail                   LSKurl@"/api/v1/life/goodOrder/detail?orderId=%@"

//收银台商品详情
#define SYTGoodDetail                   LSKurl@"/api/v1/life/shop/goods/info?barCode=%@"

//收银台商品详情
#define SYTDeleteOrder                   LSKurl@"/api/v1/life/goodOrder/del?orderId=%@"

@interface NetURL : NSObject

@end
