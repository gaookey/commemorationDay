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

static NSString *const DAY_LIST_KEY = @"DAY_LIST_KEY";
static NSString *const DAY_LIST_CELL_ID = @"DAY_LIST_CELL_ID";

@implementation GWLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self  loadCurrentDayData];
    
    [self setupDayList];
    
    [self loadLocalDayData];
}
- (void)addNewDayData:(GWLDayDataModel *)model {
    [self.dayData addObject:model];
    
    NSMutableArray *dayDataArr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dayData.count; i ++) {
        GWLDayDataModel *model = self.dayData[i];
        NSError *error = nil;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:YES error:&error];
        
        [dayDataArr addObject:data];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:dayDataArr forKey:DAY_LIST_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.dayList reloadData];
}
- (void)loadLocalDayData {
    NSMutableArray *dataArr = [[NSUserDefaults standardUserDefaults] objectForKey:DAY_LIST_KEY];
    for (NSInteger i = 0; i < dataArr.count; i ++) {
        NSData *data = dataArr[i];
        NSError *error = nil;
        GWLDayDataModel *model = [NSKeyedUnarchiver unarchivedObjectOfClass:[GWLDayDataModel class] fromData:data error:&error];
        [self.dayData addObject:model];
    }
    [self.dayList reloadData];
}
- (void)setupDayList {
    [self.dayList registerNib:[UINib nibWithNibName:NSStringFromClass([GWLDayListCell class]) bundle:nil] forCellReuseIdentifier:DAY_LIST_CELL_ID];
    [self.listView addSubview:self.dayList];
    [self.dayList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.listView);
    }];
}
- (void)loadCurrentDayData {
    self.today.text = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    self.lunarCalendar.text = [NSString stringWithFormat:@"%@ %@ %@", [GWLDayTool getChineseYearWithDate:[NSDate date]], [GWLDayTool getChineseCalendarWithDate:[NSDate date]], [GWLDayTool getWeekDayWithDate:[NSDate date]]];
}
- (IBAction)addDay:(id)sender {
    __weak typeof(self) weakSelf = self;
    GWLAddViewController *vc = [[GWLAddViewController alloc] init];
    vc.refreshDayList = ^(GWLDayDataModel * _Nonnull model) {
        [weakSelf addNewDayData:model];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWLDayListCell *cell = [tableView dequeueReusableCellWithIdentifier:DAY_LIST_CELL_ID];
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
