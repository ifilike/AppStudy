//
//  AddressViewController.m
//  QXD
//
//  Created by zhujie on 平成27-11-17.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "AddressViewController.h"
#import "TextViewController.h"
#import "AddressTableViewCell.h"
#import "AddressModel.h"
#import "UserID.h"
#import "UserIDModle.h"

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UIView *addressView;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) UIButton *morenBtn;
@property(nonatomic,strong) UIButton *selectButton;
@property(nonatomic,strong) UIButton *rightButton;
@property(nonatomic,strong) UIView *bgView;

//判断有没有点击过
@property(nonatomic,assign) BOOL isClick;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
//    [self setupNav];
    [self creatNav];
    [self creatAddAddress];
//    [self creatDataSource];
}
#pragma mark -- 创建数据源 --
-(void)creatDataSource{
    self.isClick = NO;
    [self.dataArray removeAllObjects];
    self.selectButton.selected = NO;//******防止重复选择
    //拼接url
    UserID *user = [UserID shareInState];
    NSArray *array = [user redFromUserListAllData];
    UserIDModle *model = [array lastObject];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",AddressShowList,model.ID];
    //请求数据
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            NSArray *array = [responseObject objectForKey:@"model"];
            for (NSDictionary *dict in array) {
                AddressModel *model = [[AddressModel alloc] initWithDict:dict];
                [self.dataArray addObject:model];
            }
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
        NSLog(@"Failure:%@",error);
    }];

    
}

#pragma mark -- 代理方法 --
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sve"];
    if (!cell) {
        cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"save"];
    }
    AddressModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configCellWithAddressModel:model];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//删除所有下划线
    

    
    __weak typeof(self) weakSelf = self;
    cell.isSelcect = ^(UIButton *btn){
        weakSelf.selectButton = btn;
    };
    cell.cellSelect = ^(UIButton *btn){
        self.isClick = YES;
        weakSelf.selectButton.selected = NO;
        btn.selected = !btn.selected;
        weakSelf.selectButton = btn;

        self.updataSucceed = ^(NSString *str){
            //拼接参数
            UserID *user = [UserID shareInState];
            NSArray *array = [user redFromUserListAllData];
            UserIDModle *userIDStr = [array lastObject];
            //点击完成  上传默认
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:AddressChangeDefault parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFormData:[userIDStr.ID dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_id"];
                [formData appendPartWithFormData:[model.selfId dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                    NSLog(@"成功");
                //线程通信
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf creatDataSource];
                });
                }else{
                    NSLog(@"数据格式不对");
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error:%@",error);
            }];
            

            
        };
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125*PROPORTION_WIDTH;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleDelete;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
 
        AddressModel *model = [_dataArray objectAtIndex:indexPath.row];
        AFHTTPSessionManager *magager = [AFHTTPSessionManager manager];
//        magager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [magager POST:[NSString stringWithFormat:@"%@%@",AddressDeleteUrl,model.selfId] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [self.dataArray removeObject:[_dataArray objectAtIndex:indexPath.row]];
                //                [self.tableView reloadData];
                [self creatDataSource];
                self.rightButton.titleLabel.text = @"完成";
                [self editTableView];
            });
            }else{
                NSLog(@"数据格式不对");
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
        }];

        
        

    }else if (editingStyle == UITableViewCellEditingStyleInsert)
        //增加数据 insert
        return;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除地址";
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    //确定位置和目标
    NSInteger fromRow = sourceIndexPath.row;
    NSInteger toRow = destinationIndexPath.row;
    //找到位置对应的数组元素
    id object = self.dataArray[fromRow];
    //删除位置元素
    [self.dataArray removeObject:object];
    //把位置的数组插入到目标
    [self.dataArray insertObject:object atIndex:toRow];
    //移除所有数据 添加所有数据
    [self creatDataSource];
    
}
//-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.is_shopping) {
        AddressModel *model = [self.dataArray objectAtIndex:indexPath.row];
        self.getAddressBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    NSLog(@"________%ld",(long)indexPath.row);
    AddressModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSLog(@"%@",model.name);
    TextViewController *text = [[TextViewController alloc] init];
    text.dataArrayModel = model;
    [self.navigationController pushViewController:text animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01*PROPORTION_WIDTH;
}

