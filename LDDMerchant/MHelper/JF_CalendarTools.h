//
//  JF_CalendarTools.h
//  JF_Calendar
//
//  Created by 孙建飞 on 16/5/16.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JF_CalendarTools : NSObject

+(int)getWeekOfFirstDayOfMonthWithYear:(int)year withMonth:(int)month;
+(int)getDaysOfMonthWithYear:(int)year withMonth:(int)month;
+(int)getYear;
+(int)getMonth;
+(int)getDay;
+(BOOL)isLoopYear:(NSInteger)year;

@end
