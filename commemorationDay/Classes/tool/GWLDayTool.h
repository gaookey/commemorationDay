//
//  GWLDayTool.h
//  commemorationDay
//
//  Created by 高文立 on 2020/5/4.
//  Copyright © 2020 gwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GWLDayTool : NSObject

+ (NSString *)getChineseYearWithDate:(NSDate *)date;
+ (NSString *)getChineseCalendarWithDate:(NSDate *)date;
+ (NSString *)getWeekDayWithDate:(NSDate *)date;
+ (NSString *)getWeekInyearOrMouth:(BOOL)inYear WithDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
