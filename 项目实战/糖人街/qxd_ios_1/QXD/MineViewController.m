//
//  MineViewController.m
//  QXD
//
//  Created by ZhangRui on 15/11/9.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "MineViewController.h"
#import "MineModel.h"
#import "UserInfoViewController.h"
#import "AboutMeTableViewCell.h"
#import "SetViewController.h"
#import "LastTableViewCell.h"
#import "OrderViewController.h"
#import "LastCollectionModel.h"
#import "AddressViewController.h"
#import "UserID.h"
#import "UserIDModle.h"
#import "VipViewController.h"
#import "DiscountViewController.h"
#import "NotifyViewController.h"
#import "MasterViewController.h"
#import "LastViewController.h"
//#import "SimpleViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UIImageView *imageView;//背景图
@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *imageV;//头像背景
@property(nonatomic,strong) UIImageView *iconImg;//头像图片
@property(nonatomic,strong) UILabel *iconLabel;//头像文字
@property(nonatomic,strong) UILabel *isVip;//是vip

@property(nonatomic,strong) UICollectionView *collectionView;//我的心愿单
@property(nonatomic,strong) NSMutableArray *collectionDataArray;

@property(nonatomic,strong) UIButton *rightBtn;

@property (nonatomic, strong) NSMutableArray *groups;

//@property(nonatomic,strong) NSString *useridid;
@property(nonatomic,strong) UserIDModle *userididModel;

@property(nonatomic,strong) NSString *stringWithNumber1;//购物车数量
@property(nonatomic,strong) NSString *stringWithNumber2;//购物车数量
@property(nonatomic,strong) NSString *stringWithNumber3;//购物车数量



