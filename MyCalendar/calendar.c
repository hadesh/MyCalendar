//
//  calendar.c
//  MyCalendar
//
//  Created by xiaoming han on 14-3-1.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include "calendar.h"

int getDay(int year, int month, int day)
{
    if (year > 9999 || year < 1 || month > 12 || month < 1 || day < 1 || day > 31)
    {
        return -1;
    }
    
    int week = 0;
    
    if ((month == 1) || (month == 2))
    {/*一月、二月当作前一年的十三、十四月*/
        month += 12;
        year--;
    }
    
    /*判断是否在 1752 年 9 月 3 日前*/
    if ((year < 1752)||((year == 1752)&&(month < 9))||((year == 1752)&&(month == 9)&&(day < 3)))
    {
        week = (day + 2*month + 3*(month + 1) / 5 + year + year / 4 + 5) % 7;
    }
    else
    {
        week = (day + 2*month + 3*(month + 1) / 5 + year + year / 4 - year / 100 + year / 400) % 7;
    }
    
    return week;
}

static const double x_1900_1_6_2_5 = 693966.08680556;
static const double days_per_year = 365.2422;

// 返回天数
double get_solar_term(int y, int n)
{
    static const int termInfo[] = {
        0     ,21208 ,42467 ,63836 ,85337 ,107014,
        128867,150921,173149,195551,218072,240693,
        263343,285989,308563,331033,353350,375494,
        397447,419210,440795,462224,483532,504758
    };
    return x_1900_1_6_2_5 + days_per_year * (y - 1900) + termInfo[n] / (60.0 * 24.0);
}

int format_date(double days , char *result )
{
    static const int mdays[] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365};
    
    int y , m , d;
    
    double _days = days;
    double _year = _days / days_per_year; // 2014.17842574356304
    
    
    y = (int)_year; // 2014
    
    int leap = y%(y%100?4:400) ? 0 : 1;
    
    _days = (_year - floor(_year)) * days_per_year; // 0.17842574356304 * 365.2422 -> 65.16861111560057
    
    m = 0;
    while (1)
    {
        int mday = mdays[m] + ((m > 1) ? leap : 0);

        if (mday < _days)
        {
            ++m;
        }
        else
        {
            break;
        }
    }
    
    // 65.16861111560057 - 59 = 6.16861111560057
    // m = 3
    
    _days -= mdays[m - 1] + ((m - 1 > 1) ? leap : 0);
    
    d = (int)_days;
    
    return sprintf( result , "%04d-%02d-%02d" , y , m , d );
}


int getSolarTermDate(int year, int n, char **termDate)
{
    double days = get_solar_term(year, n);
    
    *termDate = (char *)malloc(10);
    
    return format_date(days, *termDate);
}


