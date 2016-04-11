//
//  XMCalendarView.h
//  CalendarDemo
//
//  Created by xiaoming han on 15/3/30.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+Calendar.h"

@class XMCalendarView;

typedef NS_ENUM(NSInteger, XMCalendarViewType)
{
    XMCalendarViewTypeWeekly,
    XMCalendarViewTypeMonthly
};

#pragma mark - XMCalendarView

@protocol XMCalendarViewDelegate <NSObject>
@optional

- (BOOL)calendar:(XMCalendarView *)calendar shouldSelectDate:(NSDate *)date;
- (void)calendar:(XMCalendarView *)calendar didSelectDate:(NSDate *)date;

// monthly or weekly
- (void)calendarCurrentDateDidChange:(XMCalendarView *)calendar;

@end

@protocol XMCalendarViewDataSource <NSObject>
@optional

- (NSString *)calendar:(XMCalendarView *)calendar subtitleForDate:(NSDate *)date;
- (BOOL)calendar:(XMCalendarView *)calendar hasEventForDate:(NSDate *)date;

@end

#pragma mark - XMCalendarView

@interface XMCalendarView : UIView

@property (nonatomic, assign) id<XMCalendarViewDelegate> delegate;
@property (nonatomic, assign) id<XMCalendarViewDataSource> dataSource;

// XMCalendarViewTypeMonthly时为当前月，Weekly时为当前周。
@property (nonatomic, copy) NSDate *currentDate;

@property (nonatomic, copy) NSDate *selectedDate;

@property (nonatomic, readonly) XMCalendarViewType calendarType;

+ (instancetype)calendarWithType:(XMCalendarViewType)type;

//
- (void)reloadData;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *subtitleFont;
@property (nonatomic, strong) UIFont *weekdayFont;

@property (nonatomic, strong) UIColor *eventColor;
@property (nonatomic, strong) UIColor *weekdayTextColor;

@property (nonatomic, strong) UIColor *titleDefaultColor;
@property (nonatomic, strong) UIColor *titleSelectionColor;
@property (nonatomic, strong) UIColor *titleTodayColor;
@property (nonatomic, strong) UIColor *titleSpecialColor;

@property (nonatomic, strong) UIColor *subtitleDefaultColor;
@property (nonatomic, strong) UIColor *subtitleSelectionColor;
@property (nonatomic, strong) UIColor *subtitleTodayColor;
@property (nonatomic, strong) UIColor *subtitleSpecialColor ;

@property (nonatomic, strong) UIColor *backgroundSelectionColor;
@property (nonatomic, strong) UIColor *backgroundTodayColor;

@end





