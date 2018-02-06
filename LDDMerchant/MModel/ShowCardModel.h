//
//  ShowCardModel.h
//  LSKKApp
//
//  Created by 云盛科技 on 16/4/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowCardModel : NSObject

@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *cardNo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *subbranch;
@property (nonatomic, copy) NSString *userId;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
