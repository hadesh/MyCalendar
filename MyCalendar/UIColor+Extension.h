//
//  UIColor+Extension.h
//  AQIHeBei
//
//  Created by xiaoming han on 14-2-13.
//  Copyright (c) 2014年 xiaoming han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;

@end
