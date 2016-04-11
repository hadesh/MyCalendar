//
//  XMCalendar.h
//  XMCalendar
//
//  Created by xiaoming han on 15/3/30.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMCalendarComponents.h"

@protocol XMCalendarDataProvider;

@interface XMCalendar : NSObject

@property (nonatomic, readonly) NSInteger minYear;
@property (nonatomic, readonly) NSInteger maxYear;

@property (nonatomic, strong) id<XMCalendarDataProvider> dataProvider;

+ (instancetype)sharedInstance;

- (XMCalendarComponents *)componentsFromDate:(NSDate *)date;

+ (NSString *)subtitleForCalendarComponents:(XMCalendarComponents *)components;

@end
