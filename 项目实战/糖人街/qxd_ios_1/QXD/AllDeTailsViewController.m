//
//  AllDeTailsViewController.m
//  QXD
//
//  Created by WZP on 15/11/17.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "AllDeTailsViewController.h"
#import "InterestListView.h"
#import "InterestSubView.h"
#import "InterestTableViewCell.h"
#import "InterestProductModel.h"
#import "DeTaiilsViewController2.h"

@interface AllDeTailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UIImageView * mainImageView;
@property(nonatomic,retain)UITableView * tableView;
@property(nonatomic,retain)NSMutableArray * productlistArr;


@end



#define HEIGHT [[UIScreen mainScreen] bounds].size.height


@implementation AllDeTailsViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _productlistArr=[NSMutableArray arrayWithCapacity:1];
    
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49)];
    [self.view addSubview:_tableView];
    //设置控制器的属性,滚动视图的子视图位置不会受到navigationbar的影响;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    
    

    _mainImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 281*PROPORTION_WIDTH)];
    _mainImageView.image=[UIImage imageNamed:@"33"];
    _tableView.tableHeaderView=_mainImageView;
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count=(int)self.productlistArr.count;
    if (count%2==0) {
        return count/2;
    }else{
        return (count+1)/2;
        
    }

    return 0;
    
    

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
    int count=(int)self.productlistArr.count;
    
    InterestProductModel * model1=self.productlistArr[h];
    InterestProductModel * model2;
    if (ll<count) {
        model2=self.productlistArr[ll];
    }else{
        model2=nil;
    }
    [cell setModel1:model1 model2:model2];
    for (InterestSubView * subButton in cell.subButttonArr) {
        [subButton addTarget:self action:@selector(presentProductDetailsViewControllerviewWithButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return cell;

    
    
}

#pragma mark 跳转
- (void)presentProductDetailsViewControllerviewWithButton:(UIButton*)button{
    
    InterestSubView * view=(InterestSubView*)button;
    DeTaiilsViewController2 * viewController=[[DeTaiilsViewController2 alloc] init];
    viewController.hidesBottomBarWhenPushed=YES;
    viewController.productID=view.productID;
    [self.navigationController pushViewController:viewController animated:YES];
    
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
