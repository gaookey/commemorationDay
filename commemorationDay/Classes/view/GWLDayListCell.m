//
//  GWLDayListCell.m
//  commemorationDay
//
//  Created by 高文立 on 2020/5/4.
//  Copyright © 2020 gwl. All rights reserved.
//

#import "GWLDayListCell.h"

@interface GWLDayListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *cumulative;

@end

@implementation GWLDayListCell

- (void)setModel:(GWLDayDataModel *)model {
    
    [self.bgView setLayerShadow:UIColor.grayColor offset:CGSizeMake(1, 1) radius:5];
    self.bgView.layer.cornerRadius = 10;
    
    self.name.text = model.title;
    self.date.text = model.time;
        
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger cumulativeTime = [cal daysWithinEraFromDate:[NSDate dateWithString:model.time format:@"yyyy-MM-dd"] toDate:[NSDate date]];
    if (cumulativeTime < 0) {
        self.cumulative.text = [NSString stringWithFormat:@"剩 %ld 天", ABS(cumulativeTime)];
    } else {
        self.cumulative.text = [NSString stringWithFormat:@"第 %ld 天", ABS(cumulativeTime)];
    }
    
    NSMutableAttributedString *cumulativeAtt = [[NSMutableAttributedString alloc] initWithString:self.cumulative.text];
    [cumulativeAtt addAttributes:@{NSForegroundColorAttributeName: UIColor.blackColor, NSFontAttributeName: [UIFont systemFontOfSize:50]} range:NSMakeRange(@"第 ".length, [NSString stringWithFormat:@"%ld", ABS(cumulativeTime)].length + 1)];
    self.cumulative.attributedText = cumulativeAtt;
}

@end
