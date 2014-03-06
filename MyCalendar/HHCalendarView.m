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
@synthesize currentYearComponents = _currentYearComponents;
@synthesize todayComponents = _todayComponents;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
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

- (void)showsToday
{
    
    [self initCurrentMonth];
}

#pragma mark - Private

- (void)updateInfoLabelWithComponents:(HHCalendarComponents *)components
{
    if (components == nil)
    {
        return;
    }
    
    NSString *info = [NSString stringWithFormat:@"%d-%d-%d %@(%@)年%@ %@", components.yaer, components.month, components.day, components.lunarYear, components.lunarZodiac, components.lunarMonth, components.lunarDay];
    
    _selectedDayLabel.text = info;
}

- (void)updateCurrentYearComponentsWithComponents:(NSDateComponents *)comp
{
    _currentYearComponents = [[HHCalendar sharedCalendar] componentsFromComponents:comp];
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
    comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear)fromDate:currentMonthDate];
    [comps setDay:1];
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    NSUInteger dayCount = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
    
    for (int i = 0; i < dayCount; ++i)
    {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = i;
        
        NSDate *currentDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
        
        HHCalendarComponents *HHcomponents = [HHcalendar componentsFromDate:currentDate];
        
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
    
    [self updateCurrentYearComponentsWithComponents:comps];
}

- (void)initInfoLabel
{
    _selectedDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _titleView.bounds.size.height + _contentView.bounds.size.height - kInfoLabelDefaultHeight * 4, _contentView.bounds.size.width, kInfoLabelDefaultHeight)];
    
    [self addSubview:_selectedDayLabel];
    
    [self updateInfoLabelWithComponents:_todayComponents];
}

- (void)initCurrentMonth
{
    [self initViewByMountOffset:0];
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
