//
//  XMCalendarViewHeader.m
//  CalendarDemo
//
//  Created by xiaoming han on 15/3/31.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#import "XMCalendarViewHeader.h"

@interface XMCalendarViewHeader ()
{
    UILabel *_titleLabel;
}

@end

@implementation XMCalendarViewHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textColor = [UIColor blackColor];
        [self addSubview:titleLabel];
        
        _titleLabel = titleLabel;
    }
    
    return self;
}

#pragma mark -

- (void)setText:(NSString *)text
{
    _titleLabel.text = text;
    
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    
    _titleLabel.frame = CGRectMake(0, 0, size.width, size.height);
}

- (NSString *)text
{
    return _titleLabel.text;
}

- (void)setLabelCenter:(CGPoint)labelCenter
{
    _titleLabel.center = labelCenter;
}

- (CGPoint)labelCenter
{
    return _titleLabel.center;
}

@end
