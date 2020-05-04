//
//  GWLDayDataModel.m
//  commemorationDay
//
//  Created by 高文立 on 2020/5/4.
//  Copyright © 2020 gwl. All rights reserved.
//

#import "GWLDayDataModel.h"

@implementation GWLDayDataModel

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.cumulative forKey:@"cumulative"];
    [aCoder encodeObject:self.surplus forKey:@"surplus"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if(self) {
        self.title = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"title"];
        self.time = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"time"];
        self.cumulative = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"cumulative"];
        self.surplus = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"surplus"];
    }
    return self;
}

@end
