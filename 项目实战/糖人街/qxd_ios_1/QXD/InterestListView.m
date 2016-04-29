//
//  InterestListView.m
//  QXD
//
//  Created by WZP on 15/11/22.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "InterestListView.h"
#import "InterestTableViewCell.h"
#import "InterestProductModel.h"
#import "InterestSubView.h"

@implementation InterestListView


//#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.productModelArr=[NSArray array];
        _headView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        _headView.text=@"猜你喜欢";
        _headView.textAlignment=1;
        
        _footView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        _footView.text=@"没有更多商品了";
        _footView.textAlignment=1;
        
        
        _listTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _listTableView.tag=11;
        _listTableView.dataSource=self;
        _listTableView.delegate=self;
        _listTableView.tableHeaderView=_headView;
        _listTableView.tableFooterView=_footView;
        [self addSubview:_listTableView];
        
                
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count=(int)self.productModelArr.count;
    if (count%2==0) {
        return count/2;
    }else{
        return (count+1)/2;

    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    InterestTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ww"];
    if (cell==nil) {

        cell=[[NSBundle mainBundle] loadNibNamed:@"InterestTableViewCell" owner:self options:nil][0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        
    }
    int kk=(int)indexPath.row;
    int h=2*kk;
    int ll=h+1;
    int count=(int)self.productModelArr.count;
    
    InterestProductModel * model1=self.productModelArr[h];
    InterestProductModel * model2;
    if (ll<count) {
        model2=self.productModelArr[ll];
    }else{
        model2=nil;
    }
    [cell setModel1:model1 model2:model2];
    for (InterestSubView * subButton in cell.subButttonArr) {
        [subButton addTarget:self action:@selector(touchUpInsideWith:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return cell;

    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (WIDTH-20)/2+70;
    

}
- (void)touchUpInsideWith:(UIButton*)button{
    InterestSubView * view=(InterestSubView*)button;

    [self.delegate toDoSomethingWith:view.productID];

}
- (void)reloadDataWithInterestModelArr:(NSMutableArray*)interestModelArr{
    NSLog(@"猜你喜欢有%lu个",(unsigned long)interestModelArr.count);
    self.productModelArr=interestModelArr;
    [self.listTableView reloadData];
}

- (void)noHeader{

    _listTableView.tableHeaderView=nil;
    
}
- (void)noFoot{
    
    _listTableView.tableFooterView=nil;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
