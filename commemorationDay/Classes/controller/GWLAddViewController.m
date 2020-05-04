//
//  GWLAddViewController.m
//  commemorationDay
//
//  Created by 高文立 on 2020/5/4.
//  Copyright © 2020 gwl. All rights reserved.
//

#import "GWLAddViewController.h"

@interface GWLAddViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UITextField *eventTime;

@end

@implementation GWLAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加新日子";
    
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
    if (self.backData) {
        self.backData(self.eventName.text, self.eventTime.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
