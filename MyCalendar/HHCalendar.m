//
//  HHCalendar.m
//  MyCalendar
//
//  Created by xiaoming han on 14-3-1.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import "HHCalendar.h"
#include "calendar.h"

#define kLunarYearStart     1901
#define kLunarYearEnd       2099

const int HHLunarCalendarInfo[] = { 0x04AE53,0x0A5748,0x5526BD,0x0D2650,0x0D9544,0x46AAB9,0x056A4D,0x09AD42,0x24AEB6,0x04AE4A,/*1901-1910*/
    0x6A4DBE,0x0A4D52,0x0D2546,0x5D52BA,0x0B544E,0x0D6A43,0x296D37,0x095B4B,0x749BC1,0x049754,/*1911-1920*/
    0x0A4B48,0x5B25BC,0x06A550,0x06D445,0x4ADAB8,0x02B64D,0x095742,0x2497B7,0x04974A,0x664B3E,/*1921-1930*/
    0x0D4A51,0x0EA546,0x56D4BA,0x05AD4E,0x02B644,0x393738,0x092E4B,0x7C96BF,0x0C9553,0x0D4A48,/*1931-1940*/
    0x6DA53B,0x0B554F,0x056A45,0x4AADB9,0x025D4D,0x092D42,0x2C95B6,0x0A954A,0x7B4ABD,0x06CA51,/*1941-1950*/
    0x0B5546,0x555ABB,0x04DA4E,0x0A5B43,0x352BB8,0x052B4C,0x8A953F,0x0E9552,0x06AA48,0x6AD53C,/*1951-1960*/
    0x0AB54F,0x04B645,0x4A5739,0x0A574D,0x052642,0x3E9335,0x0D9549,0x75AABE,0x056A51,0x096D46,/*1961-1970*/
    0x54AEBB,0x04AD4F,0x0A4D43,0x4D26B7,0x0D254B,0x8D52BF,0x0B5452,0x0B6A47,0x696D3C,0x095B50,/*1971-1980*/
    0x049B45,0x4A4BB9,0x0A4B4D,0xAB25C2,0x06A554,0x06D449,0x6ADA3D,0x0AB651,0x093746,0x5497BB,/*1981-1990*/
    0x04974F,0x064B44,0x36A537,0x0EA54A,0x86B2BF,0x05AC53,0x0AB647,0x5936BC,0x092E50,0x0C9645,/*1991-2000*/
    0x4D4AB8,0x0D4A4C,0x0DA541,0x25AAB6,0x056A49,0x7AADBD,0x025D52,0x092D47,0x5C95BA,0x0A954E,/*2001-2010*/
    0x0B4A43,0x4B5537,0x0AD54A,0x955ABF,0x04BA53,0x0A5B48,0x652BBC,0x052B50,0x0A9345,0x474AB9,/*2011-2020*/
    0x06AA4C,0x0AD541,0x24DAB6,0x04B64A,0x69573D,0x0A4E51,0x0D2646,0x5E933A,0x0D534D,0x05AA43,/*2021-2030*/
    0x36B537,0x096D4B,0xB4AEBF,0x04AD53,0x0A4D48,0x6D25BC,0x0D254F,0x0D5244,0x5DAA38,0x0B5A4C,/*2031-2040*/
    0x056D41,0x24ADB6,0x049B4A,0x7A4BBE,0x0A4B51,0x0AA546,0x5B52BA,0x06D24E,0x0ADA42,0x355B37,/*2041-2050*/
    0x09374B,0x8497C1,0x049753,0x064B48,0x66A53C,0x0EA54F,0x06B244,0x4AB638,0x0AAE4C,0x092E42,/*2051-2060*/
    0x3C9735,0x0C9649,0x7D4ABD,0x0D4A51,0x0DA545,0x55AABA,0x056A4E,0x0A6D43,0x452EB7,0x052D4B,/*2061-2070*/
    0x8A95BF,0x0A9553,0x0B4A47,0x6B553B,0x0AD54F,0x055A45,0x4A5D38,0x0A5B4C,0x052B42,0x3A93B6,/*2071-2080*/
    0x069349,0x7729BD,0x06AA51,0x0AD546,0x54DABA,0x04B64E,0x0A5743,0x452738,0x0D264A,0x8E933E,/*2081-2090*/
    0x0D5252,0x0DAA47,0x66B53B,0x056D4F,0x04AE45,0x4A4EB9,0x0A4D4C,0x0D1541,0x2D92B5          /*2091-2099*/};

const int monthDays[] = {31, 28, 31, 30, 31, 30, 31, 31, 30 ,31, 30 ,31};
const int monthDayAdd[] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};

@interface HHCalendar ()
{
    NSArray *_heavenlyStems;
	NSArray *_earthlyBranches;
	NSArray *_lunarZodiacs;
	NSArray *_solarTerms;
	NSArray *_monthArray;
	NSArray *_dayArray;
    
