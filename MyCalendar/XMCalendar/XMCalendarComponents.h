//
//  XMCalendarComponents.h
//  CalendarDemo
//
//  Created by xiaoming han on 15/3/30.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMCalendarComponents : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger weekday;
@property (nonatomic, assign) NSInteger weekOfMonth;
@property (nonatomic, assign) NSInteger weekOfYear;
@property (nonatomic, copy) NSString *weekdayText;
@property (nonatomic, copy) NSString *holidayText;

#pragma mark - LunarComponents

@property (nonatomic, assign) BOOL isLargeMonth; // 大月
@property (nonatomic, assign) BOOL isDoubleMonth; // 闰月

@property (nonatomic, assign) NSInteger lunarMonthIndex; // 1-12
@property (nonatomic, assign) NSInteger lunarDayIndex; // 1-30

@property (nonatomic, assign) NSInteger yearHeavenlyIndex; // 0-9
@property (nonatomic, assign) NSInteger yearEarthlyIndex; // 0-11

// 年（乙未）
@property (nonatomic, copy) NSString *lunarYear;
// 月（正月、腊月）
@property (nonatomic, copy) NSString *lunarMonth;
// 日（初一、十五）
@property (nonatomic, copy) NSString *lunarDay;
// 属相
@property (nonatomic, copy) NSString *lunarZodiac;
// 节气
@property (nonatomic, copy) NSString *solarTerm;
// 农历节日
@property (nonatomic, copy) NSString *lunarHoliday;
// 天干
@property (nonatomic, copy) NSString *yearHeavenlyStem;
// 地支
@property (nonatomic, copy) NSString *yearEarthlyBranch;

@end
