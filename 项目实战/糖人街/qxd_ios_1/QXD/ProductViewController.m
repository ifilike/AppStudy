//
//  ProductViewController.m
//  QXD
//
//  Created by ZhangRui on 15/11/9.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "ProductViewController.h"
#import "FindModel.h"
#import "DeTaiilsViewController2.h"
#import "ProductTypeView.h"
#import "ByxxrMode.h"
#import "FindLittleModel.h"
#import "FoundImageButton.h"
#import "InterestTableViewCell.h"
#import "FindHeadView.h"
#import "WithLabelImageView.h"
#import "InterestListView.h"
#import "DetailsViewController.h"
#import "TableViewCell3.h"
#import "InterestSubView.h"
#import "InterestProductModel.h"
#import "FoundZTModel.h"
#import "FoundZTViewController.h"
#import "DetailsTableViewCell2.h"
#import "BuyViewController.h"
#import "KnowledgeViewController.h"
#import "MSCNetworkTypeMonitor.h"
#import "NetWorkNoView.h"



@interface ProductViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView * tableView;                    //主列表
@property(nonatomic,strong)NSMutableArray * foundZTArr;
//@property(nonatomic,retain)FindHeadView * headView;
@property(nonatomic,strong)NSMutableArray * productlistArr;            //请求下来的数据
@property(nonatomic,retain)AFHTTPSessionManager * manager;    //网络请求单例
@property(nonatomic,assign)float setOffY;
@property(nonatomic,retain)UIImageView * applyPeopleView;
@property(nonatomic,retain)UIImageView * applySkinView;
@property(nonatomic,retain)UIImageView * methodView;
@property(nonatomic,retain)NSArray * threeImageArr;
@property(nonatomic,retain)UIImageView * moistureView;
@property(nonatomic,retain)UIImageView * typeButtonView;
@property(nonatomic,retain)UILabel * typeLabel;
@property(nonatomic,retain)UIImageView * componentButtonView;
@property(nonatomic,retain)UILabel * componentLabel;
@property(nonatomic,retain)UIView * leftLien;
@property(nonatomic,retain)UIView * rightLien;
@property(nonatomic,retain)UILabel * likeLabel;

@property(nonatomic,retain)NSString * netWorkType;
@property(nonatomic,retain)NetWorkNoView * netWorkNoView;

@end




#define HEIGHT [[UIScreen mainScreen] bounds].size.height


@implementation ProductViewController


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    [self repeatRequest2];
    
}
- (void)repeatRequest2{

    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kMSCNetworkTypeChangedNotification
                                               object: nil];
    //网络请求单利
    _manager=[AFHTTPSessionManager manager];
    NSLog(@"%@",_manager);
    
    
    //发现主页面布局
    [self mainLayout];
