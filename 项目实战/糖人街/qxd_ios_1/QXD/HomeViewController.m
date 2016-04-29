//
//  HomeViewController.m
//  QXD
//
//  Created by ZhangRui on 15/11/9.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "HomeViewController.h"
#import "DeTaiilsViewController2.h"     //单品页控制器
#import "DetailsViewController.h"       //主题详情页控制器
#import "HomeTableViewCell.h"           //第一个分区和第三个分区的通用Cell类
#import "HomeTableViewCell3.h"          //第二个分区Cell类
#import "HomeModel.h"                   //首页数据模型
#import "HomeModel2.h"                  //首页数据模型
#import "SubGoodsView.h"                //首页的商品展示模块
#import "UserID.h"                      //用户信息
#import "DefaultModel.h"                //原设计中间的数据模型
#import "FoundImageButton.h"            //
#import "AllDeTailsViewController.h"    //原设计查看全部页面控制器
#import "FriendsViewController.h"       //判断有没有登录
#import "UserInfoViewController.h"      //用户信息
#import "CommentNavigationView.h"       //自定义的导航栏(原是为了给评论页用,后来多处用到)
#import "MSCNetworkTypeMonitor.h"       //获取当前网络类型
#import "NetWorkNoView.h"               //断网时的占位图


@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * tableView;        //主界面
@property(nonatomic,strong)NSMutableArray * ztModelArr;    //前两个Cell的数据
@property(nonatomic,strong)NSMutableArray * ztModelArr2;   //第四个Cell及以后的数据
@property(nonatomic,retain)DefaultModel * defaultModel;    //原来设计的中间部分数据源
@property(nonatomic,retain)UILabel * navigationLabel;      //代替系统的导航栏
@property(nonatomic,retain)AFHTTPSessionManager * manager; //网络请求的对象
@property(nonatomic,retain)NSString * netWorkType;         //网络状态
@property(nonatomic,retain)NetWorkNoView * netWorkNoView;  //网络不给力图片



@end



#define HEIGHT [[UIScreen mainScreen] bounds].size.height  //宏定义屏幕高度

@implementation HomeViewController



#pragma mark 系统方法




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //添加通知,当网络状态发生改变的时候执行reachabilityChanged方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kMSCNetworkTypeChangedNotification
                                               object: nil];
    
    
    
    
