//
//  NSDate+Calendar.h
//  CalendarDemo
//
//  Created by xiaoming han on 15/3/30.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (XMExtension)

+ (instancetype)xm_sharedCalendar;

@end

@interface NSDate (Calendar)

@property (nonatomic, readonly) NSInteger xm_year;
@property (nonatomic, readonly) NSInteger xm_month;
@property (nonatomic, readonly) NSInteger xm_day;
@property (nonatomic, readonly) NSInteger xm_weekday;
@property (nonatomic, readonly) NSInteger xm_hour;
@property (nonatomic, readonly) NSInteger xm_minute;
@property (nonatomic, readonly) NSInteger xm_second;
@property (nonatomic, readonly) NSInteger xm_weekOfMonth;
@property (nonatomic, readonly) NSInteger xm_weekOfYear;

@property (nonatomic, readonly) NSInteger xm_weekOrdinal;
@property (nonatomic, readonly) NSInteger xm_numberOfDaysInMonth;
@property (nonatomic, readonly) NSInteger xm_numberOfWeeksInMonth;

- (NSDate *)xm_dateByAddingMonths:(NSInteger)months;
- (NSDate *)xm_dateBySubtractingMonths:(NSInteger)months;
- (NSDate *)xm_dateByAddingDays:(NSInteger)days;
- (NSDate *)xm_dateBySubtractingDays:(NSInteger)days;
- (NSString *)xm_stringWithFormat:(NSString *)format;

- (NSInteger)xm_yearsFrom:(NSDate *)date;
- (NSInteger)xm_monthsFrom:(NSDate *)date;
- (NSInteger)xm_weeksFrom:(NSDate *)date;
- (NSInteger)xm_daysFrom:(NSDate *)date;

- (NSDate *)xm_firstDayOfTheWeekInMonth;
- (NSDate *)xm_firstDayOfTheMonth;

- (NSDate *)xm_dateInTheWeekWithWeekday:(NSInteger)weekday;
- (NSDate *)xm_dateInTheMonthWithDay:(NSInteger)day;

/**
 *  两个时间段之间经过的星期数。
 *  间隔天数小于一周但是处在两周的，算经过一周。
 */
- (NSInteger)xm_weekRangeFrom:(NSDate *)date;

- (BOOL)xm_isEqualToDateForMonth:(NSDate *)date;
- (BOOL)xm_isEqualToDateForDay:(NSDate *)date;

+ (instancetype)xm_dateFromString:(NSString *)string format:(NSString *)format;
+ (instancetype)xm_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end
