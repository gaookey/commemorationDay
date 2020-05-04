//
//  NSCalendar+GWLExtend.h
//  commemorationDay
//
//  Created by 高文立 on 2020/5/4.
//  Copyright © 2020 gwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCalendar (GWLExtend)

- (NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;

- (NSInteger)daysWithinEraFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;

@end

NS_ASSUME_NONNULL_END