@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatIcon];
    [self setupInit];
    [self setupData];
    [self setupSet];
    //    [self setupCollectionData];
    self.tableView.showsVerticalScrollIndicator = NO;

    
}
//创建动态头像和文字
-(void)creatIcon{
//    UserID *user = [UserID shareInState];
//    
//
//    NSMutableArray *array = [user redFromUserListAllData];
//    NSLog(@"__________%@",array);
    if (self.userididModel.ID.length > 0) {

    }else{
    ////////////////待处理
//        UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
//        userInfo.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:userInfo animated:NO];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [self getNumberWithShopping];
    //显示标签栏
    self.tabBarController.tabBar.hidden = NO;
    //显示头像

    UserID *user = [[UserID alloc] init];
    NSArray *array = [user redFromUserListAllData];
    UserIDModle *model = [array lastObject];
//    self.iconImg.image = [UIImage imageWithData:self.userididModel.userIconImg];
    //不用懒加载的数据
//    NSLog(@"%@",self.userididModel.ID);
//    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:self.userididModel.head_portrait]];
//    self.iconLabel.text = self.userididModel.nickName;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.head_portrait]];
    self.iconLabel.text = model.nickName;
    if ([self.userididModel.is_vip isEqualToString:@"1"]) {
        self.isVip.text = [NSString stringWithFormat:@"VIP有效期:%@",self.userididModel.vip_time_limit];
        self.isVip.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        self.isVip.font = [UIFont systemFontOfSize:12];
    }
    
    self.collectionDataArray = [self creatData];
    [self.tableView reloadData];
    if ([self.userididModel.load_type isEqualToString:@"sj"]) {
        
        self.iconImg.image=[UIImage imageNamed:@"默认头像"];
        
    }
    
}
//-(void)viewDidAppear:(BOOL)animated{
    
//}
//获取购物车的数量
-(void)getNumberWithShopping{
    if (self.userididModel.ID.length == 0) {
        return;
    }
    NSDictionary *dict = @{@"customer_id":self.userididModel.ID};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:OrderSize parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"0"]) {
            
            NSDictionary *dict = [responseObject objectForKey:@"model"];
            self.stringWithNumber1 = [dict objectForKey:@"dfk"];
            self.stringWithNumber2 = [dict objectForKey:@"dpj"];
            self.stringWithNumber3 = [dict objectForKey:@"dsh"];
        }
        [self.tableView reloadData];
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//设置
-(void)setupSet{

//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"site_icon"] style:UIBarButtonItemStyleBordered target:self action:@selector(setmine)];
//    [rightBtn setImage:[UIImage imageNamed:@"site_icon"]];
//    [rightBtn setTitle:@"设置"];
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [right setImage:[UIImage imageNamed:@"site_icon"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(setmine) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [left setImage:[UIImage imageNamed:@"info_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(setLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
//    self.title = @"糖人街";
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.text = @"糖人街";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [self colorWithHexString:@"#555555"];
    label.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    self.navigationItem.titleView = label;
    
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"喜欢.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(setLeft)];
//    self.navigationItem.leftBarButtonItem = leftBtn;
    
}
-(void)setmine{
    
    if (self.userididModel.ID.length == 0) {
        UserInfoViewController *userinfo = [[UserInfoViewController alloc] init];
        userinfo.VC = @"MineViewController";
        [self.navigationController pushViewController:userinfo animated:YES];
        userinfo.blockWithUser = ^(){
            [self viewWillAppear:YES];
        };
        return;
    }
    SetViewController *set = [[SetViewController alloc] init];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController  pushViewController:set animated:YES];
}
-(void)setLeft{
    if (self.userididModel.ID.length == 0) {
        UserInfoViewController *userinfo = [[UserInfoViewController alloc] init];
        userinfo.VC = @"MineViewController";
        [self.navigationController pushViewController:userinfo animated:YES];
        userinfo.blockWithUser = ^(){
            [self viewWillAppear:YES];
        };
        return;
    }
    
    NotifyViewController *notify = [[NotifyViewController alloc] init];
    [self.navigationController pushViewController:notify animated:YES];
}

//初始化界面
-(void)setupInit{
    self.imageView.image = [UIImage imageNamed:@"PK_profile_bg"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}
#pragma mark -- 拼装数据 --
-(void)setupData{
    NSMutableArray *groups = [NSMutableArray array];
    NSMutableArray *items1 = [NSMutableArray array];
    NSMutableArray *items2 = [NSMutableArray array];
    NSMutableArray *items3 = [NSMutableArray array];
    NSMutableArray *items3_1 = [NSMutableArray array];
    NSMutableArray *items3_2 = [NSMutableArray array];
    NSMutableArray *items4 = [NSMutableArray array];
    // 拼装第一组数据
    MineModel *model1 = [[MineModel alloc] init];
    //    model1.title = @"我的信息";
    model1.image = @"icon_bg";
    [items1 addObject:model1];
    
    //拼装第二组数据
    MineModel *model2 = [[MineModel alloc] init];
    model2.title = @"我的订单";
    model2.image = @"Order form_icon";
    [items2 addObject:model2];
    
    //拼装第三组数据
    MineModel *model3 = [[MineModel alloc] init];
    model3.title = @"申请严选师";
    model3.image = @"Application_icon";
    [items3 addObject:model3];
    
    //拼装第三（1）组数据
    MineModel *model3_1 = [[MineModel alloc] init];
    model3_1.title = @"收货地址";
    model3_1.image = @"address_icon";
    [items3_1 addObject:model3_1];
    
    //拼装第三（2）组数据
    MineModel *model3_2 = [[MineModel alloc] init];
    model3_2.title = @"我的优惠券";
    model3_2.image = @"coupon_icon";
    [items3_2 addObject:model3_2];
    
    //拼装第四组数据
    MineModel *model4 = [[MineModel alloc] init];
    model4.title = @"我的心愿单";
    model4.image = @"Wish List_icon";
    [items4 addObject:model4];
    
    //拼装组数据
    [groups addObject:items1];
    [groups addObject:items2];
    [groups addObject:items3];
    [groups addObject:items3_1];
    [groups addObject:items3_2];
    [groups addObject:items4];
    _groups = groups;
    

//    [self.tableView reloadData];

}
#pragma mark -- tableView 代理方法--
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _groups.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *items = _groups[section];
    return items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //第一行的
    if (indexPath.section == 0) {
        static NSString *identifer = @"MIasdf";
        AboutMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[AboutMeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        cell.backgroundColor = [self colorWithHexString:@"f7f7f7"];
        NSLog(@"__stirng1___%@___string2__%@___striing3__%@__",self.stringWithNumber1,self.stringWithNumber2,self.stringWithNumber3);
        cell.stringWithNumber1 = [NSString stringWithFormat:@"%ld",(long)[self.stringWithNumber1 integerValue]];
        cell.stringWithNumber2 = [NSString stringWithFormat:@"%ld",(long)[self.stringWithNumber2 integerValue]];;
        cell.stringWithNumber3 = [NSString stringWithFormat:@"%ld",(long)[self.stringWithNumber3 integerValue]];;
//        UILabel *imageV = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W - 38*PROPORTION_WIDTH, 7*PROPORTION_WIDTH, 5*PROPORTION_WIDTH, 5*PROPORTION_WIDTH)];
//        imageV.layer.cornerRadius = 5*PROPORTION_WIDTH;
//        imageV.layer.masksToBounds = YES;
//        imageV.backgroundColor = [UIColor redColor];
//        [self.view addSubview:imageV];
//        [self.tabBarController.tabBar addSubview:imageV];
        
        NSArray *items = _groups[indexPath.section];
        MineModel *model = items[indexPath.row];
        [cell configCellWith:model];
        cell.dfkBlock = ^(NSString *str){
            //先判断是否登录
            if (self.userididModel.ID.length == 0) {
                UserInfoViewController *userinfo = [[UserInfoViewController alloc] init];
                userinfo.VC = @"MineViewController";
                [self.navigationController pushViewController:userinfo animated:YES];
                userinfo.blockWithUser = ^(){
                    [self viewWillAppear:YES];
                };
                return;
            }
            //再执行下面的 不能isload 会异步
            OrderViewController *order = [[OrderViewController alloc] init];
            [order creatStatueWithString:str];
            [self.navigationController pushViewController:order animated:YES];
        };
        cell.dfhBlock = ^(NSString *str){
            //先判断是否登录
            if (self.userididModel.ID.length == 0) {
                UserInfoViewController *userinfo = [[UserInfoViewController alloc] init];
                userinfo.VC = @"MineViewController";
                [self.navigationController pushViewController:userinfo animated:YES];
                userinfo.blockWithUser = ^(){
                    [self viewWillAppear:YES];
                };
                return;
            }
            //再执行下面的 不能isload 会异步
            OrderViewController *order = [[OrderViewController alloc] init];
            [order creatStatueWithString:str];
            [self.navigationController pushViewController:order animated:YES];
        };
        cell.dshBlock = ^(NSString *str){
            //先判断是否登录
            if (self.userididModel.ID.length == 0) {
                UserInfoViewController *userinfo = [[UserInfoViewController alloc] init];
                userinfo.VC = @"MineViewController";
                [self.navigationController pushViewController:userinfo animated:YES];
                userinfo.blockWithUser = ^(){
                    [self viewWillAppear:YES];
                };
                return;
            }
            //再执行下面的 不能isload 会异步
            OrderViewController *order = [[OrderViewController alloc] init];
            [order creatStatueWithString:str];
            [self.navigationController pushViewController:order animated:YES];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
//    else if(indexPath.section == 5){
//        /**
//         *此处展示CollectionViewCell
//         *
//         */
//        static NSString *Collection = @"ssdfdadsf";
//        LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Collection];
////        if (!cell) {
////            cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Collection];
////        }
//        cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Collection];
//        
//        cell.dataArray = self.collectionDataArray;
//        cell.VC = self;
//        return cell;
//        
//        
//    }
    else{//中间两行
        
        static NSString *identifer = @"MINE";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        //给cell 添加分割线
        UIView *lineUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5)];
        lineUpView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [cell addSubview:lineUpView];
        UIView *lineDownView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*PROPORTION_WIDTH, SCREEN_W, 0.5)];
        lineDownView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [cell addSubview:lineDownView];
        //给cell 赋内容
        NSArray *items = _groups[indexPath.section];
        MineModel *model = items[indexPath.row];
        cell.textLabel.text = model.title;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.textLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        cell.textLabel.textColor = [self colorWithHexString:@"#555555"];
        cell.imageView.image = [UIImage imageNamed:model.image];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
//Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 5){
//        /**
//         *此处展示CollectionViewCell的高度
//         */
//        if (self.collectionDataArray.count % 2 == 0) {
//            return (WIDTH/2  + (WIDTH/4-10)) * self.collectionDataArray.count/2;
//        }return (WIDTH/2  + (WIDTH/4-10)) * (1+ self.collectionDataArray.count/2);
//    }
    if (indexPath.section == 0) {
        return 80*PROPORTION_WIDTH;
    }
    return 50*PROPORTION_WIDTH;
}

//设置标题头的名称
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 5) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
//        
//        UIImage *image = [UIImage imageNamed:@"不喜欢"];
//        UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W/3, 0, 30, 30)];
//        imagV.image = image;
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10+CGRectGetMaxX(imagV.frame), 0, 100, 30)];
//        label.font = [UIFont systemFontOfSize:14];
//        label.text = @"我的心愿单";
//        
//        [view addSubview:label];
//        [view addSubview:imagV];
//        
//        return view;
//    }else
        if (section == 0){
        [self.imageV addSubview:self.iconImg];
        [self.imageV addSubview:self.iconLabel];
        [self.imageV addSubview:self.isVip];
        return self.imageV;
    }return nil;
    
}
//设置标题头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 5) {
//        return 35;
//    }else
        if(section == 0){
        return 140*PROPORTION_WIDTH;
    }return 0.01*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 5) {
//        return 1;
//    }
    return 14*PROPORTION_WIDTH;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
         return NO;
    }return YES;
}


