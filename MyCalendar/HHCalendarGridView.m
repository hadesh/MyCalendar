//
//  HHCalendarGridView.m
//  MyCalendar
//
//  Created by xiaoming han on 14-3-1.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import "HHCalendarGridView.h"
#import "HHCalendarComponents.h"
#import "UIColor+Extension.h"

#define kGridDefaultSize            45
#define kDefaultMargin              5

@interface HHCalendarGridView ()
{
    NSArray *_colorArray;
    
    NSInteger _fontSizeNormal;
    NSInteger _fontSizeLunar;
    
    NSString *_lunarString;
}

@end

@implementation HHCalendarGridView

@synthesize calendarComponent = _calendarComponent;
@synthesize state = _state;

- (instancetype)initWitComponent:(HHCalendarComponents *)components
{
    if (components == nil)
    {
        return nil;
    }
    
    CGRect frame = CGRectMake(kGridDefaultSize * (components.weekday - 1), kGridDefaultSize * (components.weekOfMonth - 1), kGridDefaultSize, kGridDefaultSize);
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.calendarComponent = components;
        
        [self initAttributes];
    }
    
    return self;
}

- (void)initAttributes
{
    _fontSizeNormal     = 18;
    _fontSizeLunar      = 12;
    
    _state = HHCalendarGridStateNormal;
    
    _colorArray = @[@"#0D1A23", @"#BB1224", @"#0D4F8B", @"#5B7222"];
    
    _lunarString = _calendarComponent.lunarDay;
    
    if (_calendarComponent.solarTermTitle)
    {
        _lunarString = _calendarComponent.solarTermTitle;
    }
    
    if (_calendarComponent.lunarHolidayTitle)
    {
        _lunarString = _calendarComponent.lunarHolidayTitle;
        _state = HHCalendarGridStateWeekend;
    }

}

- (void)setState:(HHCalendarGridState)state
{
    if (_state == state || state < HHCalendarGridStateNormal || state > HHCalendarGridStateSelected)
    {
        return;
    }
    
    _state = state;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.calendarComponent == nil)
    {
        return;
    }
    
    // obtain current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIColor *currentColor = [UIColor colorWithHexString:_colorArray[_state]];
    CGContextSetFillColorWithColor(context, currentColor.CGColor);
    
    UIFont *font = [UIFont boldSystemFontOfSize:_fontSizeNormal];
    
    NSString *dayString = [NSString stringWithFormat:@"%d", _calendarComponent.day];
    CGSize sizeDay = [dayString sizeWithFont:font];
    double startX =  (kGridDefaultSize - sizeDay.width) / 2.0;
    
    [dayString drawAtPoint:CGPointMake(startX, kDefaultMargin) withFont:font];
    
    //
    UIFont *fontLunar = [UIFont systemFontOfSize:_fontSizeLunar];
    
    CGSize sizeLunar = [_lunarString sizeWithFont:fontLunar];
    double startXLunar =  (kGridDefaultSize - sizeLunar.width) / 2.0;
    
    [_lunarString drawAtPoint:CGPointMake(startXLunar, kGridDefaultSize - sizeLunar.height - kDefaultMargin) withFont:fontLunar];
    
    // restore context state
    CGContextRestoreGState(context);
}

@end
