//
//  PackModel.h
//  YSApp
//
//  Created by 王松松 on 2016/11/12.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackModel : NSObject
@property (nonatomic,copy)NSString *coverStr;
@property (nonatomic,copy)NSString *nameStr;
@property (nonatomic,copy)NSString *profileStr; //不知道是什么
@property (nonatomic,assign)int idStr;
@property (nonatomic,assign)float priceStr;
@property (nonatomic,assign)int count;
- (id)initWithFrameWithDic:(NSDictionary *)dic;
@end
