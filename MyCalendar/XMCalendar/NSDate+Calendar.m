//
//  NSDate+Calendar.m
//  CalendarDemo
//
//  Created by xiaoming han on 15/3/30.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#import "NSDate+Calendar.h"

@implementation NSCalendar (XMExtension)

+ (instancetype)xm_sharedCalendar
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSCalendar currentCalendar];
    });
    return instance;
}

@end

@implementation NSDate (Calendar)

- (NSString *)description
{
    return [self xm_stringWithFormat:@"yyyy-MM-dd EE"];
}

- (NSInteger)xm_year
{
    NSDateComponents *component = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitYear fromDate:self];
    return component.year;
}

- (NSInteger)xm_month
{
    NSDateComponents *component = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitMonth
                                              fromDate:self];
    return component.month;
}

- (NSInteger)xm_day
{
    NSDateComponents *component = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitDay
                                              fromDate:self];
    return component.day;
}

- (NSInteger)xm_weekday
{
    NSDateComponents *component = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitWeekday fromDate:self];
    return component.weekday;
}

- (NSInteger)xm_hour
{
    NSDateComponents *component = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitHour
                                              fromDate:self];
    return component.hour;
}

- (NSInteger)xm_minute
{
    NSDateComponents *component = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitMinute
                                              fromDate:self];
    return component.minute;
}

- (NSInteger)xm_second
{
    NSDateComponents *component = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitSecond
                                              fromDate:self];
    return component.second;
}

- (NSInteger)xm_weekOrdinal
{
    NSDateComponents *component = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self];
    return component.weekdayOrdinal;
}

- (NSInteger)xm_numberOfDaysInMonth
{
    NSRange days = [[NSCalendar xm_sharedCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return days.length;
}

- (NSInteger)xm_numberOfWeeksInMonth
{
    NSRange range = [[NSCalendar xm_sharedCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

- (NSInteger)xm_weekOfMonth
{
    NSDateComponents *component = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self];
    return component.weekOfMonth;
}

- (NSInteger)xm_weekOfYear
{
    NSDateComponents *component = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitWeekOfYear fromDate:self];
    return component.weekOfYear;
}

#pragma mark - 

- (NSString *)xm_stringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSDate *)xm_dateByAddingMonths:(NSInteger)months
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    
    return [[NSCalendar xm_sharedCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)xm_dateBySubtractingMonths:(NSInteger)months
{
    return [self xm_dateByAddingMonths:-months];
}

- (NSDate *)xm_dateByAddingDays:(NSInteger)days
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    return [[NSCalendar xm_sharedCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)xm_dateBySubtractingDays:(NSInteger)days
{
    return [self xm_dateByAddingDays:-days];
}

- (NSInteger)xm_yearsFrom:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitYear fromDate:date toDate:self options:0];
    return components.year;
}

- (NSInteger)xm_monthsFrom:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitMonth fromDate:date toDate:self options:0];
    return components.month;
}

- (NSInteger)xm_weeksFrom:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:date toDate:self options:0];
    
    return components.weekdayOrdinal;
}

- (NSInteger)xm_daysFrom:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar xm_sharedCalendar] components:NSCalendarUnitDay fromDate:date toDate:self options:0];
    return components.day;
}

#pragma mark - 

- (NSDate *)xm_firstDayOfTheWeekInMonth
{
    NSDate *firstDayOfTheWeek = nil;
    if ([[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&firstDayOfTheWeek interval:NULL forDate:self])
    {
        NSDate *firstDayOfTheMonth = [self xm_firstDayOfTheMonth];
        if (firstDayOfTheWeek.xm_month == firstDayOfTheMonth.xm_month)
        {
            return firstDayOfTheWeek;
        }
        else
        {
            return firstDayOfTheMonth;
        }
    }
    
    return firstDayOfTheWeek;
}

- (NSDate *)xm_firstDayOfTheMonth
{
    return [NSDate xm_dateWithYear:self.xm_year month:self.xm_month day:1];
}

- (NSDate *)xm_dateInTheWeekWithWeekday:(NSInteger)weekday
{
    if (weekday < 1)
    {
        weekday = 1;
    }
    
    if (weekday > 7)
    {
        weekday = 7;
    }
    
    NSDate *firstDayOfTheWeek = nil;
    if ([[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&firstDayOfTheWeek interval:NULL forDate:self])
    {
        return [firstDayOfTheWeek xm_dateByAddingDays:weekday - 1];

    }
    return nil;
}

- (NSDate *)xm_dateInTheMonthWithDay:(NSInteger)day
{
    if (day < 1)
    {
        day = 1;
    }
    
    if (day > self.xm_numberOfDaysInMonth)
    {
        day = self.xm_numberOfDaysInMonth;
    }
    
    return [NSDate xm_dateWithYear:self.xm_year month:self.xm_month day:day];
}

- (NSInteger)xm_weekRangeFrom:(NSDate *)date
{
    NSInteger weekCount = [self xm_daysFrom:date] / 7;
    
    NSDate *lastWholeWeekDay = [date xm_dateByAddingDays:weekCount * 7];
    
    // in the same year
    if (lastWholeWeekDay.xm_year == self.xm_year)
    {
        if (lastWholeWeekDay.xm_weekOfYear != self.xm_weekOfYear)
        {
            ++weekCount;
        }
    }
    else
    {
        // lastWholeWeekDay must earlier than self date
        if (lastWholeWeekDay.xm_weekday > self.xm_weekday)
        {
            ++weekCount;
        }
    }
    
    return weekCount;
}

- (BOOL)xm_isEqualToDateForMonth:(NSDate *)date
{
    return self.xm_year == date.xm_year && self.xm_month == date.xm_month;
}

- (BOOL)xm_isEqualToDateForDay:(NSDate *)date
{
    return self.xm_year == date.xm_year && self.xm_month == date.xm_month && self.xm_day == date.xm_day;
}

#pragma mark -

+ (instancetype)xm_dateFromString:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}

+ (instancetype)xm_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    return [[NSCalendar xm_sharedCalendar] dateFromComponents:components];
}

@end
