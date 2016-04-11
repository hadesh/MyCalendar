//
//  XMCalendarViewCell.m
//  CalendarDemo
//
//  Created by xiaoming han on 15/3/30.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#import "XMCalendarViewCell.h"
#import "UIView+Extension.h"

#define kAnimationDuration 0.15

@interface XMCalendarViewCell ()
{
    CAShapeLayer *_backgroundLayer;
    CAShapeLayer *_eventLayer;
    
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
}

@end

@implementation XMCalendarViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        //        self.layer.borderWidth = 1;
        //        self.layer.borderColor = [UIColor greenColor].CGColor;
        
        _titleFont = [UIFont systemFontOfSize:15];
        _subtitleFont = [UIFont systemFontOfSize:10];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = _titleFont;
        titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.font = _subtitleFont;
        subtitleLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:subtitleLabel];
        _subtitleLabel = subtitleLabel;
        
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.hidden = YES;
        [self.contentView.layer insertSublayer:_backgroundLayer atIndex:0];
        
        _eventLayer = [CAShapeLayer layer];
        _eventLayer.fillColor = [UIColor cyanColor].CGColor;
        _eventLayer.hidden = YES;
        [self.contentView.layer addSublayer:_eventLayer];
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    CGFloat titleHeight = self.bounds.size.height * 0.9;
    CGFloat diameter = MIN(titleHeight, self.bounds.size.width);
    _backgroundLayer.frame = CGRectMake((self.bounds.size.width - diameter) / 2,
                                        (self.bounds.size.height - diameter) / 2,
                                        diameter,
                                        diameter);
    
    _backgroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath;
    
    CGFloat eventSize = diameter * 0.1;
    _eventLayer.frame = CGRectMake(0, 0, eventSize, eventSize);
    _eventLayer.position = CGPointMake(_backgroundLayer.position.x, _backgroundLayer.position.y + diameter * 0.5 - eventSize);
    _eventLayer.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer.bounds].CGPath;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [CATransaction setDisableActions:YES];
}

- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary
{
    if (self.isSelected)
    {
        return dictionary[@(XMCalendarCellStateSelected)];
    }
    if (self.isToday)
    {
        return dictionary[@(XMCalendarCellStateToday)];
    }
    if (self.isSpecial)
    {
        return dictionary[@(XMCalendarCellStateSpecial)];
    }
    
    return dictionary[@(XMCalendarCellStateNormal)];
}

#pragma mark -

- (void)configureCell
{
    _titleLabel.font = _titleFont;
    _subtitleLabel.font = _subtitleFont;
    
    _titleLabel.text = _title;
    _subtitleLabel.text = _subtitle;
    _titleLabel.textColor = [self colorForCurrentStateInDictionary:_titleColors];
    _subtitleLabel.textColor = [self colorForCurrentStateInDictionary:_subtitleColors];
    
    CGFloat titleHeight = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}].height;
    if (_subtitleLabel.text.length > 0)
    {
        _subtitleLabel.hidden = NO;
        CGFloat subtitleHeight = titleHeight * 0.8;
        CGFloat height = titleHeight + subtitleHeight;
        _titleLabel.frame = CGRectMake(0,
                                       (self.contentView.xm_height - height) * 0.5,
                                       self.xm_width,
                                       titleHeight);
        
        _subtitleLabel.frame = CGRectMake(0,
                                          _titleLabel.xm_bottom - (_titleLabel.xm_height-_titleLabel.font.pointSize),
                                          self.xm_width,
                                          subtitleHeight);
    }
    else
    {
        _titleLabel.frame = CGRectMake(0, 0, self.xm_width, self.xm_height);
        _subtitleLabel.hidden = YES;
    }
    
    _backgroundLayer.fillColor = [self colorForCurrentStateInDictionary:_backgroundColors].CGColor;
    _backgroundLayer.hidden = !self.selected && !self.isToday;
    
    _eventLayer.fillColor = _eventColor.CGColor;
    _eventLayer.hidden = !self.hasEvent;
}

- (void)performSelectionAnimation:(BOOL)selected
{
    if (selected != self.selected)
    {
        return;
    }
    
    if (self.selected)
    {
        _backgroundLayer.hidden = NO;
        _backgroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath;
        _backgroundLayer.fillColor = [self colorForCurrentStateInDictionary:_backgroundColors].CGColor;
        CAAnimationGroup *group = [CAAnimationGroup animation];
        CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        zoomOut.fromValue = @0.3;
        zoomOut.toValue = @1.2;
        zoomOut.duration = kAnimationDuration/4*3;
        CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        zoomIn.fromValue = @1.2;
        zoomIn.toValue = @1.0;
        zoomIn.beginTime = kAnimationDuration/4*3;
        zoomIn.duration = kAnimationDuration/4;
        group.duration = kAnimationDuration;
        group.animations = @[zoomOut, zoomIn];
        [_backgroundLayer addAnimation:group forKey:@"bounce"];
    }
    else
    {
        _backgroundLayer.hidden = YES;
    }
    
    [self configureCell];
}

@end
