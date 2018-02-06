//
//  UIColor+Addition.m
//  ContactApp
//
//  Created by 康哥 on 15/9/14.
//  Copyright (c) 2015年 康哥. All rights reserved.
//

#import "UIColor+Addition.h"

@implementation UIColor (Addition)
+ (UIColor *)lightgreenColor {//浅绿色
    return [UIColor colorWithRed:0 green:0.8 blue:0.5 alpha:1.0];
}

+ (UIColor *)xiaobiaotiColor{
     return [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
}

+ (UIColor *)AppColor {
    return [UIColor colorWithRed:23/255.0 green:172/255.0 blue:227/255.0 alpha:1.0];
}

+ (UIColor *)backGray {
    return [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1.0];
}

+ (UIColor *)backWhite {
    return [UIColor colorWithRed:23 / 255.0 green:172 / 255.0 blue:227 / 255.0 alpha:1.0];
}

+ (UIColor *)lightWhiteColor//浅白色
{
    return [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
}

+ (UIColor *)customColor
{
    return [UIColor colorWithRed:255.0 / 255 green:240.0 / 255 blue:245.0 / 255 alpha:1.0];
}

+ (UIColor *)customGreen
{
    return [UIColor colorWithRed:88.0 / 255 green:203.0 / 255 blue:156.0 / 255 alpha:1.0];
}

+ (UIColor *)lightGrayCustom
{
    return [UIColor colorWithRed:230.0 / 255 green:230.0 / 255 blue:230.0 / 255 alpha:1.0];
}

+ (UIColor *)lightBlueColor
{
    return [UIColor colorWithRed:103.0 / 255 green:179.0 / 255 blue:252.0 / 255 alpha:1.0];
}

+ (UIColor *)lightWiteBlueColor
{
    return [UIColor colorWithRed:165.0 / 255 green:212.0 / 255 blue:255.0 / 255 alpha:1.0];
}

+ (UIColor *)pinkColor{
    return [UIColor colorWithRed:255.0 / 255 green:89.0 / 255 blue:111.0 / 255 alpha:1.0];
}


+ (UIColor *) randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
