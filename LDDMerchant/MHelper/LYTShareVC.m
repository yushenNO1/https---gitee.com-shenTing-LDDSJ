//
//  LYTShareVC.m
//  LSK
//
//  Created by 云盛科技 on 2017/1/12.
//  Copyright © 2017年 云盛科技. All rights reserved.
//

#import "LYTShareVC.h"
//UM
#import <UShareUI/UShareUI.h>
@interface LYTShareVC ()

@end

@implementation LYTShareVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

+(void)shareImage:(NSString *)img Title:(NSString *)str content:(NSString *)content AndUrl:(NSString *)url{
    //添加平台按钮
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_QQ withPlatformIcon:[UIImage imageNamed:@"umsocial_qq"]  withPlatformName:@"qq"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_Sina withPlatformIcon:[UIImage imageNamed:@"umsocial_sina"]  withPlatformName:@"新浪微博"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_WechatSession withPlatformIcon:[UIImage imageNamed:@"umsocial_wechat"]  withPlatformName:@"微信"];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_WechatTimeLine withPlatformIcon:[UIImage imageNamed:@"umsocial_wechat_timeline"]  withPlatformName:@"朋友圈"];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:str descr:content thumImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img]]]];
        //设置网页地址
        shareObject.webpageUrl = url;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
                
            }
        }];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
