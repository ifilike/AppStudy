//
//  DiscountViewController.m
//  QXD
//
//  Created by zhujie on 平成27-12-17.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "DiscountViewController.h"
#import "DiscountTableViewCell.h"
#import "DiscountModle.h"
#import "UserID.h"
#import "UserIDModle.h"

@interface DiscountViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) UserIDModle *userModle;
@property(nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,strong) NSDictionary *userDic;
@property(nonatomic,strong) UIView *bgView;//背景图片
@property(nonatomic,strong) UILabel *bgLabel;//
@end

@implementation DiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTop];
    [self creatNav];
    [self.view addSubview:self.tableView];
}
#pragma mark --- 创建导航栏 ---
-(void)creatNav{
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(abc) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UILabel *titileV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titileV.text = @"我的优惠券";
    titileV.textAlignment = NSTextAlignmentCenter;
    titileV.font = [UIFont systemFontOfSize:17];
    titileV.textColor = [self colorWithHexString:@"#555555"];
    self.navigationItem.titleView = titileV;
}
-(void)abc{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 导航栏下面的 ---
-(void)creatTop{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 40)];
    NSArray *arrayWithLabel = @[@"未使用",@"已使用",@"已过期"];
    for (int i = 0; i < 3; i++) {
        UIButton *buttonUse = [[UIButton alloc] initWithFrame:CGRectMake(20*PROPORTION_WIDTH + i*(SCREEN_W-40)/3, 10*PROPORTION_WIDTH, (SCREEN_W - 40*PROPORTION_WIDTH)/3, 20*PROPORTION_WIDTH)];
        [buttonUse setTitle:arrayWithLabel[i] forState:UIControlStateNormal];
        [buttonUse setTitleColor:[self colorWithHexString:@"#555555"] forState:UIControlStateNormal];
        [buttonUse setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateSelected];
        [buttonUse addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        buttonUse.font = [UIFont systemFontOfSize:13];
        buttonUse.tag = 130 + i;
        if (buttonUse.tag == 130) {
            self.selectBtn = buttonUse;
            self.selectBtn.selected = YES;
        }
        [view addSubview:buttonUse];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_W, 1)];
    lineView.backgroundColor = [self colorWithHexString:@"#DDDDDD"];
    [view addSubview:lineView];
    
    [self.view addSubview:view];
}
#pragma mark --- 点击时件 ---
-(void)BtnClick:(UIButton *)button{
    if (button.tag == 130) {
        self.userDic = @{@"customer_id":self.userModle.ID,@"condition":@"wsy"};
        [self getSource];
    }
    if (button.tag == 131) {
        self.userDic = @{@"customer_id":self.userModle.ID,@"condition":@"ysy"};
        [self getSource];
    }
    if (button.tag == 132) {
        self.userDic = @{@"customer_id":self.userModle.ID,@"condition":@"ygq"};
        [self getSource];
    }
    self.selectBtn.selected = NO;
    button.selected = YES;
    self.selectBtn = button;
    
}

#pragma mark --- 页面将要出现 ---
-(void)viewWillAppear:(BOOL)animated{
    
    //请求数据
    [self getSource];
}
#pragma mark --- 请求数据 ---
-(void)getSource{
    [self.dataArray removeAllObjects];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:DiscountList parameters:self.userDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            NSArray *array = [responseObject objectForKey:@"model"];
            for (NSDictionary *dic in array) {
                DiscountModle *model = [[DiscountModle alloc] initWithDiscountDic:dic];
                [self.dataArray addObject:model];
            }
            NSLog(@"______%@",self.userDic);
            NSString *statuess = [self.userDic objectForKey:@"customer_id"];
//            if ([statuess isEqualToString:@"ysy"]) {
//                [self.bgLabel removeFromSuperview];
//                self.bgLabel.text = @"你没有用过的优惠券";
//                [self.bgView addSubview:self.bgLabel];
//            }else if([statuess isEqualToString:@"ygq"]){
//                [self.bgLabel removeFromSuperview];
//                self.bgLabel.text = @"你没有过期的优惠券";
//                [self.bgView addSubview:self.bgLabel];
//            }else{
//                [self.bgLabel removeFromSuperview];
//                self.bgLabel.text = @"你还没有优惠券";
//                [self.bgView addSubview:self.bgLabel];
//            }
            
            if (self.dataArray.count == 0) {
                [self.tableView addSubview:self.bgView];
            }else{
                [self.bgView removeFromSuperview];
            }
            
            [self.tableView reloadData];
        }else{
            NSLog(@"数据格式不对");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
    }];
    

}

#pragma mark -- 代理 ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discountCell"];
    if (!cell) {
        cell = [[DiscountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"discountCell"];
    }
    DiscountModle *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configCellWithModle:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//cell不能点击
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01*PROPORTION_WIDTH;
}

#pragma mark -- 导航栏 ---
//-(void)creatNav{
//    self.title = @"我的优惠劵";
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [button setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//}
//-(void)back{
//    [self.navigationController popViewControllerAnimated:YES];
//}


#pragma mark -- 懒加载 ---
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, SCREEN_W, SCREEN_H - 104 - 49) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H /2 - 100*PROPORTION_WIDTH, SCREEN_W, 30*PROPORTION_WIDTH)];
        [_bgView addSubview:self.bgLabel];
    }
    return _bgView;
}
-(UILabel *)bgLabel{
    if (!_bgLabel) {
        _bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30*PROPORTION_WIDTH)];
        _bgLabel.textAlignment = NSTextAlignmentCenter;
        _bgLabel.text = @"你还没有优惠券";
        _bgLabel.textColor = [self colorWithHexString:@"#999999"];
        _bgLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    }
    return _bgLabel;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(UserIDModle *)userModle{
    if (!_userModle) {
        UserID *user = [UserID shareInState];
        _userModle = [[user redFromUserListAllData] lastObject];
    }
    return _userModle;
}
-(NSDictionary *)userDic{
    if (!_userDic) {
        _userDic = [[NSDictionary alloc] init];
        _userDic = @{@"customer_id":self.userModle.ID,@"condition":@"wsy"};
    }
    return _userDic;
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
