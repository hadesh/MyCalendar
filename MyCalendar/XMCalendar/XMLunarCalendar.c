//
//  XMLunarCalendar.c
//  CalendarDemo
//
//  Created by xiaoming han on 15/3/30.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#include "XMLunarCalendar.h"
#include <math.h>

//static inline double tail(double x)
//{
//    return x - floor(x);
//}

// 判断y年m月(1,2,..,12,下同)d日是Gregorian历还是Julian历
//（opt=1,2,3分别表示标准日历,Gregorge历和Julian历）,是则返回1，是Julian历则返回0，
// 若是Gregorge历所删去的那10天则返回-1
static int ifGregorian(int y, int m, int d, int opt)
{
    if (opt == 1)
    {
        if (y > 1582 || (y == 1582 && m > 10) || (y == 1582 && m == 10 && d > 14))
            return (1);     //Gregorian
        else
            if (y == 1582 && m == 10 && d >= 5 && d <= 14)
                return (-1);  //空
            else
                return (0);  //Julian
    }
    
    if (opt == 2)
        return (1);     //Gregorian
    if (opt == 3)
        return (0);     //Julian
    return (-1);
}

// 返回阳历y年m月d日的日差天数（在y年年内所走过的天数，如2000年3月1日为61）
static int dayDifference(int y, int m, int d)
{
    int ifG = ifGregorian(y, m, d, 1);
    int monL[] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    if (ifG == 1)
    {
        if ((y % 100 != 0 && y % 4 == 0) || (y % 400 == 0))
        {
            monL[2] += 1;
        }
        else if (y % 4 == 0)
        {
            monL[2] += 1;
        }
    }
    
    int v = 0;
    for (int i = 0; i <= m - 1; i++)
    {
        v += monL[i];
    }
    v += d;
    if (y == 1582)
    {
        if (ifG == 1)
            v -= 10;
        if (ifG == -1)
            v = 0;  //infinity
    }
    return v;
}

// 返回等效标准天数（y年m月d日相应历种的1年1月1日的等效(即对Gregorian历与Julian历是统一的)天数）
static double equivalentStandardDay(int y, int m, int d)
{
    //Julian的等效标准天数
    double v = (y - 1) * 365 + floor((double)((y - 1) / 4)) + dayDifference(y, m, d) - 2;
    
    if (y > 1582)
    {//Gregorian的等效标准天数
        v += -floor((double)((y - 1) / 100)) + floor((double)((y - 1) / 400)) + 2;
    }
    return v;
}

// 返回阳历y年日差天数为x时所对应的月日数（如y=2000，x=274时，返回1001(表示10月1日，即返回100*m+d)）
static double antiDayDifference(int y, double x)
{
    int m = 1;
    for (int j = 1; j <= 12; j++)
    {
        int mL = dayDifference(y, j + 1, 1) - dayDifference(y, j, 1);
        if (x <= mL || j == 12)
        {
            m = j;
            break;
        }
        else
            x -= mL;
    }
    return 100 * m + x;
}

// 返回y年第n个节气（如小寒为1）的日差天数值
static double term(int y, int n)
{
    //儒略日
    double juD = y * (365.2423112 - 6.4e-14 * (y - 100) * (y - 100) - 3.047e-8 * (y - 100)) + 15.218427 * n + 1721050.71301;
    
    //角度
    double tht = 3e-4 * y - 0.372781384 - 0.2617913325 * n;
    
    //年差实均数
    double yrD = (1.945 * sin(tht) - 0.01206 * sin(2 * tht)) * (1.048994 - 2.583e-5 * y);
    
    //朔差实均数
    double shuoD = -18e-4 * sin(2.313908653 * y - 0.439822951 - 3.0443 * n);
    
    double vs = juD + yrD + shuoD - equivalentStandardDay(y, 1, 0) - 1721425;
    
    return vs;
}

#pragma mark - Public

int xm_getSolarTermDate(int year, int n, int *month, int *day)
{
    if (month == NULL || day == NULL)
    {
        return 0;
    }
    
    double termDays = term(year, n);
    
    double mdays = antiDayDifference(year, floor(termDays));
    int tmonth = (int)ceil((double)n / 2);
    int tday = (int)mdays % 100;
    //    int hour = (int)(tail(termDays) * 24);
    //    int minute = (int)floor((double)(tail(termDays) * 24 - hour) * 60)
    
    *month = tmonth;
    *day = tday;
    return 1;
}

int xm_isLeapYear(int year)
{
    if(((year % 4 == 0)&&(year % 100 != 0)) || (year % 400 == 0))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
