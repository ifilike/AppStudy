//
//  YDSearchViewController.m
//  AccumulationFund
//
//  Created by babbage on 15/12/18.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "YDSearchViewController.h"
#import "UserAccountInfo.h"
#import "FundReferences.h"
@interface YDSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation YDSearchViewController
-(UITableView *)tableview{

    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    }
    return _tableview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableview];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.searchDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell  =[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.searchDataArr[indexPath.row][@"mc"]];
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"----dian ji la %@",self.searchDataArr[indexPath.row]);
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([_delegate respondsToSelector:@selector(dataSearch:didSelectWithObject:)]) {
            [_delegate dataSearch:self didSelectWithObject:self.searchDataArr[indexPath.row]];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
