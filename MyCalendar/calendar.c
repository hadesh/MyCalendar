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


//int b = 2 - (int)(2014/100) + ((int)(2014/100)/4);
//double jd = (int)(365.25*(2014+4716)) + (int)(30.6001*(3+1)) + 1 + b - 1524.5;


//static const double jd_1900_1_6_2_27 = 2415025.6020833333;
//static const double days_per_year = 365.24219878125;
//static const double jd_days_per_year = 365.25;

double tail(double x)
{
	return x - floor(x);
}

// 判断y年m月(1,2,..,12,下同)d日是Gregorian历还是Julian历
//（opt=1,2,3分别表示标准日历,Gregorge历和Julian历）,是则返回1，是Julian历则返回0，
// 若是Gregorge历所删去的那10天则返回-1
int ifGregorian(int y, int m, int d, int opt)
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
int dayDifference(int y, int m, int d)
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

double equivalentStandardDay(int y, int m, int d)
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
double antiDayDifference(int y, double x)
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
double term(int y, int n)
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

int getSolarTermDate(int year, int n, char *termDate)
{
    if (termDate == NULL)
    {
        return 0;
    }
    
    double termDays = term(year, n);
    
    double mdays = antiDayDifference(year, floor(termDays));
    int tMonth = (int)ceil((double)n / 2);
    int tday = (int)mdays % 100;
//    int hour = (int)(tail(termDays) * 24);
//    int minute = (int)floor((double)(tail(termDays) * 24 - hour) * 60)
    
    return sprintf(termDate , "%04d-%02d-%02d" , year , tMonth , tday);
}


//static const double x_1900_1_6_2_5 = 693966.08680556;
//
//// 返回天数
//double get_solar_term(int y, int n)
//{
//    static const int termInfo[] = {
//        0     ,21208 ,42467 ,63836 ,85337 ,107014,
//        128867,150921,173149,195551,218072,240693,
//        263343,285989,308563,331033,353350,375494,
//        397447,419210,440795,462224,483532,504758
//    };
//    return x_1900_1_6_2_5 + days_per_year * (y - 1900) + termInfo[n] / (60.0 * 24.0);
//}
//
//int format_date(double days , char *result )
//{
//    static const int mdays[] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365};
//    
//    int y , m , d;
//    
//    double _days = days;
//    double _year = _days / days_per_year; // 2014.17842574356304
//    
//    
//    y = (int)_year; // 2014
//    
//    int leap = y%(y%100?4:400) ? 0 : 1;
//    
//    _days = (_year - floor(_year)) * days_per_year; // 0.17842574356304 * 365.2422 -> 65.16861111560057
//    
//    m = 0;
//    while (1)
//    {
//        int mday = mdays[m] + ((m > 1) ? leap : 0);
//
//        if (mday < _days)
//        {
//            ++m;
//        }
//        else
//        {
//            break;
//        }
//    }
//    
//    // 65.16861111560057 - 59 = 6.16861111560057
//    // m = 3
//    
//    _days -= mdays[m - 1] + ((m - 1 > 1) ? leap : 0);
//    
//    d = (int)_days;
//    
//    return sprintf( result , "%04d-%02d-%02d" , y , m , d );
//}
//
//
//int getSolarTermDate(int year, int n, char **termDate)
//{
//    double days = get_solar_term(year, n);
//    
//    *termDate = (char *)malloc(10);
//    
//    return format_date(days, *termDate);
//}