//
    //主列表
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, HEIGHT-20)];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //去除默认的分隔线
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //用来占位的主列表头视图(必须有)
    UIView * headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 24)];
    _tableView.tableHeaderView=headView;
    [self.view addSubview:_tableView];
    
    //网络请求对象实例化
    self.manager=[AFHTTPSessionManager manager];
    
    //自定义的导航栏
    
    
    //自定义的导航栏
    _navigationLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    _navigationLabel.backgroundColor=[UIColor whiteColor];
    _navigationLabel.text=@"糖人街";
    _navigationLabel.textColor=[self colorWithHexString:@"#555555"];
    _navigationLabel.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    _navigationLabel.textAlignment=1;
    
    //一条线来区分边界
    UIView * lienView=[[UIView alloc] initWithFrame:CGRectMake(0, 43.5, WIDTH, 1)];
    lienView.backgroundColor=[self colorWithHexString:@"DDDDDD"];
    [_navigationLabel addSubview:lienView];
    [self.view addSubview:_navigationLabel];
    
    
    // 获取网络类型
    MSCNetworkType type = [MSCNetworkTypeMonitor sharedInstance].networkType;
    
    self.netWorkType=[self networkTypeName:type];
    
    if ([_netWorkType isEqualToString:@"WiFi"]) {
        [self shopCarNum];
        [self ztNetWorking];
    }else if ([_netWorkType isEqualToString:@"2G"]){
        self.netWorkNoView=[[NetWorkNoView alloc] initWithFrame:CGRectMake(0, 65, WIDTH, 1334*WIDTH/750)];
        [self.view addSubview:_netWorkNoView];
    }else if ([_netWorkType isEqualToString:@"3G"]){
        [self shopCarNum];
        [self ztNetWorking];
    }else if ([_netWorkType isEqualToString:@"4G"]){
        [self shopCarNum];
        [self ztNetWorking];
    }else if ([_netWorkType isEqualToString:@"No"]){
        self.netWorkNoView=[[NetWorkNoView alloc] initWithFrame:CGRectMake(0, 65, WIDTH, 1334*WIDTH/750)];
        [self.view addSubview:_netWorkNoView];
        
    }

}
// 网络类型发生改变
- (void)reachabilityChanged:(NSNotification *)note
{
    MSCNetworkTypeMonitor* monitor = [note object];
    MSCNetworkType status = monitor.networkType;
    NSString *name = [self networkTypeName:status];
    
    self.netWorkType = name;
    
    if ([_netWorkType isEqualToString:@"WiFi"]) {
        [self shopCarNum];
        [self ztNetWorking];
        [_netWorkNoView removeFromSuperview];
    }else if ([_netWorkType isEqualToString:@"2G"]){
    }else if ([_netWorkType isEqualToString:@"3G"]){
        [self shopCarNum];
        [self ztNetWorking];
        [_netWorkNoView removeFromSuperview];

    }else if ([_netWorkType isEqualToString:@"4G"]){
        [self shopCarNum];
        [self ztNetWorking];
        [_netWorkNoView removeFromSuperview];

    }else if ([_netWorkType isEqualToString:@"No"]){

    }
    
    
    
}
- (NSString *)networkTypeName:(MSCNetworkType)networkType
{
    NSString *string = @"*****";
    
    switch (networkType)
    {
        case kMSCNetworkTypeNone:
            NSLog(@"NotReachable");
            string = @"No";
            break;
            
        case kMSCNetworkTypeWiFi:
            NSLog(@"ReachableViaWiFi");
            string = @"WiFi";
            break;
            
        case kMSCNetworkTypeWWAN:
            NSLog(@"ReachableViaWWAN");
            string = @"WWAN";
            break;
            
        case kMSCNetworkType2G:
            NSLog(@"kReachableVia2G");
            string = @"2G";
            break;
            
        case kMSCNetworkType3G:
            NSLog(@"kReachableVia3G");
            string = @"3G";
            break;
            
        case kMSCNetworkType4G:
            NSLog(@"kReachableVia4G");
            string = @"4G";
            break;
        default:
            NSLog(@"default");
            string = @"default";
            break;
    }
    
    return string;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    //本页面出现时隐藏导航栏
    self.navigationController.navigationBar.hidden=YES;
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    //本页面消失时显示导航栏(这样不会影响到相关的跳转页面)
    self.navigationController.navigationBar.hidden=NO;
   // [self.ztModelArr removeAllObjects];
   // [self.ztModelArr2 removeAllObjects];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 请求数据
- (void)loadNewData2{
    

    //请求首页的主题数据
    
    [self ztNetWorking];
    


}
- (void)ztNetWorking{
    [self.ztModelArr removeAllObjects];
    [self.ztModelArr2 removeAllObjects];
    //请求主题数据
    NSString * zhuti=@"http://www.qiuxinde.com/mobile/index/showlist";
    //参数字典
    NSDictionary * zhutiDic=[NSDictionary dictionaryWithObject:@"zt" forKey:@"type"];
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];

    //进行请求
    [manager GET:zhuti parameters:zhutiDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"主题数据  %@",responseObject);
        //用来判断请求是否成功
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSLog(@"成功");

            //数据数组
            NSArray * modelArr=[responseObject objectForKey:@"model"];
            int count=(int)[modelArr count];
            for (int i=0; i<count; i++) {
                NSDictionary * dic=modelArr[i];
                HomeModel * model=[[HomeModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                if (i<2) {
                    //前面两个Cell的内容
                    [self.ztModelArr addObject:model];
                    NSLog(@"%lu",(unsigned long)[_ztModelArr count]);
                }else{
                    //第四个cell的内容(第三个被隐藏了,目前不需要)
                    [self.ztModelArr2 addObject:model];
                    NSLog(@"%lu",(unsigned long)[_ztModelArr2 count]);
                }
                //接受完数据刷新页面
                [_tableView reloadData];
            }
            
        }else{
            NSLog(@"请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:  %@",error);
    }];
    

}
//中间的发现请求(现在没有用到)
- (void)requestDefaultProducts{
    //请求第三条Cell的数据
    NSString * url=@"http://www.qiuxinde.com/mobile/found/showlist";
    //参数字典
    NSDictionary * dict=[NSDictionary dictionaryWithObject:@"sy" forKey:@"type"];
    //进行请求
    [_manager GET:url parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功%@",responseObject);
        NSDictionary * defaultDic=responseObject[0];
        //默认
        _defaultModel=[[DefaultModel alloc] init];
        [_defaultModel setValuesForKeysWithDictionary:defaultDic];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发现默认请求失败%@",error);
    }];
    
}
- (void)shopCarNum{
    //先判断有没有登录
    UserID *user = [UserID shareInState];
    NSArray *array = [user redFromUserListAllData];
    if (array.count != 0) {
        FriendsViewController * controller=[[FriendsViewController alloc] init];
        [controller creatDataSourceAgien];
    }
}


