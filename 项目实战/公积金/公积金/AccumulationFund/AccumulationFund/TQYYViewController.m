//
//  TQYYViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/14.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "TQYYViewController.h"
#import "FundReferences.h"
#import "SelectionView.h"
#import "SelectionTableViewCell.h"
#import "TQYYModel.h"
#import "TQYYNextViewController.h"
#import "ConvenientTools.h"
#import "SVProgressHUD.h"

@interface TQYYViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UIButton *_nextButton;
}
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSIndexPath * selectedIndex;


@end

@implementation TQYYViewController

static NSString * const reuseableIdentifier = @"selectedCell";

- (void)setDrawReason:(NSArray *)drawReason {
    _drawReason = [TQYYModel modelsWithArray:drawReason];
    ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backView addSubview:self.tableView];
    self.navigationItem.title = @"提取预约";

    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"开始监听缴存原因信息通知");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawReasonInformationDidLoad) name:@"drawReasonInfoDidLoadNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawReasonInformationDidLoad {
    self.drawReason = [ConvenientTools sharedConvenientTools].drawReason;
    [self.tableView reloadData];
}


- (void)setUI {
    UILabel * label = [[UILabel alloc] init];
    label.font = k_title_font;
    label.text = @"提取原因选择";
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 40, self.backView.frame.size.width, 60);
    [self.backView addSubview:label];
    
    UIButton * nextButton = [[UIButton alloc] init];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.backView addSubview:nextButton];
    _nextButton = nextButton;
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor = BarColor;
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(k_margin_horizontal * 4, 40, self.backView.frame.size.width - k_margin_horizontal * 8, k_tqyy_row_height * self.drawReason.count);
    _nextButton.frame = CGRectMake((self.backView.frame.size.width - k_screen_width * 0.333) * 0.5, self.tableView.frame.size.height + self.tableView.frame.origin.y + 36, k_screen_width * 0.333, k_button_size.height);
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.drawReason.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseableIdentifier];
    if (cell == nil) {
        cell = [[SelectionTableViewCell alloc] initWithSelectionType:SelectionViewTypeSingleSelection reuseIdentifier:reuseableIdentifier];
    }
    cell.selectionView.textLabel.text = [self.drawReason[indexPath.row] mc];
    cell.selectionView.selected = [self.drawReason[indexPath.row] selected];
    if (cell.selectionView.selected) {
        self.selectedIndex = indexPath;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    SelectionTableViewCell * selectedCell = [tableView cellForRowAtIndexPath:self.selectedIndex];
    selectedCell.selectionView.selected = false;
    SelectionTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionView.selected = true;
    self.selectedIndex = indexPath;
}

- (void)nextButtonClick {
    
    if (self.drawReason.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"加载购房原因信息失败" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    TQYYNextViewController *nextVC = [[TQYYNextViewController alloc] init];
    nextVC.drawReasonCode = [self.drawReason[self.selectedIndex.row] bm];
    
    [self.navigationController pushViewController:nextVC animated:true];
}


@end
