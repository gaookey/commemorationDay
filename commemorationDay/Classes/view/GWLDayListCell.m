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
@property (weak, nonatomic) IBOutlet UILabel *surplus;

@end

@implementation GWLDayListCell

- (void)setModel:(GWLDayDataModel *)model {
    
    [self.bgView setLayerShadow:UIColor.grayColor offset:CGSizeMake(1, 1) radius:5];
    self.bgView.layer.cornerRadius = 10;
    
    self.name.text = model.title;
    self.date.text = model.time;
    
    self.cumulative.text = [NSString stringWithFormat:@"第 %@ 天", model.cumulative];
    
    NSMutableAttributedString *cumulativeAtt = [[NSMutableAttributedString alloc] initWithString:self.cumulative.text];
    [cumulativeAtt addAttributes:@{NSForegroundColorAttributeName: UIColor.blackColor, NSFontAttributeName: [UIFont systemFontOfSize:50]} range:NSMakeRange(@"第 ".length, model.cumulative.length + 1)];
    self.cumulative.attributedText = cumulativeAtt;
    
    self.surplus.text = model.surplus;
}

@end