#pragma mark 页面跳转
//查看全部
- (void)presentAll{
    NSLog(@"查看全部");
    AllDeTailsViewController * allProductsViewController=[[AllDeTailsViewController alloc] init];
    [self.navigationController pushViewController:allProductsViewController animated:YES];
}
//主题详情
- (void)presentWithZtModel:(HomeModel*)ztModel{
    
    DetailsViewController * control=[[DetailsViewController alloc] init];
    control.ztID=ztModel.ID;
    [self.navigationController pushViewController:control animated:YES];
}
//单品页
- (void)presentDetailsAndCommentWithBut:(UIButton*)button{
    //获取到点击的商品的父视图,可以得到产品信息
    SubGoodsView * view=(SubGoodsView*)[button superview];
    DeTaiilsViewController2 * viewController=[[DeTaiilsViewController2 alloc] init];
    viewController.hidesBottomBarWhenPushed=YES;
    viewController.productID=view.productID;
    viewController.imageData=view.imageData;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark 懒加载
//存放前两个Cell的数据
- (NSMutableArray *)ztModelArr{
    if (_ztModelArr==nil) {
        _ztModelArr=[NSMutableArray arrayWithCapacity:0];
    }
    return _ztModelArr;
}
//存放第四个及以后的Cell的数据
- (NSMutableArray *)ztModelArr2{
    if (_ztModelArr2==nil) {
        _ztModelArr2=[NSMutableArray arrayWithCapacity:0];
    }
    return _ztModelArr2;
}
#pragma mark tableView dataSource
//三个分区,第一个是2个Cell,第二个是1个Cell,第三个不确定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        //第一个分区和第三个分区的通用Cell类
        HomeTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"qq"];
        if (cell==nil) {
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell=[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSLog(@"%ld",self.ztModelArr.count);
        HomeModel * model=self.ztModelArr[indexPath.row];
        if (indexPath.row==0) {
            NSLog(@"%@",model.content);
        }
        [cell setModel:model];
        //cell上的Button添加点击事件
        for (SubGoodsView * sub in cell.subViewArr) {
            [sub.imageButton addTarget:self action:@selector(presentDetailsAndCommentWithBut:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }else if (indexPath.section==1){
        //第二个分区的Cell类
        HomeTableViewCell3 * cell=[tableView dequeueReusableCellWithIdentifier:@"q"];
        if (cell==nil) {
            cell=[[HomeTableViewCell3 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"q"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell setModel:_defaultModel];
        //cell上的Button添加点击事件
        [cell.allGoodsBut addTarget:self action:@selector(presentAll) forControlEvents:UIControlEventTouchUpInside];
        [cell.imageBut addTarget:self action:@selector(presentAll) forControlEvents:UIControlEventTouchUpInside];
        for (SubGoodsView * sub in cell.subViewArr) {
            [sub.imageButton addTarget:self action:@selector(presentDetailsAndCommentWithBut:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }else if(indexPath.section==2){
        
        HomeTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"qq"];
        if (cell==nil) {
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell=[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        HomeModel * model=self.ztModelArr2[indexPath.row];
        NSLog(@"%@",model.content);
        if (indexPath.row==self.ztModelArr2.count-1) {
            cell.lienView.hidden=YES;
            cell.grayView.hidden=YES;
        }
        [cell setModel:model];
        //cell上的Button添加点击事件
        for (SubGoodsView * sub in cell.subViewArr) {
            [sub.imageButton addTarget:self action:@selector(presentDetailsAndCommentWithBut:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return [self.ztModelArr count];
    }else if(section==1){
        return 0;//原设计中间有第二个分区
    }else if(section==2){
        return [self.ztModelArr2 count];
    }
    return 0;
}

#pragma mark tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        //返回一个cell的高度,是根据SubGoodsView这个类算出来的,SubGoodsView的高度是141*PROPORTION_WIDTH+48,滚动视图的高度是186*PROPORTION_WIDTH+48,
        return 544*PROPORTION_WIDTH+50;
    }else if(indexPath.section==1){
        return 467*PROPORTION_WIDTH+50;
    }else{
        return 544*PROPORTION_WIDTH+50;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        HomeModel * model=self.ztModelArr[indexPath.row];
        [self presentWithZtModel:model];
    
    }else if(indexPath.section==1){

    }else{
        HomeModel * model=self.ztModelArr2[indexPath.row];
        [self presentWithZtModel:model];
    }
    
}

#pragma mark 动画效果
//导航栏的隐藏动画
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"偏移量是: %f",scrollView.contentOffset.y);
//    float hh=scrollView.contentOffset.y+20;
//    NSLog(@"%f",hh);
    
    if (scrollView.contentOffset.y>-20) {
        [UIView animateWithDuration:0.3 animations:^{
            _navigationLabel.frame=CGRectMake(0, -44, WIDTH, 44);
        }];
    }
    if (scrollView.contentOffset.y<=-20){
        [UIView animateWithDuration:0.3 animations:^{
            _navigationLabel.frame=CGRectMake(0, 20, WIDTH, 44);
        }];
    }
}

#pragma mark 获得颜色

- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
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