    NSDictionary *_lunarHolidays;
    NSMutableDictionary *_solarTermDic;
}

@end

@implementation HHCalendar

+ (HHCalendar *)sharedCalendar
{
    static dispatch_once_t instance = 0;
    __strong static HHCalendar* _sharedObject = nil;
    dispatch_once(&instance, ^{
        _sharedObject = [[HHCalendar alloc] init];
    });
    
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _heavenlyStems = [NSArray arrayWithObjects:@"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸", nil];
        
        _earthlyBranches = [NSArray arrayWithObjects:@"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥", nil];
        
        _lunarZodiacs = [NSArray arrayWithObjects:@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪", nil];
        
        _solarTerms = [NSArray arrayWithObjects:@"小寒", @"大寒", @"立春", @"雨水",
                       @"惊蛰", @"春分", @"清明", @"谷雨",
                       @"立夏", @"小满", @"芒种", @"夏至",
                       @"小暑", @"大暑", @"立秋", @"处暑",
                       @"白露", @"秋分", @"寒露", @"霜降",
                       @"立冬", @"小雪", @"大雪", @"冬至", nil];
        
        _monthArray = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月",  @"十月", @"冬月", @"腊月", nil];
        
        _dayArray = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六",
                     @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五",
                     @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四",
                     @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", nil];
        
        _lunarHolidays = @{@"1-1": @"春节",
                           @"1-15": @"元宵节",
                           @"5-5": @"端午节",
                           @"7-7": @"七夕",
                           @"7-15": @"中元节",
                           @"8-15": @"中秋节",
                           @"9-9": @"重阳节",
                           @"12-8": @"腊八",
                           @"12-29": @"除夕",
                           @"12-30": @"除夕"};
        
        _solarTermDic = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - Interface

- (NSInteger)startYear
{
    return kLunarYearStart;
}

- (NSInteger)endYear
{
    return kLunarYearEnd;
}

- (HHCalendarComponents *)componentsFromDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear) fromDate:date];
    
    return [self componentsFromComponents:components];
}

- (HHCalendarComponents *)componentsFromComponents:(NSDateComponents *)comp
{
    HHCalendarComponents *HHcomponents = [[HHCalendarComponents alloc] init];
    HHcomponents.year = comp.year;
    HHcomponents.month = comp.month;
    HHcomponents.day = comp.day;
    HHcomponents.weekday = comp.weekday;
    HHcomponents.weekOfMonth = comp.weekOfMonth;
    HHcomponents.weekOfYear = comp.weekOfYear;
    HHcomponents.isLeapMonth = comp.isLeapMonth;
    
    [self initLunarCalendarInfo:&HHcomponents];
    
    [self initSolarTerm:&HHcomponents];
    
    return HHcomponents;

}

#pragma mark - Helper

