//
//  NSCalendar+GWLExtend.m
//  commemorationDay
//
//  Created by 高文立 on 2020/5/4.
//  Copyright © 2020 gwl. All rights reserved.
//

#import "NSCalendar+GWLExtend.h"

@implementation NSCalendar (GWLExtend)

- (NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSCalendarUnit units=NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *comp1 = [self components:units fromDate:startDate];
    NSDateComponents *comp2 = [self components:units fromDate:endDate];
    [comp1 setHour:12];
    [comp2 setHour:12];
    NSDate *date1 = [self dateFromComponents: comp1];
    NSDate *date2 = [self dateFromComponents: comp2];
    
    return [[self components:NSCalendarUnitDay fromDate:date1 toDate:date2 options:0] day];
}
- (NSInteger)daysWithinEraFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSInteger startDay = [self ordinalityOfUnit:NSCalendarUnitDay inUnit: NSCalendarUnitEra forDate:startDate];
    NSInteger endDay = [self ordinalityOfUnit:NSCalendarUnitDay inUnit: NSCalendarUnitEra forDate:endDate];
    
    return endDay - startDay;
}

@end
