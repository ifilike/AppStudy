//
//  FriendsViewController.m
//  QXD
//
//  Created by ZhangRui on 15/11/9.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//
#import "FriendsViewController.h"
#import "LTableViewCell.h"
#import "CalucateViewController.h"
#import "UserID.h"
#import "UserIDModle.h"
#import "FriendsModel.h"
#import "AppDelegate.h"

#import "UserInfoViewController.h"
#import "KVOModle.h"

@interface FriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    
    
    
    UITableView *table;
    NSMutableArray *contacts;
    UIButton *button;
    NSInteger cellCount;
    UIView *_payView;
    UILabel *_label2;
    NSString *_telePhomeNunber;
    UIView *_telePhoneNumberVc;
    UIView *_rectiveVc;
    UIView *_payVC;
    UIView *_homeMuchVc;
    
    UIButton *_rightButton;
}

@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) NSMutableArray *calucateDataArray;

@property(nonatomic,assign) float money;
@property(nonatomic,assign) float totalMoney;

@property(nonatomic,strong) UILabel *label1;
@property(nonatomic,strong) UILabel *label5;

@property(nonatomic,strong) UIView *firstView;//没有登录
@property(nonatomic,strong) UIView *whiteView;//购物车空空

@property(nonatomic,strong) UIAlertView *alert;

@property(nonatomic,strong) UIView *AllSelectView;//全选视图
@property(nonatomic,strong) UIButton *allSelectButton;//全选按钮
@property(nonatomic,strong) UIButton *AllBtn;//结算按钮
@property(nonatomic,assign) BOOL isHid;//是否隐藏编辑视图
@property(nonatomic,strong) KVOModle *kvoModel;//kvo
@property(nonatomic,assign) NSInteger totalCountShopping;//kvo数量

@end

@implementation FriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellCount = 0;
    self.isHid = YES;
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_W, SCREEN_H - 49 - 44) style:UITableViewStyleGrouped];
 
    table.showsVerticalScrollIndicator = NO;
    table.separatorColor = [self colorWithHexString:@"#DDDDDD"];

    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"全选" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 80, 50);
    
    [button setImage:[UIImage imageNamed:@"select_normal_icon"] forState:UIControlStateNormal];
    [self creatRightNavBarButton];
}
#pragma mark --- 购物车右侧的编辑 ---
-(void)creatRightNavBarButton{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, SCREEN_W - 200, 44)];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 60, 20, 50, 44)];
    titleLabel.text = @"购物车";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    titleLabel.textColor = [self colorWithHexString:@"#555555"];
    
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[self colorWithHexString:@"FD681F"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    [rightBtn addTarget:self action:@selector(editingCell) forControlEvents:UIControlEventTouchUpInside];
    _rightButton = rightBtn;
    topView.backgroundColor = [self colorWithHexString:@"f7f7f7"];
    
    [topView addSubview:titleLabel];
    [topView addSubview: rightBtn];
    [self.view addSubview:topView];
    
}


#pragma mark --- 购物车编辑的点击事件 ---
-(void)editingCell{
    
    if ([_rightButton.titleLabel.text isEqualToString:@"编辑"]){
        [_rightButton setTitle:@"完成" forState:UIControlStateNormal];
        self.isHid = NO;
        
    }else if([_rightButton.titleLabel.text isEqualToString:@"完成"]){
        [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        self.isHid = YES;
    }
    //[self creatDataSourceAgien];
    [table reloadData];
    
}

#pragma mark -- tableView Delegate --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"Cell";
    LTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSUInteger row = [indexPath row];
    NSMutableDictionary *dic = [contacts objectAtIndex:row];
    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
        [dic setObject:@"NO" forKey:@"checked"];
        [cell setChecked:NO];
    }else {
        [dic setObject:@"YES" forKey:@"checked"];
        [cell setChecked:YES];
    }
    //循环遍历如果有NO 就显示NO
    for (NSDictionary *d in contacts) {
        if ([[d objectForKey:@"checked"]isEqualToString:@"NO"]) {
            self.allSelectButton.selected = NO;
        }
    }
    
    FriendsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configCellWithFriendsModel:model];
    cell.product_num_string = model.ID;
    
    cell.moneyTotal = ^(float a){
        self.money = a;
    };
    cell.BlockReload = ^{
        [self creatDataSourceAgienAgien];
    };
    cell.editingView.hidden = self.isHid;//是否隐藏编辑视图
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.AllBtn setTitle:@"结算" forState:UIControlStateNormal];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LTableViewCell *cell = (LTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    NSUInteger row = [indexPath row];
    NSMutableDictionary *dic = [contacts objectAtIndex:row];
    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
        [dic setObject:@"YES" forKey:@"checked"];
        [cell setChecked:YES];
        //添加数据到calucateDataArrya
        
        FriendsModel *frednModel = [self.dataArray objectAtIndex:indexPath.row];
        [self.calucateDataArray addObject:frednModel];
        //计算总钱
        [cell creatTotalMoney];
        self.totalMoney += self.money;
        NSLog(@"%.2f",self.totalMoney);
        _label2.text = [NSString stringWithFormat:@"商品总价%.2f",self.totalMoney];
        //计算个数
        cellCount ++;
        _label1.text = [NSString stringWithFormat:@"已选择%ld件商品",cellCount];
      
        _label5.text = [NSString stringWithFormat:@"总计%.2f元",self.totalMoney];
        
//        [table reloadData];
        
    }else {
        [dic setObject:@"NO" forKey:@"checked"];
        [cell setChecked:NO];
        //删除改数据
        
        FriendsModel *frednModel = [self.dataArray objectAtIndex:indexPath.row];
        [self.calucateDataArray removeObject:frednModel];
        
        //计算总钱
        [cell creatTotalMoney];
        self.totalMoney -=self.money;
        NSLog(@"%.2f",self.totalMoney);
        _label2.text = [NSString stringWithFormat:@"商品总价%.2f",self.totalMoney];
        //计算个数
        cellCount --;
        _label1.text = [NSString stringWithFormat:@"已选择%ld件商品",cellCount];
        
        _label5.text = [NSString stringWithFormat:@"总计%.2f元",self.totalMoney];
        if (cellCount == 0) {
            _label5.text = [NSString stringWithFormat:@"请选择购买"];
        }
        
//        [table reloadData];
    }
    [self creatAllSelect];
    
    
    for (NSDictionary *d in contacts) {
        if ([[d objectForKey:@"checked"]isEqualToString:@"NO"]) {
            self.allSelectButton.selected = NO;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_rightButton.titleLabel.text isEqualToString:@"编辑"]) {
        return 150*PROPORTION_WIDTH;
    }
    return 190*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:ShopCarDelete parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[model.ID dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
        [self creatDataSourceAgien];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
}