//点击第一个Cell触发的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //先判断是否登录
    if (self.userididModel.ID.length == 0) {
        UserInfoViewController *userinfo = [[UserInfoViewController alloc] init];
        userinfo.VC = @"MineViewController";
        [self.navigationController pushViewController:userinfo animated:YES];
        userinfo.blockWithUser = ^(){
            [self viewWillAppear:YES];
        };
        return;
    }
    //判断选择的第几行
    if (indexPath.section == 0) {
        if (indexPath.row == 0 ) {
            //跳转到第三方登录
            
        }
    }
    if (indexPath.section == 1) {
        OrderViewController *order = [[OrderViewController alloc] init];
        [self.navigationController pushViewController:order animated:YES];
    }
    if (indexPath.section == 2) {
        //跳转到 VIP   改需求
//        VipViewController *vip = [[VipViewController alloc] init];
//        [self.navigationController pushViewController:vip animated:YES];
        //跳转到 申请魔选师
        MasterViewController *master = [[MasterViewController alloc] init];
        [self.navigationController pushViewController:master animated:YES];
        
        
    }
    if (indexPath.section == 3) {
        AddressViewController *address = [[AddressViewController alloc] init];
        [self.navigationController pushViewController:address animated:YES];
    }
    if (indexPath.section == 4) {
        DiscountViewController *discount = [[DiscountViewController alloc] init];
        [self.navigationController pushViewController:discount animated:YES];
        
//        SimpleViewController *simpleV = [[SimpleViewController alloc] init];
//        [self.navigationController pushViewController:simpleV animated:YES];
    }
    if (indexPath.section == 5) {
        LastViewController *last = [[LastViewController alloc] init];
        last.dataArray = self.collectionDataArray;
        [self.navigationController pushViewController:last animated:YES];
    }

}
#pragma mark -- 懒加载 --
-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 49 - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [self colorWithHexString:@"#f7f7f7"];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;//去处分割线
        _tableView.separatorColor = [self colorWithHexString:@"DDDDDD"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _imageV.image = [UIImage imageNamed:@"icon_bg"];
    }
    return _imageV;
}