//    UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
//    label.text=@"发现";
//    label.backgroundColor=[UIColor clearColor];
//    label.textAlignment=1;
//    [self.view addSubview:label];

}
// 网络类型发生改变
- (void)reachabilityChanged:(NSNotification *)note
{
    MSCNetworkTypeMonitor* monitor = [note object];
    MSCNetworkType status = monitor.networkType;
    NSString *name = [self networkTypeName:status];
    
    self.netWorkType = name;
    
    if ([_netWorkType isEqualToString:@"WiFi"]) {
        [self requestAllProducts];
        [self requestDefaultProducts];
        [_netWorkNoView removeFromSuperview];
    }else if ([_netWorkType isEqualToString:@"2G"]){
       // [self requestAllProducts];
       // [self requestDefaultProducts];
    }else if ([_netWorkType isEqualToString:@"3G"]){
        [self requestAllProducts];
        [self requestDefaultProducts];
        [_netWorkNoView removeFromSuperview];

    }else if ([_netWorkType isEqualToString:@"4G"]){
        [self requestAllProducts];
        [self requestDefaultProducts];
        [_netWorkNoView removeFromSuperview];

    }else if ([_netWorkType isEqualToString:@"No"]){
        // [self shopCarNum];
        // [self ztNetWorking];
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

#pragma mark 网络请求
- (void)requestAllProducts{
    NSString * url=@"http://www.qiuxinde.com/mobile/product/allProduct";
    [_manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"猜你喜欢请求成功%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSArray * modelArr=[responseObject objectForKey:@"model"];
            for (NSDictionary * defaultDic in modelArr) {
                //所有产品
                InterestProductModel * model=[[InterestProductModel alloc] init];
                [model setValuesForKeysWithDictionary:defaultDic];
                [self.productlistArr addObject:model];
                NSLog(@"现在有%lu个产品",(unsigned long)self.productlistArr.count);
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"猜你喜欢请求失败%@",error);
    }];
    
}
//默认的产品信息
- (void)requestDefaultProducts{
    NSString * url=@"http://www.qiuxinde.com/mobile/found/showlist";
    NSDictionary * urlDic=[NSDictionary dictionaryWithObject:@"fx" forKey:@"type"];
    [_manager GET:url parameters:urlDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发现请求成功%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSArray * modelArr=[responseObject objectForKey:@"model"];
            for (NSDictionary * defaultDic in modelArr) {
              //  NSLog(@"%@",defaultDic.);
                //默认
                FoundZTModel * model=[[FoundZTModel alloc] init];
                [model setValuesForKeysWithDictionary:defaultDic];
                [self.foundZTArr addObject:model];
                NSLog(@"现在有%lu个默认 CELL",(unsigned long)self.foundZTArr.count);
            }
            
            
            [self reloadData];
            [self.tableView reloadData];
        }else{
            NSLog(@"请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发现请求失败%@",error);
    }];
}


#pragma mark 布局

- (void)mainLayout{
    
    
    
//    _headView=[[FindHeadView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, (WIDTH-20)*2/3+15)];
//    _headView.delegate=self;
    
    //主列表
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, -20, WIDTH, HEIGHT+20)];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
    
    //适用肤质
    _applySkinView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 400*PROPORTION_WIDTH)];
//    _applySkinView.image=[UIImage imageNamed:@"适用人群"];

    
    
    //适用人群
    _applyPeopleView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 15*PROPORTION_WIDTH, WIDTH, 400*PROPORTION_WIDTH)];
//    _applyPeopleView.image=[UIImage imageNamed:@"适用人群"];
    
    //使用方法
    _methodView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 15*PROPORTION_WIDTH, WIDTH, 400*PROPORTION_WIDTH)];
//    _methodView.image=[UIImage imageNamed:@"使用方法"];
    
    //存放前三张图片的数组
    _threeImageArr=[NSArray arrayWithObjects:_applySkinView,_applyPeopleView,_methodView, nil];
    
    //面膜种类百科
    _typeButtonView=[[UIImageView alloc] initWithFrame:CGRectMake(68.75*PROPORTION_WIDTH, 48*PROPORTION_WIDTH, 50*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
    _typeButtonView.image=[UIImage imageNamed:@"mianmo zhongleibaike_icon"];
    _typeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 108*PROPORTION_WIDTH, WIDTH/2, 25*PROPORTION_WIDTH)];
    _typeLabel.text=@" ";
    _typeLabel.textAlignment=1;
    _typeLabel.textColor=[self colorWithHexString:@"#555555"];
    _typeButtonView.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap1=[[UITapGestureRecognizer alloc] init];
    [tap1 addTarget:self action:@selector(maskType)];
    [_typeButtonView addGestureRecognizer:tap1];
    
    
    
    
    //面膜成分百科
    _componentButtonView=[[UIImageView alloc] initWithFrame:CGRectMake(256.25*PROPORTION_WIDTH, 48*PROPORTION_WIDTH, 50*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
    _componentButtonView.image=[UIImage imageNamed:@"mianmochengfengbaike_icon"];
    _componentLabel=[[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2, 108*PROPORTION_WIDTH, WIDTH/2, 25*PROPORTION_WIDTH)];
    _componentLabel.text=@" ";
    _componentLabel.textColor=[self colorWithHexString:@"#555555"];
    _componentLabel.textAlignment=1;
    _componentButtonView.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap2=[[UITapGestureRecognizer alloc] init];
    [tap2 addTarget:self action:@selector(maskComponent)];
    [_componentButtonView addGestureRecognizer:tap2];
    
    //保湿图片
    _moistureView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 171*PROPORTION_WIDTH)];
