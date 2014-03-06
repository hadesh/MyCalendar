//
//  HHCalendar.h
//  MyCalendar
//
//  Created by xiaoming han on 14-3-1.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHCalendarComponents.h"

@interface HHCalendar : NSObject

+ (HHCalendar *)sharedCalendar;

- (HHCalendarComponents *)componentsFromDate:(NSDate *)date;
- (HHCalendarComponents *)componentsFromComponents:(NSDateComponents *)comp;

@end
