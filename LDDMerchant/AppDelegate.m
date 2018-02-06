//
//  AppDelegate.m
//  LDDMerchant
//
//  Created by 李宇廷 on 2018/1/25.
//  Copyright © 2018年 李宇廷. All rights reserved.
//

#import "AppDelegate.h"

#import "MerchantsVC.h"
#import "SYLoginPage.h"
#import <UMSocialCore/UMSocialCore.h>
#import "NetURL.h"
#import "EarningsDetailController.h"
#import <AVFoundation/AVSpeechSynthesis.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    NSLog(@"s---s-s-s------$%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"]);
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"]) {
        SYLoginPage * me = [[SYLoginPage alloc] init];
        UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:me];
        self.window.rootViewController = naVC;
    } else {
        
        UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor whiteColor];
        UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:vc];
        window.rootViewController = naVC;
        [self LoginRequest];
        
    }
    
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5875a5d2717c190e67002ea6"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105999362"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:@"1105999362"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"816805401"  appSecret:@"5ac00f4e57b8e0db8eabc7a8747128a4" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxe9a85bd474382b77" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:@"wxe9a85bd474382b77" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
    
    
    [self configPgyUpdate];
    
    
    /*---------------------极光注册+初始化-------------------------*/
    //极光注册模块
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound | UIUserNotificationTypeAlert)     categories:nil];
    } else {
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
#else
                                              categories:nil];
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
#endif
                                              categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions];
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            NSLog(@"推送消息==== %@",remoteNotification);
            [self goToMssageViewControllerWith:remoteNotification];
        }
    }
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //极光初始化模块
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    
    
    
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    //apsForProduction    0表示测试   1表示上线
    //    NSString *appKey = @"aadebd5f4d4744a67ccbb119";//企业上线
    ////     NSString *appKey = @"d308fa5b566aed05655aa267";//线下测试
    
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHappKey
                          channel:@""
                 apsForProduction:JPUSHaps
            advertisingIdentifier:advertisingId];
    
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(JGBieMing) name:kJPFNetworkDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(JGBieMing) name:@"JGLOgin" object:nil];
    
    return YES;
}
#pragma mark ---  配置蒲公英更新
-(void)configPgyUpdate{
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:PgyManagerId];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PgyManagerId];
    //    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    //关闭反馈
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
}
-(void)updateMethod:(NSDictionary *)dic{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dic[@"downloadURL"]]];
    [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
}

-(void)JGBieMing{
    NSLog(@"搜索撒  什么时候会执行");
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"infoMy"];
    
    [JPUSHService setTags:nil alias:[NSString stringWithFormat:@"%@",dic[@"userVo"][@"id"]] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
    }];
}

//106903290132531

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"尼玛的推送消息呢===%@",userInfo);
    // 取得 APNs 标准信息内容，如果没需要可以不取
    //     NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //     NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //     NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    //     NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得自定义字段内容，userInfo就是后台返回的JSON数据，是一个字典
    [JPUSHService handleRemoteNotification:userInfo];
    application.applicationIconBadgeNumber = 0;
    [self goToMssageViewControllerWith:userInfo];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];   //清除角标
    [application cancelAllLocalNotifications];
}
- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic{
    //将字段存入本地，因为要在你要跳转的页面用它来判断,这里我只介绍跳转一个页面，
    
    NSString * targetStr = [NSString stringWithFormat:@"%@",msgDic [@"data"][@"type"]];
    if ([targetStr isEqualToString:@"2"]) {
        NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@"push"forKey:@"push"];
        [pushJudge synchronize];
        EarningsDetailController * VC = [[EarningsDetailController alloc]init];
        UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:VC];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
        [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
        
    }
}

- (void)LoginRequest{
    NSString *login = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginID"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"PwdID"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"Basic bW9iaWxlOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
    [manager POST:[NSString stringWithFormat:loginUrl,login, password] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"登录请求%@",responseObject);
        NSString *tokenStr = [NSString stringWithFormat:@"Bearer %@",responseObject[@"access_token"]];
        [[NSUserDefaults standardUserDefaults]setObject:tokenStr  forKey:@"token"];
        UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
        MerchantsVC * zjwVC = [[MerchantsVC alloc] init];
        UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:zjwVC];
        window.rootViewController = naVC;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录请求失败%@",error);
        SYLoginPage * me = [[SYLoginPage alloc] init];
        UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:me];
        self.window.rootViewController = naVC;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"MyInfo"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"refresh_token"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LoginID"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PwdID"];
    }];
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        NSLog(@"回调");
    }
    return result;
}
//上传推送证书
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}





- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"WDHMerchant"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        NSString * targetStr = [NSString stringWithFormat:@"%@",userInfo [@"data"][@"type"]];
        if ([targetStr isEqualToString:@"2"]) {
            NSString *message = [NSString stringWithFormat:@"%@", [userInfo[@"aps"] objectForKey:@"alert"]];
            NSLog(@"iOS10程序在前台时收到的推送: %@", message);
            //语音播报
            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:message];
            AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
            [synth speakUtterance:utterance];
        }
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSLog(@"qweq----10-");
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [self goToMssageViewControllerWith:userInfo];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    NSLog(@"qweq----7-");
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}



#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end
