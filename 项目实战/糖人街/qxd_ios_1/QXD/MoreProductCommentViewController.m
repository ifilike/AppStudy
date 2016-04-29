//
//  MoreProductCommentViewController.m
//  QXD
//
//  Created by wzp on 15/12/16.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "MoreProductCommentViewController.h"
#import "ProductCommentModel.h"
#import "CommentModel.h"
#import "CommentWithStarsTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CommentNavigationView.h"

@interface MoreProductCommentViewController ()<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)NSMutableArray * commentModelArr;
@property(nonatomic,retain)MJRefreshNormalHeader * header;
@property(nonatomic,retain)MJRefreshAutoNormalFooter * footer;
@property(nonatomic,retain)UITableView * tableView;
@property(nonatomic,retain)NSString * numOfRequest;

@property(nonatomic,retain)NSMutableArray * cellHighArr;
@property(nonatomic,retain)UILabel * heightLabel;


@end

#define HEIGHT [[UIScreen mainScreen] bounds].size.height



@implementation MoreProductCommentViewController



- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden=YES;
    
    
    if ([self.content isEqualToString:@"dp"]) {
        [self requestCommentWithProductID:self.productID];
    }else if ([self.content isEqualToString:@"zt"]){
        [self ztCommentNetWorking];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;

    self.tabBarController.tabBar.hidden=NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _heightLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH-61*PROPORTION_WIDTH-23*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
//    _heightLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
//    _heightLabel.numberOfLines=0;
//    [self.view addSubview:_heightLabel];
//    _heightLabel.alpha=0;
//    
    
    self.cellHighArr=[NSMutableArray arrayWithCapacity:1];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT-10)];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    self.tableView.showsVerticalScrollIndicator=NO;
    //设置控制器的属性,滚动视图的子视图位置不会受到navigationbar的影响;
    self.automaticallyAdjustsScrollViewInsets=NO;

    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    _header= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _footer.automaticallyHidden=YES;
    
    self.tableView.tableHeaderView=_header;
    self.tableView.tableFooterView=_footer;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _numOfRequest=[NSString stringWithFormat:@"%@",@"2"];
    
    
    
    CommentNavigationView * label=[[CommentNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64) withName:@"全部评论"];
    [label.cancellBut addTarget:self action:@selector(cancell) forControlEvents:UIControlEventTouchUpInside];
    
    
    label.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:label];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadMoreData{
    NSLog(@"再次请求10条评论");
    if ([self.content isEqualToString:@"dp"]) {
        //请求的是单品的评论
        [self requestMoreCommentWithProductID:_productID numOfRequest:_numOfRequest];
    }else if ([self.content isEqualToString:@"zt"]){
        //请求的是主题的评论
        [self moreZtCommentNetWorkingWithNumberOfRequest:_numOfRequest];
    }
    
}
- (void)loadNewData{
    NSLog(@"请求前10条评论");
    [self.commentModelArr removeAllObjects];
    if ([self.content isEqualToString:@"dp"]) {
        //请求的是单品的评论
        [self requestCommentWithProductID:_productID];
    }else if ([self.content isEqualToString:@"zt"]){
        //请求的是主题的评论
        [self ztCommentNetWorking];
    
    }
    
}
//返回上一页
- (void)cancell{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 商品评论请求

- (void)requestCommentWithProductID:(NSString*)productID{
    //请求商品评论
    NSString * getUrl=@"http://www.qiuxinde.com/mobile/product/productCommentList";
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSDictionary * productDic2=[NSDictionary dictionaryWithObjectsAndKeys:productID,@"product_id",@"1",@"pageNum",@"10",@"pageSize", nil];
    
    [manager GET:getUrl parameters:productDic2 progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSArray * modelArr=[responseObject objectForKey:@"model"];
            for (NSDictionary * commnetDic in modelArr) {
                ProductCommentModel * model=[[ProductCommentModel alloc] init];
                [model setValuesForKeysWithDictionary:commnetDic];
                [_commentModelArr addObject:model];
            }
            [_header endRefreshing];
            [_footer resetNoMoreData];
            _numOfRequest=@"2";
            
            [self.cellHighArr removeAllObjects];
            
            
            for (ProductCommentModel * model in self.commentModelArr) {
                float  hh= [self getHeightWithStr:model.comment_content];
                [self removeHeightLabel];
                    NSString * height=[NSString stringWithFormat:@"%f",hh];
                    [self.cellHighArr addObject:height];
            }

            
            [self.tableView reloadData];
            
        }else{
            NSLog(@"请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"商品评论请求失败 :%@",error);
    }];
    
}
- (void)requestMoreCommentWithProductID:(NSString*)productID numOfRequest:(NSString*)numOfRequest{
    
    //请求商品评论
    NSString * getUrl=@"http://www.qiuxinde.com/mobile/product/productCommentList";
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSDictionary * productDic2=[NSDictionary dictionaryWithObjectsAndKeys:productID,@"product_id",numOfRequest,@"pageNum",@"10",@"pageSize", nil];
    
    [manager GET:getUrl parameters:productDic2 progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSArray * modelArr=[responseObject objectForKey:@"model"];
            for (NSDictionary * commnetDic in modelArr) {
                ProductCommentModel * model=[[ProductCommentModel alloc] init];
                [model setValuesForKeysWithDictionary:commnetDic];
                [_commentModelArr addObject:model];
                
                float  hh= [self getHeightWithStr:model.comment_content];
                [self removeHeightLabel];
                    NSString * height=[NSString stringWithFormat:@"%f",hh];
                    [self.cellHighArr addObject:height];

            }
            int comments=(int)[responseObject count];
            if (comments==0) {
                [_footer endRefreshingWithNoMoreData];
            }else{
                int num=[_numOfRequest intValue];
                num+=1;
                _numOfRequest=[NSString stringWithFormat:@"%d",num];
                [_footer endRefreshing];
            }
            
            [self.tableView reloadData];
        }else{
        
            NSLog(@"请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"商品评论请求失败 :%@",error);
    }];
    
}

#pragma mark 主题评论请求

- (void)ztCommentNetWorking{
   NSString * urlStr =@"http://www.qiuxinde.com/mobile/index/queryById/";

NSDictionary * ztDic=[NSDictionary dictionaryWithObjectsAndKeys:_ztID,@"id",@"1",@"pageNum",@"10",@"pageSize", nil];

    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    
//请求主题评论数据
[manager GET:urlStr parameters:ztDic progress:^(NSProgress * _Nonnull downloadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSLog(@"%@",responseObject);
    NSString * succeed=[responseObject objectForKey:@"code"];
    if ([succeed isEqualToString:@"0"]) {
        NSArray * modelArr=[responseObject objectForKey:@"model"];
        for (NSDictionary * commentDic in modelArr) {
            CommentModel * commentModel=[[CommentModel alloc] init];
            [commentModel setValuesForKeysWithDictionary:commentDic];
            [self.commentModelArr addObject:commentModel];
        }
        [_header endRefreshing];
        [_footer resetNoMoreData];
        _numOfRequest=@"2";
        
        [self.cellHighArr removeAllObjects];
        
        
        for (CommentModel * model in self.commentModelArr) {
            float  hh= [self getHeightWithStr:model.comment_content];
            [self removeHeightLabel];
                NSString * height=[NSString stringWithFormat:@"%f",hh];
                [self.cellHighArr addObject:height];
        }

        
        
        
        
        [_tableView reloadData];
    }else{
        NSLog(@"请求失败");
    }
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"评论数据错误:  %@",error);
}];

}
- (void)moreZtCommentNetWorkingWithNumberOfRequest:(NSString*)numberOfRequest{
    
    NSString * urlStr =@"http://www.qiuxinde.com/mobile/index/queryById/";
    
    NSDictionary * ztDic=[NSDictionary dictionaryWithObjectsAndKeys:_ztID,@"id",numberOfRequest,@"pageNum",@"10",@"pageSize", nil];
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    
    //请求主题评论数据
    [manager GET:urlStr parameters:ztDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSArray * modelArr=[responseObject objectForKey:@"model"];
            for (NSDictionary * commentDic in modelArr) {
                CommentModel * commentModel=[[CommentModel alloc] init];
                [commentModel setValuesForKeysWithDictionary:commentDic];
                [self.commentModelArr addObject:commentModel];
                
                float  hh= [self getHeightWithStr:commentModel.comment_content];
                [self removeHeightLabel];
                    NSString * height=[NSString stringWithFormat:@"%f",hh];
                    [self.cellHighArr addObject:height];
            }
            int comments=(int)[responseObject count];
            if (comments==0) {
                [_footer endRefreshingWithNoMoreData];
            }else{
                int num=[_numOfRequest intValue];
                num+=1;
                _numOfRequest=[NSString stringWithFormat:@"%d",num];
                [_footer endRefreshing];
            }
            [_tableView reloadData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"评论数据错误:  %@",error);
    }];
}


