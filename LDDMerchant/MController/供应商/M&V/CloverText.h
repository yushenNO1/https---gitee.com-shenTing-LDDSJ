//
//  CloverText.h
//  CloverTextDemo
//
//  Created by FengXingTianXia on 14-2-27.
//  Copyright (c) 2014年 Clover. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CloverText : UITextView <UITextViewDelegate>

@property(nonatomic,copy) NSString *placeholder;
@property(nonatomic,strong) UITextView *textField;

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;


@end