#pragma mark ---- 结算最新 ----

-(void)creatAllSelect{//全选总计计算
    UIView *AllSelect = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 49 - 55*PROPORTION_WIDTH, SCREEN_W, 55*PROPORTION_WIDTH)];
    AllSelect.backgroundColor = [UIColor whiteColor];
    //虚线
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 1)];
    lineV.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [AllSelect addSubview:lineV];
    UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 54, SCREEN_W, 1)];
    lineV1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//    [AllSelect addSubview:lineV1];
    //按钮
    UIView *AllSelectV = [[UIView alloc] initWithFrame:CGRectMake(17*PROPORTION_WIDTH, 17*PROPORTION_WIDTH, 70*PROPORTION_WIDTH, 21*PROPORTION_WIDTH)];
    
    UIButton *AllSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    AllSelectBtn.frame = CGRectMake(0*PROPORTION_WIDTH, 0*PROPORTION_WIDTH, 70*PROPORTION_WIDTH, 21*PROPORTION_WIDTH);
    [AllSelectBtn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
        //按钮文字
    UILabel *labelB = [[UILabel alloc] initWithFrame:CGRectMake(21*PROPORTION_WIDTH, 0, 49*PROPORTION_WIDTH, 21*PROPORTION_WIDTH)];
    labelB.backgroundColor = [UIColor whiteColor];
    labelB.text = @"全选";
    labelB.textAlignment = NSTextAlignmentCenter;
    labelB.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    labelB.textColor = [self colorWithHexString:@"#555555"];
    
    [AllSelectV addSubview:labelB];
        //按钮图片
    UIButton *iconImg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21*PROPORTION_WIDTH, 21*PROPORTION_WIDTH)];
    [iconImg setImage:[UIImage imageNamed:@"select_normal_icon"] forState:UIControlStateNormal];
    [iconImg setImage:[UIImage imageNamed:@"select_selected_icon"] forState:UIControlStateSelected];
    
    self.allSelectButton = iconImg;//全局变量
    iconImg.selected = YES;
    [AllSelectV addSubview:iconImg];AllSelectBtn.backgroundColor = [UIColor whiteColor];
    [AllSelectV addSubview:AllSelectBtn];
    AllSelectBtn.backgroundColor = [UIColor clearColor];
    [AllSelect addSubview:AllSelectV];
    //总计
    NSString *totalM = [NSString stringWithFormat:@"总计:￥%.2f (不含运费)",self.totalMoney];
    
    NSMutableAttributedString *countLabelString = [[NSMutableAttributedString alloc] initWithString:totalM];
    [countLabelString setAttributes:@{NSForegroundColorAttributeName:[self colorWithHexString:@"#555555"], NSFontAttributeName:[UIFont systemFontOfSize:14*PROPORTION_WIDTH]} range:NSMakeRange(0, 3)];
    [countLabelString setAttributes:@{NSForegroundColorAttributeName:[self colorWithHexString:@"#FD681F"], NSFontAttributeName:[UIFont systemFontOfSize:14*PROPORTION_WIDTH]} range:NSMakeRange(3, totalM.length - 10)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(AllSelectV.frame) + 0*PROPORTION_WIDTH, 0, 160*PROPORTION_WIDTH, 55*PROPORTION_WIDTH)];
    lable.font = [UIFont systemFontOfSize:10*PROPORTION_WIDTH];
    lable.textColor = [self colorWithHexString:@"#999999"];
    lable.attributedText = countLabelString;
    
    [AllSelect addSubview:lable];
    //结算
    
    UIButton *totalBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 115*PROPORTION_WIDTH, 0, 115*PROPORTION_WIDTH, 55*PROPORTION_WIDTH)];
    totalBtn.backgroundColor = [self colorWithHexString:@"FD681F"];
    [totalBtn setTitle:@"结算" forState:UIControlStateNormal];
    totalBtn.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    [totalBtn addTarget:self action:@selector(calucate) forControlEvents:UIControlEventTouchUpInside];
    self.AllBtn = totalBtn;
    [AllSelect addSubview:totalBtn];
    self.AllSelectView = AllSelect;
    if (_rightButton.hidden == YES) {
        [self.AllSelectView removeFromSuperview];
    }else{
        [self.view addSubview:self.AllSelectView];
    }
}


