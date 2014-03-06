//
//  CalendarPickerView.h
//  MyCalendar
//
//  Created by xiaoming han on 14-3-6.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarPickerView : UIView

@property (nonatomic, assign) NSInteger startYear;
@property (nonatomic, assign) NSInteger endYear;

- (id)initWithFormYear:(NSInteger)fromYear endYear:(NSInteger)endYear;

- (void)setSelectedWithYear:(NSInteger)year month:(NSInteger)month;

- (NSInteger)getSelectedYear;
- (NSInteger)getSelectedMonth;

@end