-(UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W-60*PROPORTION_WIDTH)/2, 30*PROPORTION_WIDTH, 60*PROPORTION_WIDTH, 60*PROPORTION_WIDTH)];
        _iconImg.backgroundColor = [UIColor colorWithWhite:0.89 alpha:1.0];
        _iconImg.layer.cornerRadius = 30*PROPORTION_WIDTH;
        _iconImg.layer.masksToBounds = YES;
    }
    return _iconImg;
}
-(UILabel *)isVip{
    if (!_isVip) {
        _isVip = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(self.iconLabel.frame), SCREEN_W, 20)];
        _isVip.textAlignment = NSTextAlignmentCenter;
    }
    return _isVip;
}
-(UILabel *)iconLabel{
    if (!_iconLabel) {
        _iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconImg.frame)+10*PROPORTION_WIDTH, SCREEN_W, 15*PROPORTION_WIDTH)];
        _iconLabel.textAlignment = NSTextAlignmentCenter;
        _iconLabel.font = [UIFont systemFontOfSize:14];
        _iconLabel.text = @"小米就是我";
        _iconLabel.textColor = [self colorWithHexString:@"#555555"];
    }
    return _iconLabel;
}
//collectionView
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 20)];
        _collectionView.backgroundColor = [UIColor blueColor];
 
    }
    return _collectionView;
}


