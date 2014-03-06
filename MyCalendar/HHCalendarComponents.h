//
//  HHCalendarComponents.h
//  MyCalendar
//
//  Created by xiaoming han on 14-3-1.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHCalendarComponents : NSObject

@property (nonatomic, assign) NSInteger yaer;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger weekday;
@property (nonatomic, assign) NSInteger weekOfMonth;
@property (nonatomic, assign) NSInteger weekOfYear;
@property (nonatomic, assign) BOOL isLeapMonth;

#pragma mark - LunarComponents

@property (nonatomic, copy) NSString *lunarYear;
@property (nonatomic, copy) NSString *lunarMonth;
@property (nonatomic, copy) NSString *lunarDay;
@property (nonatomic, copy) NSString *lunarZodiac;

@property (nonatomic, assign) NSInteger lunarMonthIndex; // 1-12
@property (nonatomic, assign) NSInteger lunarDayIndex; // 1-30

@property (nonatomic, assign) BOOL isLargeMonth;
@property (nonatomic, assign) BOOL isDoubleMonth;

@property (nonatomic, copy) NSString *solarTermTitle;
@property (nonatomic, copy) NSString *lunarHolidayTitle;

@property (nonatomic, copy) NSString *yearHeavenlyStem;
@property (nonatomic, copy) NSString *yearEarthlyBranch;

//to be done...
@property (nonatomic, copy) NSString *monthHeavenlyStem;
@property (nonatomic, copy) NSString *monthEarthlyBranch;
@property (nonatomic, copy) NSString *dayHeavenlyStem;
@property (nonatomic, copy) NSString *dayEarthlyBranch;

@end
