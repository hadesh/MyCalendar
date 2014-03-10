//
//  ViewController.m
//  MyCalendar
//
//  Created by xiaoming han on 14-2-27.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>

#import "HHCalendarView.h"
#import "CalendarPickerView.h"

@interface ViewController ()

@property (nonatomic, strong) HHCalendarView *calendarView;
@property (nonatomic, strong) CalendarPickerView *calendarPicker;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(prevAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@">"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(nextAction)];
    
    self.calendarView = [[HHCalendarView alloc] initWithFrame:CGRectMake(0, 0, 320, 380)];
    [self.view addSubview:self.calendarView];
    
    self.calendarPicker = [[CalendarPickerView alloc] initWithFormYear:self.calendarView.startYear endYear:self.calendarView.endYear];
    
    self.calendarPicker.hidden = YES;
    [self.view addSubview:self.calendarPicker];
    
    [self updateUI];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    
    button.frame = CGRectMake(5, 440, 32, 32);
    [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    button1.frame = CGRectMake(250, 440, 60, 30);
    [button1 setTitle:@"显示今天" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(todayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
}

- (void)todayAction:(id)sender
{
    [self.calendarView showsToday];
    [self updateUI];
}

- (void)tapAction:(id)sender
{
    if (self.calendarPicker.hidden)
    {
        self.calendarPicker.hidden = NO;
        [self.calendarPicker setSelectedWithYear:self.calendarView.currentMonthComponents.year month:self.calendarView.currentMonthComponents.month];
        
        self.calendarView.userInteractionEnabled = NO;
        
    }
    else
    {
        NSInteger year = [self.calendarPicker getSelectedYear];
        NSInteger month = [self.calendarPicker getSelectedMonth];
        
        [self.calendarView showsWithYear:year month:month];
        
        self.calendarPicker.hidden = YES;
        self.calendarView.userInteractionEnabled = YES;
        
        [self updateUI];
    }
}

- (void)prevAction
{
    self.calendarView.monthOffset -= 1;
    [self updateUI];
}

- (void)nextAction
{
    self.calendarView.monthOffset += 1;
    [self updateUI];
}

- (void)updateUI
{
    self.title = [NSString stringWithFormat:@"%d年%d月[%@年(%@)]", self.calendarView.currentMonthComponents.year, self.calendarView.currentMonthComponents.month, self.calendarView.currentMonthComponents.lunarYear, self.calendarView.currentMonthComponents.lunarZodiac];
    
    NSInteger prevMonth = self.calendarView.currentMonthComponents.month - 1 > 0 ? self.calendarView.currentMonthComponents.month - 1 : 12;
    NSInteger nextMonth = self.calendarView.currentMonthComponents.month + 1 < 13 ? self.calendarView.currentMonthComponents.month + 1 : 1;
    
    self.navigationItem.leftBarButtonItem.title = [NSString stringWithFormat:@"%d月", prevMonth];
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%d月", nextMonth];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
