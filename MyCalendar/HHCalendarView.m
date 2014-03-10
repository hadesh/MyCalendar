//
//  HHCalendarView.m
//  MyCalendar
//
//  Created by xiaoming han on 14-3-1.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import "HHCalendarView.h"
#import "HHCalendarGridView.h"
#import "NSDate+Calendar.h"

#define kInfoLabelDefaultHeight     44

@interface HHCalendarView ()<UIGestureRecognizerDelegate>
{
    UIView *_titleView;
    UIView *_contentView;
    UILabel *_selectedDayLabel;
    
    HHCalendarGridView *_selectedGrid;
}

@end


@implementation HHCalendarView
@synthesize calendarType = _calendarType;
@synthesize monthOffset = _monthOffset;
@synthesize currentMonthComponents = _currentMonthComponents;
@synthesize todayComponents = _todayComponents;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _calendarType = HHCalendarTypeMonth;
        _monthOffset = -1;
        
        [self initWeekTitleView];
        [self initCurrentMonth];
        [self initInfoLabel];
        
        UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapRecognizer.numberOfTouchesRequired = 1;
        singleTapRecognizer.delegate = self;
        
        [self addGestureRecognizer:singleTapRecognizer];
    }
    return self;
}

#pragma mark - Gestures

- (void)handleSingleTap:(UIGestureRecognizer *)recognizer
{
    UIView *hitView = [_contentView hitTest:[recognizer locationInView:_contentView] withEvent:nil];
    
    if (![hitView isKindOfClass:[HHCalendarGridView class]] || _selectedGrid == hitView)
    {
        return;
    }
    
    HHCalendarGridView *gridView = (HHCalendarGridView *)hitView;
    
    if (_selectedGrid)
    {
        [_selectedGrid setState:HHCalendarGridStateNormal];
        _selectedGrid = nil;
    }
    
    if (gridView.state == HHCalendarGridStateNormal)
    {
        [gridView setState:HHCalendarGridStateSelected];
        _selectedGrid = gridView;
    }
    
    // update ui
    [self updateInfoLabelWithComponents:gridView.calendarComponent];
    
    // notify delegate
    if (_delegate && [_delegate respondsToSelector:@selector(calendarView:didCalendarTapped:)])
    {
        [_delegate calendarView:self didCalendarTapped:gridView.calendarComponent];
    }
    
}

#pragma mark - 

- (void)setCalendarType:(HHCalendarType)calendarType
{
    if (_calendarType == calendarType || calendarType < HHCalendarTypeYear || calendarType > HHCalendarTypeMonth)
    {
        return;
    }
    
    _calendarType = calendarType;
    
    // change view

}

- (void)setMonthOffset:(NSInteger)monthOffset
{
    if (_monthOffset == monthOffset)
    {
        return;
    }
    
    _monthOffset = monthOffset;
    
    [_contentView removeFromSuperview];
    _contentView = nil;
    
    [self initViewByMountOffset:_monthOffset];
    
}

- (void)showsWithYear:(NSInteger)year month:(NSInteger)month
{
    NSInteger currentYear = self.todayComponents.year;
    NSInteger currentMonth = self.todayComponents.month;
    
    NSInteger monthOffset = (year - currentYear) * 12 + (month - currentMonth);
    
    [self setMonthOffset:monthOffset];
}

- (void)showsWithDate:(NSDate *)date
{
    [self showsWithYear:[date year] month:[date month]];
}

- (void)showsToday
{
    [self initCurrentMonth];
}

- (NSInteger)startYear
{
    return [[HHCalendar sharedCalendar] startYear];
}

- (NSInteger)endYear
{
    return [[HHCalendar sharedCalendar] endYear];
}

#pragma mark - Private

- (void)updateInfoLabelWithComponents:(HHCalendarComponents *)components
{
    if (components == nil)
    {
        return;
    }
    
    NSMutableString *info = [NSMutableString stringWithFormat:@"%04d-%02d-%02d %@(%@)年 %@ %@", components.year, components.month, components.day, components.lunarYear, components.lunarZodiac, components.lunarMonth, components.lunarDay];
    
    if (components.lunarHolidayTitle)
    {
        [info appendFormat:@" %@", components.lunarHolidayTitle];
    }
    
    if (components.solarTermTitle)
    {
        [info appendFormat:@" %@", components.solarTermTitle];
    }
    
    _selectedDayLabel.text = info;
}

- (void)initViewByMountOffset:(NSInteger)offset
{
    _selectedGrid = nil;
    
    if (_contentView)
    {
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleView.bounds.size.height + 2, self.bounds.size.width, self.bounds.size.height - _titleView.bounds.size.height)];
    [self addSubview:_contentView];
    
    HHCalendar *HHcalendar = [HHCalendar sharedCalendar];
    
    NSDate *today = [NSDate date];
    
    NSDateComponents *componentMonthOff = [[NSDateComponents alloc] init];
    componentMonthOff.month = offset;
    
    NSDate *currentMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:componentMonthOff toDate:today options:0];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    
    // 年月日获得
    comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear) fromDate:currentMonthDate];
    [comps setDay:1];
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    NSUInteger dayCount = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
    
    for (int i = 0; i < dayCount; ++i)
    {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = i;
        
        NSDate *currentDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
        
        HHCalendarComponents *HHcomponents = [HHcalendar componentsFromDate:currentDate];
        
        if (i == 0)
        {
            // 记录月信息
            _currentMonthComponents = HHcomponents;
        }
        
        HHCalendarGridView *gridView = [[HHCalendarGridView alloc] initWitComponent:HHcomponents];
        
        if ([currentDate sameDayWithDate:today])
        {
            _todayComponents = HHcomponents;
            [gridView setState:HHCalendarGridStateToday];
        }
        if (HHcomponents.weekday == 1 || HHcomponents.weekday == 7)
        {
            [gridView setState:HHCalendarGridStateWeekend];
        }

        
        [_contentView addSubview:gridView];
    }
}

- (void)initInfoLabel
{
    _selectedDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 330, _contentView.bounds.size.width, kInfoLabelDefaultHeight)];
    
    [self addSubview:_selectedDayLabel];
    
    [self updateInfoLabelWithComponents:_todayComponents];
}

- (void)initCurrentMonth
{
    [self setMonthOffset:0];
}

- (void)initWeekTitleView
{
    UIImage *image = [UIImage imageNamed:@"weekdaysBarView.png"];
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_titleView.bounds];
    imageView.image = image;
    
    [_titleView addSubview:imageView];
    
    [self addSubview:_titleView];
}

@end
