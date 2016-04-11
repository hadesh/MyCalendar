//
//  XMCalendarView.m
//  CalendarDemo
//
//  Created by xiaoming han on 15/3/30.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#import "XMCalendarView.h"
#import "UIView+Extension.h"

#import "XMCalendarViewCell.h"
#import "XMCalendarViewHeader.h"

#define kDefaultCalendarColumn          7

#define kDefaultCalendarCellHeight      30
#define kDefaultCalendarWeekdayHeight   20
#define kDefaultCalendarHeaderHeight    20
#define kCalendarScrollOffsetBuffer     10

#define kCalendarCellReuseIdentifier        @"calendarCellReuseIdentifier"
#define kCalendarHeaderReuseIdentifier      @"calendarHeaderReuseIdentifier"


@interface XMCalendarView ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *_weekdayLabels;
    NSMutableDictionary *_backgroundColors;
    NSMutableDictionary *_titleColors;
    NSMutableDictionary *_subtitleColors;
    
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_collectionViewFlowLayout;
    
    NSDate *_minDate;
    NSDate *_maxDate;
    
    BOOL _pagingEnabled;
    
    CALayer *_topLineLayer;
    CALayer *_bottomLineLayer;
    
    CGPoint _prevScrollContenOffset;
    BOOL _isAnimatedScrolling;
}

@property (nonatomic, readwrite) XMCalendarViewType calendarType;

@end

@implementation XMCalendarView

+ (instancetype)calendarWithType:(XMCalendarViewType)type
{
    XMCalendarView *instance = [[XMCalendarView alloc] initWithFrame:CGRectZero withType:type];
    
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initializeWithType:XMCalendarViewTypeMonthly];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initializeWithType:XMCalendarViewTypeMonthly];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withType:(XMCalendarViewType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initializeWithType:type];
    }
    return self;
}

- (void)initializeWithType:(XMCalendarViewType)type
{
    //!!!:必须从1号开始，否则indexPathForDate会有问题。
    _minDate = [NSDate xm_dateWithYear:1970 month:1 day:1];
    _maxDate = [NSDate xm_dateWithYear:2099 month:12 day:31];
//    _minDate = [NSDate xm_dateWithYear:2014 month:12 day:1];
//    _maxDate = [NSDate xm_dateWithYear:2015 month:12 day:31];
    
    self.backgroundColor = [UIColor whiteColor];
    
    _isAnimatedScrolling = NO;
    _prevScrollContenOffset = CGPointZero;
    
    _titleFont        = [UIFont systemFontOfSize:15];
    _subtitleFont     = [UIFont systemFontOfSize:10];
    _weekdayFont      = [UIFont systemFontOfSize:12];
    
    _currentDate = [NSDate date];
    
    //colors
    _backgroundColors = [NSMutableDictionary dictionaryWithCapacity:4];
    _backgroundColors[@(XMCalendarCellStateNormal)] = [UIColor clearColor];
    _backgroundColors[@(XMCalendarCellStateSelected)] = [UIColor blueColor];
    _backgroundColors[@(XMCalendarCellStateToday)] = [UIColor redColor];
    _backgroundColors[@(XMCalendarCellStateSpecial)] = [UIColor lightGrayColor];
    
    _titleColors = [NSMutableDictionary dictionaryWithCapacity:4];
    _titleColors[@(XMCalendarCellStateNormal)] = [UIColor blackColor];
    _titleColors[@(XMCalendarCellStateSelected)] = [UIColor whiteColor];
    _titleColors[@(XMCalendarCellStateToday)] = [UIColor whiteColor];
    _titleColors[@(XMCalendarCellStateSpecial)] = [UIColor redColor];
    
    _subtitleColors = [NSMutableDictionary dictionaryWithCapacity:4];
    _subtitleColors[@(XMCalendarCellStateNormal)] = [UIColor darkGrayColor];
    _subtitleColors[@(XMCalendarCellStateSelected)] = [UIColor whiteColor];
    _subtitleColors[@(XMCalendarCellStateToday)] = [UIColor whiteColor];
    _subtitleColors[@(XMCalendarCellStateSpecial)] = [UIColor redColor];
    
    _eventColor = [UIColor cyanColor];
    _weekdayTextColor = [UIColor blackColor];
    
    _calendarType = type;
    _pagingEnabled = NO;
    
    //
    NSArray *weekSymbols = [[NSCalendar currentCalendar] shortStandaloneWeekdaySymbols];
    _weekdayLabels = [NSMutableArray arrayWithCapacity:weekSymbols.count];
    for (int i = 0; i < weekSymbols.count; i++)
    {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        weekdayLabel.text = weekSymbols[i];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.font = _weekdayFont;
        weekdayLabel.textColor = _weekdayTextColor;
        [_weekdayLabels addObject:weekdayLabel];
        [self addSubview:weekdayLabel];
    }
    
    _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [self configureLayout:_collectionViewFlowLayout forCalendarType:_calendarType];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:_collectionViewFlowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.bounces = YES;
    collectionView.pagingEnabled = _pagingEnabled;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[XMCalendarViewCell class] forCellWithReuseIdentifier:kCalendarCellReuseIdentifier];
    
    [collectionView registerClass:[XMCalendarViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCalendarHeaderReuseIdentifier];
    
    [collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [self addSubview:collectionView];
    
    _collectionView = collectionView;
    
    
    _topLineLayer = [CALayer layer];
    _topLineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:_topLineLayer];
    
    _bottomLineLayer = [CALayer layer];
    _bottomLineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:_bottomLineLayer];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _collectionView.frame = CGRectMake(0, kDefaultCalendarWeekdayHeight, self.xm_width, self.xm_height - kDefaultCalendarWeekdayHeight);
    
    CGSize itemSize = CGSizeMake(_collectionView.xm_width / kDefaultCalendarColumn, _collectionView.xm_width / kDefaultCalendarColumn);
    
    if (_calendarType == XMCalendarViewTypeMonthly)
    {
        
        
    }
    else
    {
        if (itemSize.height > _collectionView.xm_height)
        {
            itemSize.height = _collectionView.xm_height;
        }
    }
    
    _collectionViewFlowLayout.itemSize = itemSize;
    
    [_weekdayLabels enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat width = self.xm_width/_weekdayLabels.count;
        CGFloat height = kDefaultCalendarWeekdayHeight;
        
        [obj setFrame:CGRectMake(idx * width, 0, width, height)];
    }];
    
    _topLineLayer.frame = CGRectMake(0, _collectionView.xm_top - 0.5, self.xm_width, 0.5);
    _bottomLineLayer.frame = CGRectMake(0, _collectionView.xm_bottom - 0.5, self.xm_width, 0.5);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        [self scrollToDate:_currentDate animated:NO];
        [_collectionView removeObserver:self forKeyPath:@"contentSize"];
    }
}

