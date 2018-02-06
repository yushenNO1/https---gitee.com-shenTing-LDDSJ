//
//  CloverText.m
//  CloverTextDemo
//
//  Created by FengXingTianXia on 14-2-27.
//  Copyright (c) 2014年 Clover. All rights reserved.
//

#import "CloverText.h"

@implementation CloverText

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
         
         UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
         
         [self addGestureRecognizer:myTap];
    
         
        // Initialization code
        self.textField = [[UITextView alloc]initWithFrame:WDH_CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.textField.text = placeholder;
        self.textField.textColor = [UIColor colorWithRed:215 / 255.0 green:215 / 255.0 blue:215 / 255.0 alpha:1];
        self.textField.font = [UIFont systemFontOfSize:17* kScreenHeight1];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.editable = NO;
        [self addSubview:self.textField];
        [self sendSubviewToBack:self.textField];
        self.delegate = self;
    }
    return self;
}

- (void)scrollTap:(id)sender {
     [self becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.text.length == 0) {
        self.textField.hidden = NO;
    }
    else {
        self.textField.hidden = YES;
    }
}

@end