-(void)calucate{
    if (cellCount == 0) {
        [self.AllBtn setTitle:@"选择商品" forState:UIControlStateNormal];
        return;
    }
    
    CalucateViewController *caluctae = [[CalucateViewController alloc] init];
    caluctae.array1 = self.calucateDataArray;
    caluctae.isBuy = NO;
    caluctae.totalMoney = self.totalMoney;
    [self.navigationController pushViewController:caluctae animated:YES];
}
#pragma mark --- 页面将要出现 ---
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    UserID *user = [UserID shareInState];
    UserIDModle *model = [[user redFromUserListAllData] lastObject];
    if (model.ID.length == 0) {
        self.alert = [[UIAlertView alloc] initWithTitle:@"没有登录" message:@"跳转登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.whiteView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [self.whiteView addSubview:[self creadUnloadView]];
        [self.view addSubview:self.whiteView];
        _rightButton.hidden = YES;
        return ;
    }else{
        self.whiteView.frame = CGRectMake(0, 0, 0, 0);
        [self.whiteView removeFromSuperview];
        _rightButton.hidden = NO;
    }

    [self.calucateDataArray removeAllObjects];
    [self creatDataSourceAgien];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [self.whiteView removeFromSuperview];
    self.whiteView = nil;
}
#pragma mark --- 没有登录的页面 ---
-(UIView *)creadUnloadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(20, SCREEN_H/2 - 60, SCREEN_W - 40, 120)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleView.frame.size.width, 30)];
    UIButton *FindBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 60, titleView.frame.size.width/2 - 60, 30)];
    UIButton *LoadBtn = [[UIButton alloc] initWithFrame:CGRectMake(titleView.frame.size.width/2 , 60,titleView.frame.size.width/2 - 60, 30)];
    titleLabel.text = @"您现在还没有登录";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [FindBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
    [FindBtn addTarget:self action:@selector(find) forControlEvents:UIControlEventTouchUpInside];
    [LoadBtn setTitle:@"点击登录" forState:UIControlStateNormal];
    titleLabel.textColor = [self colorWithHexString:@"999999"];
    [FindBtn setTitleColor:[self colorWithHexString:@"#FD681F"]forState:UIControlStateNormal];
    [LoadBtn setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateNormal];
    titleLabel.font = [UIFont systemFontOfSize:16*PROPORTION_WIDTH];
    [LoadBtn addTarget:self action:@selector(loadWithUser) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(12*PROPORTION_WIDTH, 29, titleView.frame.size.width/2 - 86*PROPORTION_WIDTH, 1)];
    lineV1.backgroundColor = [self colorWithHexString:@"#FD681F"];

    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(12*PROPORTION_WIDTH, 29, titleView.frame.size.width/2 - 86*PROPORTION_WIDTH, 1)];
    lineV2.backgroundColor = [self colorWithHexString:@"#FD681F"];

    
    
    //添加导航栏
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_W, 44)];
    label.text = @"购物车";
    label.textColor = [self colorWithHexString:@"#555555"];
    label.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    label.textAlignment = NSTextAlignmentCenter;
    [topV addSubview:label];
    [view addSubview:topV];
    topV.backgroundColor = [self colorWithHexString:@"f7f7f7"];
    [titleView addSubview:titleLabel];
    [titleView addSubview:FindBtn];
    [titleView addSubview:LoadBtn];
    [view addSubview:titleView];
    
    return view;
}
-(void)find{
    self.tabBarController.selectedIndex = 1;
}
-(void)loadWithUser{
        UserInfoViewController *userinfo = [[UserInfoViewController alloc] init];
        userinfo.VC = @"ShopCar";
        [self.navigationController pushViewController:userinfo animated:YES];
        userinfo.blockWithShopCart = ^(){
            
            [self.whiteView removeFromSuperview];
            [self.calucateDataArray removeAllObjects];
            [self creatDataSourceAgien];
        };
}

#pragma mark --- 从新请求数据 ---
-(void)creatDataSourceAgien{

    UserID *user = [UserID shareInState];
    UserIDModle *model = [[user redFromUserListAllData] lastObject];
    NSDictionary *dict = @{@"customer_id":model.ID};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:ShopCarList parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
        [self.dataArray removeAllObjects];
        [self.calucateDataArray removeAllObjects];
        /**
         *  判断是否为空数据 有的显示没有购买任何物品
         */
        NSArray *array = [responseObject objectForKey:@"model"];
        if (array.count == 0) {
            self.firstView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
            [self.view addSubview:_firstView];
            _rightButton.hidden = YES;
        }else{
            self.firstView.frame = CGRectMake(0, 0, 0, 0);
            [self.firstView removeFromSuperview];
            _rightButton.hidden = NO;
            [self creatAllSelect];
        }
        
//        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *didi in array) {
                FriendsModel *model = [[FriendsModel alloc] initWithDict:didi];
                [_dataArray addObject:model];
            }
