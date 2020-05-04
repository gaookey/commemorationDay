//
//  ViewController.m
//  commemorationDay
//
//  Created by 高文立 on 2020/5/4.
//  Copyright © 2020 gwl. All rights reserved.
//

#import "GWLHomeViewController.h"
#import "GWLDayTool.h"
#import "GWLDayListCell.h"
#import "GWLAddViewController.h"

@interface GWLHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *today;
@property (weak, nonatomic) IBOutlet UILabel *lunarCalendar;
@property (weak, nonatomic) IBOutlet UIView *listView;
@property (strong, nonatomic) UITableView *dayList;
@property (strong, nonatomic) NSMutableArray <GWLDayDataModel*>*dayData;

@end

static NSString *const GWLDayListCellID = @"GWLDayListCellID";

@implementation GWLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self  loadDayData];
    
    [self.dayList registerNib:[UINib nibWithNibName:NSStringFromClass([GWLDayListCell class]) bundle:nil] forCellReuseIdentifier:GWLDayListCellID];
    [self.listView addSubview:self.dayList];
    [self.dayList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.listView);
    }];
}
- (void)loadDayData {
    
    self.today.text = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    self.lunarCalendar.text = [NSString stringWithFormat:@"%@ %@ %@", [GWLDayTool getChineseYearWithDate:[NSDate date]], [GWLDayTool getChineseCalendarWithDate:[NSDate date]], [GWLDayTool getWeekDayWithDate:[NSDate date]]];
}

- (IBAction)addDay:(id)sender {
    __weak typeof(self) weakSelf = self;
    GWLAddViewController *vc = [[GWLAddViewController alloc] init];
    vc.backData = ^(NSString * _Nonnull title, NSString * _Nonnull time) {
        GWLDayDataModel *model = [[GWLDayDataModel alloc] init];
        model.title = title;
        model.time = time;
        
        [weakSelf.dayData addObject:model];
        [weakSelf.dayList reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GWLDayListCell *cell = [tableView dequeueReusableCellWithIdentifier:GWLDayListCellID];
    cell.model = self.dayData[indexPath.row];
    return cell;
}

#pragma mark - dayList
- (UITableView *)dayList {
    if (_dayList == nil) {
        _dayList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _dayList.delegate = self;
        _dayList.dataSource = self;
        _dayList.allowsSelection = NO;
        _dayList.estimatedRowHeight = 100;
        _dayList.rowHeight = UITableViewAutomaticDimension;
        _dayList.showsVerticalScrollIndicator = NO;
        _dayList.tableFooterView = [[UIView alloc] init];
        _dayList.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _dayList;
}

- (NSMutableArray<GWLDayDataModel *> *)dayData {
    if (!_dayData) {
        _dayData = [[NSMutableArray alloc] init];
    }
    return _dayData;
}


@end
