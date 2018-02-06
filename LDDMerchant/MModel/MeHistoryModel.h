//
//  MeHistoryModel.h
//  YSApp
//
//  Created by 张敬文 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeHistoryModel : NSObject
@property (nonatomic, copy) NSString * fundStr;
@property (nonatomic, copy) NSString * accStr;
@property (nonatomic, copy) NSString * priceStr;
@property (nonatomic, copy) NSString * dateStr;
@property (nonatomic, copy) NSString * nameStr;
@property (nonatomic, copy) NSString * codeStr;
@property (nonatomic, copy) NSString * cover;
- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)MeWithDictionary:(NSDictionary *)dic;
@end