//        }
        
        //        }
            self.totalMoney = 0;
            self.totalCountShopping = 0;
        contacts = [NSMutableArray array];
        for (int i = 0; i < _dataArray.count; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"YES" forKey:@"checked"];//一点击进去默认为点击
            [contacts addObject:dic];
//            NSLog(@"%ld",contacts.count);
            FriendsModel *model = [_dataArray objectAtIndex:i];
            float money = [model.product_price floatValue] * [model.product_num floatValue];
            self.totalMoney += money;
            cellCount = _dataArray.count;
            FriendsModel *frednModel = [self.dataArray objectAtIndex:i];
            [self.calucateDataArray addObject:frednModel];
            self.totalCountShopping += [model.product_num integerValue];
        }
            [self postKVO];
        [self creatAllSelect];
        [table reloadData];
        
            
        }else{
            NSLog(@"数据格式不对");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
}

-(void)creatDataSourceAgienAgien{
    [self.calucateDataArray removeAllObjects];
    [self.dataArray removeAllObjects];
    UserID *user = [UserID shareInState];
    UserIDModle *model = [[user redFromUserListAllData] lastObject];
    NSDictionary *dict = @{@"customer_id":model.ID};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:ShopCarList parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            NSArray *array = [responseObject objectForKey:@"model"];
            for (NSDictionary *didi in array) {
                FriendsModel *model = [[FriendsModel alloc] initWithDict:didi];
                [_dataArray addObject:model];
            }
//        }
        
        self.totalMoney = 0;
            self.totalCountShopping = 0;
        NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[table indexPathsForRowsInRect:CGRectMake(0, 0, SCREEN_W, _dataArray.count* 200*PROPORTION_WIDTH)]];
            NSLog(@"%ld",anArrayOfIndexPath.count);
        for (int i = 0; i < [anArrayOfIndexPath count]; i++) {
            NSIndexPath *indexPath= [anArrayOfIndexPath objectAtIndex:i];
            LTableViewCell *cell = (LTableViewCell*)[table cellForRowAtIndexPath:indexPath];
            
            NSMutableDictionary *dic = [contacts objectAtIndex:indexPath.row];
            if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {continue;}
            
            
            cellCount = anArrayOfIndexPath.count;
            
            FriendsModel *frednModel = [[FriendsModel alloc] init];
            frednModel = [self.dataArray objectAtIndex:indexPath.row];
            [self.calucateDataArray addObject:frednModel];
            //算钱数
            self.totalMoney += [frednModel.product_num integerValue] *[frednModel.product_price floatValue];
            //算数量
            NSLog(@"%ld",[frednModel.product_num integerValue]);
            self.totalCountShopping += [frednModel.product_num integerValue];
            
        }
        [self postKVO];
        [self creatAllSelect];
        [table reloadData];
        }else{
            NSLog(@"数据格式不对");
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}

#pragma mark ---  懒加载  ---
-(KVOModle *)kvoModel{
    if (!_kvoModel) {
        _kvoModel = [[KVOModle alloc] init];
    }
    return _kvoModel;
}
-(UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

-(UIView *)firstView{
    if (!_firstView) {
        _firstView = [[UIView alloc] init];
        _firstView.backgroundColor = [UIColor whiteColor];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H/2 - 60, SCREEN_W, 120)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
        label.text = @"购物车空空如也";
        UIButton *buttona = [[UIButton alloc] initWithFrame:CGRectMake(140*PROPORTION_WIDTH,CGRectGetMaxY(label.frame)+40*PROPORTION_WIDTH, SCREEN_W -280*PROPORTION_WIDTH , 30*PROPORTION_WIDTH)];
        [buttona setTitle:@"随便逛逛" forState:UIControlStateNormal];
        [buttona setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateNormal];
        [buttona addTarget:self action:@selector(find) forControlEvents:UIControlEventTouchUpInside];
        
        label.textColor = [self colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:16*PROPORTION_WIDTH];
        label.textAlignment = NSTextAlignmentCenter;
        //
        UIView *linve = [[UIView alloc] initWithFrame:CGRectMake(10, 29*PROPORTION_WIDTH, SCREEN_W - 300*PROPORTION_WIDTH, 1*PROPORTION_WIDTH)];
        linve.backgroundColor = [self colorWithHexString:@"FD681F"];

        //添加导航栏
        UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
        UILabel *labela = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_W, 44)];
        labela.text = @"购物车";
        labela.textColor = [self colorWithHexString:@"#555555"];
        labela.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
        labela.textAlignment = NSTextAlignmentCenter;
        [topV addSubview:labela];
        [_firstView addSubview:topV];
        topV.backgroundColor = [self colorWithHexString:@"f7f7f7"];
        [_firstView addSubview:topV];
        
        [titleView addSubview:buttona];
        [titleView addSubview:label];
        [_firstView addSubview:titleView];
    }
    return _firstView;
}

