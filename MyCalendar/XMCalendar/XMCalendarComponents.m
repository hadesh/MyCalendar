//
//  XMCalendarComponents.m
//  CalendarDemo
//
//  Created by xiaoming han on 15/3/30.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#import "XMCalendarComponents.h"

@implementation XMCalendarComponents

- (NSString *)description
{
   return [NSString stringWithFormat:@"公元 %d年%d月%d日 星期%@ - %@，农历 %@（%@）年 %@月 %@ - %@ - %@", @(self.year).intValue, @(self.month).intValue, @(self.day).intValue, self.weekdayText, self.holidayText, self.lunarYear, self.lunarZodiac, self.lunarMonth, self.lunarDay, self.solarTerm, self.lunarHoliday];
}

@end
