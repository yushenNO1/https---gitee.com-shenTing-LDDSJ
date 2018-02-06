//
//  TextImageModel.h
//  供应商
//
//  Created by 张敬文 on 2017/8/4.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextImageModel : NSObject
@property (nonatomic, copy) NSString * text;
@property (nonatomic, strong) id image;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * imageCode;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)textWithDictionary:(NSDictionary *)dic;
@end