//    _moistureView.image=[UIImage imageNamed:@"保湿"];
    
    //猜你喜欢的标志
    _leftLien=[[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 10*PROPORTION_WIDTH, 133*PROPORTION_WIDTH, 1)];
    _leftLien.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
    
    _rightLien=[[UIView alloc] initWithFrame:CGRectMake(WIDTH-148*PROPORTION_WIDTH, 10*PROPORTION_WIDTH, 133*PROPORTION_WIDTH, 1)];
    _rightLien.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
    
    _likeLabel=[[UILabel alloc] initWithFrame:CGRectMake(159*PROPORTION_WIDTH, -5*PROPORTION_WIDTH, WIDTH-318*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    _likeLabel.text=@"宝贝集";
//    _likeLabel.backgroundColor=[UIColor blueColor];
    _likeLabel.textAlignment=1;
    _likeLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    _likeLabel.textColor=[self colorWithHexString:@"#FD681F"];
    
    
    // 获取网络类型
    MSCNetworkType type = [MSCNetworkTypeMonitor sharedInstance].networkType;
    
    self.netWorkType=[self networkTypeName:type];
    
    if ([_netWorkType isEqualToString:@"WiFi"]) {
        //        [self shopCarNum];
        //        [self ztNetWorking];
        [self requestAllProducts];
        [self requestDefaultProducts];
    }else if ([_netWorkType isEqualToString:@"2G"]){
        // [self requestAllProducts];
        // [self requestDefaultProducts];
        self.netWorkNoView=[[NetWorkNoView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, WIDTH*1334/750)];
        [self.view addSubview:_netWorkNoView];
    }else if ([_netWorkType isEqualToString:@"3G"]){
        [self requestAllProducts];
        [self requestDefaultProducts];
    }else if ([_netWorkType isEqualToString:@"4G"]){
        [self requestAllProducts];
        [self requestDefaultProducts];
    }else if ([_netWorkType isEqualToString:@"No"]){
        // [self shopCarNum];
        // [self ztNetWorking];
        self.netWorkNoView=[[NetWorkNoView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, WIDTH*1334/750)];
        [self.view addSubview:_netWorkNoView];
    }

    
    
}

- (void)reloadData{
    if (_foundZTArr.count>=3) {
        
        for (int i=0; i<3; i++) {
            UIImageView * imageView=_threeImageArr[i];
            FoundZTModel * model=_foundZTArr[i];
            NSURL * imageUrl=[NSURL URLWithString:model.img];
            [imageView sd_setImageWithURL:imageUrl];
        }
        FoundZTModel * model2=_foundZTArr[3];
        FoundZTModel * model3=_foundZTArr[4];
        _typeLabel.text=model2.title;
        _componentLabel.text=model3.title;
        
        
        
        
        FoundZTModel * model=[_foundZTArr lastObject];
        NSURL * imageUrl=[NSURL URLWithString:model.img];
        [_moistureView sd_setImageWithURL:imageUrl];
        
        
        
        
        
    }
    
}


#pragma mark 跳转
- (void)presentProductDetailsViewControllerviewWithButton:(UIButton*)button{
    
    InterestSubView * view=(InterestSubView*)button;
    DeTaiilsViewController2 * viewController=[[DeTaiilsViewController2 alloc] init];
    viewController.hidesBottomBarWhenPushed=YES;
    viewController.productID=view.productID;
    [self.navigationController pushViewController:viewController animated:YES];
    
}
- (void)presentViewControllerWithID:(NSString*)foundZTID{
    NSLog(@"跳转");
    
    [self presentKnowledgeViewControllerWithID:foundZTID];

    
}


- (void)maskType{
    NSLog(@"面膜种类");
    
    FoundZTModel * model=self.foundZTArr[3];
    [self presentKnowledgeViewControllerWithID:model.ID];

}
- (void)maskComponent{
    NSLog(@"面膜成分");
    FoundZTModel * model=self.foundZTArr[4];

    [self presentKnowledgeViewControllerWithID:model.ID ];
    
}

- (void)presentKnowledgeViewControllerWithID:(NSString*)ID{

    KnowledgeViewController * knowledgeViewController=[[KnowledgeViewController alloc] init];
    knowledgeViewController.hidesBottomBarWhenPushed=YES;
    knowledgeViewController.ztID=ID;
    [self.navigationController pushViewController:knowledgeViewController animated:YES];
    
}
//- (void)presentFoundZTViewControllerWithID:(NSString*)ID{
//    FoundZTViewController * foundZTViewController=[[FoundZTViewController alloc] init];
//    foundZTViewController.ztID=ID;
//    foundZTViewController.hidesBottomBarWhenPushed=YES;
//
//    [self.navigationController pushViewController:foundZTViewController animated:YES];
//
//    
//}

#pragma mark tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        int count=(int)[self.foundZTArr count];
        return 3;
    }else if(section==1){
        return 1;
    }else if (section==2){
        return 1;
    }else if (section==3){
        int count=(int)self.productlistArr.count;
        if (count%2==0) {
            return count/2;
        }else{
            return (count+1)/2;
        }
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}       

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"qq"];
        if (cell==nil) {
            cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qq"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        UIImageView * imageView=_threeImageArr[indexPath.row];
        [cell addSubview:imageView];
                return cell;
    }else if (indexPath.section==1){
        DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"ww"];
        if (cell==nil) {
            cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ww"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row==0) {
            [cell addSubview:_typeButtonView];
            [cell addSubview:_typeLabel];
            [cell addSubview:_componentButtonView];
            [cell addSubview:_componentLabel];
        }else{
            [cell addSubview:_moistureView];
        }
        return cell;
    }else if(indexPath.section==2){
        DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"ee"];
        if (cell==nil) {
            cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ee"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
//        cell.backgroundColor=[UIColor redColor];
        [cell addSubview:_likeLabel];
        [cell addSubview:_leftLien];
        [cell addSubview:_rightLien];
        
        return cell;
    }else if (indexPath.section==3){
        InterestTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"rr"];
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
        for (InterestSubView * subView in cell.subButttonArr) {
            [subView addTarget:self action:@selector(presentProductDetailsViewControllerviewWithButton:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        return cell;
    }
    return nil;
}
#pragma mark tableView 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
        if (_foundZTArr.count>=3) {
            FoundZTModel * model=_foundZTArr[indexPath.row];
            
            [self presentViewControllerWithID:model.ID];
        }
        
        
    }
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 400*PROPORTION_WIDTH;
            
        }else{
            return 415*PROPORTION_WIDTH;
        }
        return 0;
        
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            return 165*PROPORTION_WIDTH;
        }else{
            return 171*PROPORTION_WIDTH;
        }
        return 0;
    }else if (indexPath.section==2){
        return 40*PROPORTION_WIDTH;
    }else if (indexPath.section==3){
        return 266*PROPORTION_WIDTH;
    }
    return 0;
}

#pragma mark 懒加载

- (NSMutableArray *)foundZTArr{
    if (_foundZTArr==nil) {
        _foundZTArr=[NSMutableArray arrayWithCapacity:1];
        
    }
    return _foundZTArr;
}
- (NSMutableArray *)productlistArr{
    if (_productlistArr==nil) {
        _productlistArr=[NSMutableArray arrayWithCapacity:1];
    }
    return _productlistArr;
}
#pragma mark headView代理方法
//- (void)doSomethingWithString:(NSString *)ID{
//    NSLog(@"++++%@",ID);
//    [self presentFoundZTViewControllerWithID:ID];
//
//}

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
