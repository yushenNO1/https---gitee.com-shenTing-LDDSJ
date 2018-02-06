//
//  CategoryModel.h
//  YSApp
//
//  Created by 王松松 on 2016/11/11.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property (nonatomic, copy) NSString * cateId;
@property (nonatomic, copy) NSString * children;
@property (nonatomic, copy) NSString * fee;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * parentId;
@property (nonatomic, copy) NSString * profile;
@property (nonatomic, copy) NSString * sequence;
@property (nonatomic, assign) BOOL isHot;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)withDrWithDictionary:(NSDictionary *)dic;

@end