#pragma mark - Delegate helpers

- (BOOL)shouldSelectDate:(NSDate *)date
{
    if (date == nil)
    {
        return NO;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(calendar:shouldSelectDate:)])
    {
        return [_delegate calendar:self shouldSelectDate:date];
    }
    else
    {
        return YES;
    }
}

- (void)didSelectDate:(NSDate *)date
{
    if (_delegate && [_delegate respondsToSelector:@selector(calendar:didSelectDate:)])
    {
        [_delegate calendar:self didSelectDate:date];
    }
}

- (void)currentDateDidChange
{
    if (_delegate && [_delegate respondsToSelector:@selector(calendarCurrentDateDidChange:)])
    {
        [_delegate calendarCurrentDateDidChange:self];
    }
}

- (NSString *)subtitleForDate:(NSDate *)date
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(calendar:subtitleForDate:)])
    {
        return [_dataSource calendar:self subtitleForDate:date];
    }
    
    return nil;
}

- (BOOL)hasEventForDate:(NSDate *)date
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(calendar:hasEventForDate:)])
    {
        return [_dataSource calendar:self hasEventForDate:date];
    }
    
    return NO;
}

#pragma mark - Helpers

- (void)configureLayout:(UICollectionViewFlowLayout *)flowLayout forCalendarType:(XMCalendarViewType)type
{
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.minimumLineSpacing = 0.0;
    
    if (type == XMCalendarViewTypeMonthly)
    {
        flowLayout.headerReferenceSize = CGSizeMake(flowLayout.collectionView.bounds.size.width, kDefaultCalendarHeaderHeight);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _pagingEnabled = NO;
    }
    else
    {
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _pagingEnabled = YES;
    }
}