#pragma mark -- 默认按钮的点击事件 --
-(void)changMorenBtnState{
//    [self.morenBtn setHidden:NO];
}


#pragma mark -- 标签栏隐藏 --
-(void)creatAddAddress{
    [self.view addSubview:self.addressView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    //隐藏标签栏
    self.tabBarController.tabBar.hidden = YES;
    //刷新数据
    //self.selectButton.selected = NO;//******防止从我的收获地址返回来重复选择
    [self creatDataSource];
}
-(void)viewWillDisappear:(BOOL)animated{
    //显示导航栏
    self.navigationController.navigationBarHidden = NO;
    //显示标签栏
//    [_dataArray removeAllObjects];
    [super viewWillDisappear:animated];
    //self.selectButton.selected = NO;//******防止从我的收获地址返回来重复选择
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark --- 创建导航栏 ---
-(void)creatNav{
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(abc) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, SCREEN_W - 200, 44)];
    titleLabel.text = @"收货地址";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [self colorWithHexString:@"#555555"];
    
    UIView *lineT = [[UIView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_W, 0.5)];
    lineT.backgroundColor = [self colorWithHexString:@"#DDDDDD"];
    [topView addSubview:lineT];
    
    topView.backgroundColor = [self colorWithHexString:@"#f7f7f7"];
    [topView addSubview:titleLabel];
    [topView addSubview: left];
    [self.view addSubview:topView];
}
-(void)abc{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 创建导航栏 --
-(void)setupNav{
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //left
    [left setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(ds) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBtn ;
    UILabel *lable = [[UILabel alloc] init];
    lable.frame = CGRectMake(0, 0, 60, 30);
    lable.text = @"我的收货地址";
    self.navigationItem.titleView = lable;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //right
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, 50, 30);
    
    [button addTarget:self action:@selector(editTableView) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightButton = button;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    
    //添加右边导航栏   改需求
    //self.navigationItem.rightBarButtonItem = right;
}
-(void)ds{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击切换编辑状态的开启或者关闭
-(void)editTableView{

//发送 判断是否是编辑状态
    if ([self.rightButton.titleLabel.text isEqualToString:@"编辑"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"123" object:nil];
        [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
        self.addressView.userInteractionEnabled = NO;
    }
    
    if ([self.rightButton.titleLabel.text isEqualToString:@"完成"]) {
        if (self.isClick) {
            self.updataSucceed(@"完成");
        }else{
//            [self creatDataSource];
            [self.tableView reloadData];
        }
       
        [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        self.addressView.userInteractionEnabled = YES;
    }
}

#pragma mark --- 点击增加按钮 实现添加地址 ---
-(void)add{
    TextViewController *text = [[TextViewController alloc] init];
    [self.navigationController pushViewController:text animated:YES];
}
#pragma mark -- 懒加载 --
//添加地址
-(UIView *)addressView{
    if (!_addressView) {
        _addressView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-55*PROPORTION_WIDTH, SCREEN_W, 55*PROPORTION_WIDTH)];
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@"添加地址" forState:UIControlStateNormal];
        addBtn.font = [UIFont systemFontOfSize:20*PROPORTION_WIDTH];
        addBtn.backgroundColor = [self colorWithHexString:@"#FD681F"];
        [addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        addBtn.frame = CGRectMake(0, 0, SCREEN_W, 55*PROPORTION_WIDTH);
        _addressView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        [_addressView addSubview:addBtn];
    }
    return _addressView;
}

//tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44, SCREEN_W, SCREEN_H  - 49)style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [self colorWithHexString:@"#f7f7f7"];
    }
    return _tableView;
}
//bgView
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H /2 - 100*PROPORTION_WIDTH, SCREEN_W, 30*PROPORTION_WIDTH)];
        UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30*PROPORTION_WIDTH)];
        bgLabel.text = @"你还没有收获地址";
        bgLabel.textAlignment = NSTextAlignmentCenter;
        bgLabel.textColor = [self colorWithHexString:@"#999999"];
        bgLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        [_bgView addSubview:bgLabel];
    }
    return _bgView;
}
//dataArray
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
