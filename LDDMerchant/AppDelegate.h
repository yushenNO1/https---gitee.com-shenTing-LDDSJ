//
//  AppDelegate.h
//  LDDMerchant
//
//  Created by 李宇廷 on 2018/1/25.
//  Copyright © 2018年 李宇廷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

