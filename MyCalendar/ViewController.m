//
//  ViewController.m
//  MyCalendar
//
//  Created by xiaoming han on 14-2-27.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>

#import "XMCalendarKit.h"
#import "CalendarPickerView.h"

@interface ViewController ()<XMCalendarViewDelegate, XMCalendarViewDataSource>

@property (nonatomic, strong) XMCalendarView *calendarView;

@property (nonatomic, strong) CalendarPickerView *calendarPicker;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"today" style:UIBarButtonItemStyleBordered target:self action:@selector(showToday:)];

    _calendarView = [[XMCalendarView alloc] initWithFrame:CGRectZero];
    
    _calendarView.delegate = self;
    _calendarView.dataSource = self;
    
    [self.view addSubview:_calendarView];
}

- (void)viewDidLayoutSubviews
{
    _calendarView.frame = self.view.bounds;
}

- (void)showToday:(id)sender
{
    self.calendarView.currentDate = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - XMCalendar

- (BOOL)calendar:(XMCalendarView *)calendar shouldSelectDate:(NSDate *)date
{
    return YES;
}

- (void)calendar:(XMCalendarView *)calendar didSelectDate:(NSDate *)date
{
    XMCalendarComponents *components = [[XMCalendar sharedInstance] componentsFromDate:date];
    
    NSLog(@"did select date %@", components);
}

- (void)calendarCurrentDateDidChange:(XMCalendarView *)calendar
{
    NSLog(@"did change to month %@",[calendar.currentDate xm_stringWithFormat:@"yyyy-MM-dd EE"]);
    
    calendar.selectedDate = [calendar.currentDate xm_dateInTheMonthWithDay:calendar.selectedDate.xm_day];
}

- (NSString *)calendar:(XMCalendarView *)calendarView subtitleForDate:(NSDate *)date
{
    XMCalendarComponents *components = [[XMCalendar sharedInstance] componentsFromDate:date];
    
    return [XMCalendar subtitleForCalendarComponents:components];
}

- (BOOL)calendar:(XMCalendarView *)calendar hasEventForDate:(NSDate *)date
{
    return NO;
}

@end