- (NSInteger)rowCountForSection:(NSInteger)section
{
    if (_calendarType == XMCalendarViewTypeMonthly)
    {
        NSDate *currentMonth = [_minDate xm_dateByAddingMonths:section];
        return currentMonth.xm_numberOfWeeksInMonth;
    }
    
    return 1;
}

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated
{
    NSIndexPath *indexPath = [self indexPathForDate:date];
    
    _isAnimatedScrolling = animated;
    
    if (_calendarType == XMCalendarViewTypeMonthly)
    {
        UICollectionViewLayoutAttributes *sectionAttributes = [_collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        [_collectionView setContentOffset:CGPointMake(0, CGRectGetMinY(sectionAttributes.frame)) animated:animated];
    }
    else
    {
        [_collectionView setContentOffset:CGPointMake(indexPath.section * _collectionView.xm_width, 0) animated:animated];
    }
}

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = nil;
    
    if (_calendarType == XMCalendarViewTypeMonthly)
    {
        NSDate *currentMonth = [_minDate xm_dateByAddingMonths:indexPath.section];
        NSDate *firstDayOfMonth = [NSDate xm_dateWithYear:currentMonth.xm_year
                                                    month:currentMonth.xm_month
                                                      day:1];
        
        NSInteger minItem = firstDayOfMonth.xm_weekday - 1;
        NSInteger maxItem = minItem + firstDayOfMonth.xm_numberOfDaysInMonth;
        
        if (indexPath.item >= minItem && indexPath.item < maxItem)
        {
            date = [firstDayOfMonth xm_dateByAddingDays:indexPath.item - minItem];
        }
    }
    else
    {
        NSDate *currentWeek = [_minDate xm_dateByAddingDays:indexPath.section * 7];
        
        NSDate *firstDayOfTheWeek = [currentWeek xm_dateBySubtractingDays:currentWeek.xm_weekday - 1];
        
        date = [firstDayOfTheWeek xm_dateByAddingDays:indexPath.item];
    }
    
    return date;
}

- (NSIndexPath *)indexPathForDate:(NSDate *)date
{
    if (_calendarType == XMCalendarViewTypeMonthly)
    {
        NSInteger section = [date xm_monthsFrom:_minDate];
        NSDate *firstDayOfMonth = [NSDate xm_dateWithYear:date.xm_year month:date.xm_month day:1];
        NSInteger item = [date xm_daysFrom:firstDayOfMonth] + firstDayOfMonth.xm_weekday - 1;
        
        return [NSIndexPath indexPathForItem:item inSection:section];
    }
    else
    {
        NSInteger section = [date xm_weekRangeFrom:_minDate];
        NSInteger item = date.xm_weekday - 1;
        
        return [NSIndexPath indexPathForItem:item inSection:section];
    }
    
}

#pragma mark - UIScrollViewDelegate

    //TODO: 动画结束后再通知

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//        NSLog(@"edr :%d", decelerate);
//    _isAnimatedScrolling = decelerate;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"ed");
//    _isAnimatedScrolling = NO;
//    [self scrollViewDidScroll:scrollView];
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"bg");
    _isAnimatedScrolling = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
        NSLog(@"se");
    _isAnimatedScrolling = NO;
    [self scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 忽略动画中
    if (_isAnimatedScrolling)
    {
        return;
    }
    
    // 忽略小变化
    if (fabs(scrollView.contentOffset.x - _prevScrollContenOffset.x) < kCalendarScrollOffsetBuffer && fabs(scrollView.contentOffset.y - _prevScrollContenOffset.y) < kCalendarScrollOffsetBuffer)
    {
        return;
    }
    
    NSDate *currentDate = [_currentDate copy];
    
    if (_calendarType == XMCalendarViewTypeMonthly)
    {
        NSArray *attributes = [_collectionView.collectionViewLayout layoutAttributesForElementsInRect:CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, scrollView.bounds.size.width, kCalendarScrollOffsetBuffer)];
        
        __block NSIndexPath *indexPath = nil;
        
        [attributes enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             UICollectionViewLayoutAttributes *attribute = (UICollectionViewLayoutAttributes *)obj;
             if ([attribute.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
             {
                 indexPath = attribute.indexPath;
                 *stop = YES;
             }
         }];
        
        if (indexPath)
        {
            currentDate = [_minDate xm_dateByAddingMonths:indexPath.section];
            
            // 匹配日期
            currentDate = [currentDate xm_dateInTheMonthWithDay:_currentDate.xm_day];
        }
    }
    else
    {
        CGFloat scrollOffset = scrollView.contentOffset.x / scrollView.xm_width;
        
        NSInteger addDays = round(scrollOffset) * 7 + (_currentDate.xm_weekday - _minDate.xm_weekday);
        currentDate = [_minDate xm_dateByAddingDays:addDays];
    }
    
    if (![_currentDate xm_isEqualToDateForDay:currentDate])
    {
        _currentDate = [currentDate copy];
        [self currentDateDidChange];
    }
    
    _prevScrollContenOffset = scrollView.contentOffset;
}

