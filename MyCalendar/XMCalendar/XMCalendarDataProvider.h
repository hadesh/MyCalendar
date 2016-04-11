//
//  XMCalendarDataProvider.h
//  CalendarDemo
//
//  Created by xiaoming han on 15/4/1.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMCalendarDataProvider <NSObject>

- (NSArray *)heavenlyStems;
- (NSArray *)earthlyBranches;
- (NSArray *)lunarZodiacs;
- (NSArray *)solarTerms;
- (NSArray *)lunarMonthItems;
- (NSArray *)lunarDayItems;
- (NSArray *)weekdaySymbols;
- (NSDictionary *)lunarHolidays;
- (NSDictionary *)solarHolidays;

@end

@interface XMCalendarDataProvider : NSObject<XMCalendarDataProvider>

@end