#pragma mark commentTableView  dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.commentModelArr count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.content isEqualToString:@"dp"]) {
        CommentWithStarsTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"tt"];
        if (cell==nil) {
            cell=[[CommentWithStarsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tt"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        ProductCommentModel * model=self.commentModelArr[indexPath.row];
        [cell setProductCommentModel:model];
        return cell;
    }else if ([self.content isEqualToString:@"zt"]){
        
        CommentWithStarsTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"rr"];
        if (cell==nil) {
            cell=[[CommentWithStarsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rr"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor clearColor]];
            //        cell.backgroundColor=[UIColor greenColor];
        }
        CommentModel * model=self.commentModelArr[indexPath.row];
        
        [cell setZTCommentModel:model];
        return cell;
        
        
    }
    
    
    return nil;
}

#pragma mark commentTableView  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString * height=self.cellHighArr[indexPath.row];
    NSLog(@"CELL的高度是:%@",height);
    
    float high=[height floatValue];
    return high;

//    if (high>90*PROPORTION_WIDTH) {
//        return high;
//    }else{
//        return 90*PROPORTION_WIDTH;
//    }

    
}

#pragma mark 懒加载
- (NSMutableArray *)commentModelArr{
    if (_commentModelArr==nil) {
        _commentModelArr=[NSMutableArray arrayWithCapacity:1];
    }
    return _commentModelArr;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (float)getHeightWithStr:(NSString*)content{
    
    _heightLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH-61*PROPORTION_WIDTH-23*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
    _heightLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    _heightLabel.numberOfLines=0;
    [self.view addSubview:_heightLabel];
    _heightLabel.alpha=0;
    NSString * labelText =content;
    //设置行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    _heightLabel.attributedText = attributedString;
    //    NSLog(@"%f",_commentLabel.frame.size.height);
    [_heightLabel sizeToFit];
    return _heightLabel.frame.size.height+39*PROPORTION_WIDTH;

    
    
}
- (void)removeHeightLabel{
    [_heightLabel removeFromSuperview];



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
