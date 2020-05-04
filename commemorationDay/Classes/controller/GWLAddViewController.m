//
//  GWLAddViewController.m
//  commemorationDay
//
//  Created by 高文立 on 2020/5/4.
//  Copyright © 2020 gwl. All rights reserved.
//

#import "GWLAddViewController.h"
#import "NSCalendar+GWLExtend.h"

@interface GWLAddViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UITextField *eventTime;

@end

@implementation GWLAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加新日子";
    
    [self setupSetting];
}
- (void)setupSetting {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveData)];
    
    self.eventTime.placeholder = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    self.eventTime.inputView = self.datePicker;
    
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
}
- (void)dateChange:(UIDatePicker *)datePicker {
    self.eventTime.text = [datePicker.date stringWithFormat:@"yyyy-MM-dd"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.eventTime) {
        return NO;
    }
    return YES;
}
- (void)saveData {
    GWLDayDataModel *model = [[GWLDayDataModel alloc] init];
    model.title = self.eventName.text.length > 0 ? self.eventName.text : @"事件名称";
    model.time = self.eventTime.text.length > 0 ? self.eventTime.text : [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSInteger time = [cal daysWithinEraFromDate:[NSDate dateWithString:model.time format:@"yyyy-MM-dd"] toDate:[NSDate date]];
    
    model.cumulative = [NSString stringWithFormat:@"%ld", (long)time];
    

    if (self.refreshDayList) {
        self.refreshDayList(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
