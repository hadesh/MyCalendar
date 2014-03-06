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

@interface ViewController ()

@property (nonatomic, strong) HHCalendarView *calendarView;

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
    
    
    self.calendarView = [[HHCalendarView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.calendarView];
    
    [self updateUI];
    
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
    self.title = [NSString stringWithFormat:@"%d年%d月[%@年(%@)]", self.calendarView.currentYearComponents.yaer, self.calendarView.currentYearComponents.month, self.calendarView.currentYearComponents.lunarYear, self.calendarView.currentYearComponents.lunarZodiac];
    
    NSInteger prevMonth = self.calendarView.currentYearComponents.month - 1 > 0 ? self.calendarView.currentYearComponents.month - 1 : 12;
    NSInteger nextMonth = self.calendarView.currentYearComponents.month + 1 < 13 ? self.calendarView.currentYearComponents.month + 1 : 1;
    
    self.navigationItem.leftBarButtonItem.title = [NSString stringWithFormat:@"%d月", prevMonth];
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%d月", nextMonth];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
