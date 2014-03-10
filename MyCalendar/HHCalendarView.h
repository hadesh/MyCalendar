//
//  HHCalendarView.h
//  MyCalendar
//
//  Created by xiaoming han on 14-3-1.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCalendar.h"

typedef NS_ENUM(NSInteger, HHCalendarType)
{
    HHCalendarTypeYear,
    HHCalendarTypeMonth
};

@protocol HHCalendarDelegate;

@interface HHCalendarView : UIView

@property (nonatomic, assign) id <HHCalendarDelegate> delegate;

@property (nonatomic, assign) HHCalendarType calendarType;

@property (nonatomic, readonly) HHCalendarComponents *currentMonthComponents;

@property (nonatomic, readonly) HHCalendarComponents *todayComponents;

@property (nonatomic, readonly) NSInteger startYear;

@property (nonatomic, readonly) NSInteger endYear;

@property (nonatomic, assign) NSInteger monthOffset; // 当前显示月和今天所在月的差

- (void)showsWithYear:(NSInteger)year month:(NSInteger)month;

- (void)showsWithDate:(NSDate *)date;

- (void)showsToday;

@end

@protocol HHCalendarDelegate <NSObject>

- (void)calendarView:(HHCalendarView *)calendarView didCalendarTapped:(HHCalendarComponents *)components;

@end


