//
//  XMCalendarViewCell.h
//  CalendarDemo
//
//  Created by xiaoming han on 15/3/30.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, XMCalendarCellState)
{
    XMCalendarCellStateNormal      = 0,
    XMCalendarCellStateSelected    = 1,
    XMCalendarCellStateToday       = 1 << 1,
    XMCalendarCellStateSpecial     = 1 << 2
};

@interface XMCalendarViewCell : UICollectionViewCell

@property (nonatomic, copy) NSDate *date;

@property (nonatomic, strong) UIColor *eventColor;

@property (nonatomic, strong) NSDictionary *titleColors;
@property (nonatomic, strong) NSDictionary *subtitleColors;
@property (nonatomic, strong) NSDictionary *backgroundColors;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) UIFont *titleFont;
@property (nonatomic, copy) UIFont *subtitleFont;

@property (nonatomic, assign) BOOL isToday;
@property (nonatomic, assign) BOOL isSpecial;
@property (nonatomic, assign) BOOL hasEvent;

- (void)configureCell;

- (void)performSelectionAnimation:(BOOL)selected;

@end
