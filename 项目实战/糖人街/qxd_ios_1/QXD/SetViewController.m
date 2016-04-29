//
//  SetViewController.m
//  QXD
//
//  Created by zhujie on 平成27-11-16.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "SetViewController.h"
#import "AddressViewController.h"
#import "UserID.h"
#import "UserIDModle.h"
#import "meMeViewController.h"


@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *birthdayLabel;
@property(nonatomic,strong) UIButton *exitButton;
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    [self creatData];
    [self creatTableView];
}
#pragma mark -- 创建导航栏 --
-(void)setupNav{
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    [left setBackgroundImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(dismss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBtn ;
    UILabel *lable = [[UILabel alloc] init];
    lable.frame = CGRectMake(0, 0, 100, 30);
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"我的设置";
    lable.textColor = [self colorWithHexString:@"#555555"];
    lable.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = lable;
}
-(void)viewWillAppear:(BOOL)animated{
    //隐藏标签栏
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    //显示标签栏
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark -- 按钮点击dismiss --
-(void)dismss{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 代理方法 --

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArray[section];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    NSArray *arr = self.dataArray[indexPath.section];
    NSString *str = arr[indexPath.row];
    cell.textLabel.text = str;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [self colorWithHexString:@"#555555"];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //给第一行头像添加Image
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell addSubview:self.imageV];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [cell addSubview:self.nameLabel];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        //[cell addSubview:self.birthdayLabel];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 65*PROPORTION_WIDTH;
    }
    return 47*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 70*PROPORTION_WIDTH;
    }
    return 0.1;
}


//点击事件的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 0) {
        //退出登录
//        UserID *user = [UserID shareInState];
//        [user deleteUserList];
        
        //关于我们
        meMeViewController *meme = [[meMeViewController alloc] init];
        [self.navigationController pushViewController:meme animated:YES];
    }
    if (indexPath.section == 1) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *str = [NSString stringWithFormat:@"缓存大小%.1fM", [self folderSizeAtPath:path]];
        UIAlertView *aleat = [[UIAlertView alloc] initWithTitle:@"清理缓存" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [aleat show];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView *exitVC = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
        [exitVC addSubview:self.exitButton];
        return exitVC;
    }
    return nil;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }else{
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
        for (NSString *p in files) {
            NSString *pa = [path stringByAppendingPathComponent:p];
            [[NSFileManager defaultManager] removeItemAtPath:pa error:nil];
        }
        
    }
}

//遍历文件夹获得文件夹大小，返回多少M

- (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
    
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
    
}
#pragma mark -- 创建TableView --
-(void)creatTableView{
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H ) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
//    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [self colorWithHexString:@"#DDDDDD"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, SCREEN_W, 1);
    [self.tableView reloadData];
}
#pragma mark -- 创建数据源方法 --
-(void)creatData{
    _dataArray = [[NSMutableArray alloc] init];
    //第一组
    NSArray *arr1 = [NSArray array];
    NSArray *arr2 = [NSArray array];
    NSArray *arr3 = [NSArray array];
    
    arr1 = @[@"头像",@"昵称"];
    arr2 = @[@"清理缓存"];
    arr3 = @[@"关于我们"];
    
    [self.dataArray addObject:arr1];
    [self.dataArray addObject:arr2];
    [self.dataArray addObject:arr3];
    
}
#pragma mark --- 退出登录 ---
-(void)UserExit{
    UserID *user = [UserID shareInState];
    [user deleteUserList];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 懒加载 --
-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV  = [[UIImageView alloc] initWithFrame:CGRectMake(285*PROPORTION_WIDTH, 10*PROPORTION_WIDTH, 45*PROPORTION_WIDTH, 45*PROPORTION_WIDTH)];
        _imageV.layer.cornerRadius = 45*PROPORTION_WIDTH/2.0;
        _imageV.layer.masksToBounds = YES;
        _imageV.backgroundColor = [UIColor colorWithWhite:0.89 alpha:1.0];
        
        UserID *user = [UserID shareInState];
        
        if ([user redFromUserListAllData].count > 0) {
            UserIDModle *model = [[user redFromUserListAllData] lastObject];
            [_imageV sd_setImageWithURL:[NSURL URLWithString:model.head_portrait]];

            if ([model.load_type isEqualToString:@"sj"]) {
                _imageV.image = [UIImage imageNamed:@"默认头像"];
            }
        }
    }
    return _imageV;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
       
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100*PROPORTION_WIDTH, 0, 245*PROPORTION_WIDTH, 47*PROPORTION_WIDTH)];
        _nameLabel.textColor = [self colorWithHexString:@"#555555"];
        _nameLabel.font  = [UIFont systemFontOfSize:14];
        _nameLabel.text = @"";//没有登录的时候昵称
        _nameLabel.textAlignment = NSTextAlignmentRight;

        UserID *user = [UserID shareInState];
        if ([user redFromUserListAllData].count > 0) {
            UserIDModle *model = [[user redFromUserListAllData] lastObject];
            _nameLabel.text = model.nickName;
        }

    }
    return _nameLabel;
}
-(UILabel *)birthdayLabel{
    if (!_birthdayLabel) {
        _birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*SCREEN_W/3 - 50, 5, 150, 30)];
        _birthdayLabel.textColor = [UIColor orangeColor];
        _birthdayLabel.textAlignment = NSTextAlignmentCenter;
        
        UserID *user = [UserID shareInState];
        if ([user redFromUserListAllData].count > 0 ) {
            UserIDModle *modle = [[user redFromUserListAllData]lastObject];
            if ([modle.birthday isEqualToString:@"<null>"]) {
                _birthdayLabel.text = @"生日还没完善";
            }else{
                _birthdayLabel.text = modle.birthday;
            }
        }
        
    }
    return _birthdayLabel;
}
-(UIButton *)exitButton{
    if (!_exitButton) {
        _exitButton = [[UIButton alloc] initWithFrame:CGRectMake(120*PROPORTION_WIDTH, 40*PROPORTION_WIDTH, SCREEN_W - 240*PROPORTION_WIDTH, 40*PROPORTION_WIDTH)];
        [_exitButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [_exitButton setTitleColor:[self colorWithHexString:@"#555555"] forState:UIControlStateNormal];
        _exitButton.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        _exitButton.layer.borderWidth = 1;
        _exitButton.layer.borderColor = [[UIColor colorWithWhite:0.7 alpha:1] CGColor];
        _exitButton.layer.cornerRadius = 5;
        _exitButton.layer.masksToBounds = YES;
        [_exitButton addTarget:self action:@selector(UserExit) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _exitButton;
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
