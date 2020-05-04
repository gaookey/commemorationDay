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
@property (assign, nonatomic) BOOL isDayListEditing;
///多选删除的数据
@property (strong, nonatomic) NSMutableArray<GWLDayDataModel*> *delectData;

@end

static NSString *const DAY_LIST_KEY = @"DAY_LIST_KEY";
static NSString *const DAY_LIST_CELL_ID = @"DAY_LIST_CELL_ID";

@implementation GWLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self  loadCurrentDayData];
    
    [self setupDayList];
    
    [self loadLocalDayData];
    
    [self addLeftBarButtonItem];
}
- (void)addLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"多选" style:UIBarButtonItemStyleDone target:self action:@selector(moreSelect)];
}
- (void)moreSelect {
    if (self.dayData.count <= 0 && !self.isDayListEditing) {
        return;
    }
    
    self.isDayListEditing = !self.isDayListEditing;
    [self.dayList setEditing:self.isDayListEditing animated:YES];
    
    self.navigationItem.leftBarButtonItem.title = self.isDayListEditing ? @"取消" : @"多选";
    self.navigationItem.rightBarButtonItem.title = self.isDayListEditing ? @"删除" : @"添加";
    
    self.dayList.allowsSelection = self.isDayListEditing;
}
#pragma mark - 更新数据
- (void)updateDayData {
    NSMutableArray *dayDataArr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dayData.count; i ++) {
        GWLDayDataModel *model = self.dayData[i];
        NSError *error = nil;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:YES error:&error];
        
        [dayDataArr addObject:data];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:dayDataArr forKey:DAY_LIST_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - 获取本地数据
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
    if (self.isDayListEditing) {
        if (self.delectData.count <= 0) {
            return;
        }
        
        for (NSInteger i = 0; i < self.delectData.count; i ++) {
            GWLDayDataModel *model = self.delectData[i];
            [self.dayData removeObject:model];
        }
        [self.dayList reloadData];
        [self moreSelect];
        [self updateDayData];
    } else {
        [self pushAddViewController];
    }
}
- (void)pushAddViewController {
    __weak typeof(self) weakSelf = self;
    GWLAddViewController *vc = [[GWLAddViewController alloc] init];
    vc.refreshDayList = ^(GWLDayDataModel * _Nonnull model) {
        [weakSelf.dayData addObject:model];
        [weakSelf.dayList reloadData];
        [weakSelf updateDayData];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {   GWLDayDataModel *model = self.dayData[indexPath.row];
    [self.delectData addObject:model];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    GWLDayDataModel *model = self.dayData[indexPath.row];
    [self.delectData removeObject:model];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dayList.editing) {
        return UITableViewCellEditingStyleDelete| UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dayData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateDayData];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.dayData exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    [self updateDayData];
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
- (NSMutableArray<GWLDayDataModel *> *)delectData {
    if (!_delectData) {
        _delectData = [[NSMutableArray alloc] init];
    }
    return _delectData;
}

@end
