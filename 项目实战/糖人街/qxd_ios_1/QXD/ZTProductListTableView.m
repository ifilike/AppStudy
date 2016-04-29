//
//  ZTProductListTableView.m
//  QXD
//
//  Created by wzp on 15/12/7.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "ZTProductListTableView.h"
#import "ZTProductTableViewCell.h"
#import "ZTProductListModel.h"


@implementation ZTProductListTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.listModelArr=[NSMutableArray arrayWithCapacity:1];
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.scrollEnabled=NO;
        [self addSubview:self.tableView];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"列表数据有%lu条",self.listModelArr.count);
    
    return self.listModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZTProductTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"qq"];
    if (cell==nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:@"ZTProductTableViewCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    ZTProductListModel * model=self.listModelArr[indexPath.row];
    [cell setModel:model];
    cell.nowToBuyBut.tag=indexPath.row+1;
    [cell.nowToBuyBut addTarget:self action:@selector(nowToBuyWithButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZTProductListModel * model=self.listModelArr[indexPath.row];
    [self.delegate doOtherThingWithProductID:model.ID];
    
}




- (void)reloadDatasWithZTProductListModelArr:(NSMutableArray*)ZTProductListModelArr{
    self.listModelArr=ZTProductListModelArr;
    NSLog(@"列表数据有%lu条",self.listModelArr.count);
    [self.tableView reloadData];
}
//立即购买的点击事件
//- (void)nowToBuyWithButton:(UIButton*)button{
//    NSLog(@"第%ld个",(long)button.tag);
//    [self.delegate addButtonEvent];
//}




@end
