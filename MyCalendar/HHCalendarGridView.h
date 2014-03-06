//
//  HHCalendarGridView.h
//  MyCalendar
//
//  Created by xiaoming han on 14-3-1.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HHCalendarGridState)
{
    HHCalendarGridStateNormal,
    HHCalendarGridStateWeekend,
    HHCalendarGridStateToday,
    HHCalendarGridStateSelected
};

@class HHCalendarComponents;

@interface HHCalendarGridView : UIView

@property (nonatomic, strong) HHCalendarComponents *calendarComponent;
@property (nonatomic, assign) HHCalendarGridState state;

- (instancetype)initWitComponent:(HHCalendarComponents *)components;


@end