//collectionDataArray
-(NSMutableArray *)collectionDataArray{
    if(!_collectionDataArray){
        _collectionDataArray = [[NSMutableArray alloc] init];
    }
    return _collectionDataArray;
}
-(NSString *)stringWithNumber1{
    if (!_stringWithNumber1) {
        _stringWithNumber1 = @"0";
    }
    return _stringWithNumber1;
}
-(NSString *)stringWithNumber2{
    if (!_stringWithNumber2) {
        _stringWithNumber2 = @"0";
    }
    return _stringWithNumber2;
}
-(NSString *)stringWithNumber3{
    if (!_stringWithNumber3) {
        _stringWithNumber3 = @"0";
    }
    return _stringWithNumber3;
}

#pragma mark --- 加载我的心愿单 ---
-(NSMutableArray *)creatData{
    NSMutableArray *array = [NSMutableArray array];
//    NSDictionary *dic = @{@"customer_id":self.userididModel.userID};
    UserID *user = [UserID shareInState];
    _userididModel = [[user redFromUserListAllData] lastObject];
    NSArray *arrayay = [user redFromUserListAllData];
    if (arrayay.count == 0) {
        return array;
    }else{
    NSDictionary *dic = @{@"customer_id":_userididModel.ID};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:WishList parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"code"] isEqualToString:@"0"]) {
                    NSLog(@"成功");
                    NSArray *objectArray = [responseObject objectForKey:@"model"];
                    for (NSDictionary *dictionary in objectArray) {
                        LastCollectionModel *modd = [[LastCollectionModel alloc] initWithDic:dictionary];
                        [array addObject:modd];
                    }
                    [self.tableView reloadData];
                }else{
                    NSLog(@"数据格式不对");
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Error:%@",error);
        }];

        
    return array;
    }
}
//-(NSString *)useridid{
//    if (!_useridid) {
//        UserID *user = [UserID shareInState];
//        UserIDModle *modle = [[user redFromUserListAllData] lastObject];
//        _useridid = modle.userID;
//
//    }
//    return _useridid;
//}
-(UserIDModle *)userididModel{
    if (!_userididModel) {
        UserID *user = [UserID shareInState];
        _userididModel = [[user redFromUserListAllData] lastObject];
    }
    return _userididModel;
}

#pragma mark --- 颜色 ---
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