//
//  HHCalendarComponents.m
//  MyCalendar
//
//  Created by xiaoming han on 14-3-1.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import "HHCalendarComponents.h"


@implementation HHCalendarComponents

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d %d %d - %d %d %d - %d - %@ %@ %@ - %@ %@", self.year, self.month, self.day, self.weekday, self.weekOfMonth, self.weekOfYear, self.isLeapMonth, self.lunarYear, self.lunarMonth, self.lunarDay, self.lunarHolidayTitle, self.solarTermTitle];
}

@end
