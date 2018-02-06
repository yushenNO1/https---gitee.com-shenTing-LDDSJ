//
//  InfoModel.h
//  YSApp
//
//  Created by 云盛科技 on 16/6/2.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoModel : NSObject

@property (nonatomic, strong) NSString *error_code;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
