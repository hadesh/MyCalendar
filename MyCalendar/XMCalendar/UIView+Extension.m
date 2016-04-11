//
//  UIView+Extension.m
//  CalendarDemo
//
//  Created by xiaoming han on 15/3/30.
//  Copyright (c) 2015年 xiaoming.han. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (CGFloat)xm_width
{
    return CGRectGetWidth(self.frame);
}

- (void)setXm_width:(CGFloat)xm_width
{
    self.frame = CGRectMake(self.xm_left, self.xm_top, xm_width, self.xm_height);
}

- (CGFloat)xm_height
{
    return CGRectGetHeight(self.frame);
}

- (void)setXm_height:(CGFloat)xm_height
{
    self.frame = CGRectMake(self.xm_left, self.xm_top, self.xm_width, xm_height);
}

- (CGFloat)xm_top
{
    return CGRectGetMinY(self.frame);
}

- (void)setXm_top:(CGFloat)xm_top
{
    self.frame = CGRectMake(self.xm_left, xm_top, self.xm_width, self.xm_height);
}

- (CGFloat)xm_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setXm_bottom:(CGFloat)xm_bottom
{
    self.xm_top = xm_bottom - self.xm_height;
}

- (CGFloat)xm_left
{
    return CGRectGetMinX(self.frame);
}

- (void)setXm_left:(CGFloat)xm_left
{
    self.frame = CGRectMake(xm_left, self.xm_top, self.xm_width, self.xm_height);
}

- (CGFloat)xm_right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setXm_right:(CGFloat)xm_right
{
    self.xm_left = self.xm_right - self.xm_width;
}

@end