-(NSMutableArray *)calucateDataArray{
    if (!_calucateDataArray) {
        _calucateDataArray = [[NSMutableArray alloc] init];
    }
    return _calucateDataArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark --- 改变状态 ---
-(void)changeStatue{
    //更改状态
    self.allSelectButton.selected = YES;
}
#pragma mark --- 全部选择 ---
- (void)allSelect:(UIButton*)sender{
    if (self.allSelectButton.selected == NO) {
        self.allSelectButton.selected = YES;
        //全选
        self.totalMoney = 0;
        cellCount = 0;
        [table reloadData];
        NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[table indexPathsForVisibleRows]];
        for (int i = 0; i < [anArrayOfIndexPath count]; i++) {
            NSIndexPath *indexPath= [anArrayOfIndexPath objectAtIndex:i];
            LTableViewCell *cell = (LTableViewCell*)[table cellForRowAtIndexPath:indexPath];
            NSUInteger row = [indexPath row];
            NSLog(@"%lu",(unsigned long)row);
            NSMutableDictionary *dic = [contacts objectAtIndex:row];
            if ([[[(UIButton*)sender titleLabel] text] isEqualToString:@"全选"]) {
                [dic setObject:@"YES" forKey:@"checked"];
                [cell setChecked:YES];
                cellCount ++;
                
                [cell creatTotalMoney];
                self.totalMoney += self.money;
                [table reloadData];
            }else {
                [dic setObject:@"YES" forKey:@"checked"];
                [cell setChecked:YES];
                [self viewWillAppear:YES];
            }
        }
    }else if(self.allSelectButton.selected == YES){
        self.allSelectButton.selected = NO;
        
        self.totalMoney = 0;
        cellCount = 0;
        self.totalMoney = 0;
        [self.calucateDataArray removeAllObjects];
        for (NSDictionary *dic in contacts) {
            [dic setValue:@"NO" forKey:@"checked"];
        }
        [self creatAllSelect];
        [table reloadData];
    }

}

#pragma mark -- keyBordNotificationCenter --
-(void)creatNotificationCenter{
    //键盘升起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark -- observer keyBoardNotification --
-(void)keyBoardWillShow:(NSNotificationCenter *)noti{
    
    NSLog(@"----------%@",noti);
    [UIView animateWithDuration:0.25 animations:^{
        _telePhoneNumberVc.frame = CGRectMake(0,  SCREEN_H-225 - 283, SCREEN_W, 225);
    }];
}
-(void)postKVO{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [self.kvoModel setValue:@"a" forKey:@"numberWithShopping"];
    [_kvoModel addObserver:appdelegate forKeyPath:@"numberWithShopping" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"change"];
    [_kvoModel setValue:[NSString stringWithFormat:@"%ld",self.totalCountShopping] forKey:@"numberWithShopping"];
    [self.kvoModel removeObserver:appdelegate forKeyPath:@"numberWithShopping"];
}

-(void)keyBoardWillHide:(NSNotificationCenter *)noti{
    [UIView animateWithDuration:0.25 animations:^{
        _telePhoneNumberVc.frame = CGRectMake(0, SCREEN_H - 225, SCREEN_W, 225);
    }];
}
#pragma mark --- 创建数据源方法 ---
-(void)creatDataSource{
    [self.dataArray removeAllObjects];
    UserID *user = [UserID shareInState];
    UserIDModle *model = [[user redFromUserListAllData] lastObject];
    
    NSString *str = [NSString stringWithFormat:@"%@?customer_id=%@",ShopCarList,model.ID];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (received == nil) {
        return;
    }
    
    id root = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
    if ([root isKindOfClass:[NSArray class]]) {
        NSArray *rootArray = root;
        for (NSDictionary *dididi in rootArray) {
            FriendsModel *momom = [[FriendsModel alloc] initWithDict:dididi];
            [_dataArray addObject:momom];
        }
        
    }
    
    NSLog(@"_dataArray-----%ld",_dataArray.count);
    
    contacts = [NSMutableArray array];
    for (int i = 0; i < _dataArray.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:@"checked"];
        [contacts addObject:dic];
        NSLog(@"%ld",contacts.count);
        
    }
    
    [table reloadData];
}