#pragma mark - UICollectionView dataSource/delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger monthCount = [_maxDate xm_monthsFrom:_minDate] + 1;
    NSInteger weekCount = [_maxDate xm_weekRangeFrom:_minDate] + 1;
    return _calendarType == XMCalendarViewTypeMonthly ? monthCount : weekCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kDefaultCalendarColumn * [self rowCountForSection:section];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        XMCalendarViewHeader *headerView = (XMCalendarViewHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCalendarHeaderReuseIdentifier forIndexPath:indexPath];
        
        NSDate *currentMonth = [_minDate xm_dateByAddingMonths:indexPath.section];
        NSDate *firstDayOfMonth = [NSDate xm_dateWithYear:currentMonth.xm_year
                                                    month:currentMonth.xm_month
                                                      day:1];
        
        NSInteger weekdayOfFirstDay = firstDayOfMonth.xm_weekday - 1;
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
        
        headerView.text = [NSString stringWithFormat:@"%d月", @(firstDayOfMonth.xm_month).intValue];
        headerView.labelCenter = CGPointMake((weekdayOfFirstDay + 0.5) * layout.itemSize.width, headerView.labelCenter.y);
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCalendarCellReuseIdentifier forIndexPath:indexPath];
    
    cell.date = [self dateForIndexPath:indexPath];
    
    if (cell.date == nil)
    {
        cell.hidden = YES;
    }
    else
    {
        cell.hidden = NO;
        
        cell.titleColors = _titleColors;
        cell.subtitleColors = _subtitleColors;
        cell.backgroundColors = _backgroundColors;
        cell.eventColor = self.eventColor;
        
        cell.titleFont = _titleFont;
        cell.subtitleFont = _subtitleFont;
        
        cell.hasEvent = [self hasEventForDate:cell.date];
        cell.isToday = [cell.date xm_isEqualToDateForDay:[NSDate date]];
        cell.isSpecial = cell.date.xm_weekday == 1 || cell.date.xm_weekday == 7;
        
        cell.title = [NSString stringWithFormat:@"%@",@(cell.date.xm_day)];
        cell.subtitle = [self subtitleForDate:cell.date];
        
        [cell configureCell];
    }
    
    return cell;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [self dateForIndexPath:indexPath];
    
    return [self shouldSelectDate:date] && ![[collectionView indexPathsForSelectedItems] containsObject:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMCalendarViewCell *cell = (XMCalendarViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell performSelectionAnimation:YES];
    
    _selectedDate = [self dateForIndexPath:indexPath];
    [self didSelectDate:_selectedDate];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMCalendarViewCell *cell = (XMCalendarViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell performSelectionAnimation:NO];
}

#pragma mark - Public

