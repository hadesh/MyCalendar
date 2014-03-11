//
//  CalendarPickerView.m
//  MyCalendar
//
//  Created by xiaoming han on 14-3-6.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import "CalendarPickerView.h"

@interface CalendarPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger _yearCount;
}

@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation CalendarPickerView
@synthesize startYear = _startYear;
@synthesize endYear = _endYear;

- (id)initWithFormYear:(NSInteger)fromYear endYear:(NSInteger)endYear
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 260)];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.95];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.showsSelectionIndicator = YES;
        
        [self addSubview:self.pickerView];
        
        _startYear = fromYear;
        _endYear = endYear;
        
        _yearCount = _endYear - _startYear;
    }
    
    return self;
}

- (void)setSelectedWithYear:(NSInteger)year month:(NSInteger)month
{
    if (year < _startYear || year > _endYear || month < 1 || month > 13)
    {
        return;
    }
    
    [self.pickerView selectRow:(year - _startYear) inComponent:0 animated:NO];

    [self.pickerView selectRow:(month - 1) inComponent:1 animated:NO];
}

- (NSInteger)getSelectedYear
{
    return [self.pickerView selectedRowInComponent:0] + _startYear;
}

- (NSInteger)getSelectedMonth
{
    return [self.pickerView selectedRowInComponent:1] + 1;
}

#pragma mark - UIPickerDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _yearCount;
    }
    
    return 12;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [NSString stringWithFormat:@"%ld", _startYear + row];
    }
    
    return [NSString stringWithFormat:@"%ld", row + 1];
}

@end