- (void)initLunarCalendarInfo:(inout HHCalendarComponents **)components
{
    if ((*components) == nil || (*components).year < kLunarYearStart - 1 || (*components).year > kLunarYearEnd)
    {
        return;
    }
    
    int year = (int)(*components).year;
    int month = (int)(*components).month;
    int day = (int)(*components).day;
    
    int lunarInfo = HHLunarCalendarInfo[year - kLunarYearStart];
    
    int heavenlyIndex = ((year % 10) + 6) % 10;
    (*components).yearHeavenlyStem = _heavenlyStems[heavenlyIndex];
    
    int earthlyIndex = ((year % 12) + 8) % 12;
    (*components).yearEarthlyBranch = _earthlyBranches[earthlyIndex];
    
    (*components).lunarZodiac = _lunarZodiacs[earthlyIndex];
    
    (*components).lunarYear = [NSString stringWithFormat:@"%@%@", (*components).yearHeavenlyStem, (*components).yearEarthlyBranch];
    
    int newYearDay = lunarInfo & 0x0000001F;
    int newYearMonth = (lunarInfo >> 5) & 0x00000003;
    
    int isLargeMonth = 0;
    int doubleMonth = -1;
    
    int lunarDayInMonth = 0;
    int lunarMonth = 0;
    
    // 春节之后
    if (month > newYearMonth || ((month == newYearMonth) && (day >= newYearDay)))
    {
        // 春节是元旦之后多少天
        int dayBetweenNewYear = 0;
        for (int i = 0; i < newYearMonth - 1; ++i)
        {
            dayBetweenNewYear += monthDays[i];
        }
        
        dayBetweenNewYear += (newYearDay - 1);
        
        if (newYearMonth > 2 && (*components).isLeapMonth)
        {
            ++dayBetweenNewYear;
        }
        
        // 今天是今年的第几天
        int dayInYear = monthDayAdd[month - 1] + (int)day;
        
        // 计算农历月
        int lunarDayInYear = dayInYear - dayBetweenNewYear;
        
        lunarDayInMonth = lunarDayInYear;
        
        while (1)
        {
            isLargeMonth = (lunarInfo >> (19 - lunarMonth)) & 0x1;
            int daysCount = 29 + isLargeMonth;
            
            if (lunarDayInMonth > daysCount)
            {
                lunarDayInMonth -= daysCount;
                ++lunarMonth;
            }
            else
            {
                break;
            }

        }
        
        doubleMonth = ((lunarInfo >> 20) & 0x0000000F) - 1;
    }
    else // 上一年
    {
        int prevYear = (int)year - 1;
        
        int prevLunarInfo = HHLunarCalendarInfo[prevYear - kLunarYearStart];
        
        int prevHeavenlyIndex = ((prevYear % 10) + 6) % 10;
        (*components).yearHeavenlyStem = _heavenlyStems[prevHeavenlyIndex];
        
        int prevEarthlyIndex = ((prevYear % 12) + 8) % 12;
        (*components).yearEarthlyBranch = _earthlyBranches[prevEarthlyIndex];
        
        (*components).lunarZodiac = _lunarZodiacs[prevEarthlyIndex];
        
        (*components).lunarYear = [NSString stringWithFormat:@"%@%@", (*components).yearHeavenlyStem, (*components).yearEarthlyBranch];

        doubleMonth = ((prevLunarInfo >> 20) & 0x0000000F) - 1;
        
        // 是上一个农历年的倒数第几天
        int lunarDayBeforeNewYear = 0;
        
        for (int i = month - 1; i < newYearMonth - 1; ++i)
        {
            lunarDayBeforeNewYear += monthDays[i];
        }
        
        lunarDayBeforeNewYear -= day;
        lunarDayBeforeNewYear += newYearDay;
        
        if (newYearMonth > 2 && month < 2 && (*components).isLeapMonth)
        {
            ++lunarDayBeforeNewYear;
        }
        
        // 计算农历日期
        lunarDayInMonth = lunarDayBeforeNewYear;
        
        // 考虑闰月
        lunarMonth = doubleMonth > 0 ? 12 : 11;
        
        int currentMonthDayCount = 0;
        
        while (1)
        {
            isLargeMonth = (prevLunarInfo >> (19 - lunarMonth)) & 0x1;
            currentMonthDayCount = 29 + isLargeMonth;
            
            if (lunarDayInMonth > currentMonthDayCount)
            {
                lunarDayInMonth -= currentMonthDayCount;
                --lunarMonth;
            }
            else
            {
                break;
            }
            
        }
        
        lunarDayInMonth = currentMonthDayCount - lunarDayInMonth + 1;
    }
    
    if (doubleMonth > 0 && lunarMonth > doubleMonth)
    {
        --lunarMonth;
        (*components).isDoubleMonth = (doubleMonth == lunarMonth);
    }
    
    (*components).isLargeMonth = (isLargeMonth == 1);
    (*components).lunarMonth = _monthArray[lunarMonth];
    (*components).lunarDay = _dayArray[lunarDayInMonth - 1];
    
    (*components).lunarMonthIndex = lunarMonth + 1;
    (*components).lunarDayIndex = lunarDayInMonth;
    
    if (!(*components).isDoubleMonth)
    {
        NSString *key = [NSString stringWithFormat:@"%ld-%ld", (*components).lunarMonthIndex, (*components).lunarDayIndex];
        
        // 屏蔽腊月29春节
        if ((*components).isLargeMonth && [key isEqualToString:@"12-29"])
        {
            return;
        }
        
        (*components).lunarHolidayTitle = [_lunarHolidays objectForKey:key];
    }
}

- (void)initSolarTerm:(inout HHCalendarComponents **)components
{
    if ((*components) == nil || (*components).year < kLunarYearStart - 1 || (*components).year > kLunarYearEnd)
    {
        return;
    }
    
    int year = (int)(*components).year;
    int month = (int)(*components).month;
    int day = (int)(*components).day;
    
    // 1号的时候计算本月节气日期
    if (day == 1)
    {
        [_solarTermDic removeAllObjects];
        
        for (int i = month * 2 - 1 - 1; i <= month * 2 - 1; ++i)
        {
            char *result = NULL;
            getSolarTermDate(year, i, &result);
            
            if (result != NULL)
            {
                NSString *str = [NSString stringWithUTF8String:result];
                [_solarTermDic setObject:[NSNumber numberWithInt:i] forKey:str];
                free(result);
            }

        }
    }
    else
    {
        NSString *solarTermKey = [NSString stringWithFormat:@"%04d-%02d-%02d", year, month, day];
        NSNumber *index = [_solarTermDic objectForKey:solarTermKey];
        if (index)
        {
            (*components).solarTermTitle = _solarTerms[[index intValue]];
        }
        
    } 
}

@end





