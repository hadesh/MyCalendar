//
//  calendar.c
//  MyCalendar
//
//  Created by xiaoming han on 14-3-1.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#include <stdio.h>
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