- (void)reloadData
{
    NSIndexPath *selectedPath = [_collectionView indexPathsForSelectedItems].lastObject;
    [_collectionView reloadData];
    
    [_collectionView selectItemAtIndexPath:selectedPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    [_weekdayLabels setValue:_weekdayFont forKey:@"font"];
    [_weekdayLabels setValue:_weekdayTextColor forKey:@"textColor"];
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    NSIndexPath *selectedIndexPath = [self indexPathForDate:selectedDate];
    if (![_selectedDate xm_isEqualToDateForDay:selectedDate] && [self collectionView:_collectionView shouldSelectItemAtIndexPath:selectedIndexPath])
    {
        NSIndexPath *currentIndex = [_collectionView indexPathsForSelectedItems].lastObject;
        [_collectionView deselectItemAtIndexPath:currentIndex animated:NO];
        [self collectionView:_collectionView didDeselectItemAtIndexPath:currentIndex];
        
        [_collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
        if ([_collectionView cellForItemAtIndexPath:selectedIndexPath] == nil)
        {
            [self scrollToDate:selectedDate animated:YES];
        }
 
        [self collectionView:_collectionView didSelectItemAtIndexPath:selectedIndexPath];
    }
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    if (![_currentDate xm_isEqualToDateForDay:currentDate])
    {
        _currentDate = [currentDate copy];

        [self scrollToDate:_currentDate animated:NO];
        [self currentDateDidChange];
    }
}

- (UIColor *)titleDefaultColor
{
    return _titleColors[@(XMCalendarCellStateNormal)];
}

- (void)setTitleDefaultColor:(UIColor *)titleDefaultColor
{
    if (titleDefaultColor)
    {
        _titleColors[@(XMCalendarCellStateNormal)] = titleDefaultColor;
    }
    else
    {
        [_titleColors removeObjectForKey:@(XMCalendarCellStateNormal)];
    }
}

- (UIColor *)titleSelectionColor
{
    return _titleColors[@(XMCalendarCellStateSelected)];
}

- (void)setTitleSelectionColor:(UIColor *)titleSelectionColor
{
    if (titleSelectionColor)
    {
        _titleColors[@(XMCalendarCellStateSelected)] = titleSelectionColor;
    }
    else
    {
        [_titleColors removeObjectForKey:@(XMCalendarCellStateSelected)];
    }
}

- (UIColor *)titleTodayColor
{
    return _titleColors[@(XMCalendarCellStateToday)];
}

- (void)setTitleTodayColor:(UIColor *)titleTodayColor
{
    if (titleTodayColor)
    {
        _titleColors[@(XMCalendarCellStateToday)] = titleTodayColor;
    }
    else
    {
        [_titleColors removeObjectForKey:@(XMCalendarCellStateToday)];
    }
}

- (UIColor *)titleSpecialColor
{
    return _titleColors[@(XMCalendarCellStateSpecial)];
}

- (void)setTitleSpecialColor:(UIColor *)titleSpecialColor
{
    if (titleSpecialColor)
    {
        _titleColors[@(XMCalendarCellStateSpecial)] = titleSpecialColor;
    }
    else
    {
        [_titleColors removeObjectForKey:@(XMCalendarCellStateSpecial)];
    }
}

- (UIColor *)subtitleDefaultColor
{
    return _subtitleColors[@(XMCalendarCellStateNormal)];
}

- (void)setSubtitleDefaultColor:(UIColor *)subtitleDefaultColor
{
    if (subtitleDefaultColor)
    {
        _subtitleColors[@(XMCalendarCellStateNormal)] = subtitleDefaultColor;
    }
    else
    {
        [_subtitleColors removeObjectForKey:@(XMCalendarCellStateNormal)];
    }
}

- (UIColor *)subtitleSelectionColor
{
    return _subtitleColors[@(XMCalendarCellStateSelected)];
}

- (void)setSubtitleSelectionColor:(UIColor *)subtitleSelectionColor
{
    if (subtitleSelectionColor)
    {
        _subtitleColors[@(XMCalendarCellStateSelected)] = subtitleSelectionColor;
    }
    else
    {
        [_subtitleColors removeObjectForKey:@(XMCalendarCellStateSelected)];
    }
}

- (UIColor *)subtitleTodayColor
{
    return _subtitleColors[@(XMCalendarCellStateToday)];
}

- (void)setSubtitleTodayColor:(UIColor *)subtitleTodayColor
{
    if (subtitleTodayColor)
    {
        _subtitleColors[@(XMCalendarCellStateToday)] = subtitleTodayColor;
    }
    else
    {
        [_subtitleColors removeObjectForKey:@(XMCalendarCellStateToday)];
    }
}

- (UIColor *)subtitleSpecialColor
{
    return _subtitleColors[@(XMCalendarCellStateSpecial)];
}

- (void)setSubtitleSpecialColor:(UIColor *)subtitleSpecialColor
{
    if (subtitleSpecialColor)
    {
        _subtitleColors[@(XMCalendarCellStateSpecial)] = subtitleSpecialColor;
    }
    else
    {
        [_subtitleColors removeObjectForKey:@(XMCalendarCellStateSpecial)];
    }
}

- (UIColor *)backgroundSelectionColor
{
    return _backgroundColors[@(XMCalendarCellStateSelected)];
}

- (void)setBackgroundSelectionColor:(UIColor *)backgroundSelectionColor
{
    if (backgroundSelectionColor)
    {
        _backgroundColors[@(XMCalendarCellStateSelected)] = backgroundSelectionColor;
    }
    else
    {
        [_backgroundColors removeObjectForKey:@(XMCalendarCellStateSelected)];
    }
}

- (UIColor *)backgroundTodayColor
{
    return _backgroundColors[@(XMCalendarCellStateToday)];
}

- (void)setBackgroundTodayColor:(UIColor *)backgroundTodayColor
{
    if (backgroundTodayColor)
    {
        _backgroundColors[@(XMCalendarCellStateToday)] = backgroundTodayColor;
    }
    else
    {
        [_backgroundColors removeObjectForKey:@(XMCalendarCellStateToday)];
    }
}

@end
