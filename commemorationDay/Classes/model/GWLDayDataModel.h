//
//  GWLDayDataModel.h
//  commemorationDay
//
//  Created by 高文立 on 2020/5/4.
//  Copyright © 2020 gwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GWLDayDataModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *cumulative;
@property (copy, nonatomic) NSString *surplus;

@end

NS_ASSUME_NONNULL_END