#pragma mark ---  结算  ---
-(void)calcute{
    //结算的计算和操作都写在这里
    self.tabBarController.tabBar.hidden = YES;
    //删除
    //    table.frame = CGRectMake(0, 0, 0, 0);
    [_telePhoneNumberVc removeFromSuperview];
    [_rectiveVc removeFromSuperview];
    [_payVC removeFromSuperview];
    [_homeMuchVc removeFromSuperview];
    
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 315, SCREEN_W, 315)];
    //手机验证
    CGFloat higth = 45.0;
    [payView addSubview:[self creatViewWithTitle:@"需要验证您的手机" detail:@"" getOrginy:higth *0 WithTag:8] ];
    [payView addSubview:[self creatViewWithTitle:@"收货地址" detail:@"东直门外大街42号宇飞大厦703房间" getOrginy:higth *1 WithTag:9] ];
    [payView addSubview:[self creatViewWithTitle:@"积分抵现金" detail:@"500积分抵3.9元" getOrginy:higth *2 WithTag:10] ];
    [payView addSubview:[self creatViewWithTitle:@"优惠劵" detail:@"新用户15元优惠" getOrginy:higth *3 WithTag:11] ];
    [payView addSubview:[self creatViewWithTitle:@"支付方式" detail:@"微信支付" getOrginy:higth *4 WithTag:12] ];
    [payView addSubview:[self creatViewWithTitle:@"应付总额" detail:_label2.text getOrginy:higth *5 WithTag:13] ];
    [payView addSubview:[self creatViewWithTitle:@"确认支付" detail:nil getOrginy:higth *6 WithTag:14] ];
    
    payView.backgroundColor = [UIColor whiteColor];
    _payView = payView;
    [self.view addSubview:_payView];
}
//返回view
-(UIView *)creatViewWithTitle:(NSString *)title detail:(NSString *)detail getOrginy:(CGFloat)y WithTag:(NSInteger)tag{
    UIView *pay = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, 45)];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_W/3, 25)];
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 10 - 30, 10, 30, 30)];
    UILabel *detailL = [[ UILabel alloc] initWithFrame:CGRectMake( 10 + CGRectGetMaxX(titleLab.frame), 5, SCREEN_W - 60 - CGRectGetMaxX(titleLab.frame), 25)];
    nextButton.tag = tag;
    [nextButton addTarget:self action:@selector(nextbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [pay addSubview:titleLab];
    [pay addSubview:nextButton];
    [pay addSubview:detailL];
    detailL.textAlignment = NSTextAlignmentRight;
    titleLab.font = [UIFont systemFontOfSize:11];
    detailL.font = [UIFont systemFontOfSize:11];
    
    
    titleLab.text = title;
    detailL.text = detail;
    nextButton.backgroundColor = [UIColor cyanColor];
    
    if (tag%2 == 0) {
        pay.layer.borderWidth = 1;
        pay.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:0.8] CGColor];
    }
    if (tag == 8) {
        nextButton.frame = CGRectMake(SCREEN_W - 10 - 100, 10, 100, 30);
        [nextButton setTitle:@"点击验证" forState:UIControlStateNormal];
        nextButton.backgroundColor = [UIColor orangeColor];
    }
    if (tag == 10) {
        [nextButton setBackgroundColor:[UIColor clearColor]];
        [nextButton setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateNormal];
    }
    if (tag == 13) {
        detailL.text = _label2.text;
    }
    if (tag == 14) {
        titleLab.text = nil;
        nextButton.frame = CGRectMake(30, 7, SCREEN_W - 60, 30);
        [nextButton setTitle:title forState:UIControlStateNormal];
        [nextButton setBackgroundColor:[UIColor redColor]];
        nextButton.layer.cornerRadius = 5;
        nextButton.layer.masksToBounds = YES;
    }
    
    //    [_payView addSubview:pay];
    return pay;
}
#pragma mark 验证手机号码 支付和收货地址
//点击进入下一页
-(void)nextbtnClick:(UIButton *)btn{
    [_payView removeFromSuperview];
    if (btn.tag == 8) {
        [self telePhoneNumber];
    }
    if (btn.tag == 9) {
        [self receive];
    }
    if (btn.tag == 10) {
        NSLog(@"--------10");
    }
    if (btn.tag == 11) {
        NSLog(@"--------11");
    }
    if (btn.tag == 12) {
        [self wxPayFor];
    }
    if (btn.tag == 13) {
        [self HowMuchMoney];
    }
    if (btn.tag == 14) {
        NSLog(@"--------14");
    }
    
    
}
//应付总额
-(void)HowMuchMoney{
    UIView *homeMuchVc = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 195, SCREEN_W, 195)];
    NSArray *array = @[@"应付总额",@"商品总计",@"优惠劵",@"运费",@"总计"];
    NSArray *numArray = @[@"",@"180元",@"－10元",@"0.00元",@"170元"];
    for (int  i = 0 ; i < 5; i ++) {
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, i*30, SCREEN_W, 30)];
        UILabel *subTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
        subTitleLable.text = array[i];
        UILabel *subNumLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W - 90, 5, 80, 20)];
        subNumLable.text = numArray[i];
        subNumLable.textAlignment = NSTextAlignmentRight;
        if (i == 0) {
            UIButton *upBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 20, 20)];
            upBtn.backgroundColor = [UIColor redColor];
            subNumLable.userInteractionEnabled = YES;
            [upBtn addTarget:self action:@selector(calcute) forControlEvents:UIControlEventTouchUpInside];
            [subNumLable addSubview:upBtn];
        }
        if (i == 3) {
            UILabel *baoYouLab = [[UILabel alloc] initWithFrame:CGRectMake( SCREEN_W - 150, 5, 80, 20)];
            baoYouLab.text = @"全场包邮";
            baoYouLab.backgroundColor = [UIColor redColor];
            baoYouLab.textAlignment = NSTextAlignmentCenter;
            [subView addSubview:baoYouLab];
        }
        
        [subView addSubview:subTitleLable];
        [subView addSubview:subNumLable];
        [homeMuchVc addSubview:subView];
    }
    UIView *redVc = [[UIView alloc] initWithFrame:CGRectMake(0, homeMuchVc.frame.size.height - 45, SCREEN_W, 45)];
    UIButton *redBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 7, SCREEN_W - 60, 30)];
    redBtn.backgroundColor = [UIColor redColor];
    [redBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [redBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
    redBtn.layer.cornerRadius = 5;
    redBtn.layer.masksToBounds = YES;
    
    [redVc addSubview:redBtn];
    [homeMuchVc addSubview:redVc];
    _homeMuchVc = homeMuchVc;
    [self.view addSubview:_homeMuchVc];
    
}
-(void)pay{
    //这里写确认支付跳转的页面
    
}
//支付方式
-(void)wxPayFor{
    UIView *payVc = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 135, SCREEN_W, 135)];
    UIView *AllpayVc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    UIView *zfbPayVc = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(AllpayVc.frame), SCREEN_W, 30)];
    UIView *wxPayVc = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(zfbPayVc.frame), SCREEN_W, 30)];
    UIView *redVc = [[UIView alloc] initWithFrame:CGRectMake(0, payVc.frame.size.height - 45, SCREEN_W, 30)];
    //第一行
    UILabel *AllpayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    UIButton *AllpayBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 20, 10, 10, 10)];
    AllpayLabel.text = @"支付方式";
    AllpayBtn.backgroundColor = [UIColor redColor];
    [AllpayVc addSubview:AllpayLabel];
    [AllpayVc addSubview:AllpayBtn];
    //第二行
    UIImageView *payImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 20)];
    payImg.backgroundColor = [UIColor yellowColor];
    UILabel *zfbPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(payImg.frame)+20, 5, 100, 20)];
    zfbPayLabel.text = @"支付宝";
    UIButton *zfbPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 30, 5, 20, 20)];
    zfbPayBtn.backgroundColor = [UIColor redColor];
    
    [zfbPayVc addSubview:payImg];
    [zfbPayVc addSubview:zfbPayLabel];
    [zfbPayVc addSubview:zfbPayBtn];
    //第三行
    UIImageView *wxpayImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 20)];
    wxpayImg.backgroundColor = [UIColor yellowColor];
    UILabel *wxPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(payImg.frame)+20, 5, 100, 20)];
    wxPayLabel.text = @"微信支付";
    UIButton *wxPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 30, 5, 20, 20)];
    wxPayBtn.backgroundColor = [UIColor redColor];
    
    [wxPayVc addSubview:wxpayImg];
    [wxPayVc addSubview:wxPayLabel];
    [wxPayVc addSubview:wxPayBtn];
    //第四行
    UIButton *reBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 7, SCREEN_W - 60, 30)];
    reBtn.backgroundColor = [UIColor redColor];
    [reBtn setTitle:@"确认" forState:UIControlStateNormal];
    reBtn.layer.cornerRadius = 5;
    reBtn.layer.masksToBounds = YES;
    [redVc addSubview:reBtn];
    
    
    [payVc addSubview:AllpayVc];
    [payVc addSubview:zfbPayVc];
    [payVc addSubview:wxPayVc];
    [payVc addSubview:redVc];
    payVc.backgroundColor = [UIColor whiteColor];
    _payVC = payVc;
    [self.view addSubview:payVc];
    
}
//验证手机的页面
-(void)telePhoneNumber{
    UIView *telePhoneNumberVc = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 225, SCREEN_W, 225)];
    UIView *yanZhengPhomeVc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 225 -45)];
    UIView *redVc = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(yanZhengPhomeVc.frame), SCREEN_W, 45)];
    UILabel *yanZhengPhomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_W - 20, 20)];
    UIView *PhoneNumVc = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(yanZhengPhomeLabel.frame)+20, SCREEN_W - 60, 30)];
    UIView *yanZhengNumVc = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(PhoneNumVc.frame)+20, SCREEN_W - 60, 30)];
    UITextField *phoneNmbField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, PhoneNumVc.frame.size.width - 20, 30)];
    UITextField *yanZhengNumField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W/2, 30)];
    UIView *yanZhengNumFieldVc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W/2+20, 30)];
    [yanZhengNumFieldVc addSubview:yanZhengNumField];
    
    UIButton *yanZhengNumBtn = [[UIButton alloc] initWithFrame:CGRectMake(yanZhengNumVc.frame.size.width - 100, 0, 100, 30)];
    
    //颜色确定在什么地方
    yanZhengNumFieldVc.backgroundColor = [UIColor yellowColor];
    PhoneNumVc.backgroundColor = [UIColor yellowColor];
    yanZhengNumBtn.backgroundColor = [UIColor redColor];
    yanZhengNumVc.backgroundColor = [UIColor blueColor];
    
    yanZhengPhomeLabel.text = @"验证手机";
    phoneNmbField.placeholder = @"手机号";
    yanZhengNumField.placeholder = @"验证码";
    [yanZhengNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    //验证按钮
    UIButton *yangzhengBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 7, SCREEN_W - 60, 30)];
    yangzhengBtn.backgroundColor = [UIColor redColor];
    [yangzhengBtn setTitle:@"验证" forState:UIControlStateNormal];
    [redVc addSubview:yangzhengBtn];
    
    
    yanZhengPhomeVc.layer.borderWidth = 1;
    yanZhengPhomeVc.layer.borderColor = ([[UIColor colorWithWhite:0.8 alpha:0.8] CGColor]);
    PhoneNumVc.layer.borderWidth = 1;
    PhoneNumVc.layer.borderColor = ([[UIColor colorWithWhite:0.8 alpha:0.8] CGColor]);
    yanZhengNumFieldVc.layer.borderWidth = 1;
    yanZhengNumFieldVc.layer.borderColor = ([[UIColor colorWithWhite:0.8 alpha:0.8] CGColor]);
    telePhoneNumberVc.backgroundColor = [UIColor whiteColor];
    
    [PhoneNumVc addSubview:phoneNmbField];
    [yanZhengNumVc addSubview:yanZhengNumFieldVc];
    [yanZhengNumVc addSubview:yanZhengNumBtn];
    
    [yanZhengPhomeVc addSubview:yanZhengPhomeLabel];
    [yanZhengPhomeVc addSubview:PhoneNumVc];
    [yanZhengPhomeVc addSubview:yanZhengNumVc];
    
    [telePhoneNumberVc addSubview:yanZhengPhomeVc];
    [telePhoneNumberVc addSubview:redVc];
    _telePhoneNumberVc = telePhoneNumberVc;
    [self.view addSubview:_telePhoneNumberVc];
    
}
//收货地址
-(void)receive{
    UIView *rectiveVc = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 155, SCREEN_W, 155)];
    UIView *rectiveAddressVc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    UIView *addressDetailVc = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rectiveAddressVc.frame), SCREEN_W, 50)];
    UIView *addAddressVc = [[UIView alloc] initWithFrame:CGRectMake(0, rectiveVc.frame.size.height - 75, SCREEN_W, 30)];
    UIView *redViewVc = [[UIView alloc] initWithFrame:CGRectMake(0, rectiveVc.frame.size.height - 45, SCREEN_H, 45)];
    
    //第一行
    UILabel *rectiveLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    UIButton *upBtn = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_W - 40, 5,20, 20)];
    //颜色
    upBtn.backgroundColor = [UIColor redColor];
    rectiveLable.text = @"收货地址";
    [upBtn addTarget:self action:@selector(calcute) forControlEvents:UIControlEventTouchUpInside];
    
    [rectiveAddressVc addSubview:rectiveLable];
    [rectiveAddressVc addSubview:upBtn];
    //第二行   根据数据来判断这个内容 可以利用循环来判断这里的数据
    UIImageView *painImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(painImg.frame)+20, 5, SCREEN_W - CGRectGetMaxX(painImg.frame)-20 - 40 - 40, 20)];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(painImg.frame)+20, CGRectGetMaxY(titleLabel.frame), SCREEN_W - CGRectGetMaxX(painImg.frame)-20 - 40 - 40, 20)];
    detailLabel.numberOfLines = 2;
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W - 40, 15, 20, 20)];
    //颜色
    painImg.backgroundColor = [UIColor cyanColor];
    titleLabel.backgroundColor = [UIColor cyanColor];
    detailLabel.backgroundColor = [UIColor yellowColor];
    rightImg.backgroundColor = [UIColor cyanColor];
    //第三行  添加新地址
    UILabel *addAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    addAddressLabel.text = @"添加新地址";
    UIImageView *addImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W - 40, 5, 20, 20)];
    //颜色
    addImg.backgroundColor = [UIColor redColor];
    
    [addAddressVc addSubview:addAddressLabel];
    [addAddressVc addSubview:addImg];
    //第四行
    UIButton *redBtn  = [[UIButton alloc] initWithFrame:CGRectMake(30, 5, SCREEN_W - 60, 30)];
    [redBtn setTitle:@"确认" forState:UIControlStateNormal];
    //颜色
    redBtn.backgroundColor = [UIColor redColor];
    redBtn.layer.cornerRadius = 5;
    redBtn.layer.masksToBounds = YES;
    [redViewVc addSubview:redBtn];
    
    [addressDetailVc addSubview:painImg];
    [addressDetailVc addSubview:titleLabel];
    [addressDetailVc addSubview:detailLabel];
    [addressDetailVc addSubview:rightImg];
    
    //收货地址和增加新地址的黑线
    rectiveAddressVc.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1] CGColor];
    rectiveAddressVc.layer.borderWidth = 1;
    addAddressVc.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1] CGColor];
    addAddressVc.layer.borderWidth = 1;
    
    [rectiveVc addSubview:rectiveAddressVc];
    [rectiveVc addSubview:addressDetailVc];
    [rectiveVc addSubview:addAddressVc];
    [rectiveVc addSubview:redViewVc];
    rectiveVc.backgroundColor = [UIColor whiteColor];
    _rectiveVc = rectiveVc;
    [self.view addSubview:rectiveVc];
    
}


#pragma mark --- 颜色 ---
- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
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


#pragma mark -- 点击空白让键盘消失 --
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)text{
    
}

@end