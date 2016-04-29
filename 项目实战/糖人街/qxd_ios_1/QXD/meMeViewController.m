//
//  meMeViewController.m
//  QXD
//
//  Created by zhujie on 平成28-02-01.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "meMeViewController.h"

@interface meMeViewController ()

@end

@implementation meMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}
-(void)creatUI{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    bgView.image = [UIImage imageNamed:@"aboutMe.png"];
    [self.view addSubview:bgView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, SCREEN_W - 200, 44)];
    
    
    
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(abc) forControlEvents:UIControlEventTouchUpInside];
    titleLabel.text = @"关于我们";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [self colorWithHexString:@"#555555"];
    
    topView.backgroundColor = [self colorWithHexString:@"f7f7f7"];
    [topView addSubview:titleLabel];
    [topView addSubview: left];
    [self.view addSubview:topView];
    
    [self creatDowm];//创建公司信息
    
}
-(void)creatDowm{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 80*PROPORTION_WIDTH, SCREEN_W, 60*PROPORTION_WIDTH)];
    UILabel *dowm = [[UILabel alloc] initWithFrame:CGRectMake(0, 10*PROPORTION_WIDTH, SCREEN_W, 20*PROPORTION_WIDTH)];
    
    UILabel *lastView = [[UILabel alloc] initWithFrame:CGRectMake(0, 35*PROPORTION_WIDTH, SCREEN_W, 20)];
    
    dowm.text = @"北京骁讯网络科技有限公司";
    lastView.text = @"糖人街 v1.0";
    dowm.textColor = [self colorWithHexString:@"#999999"];
    lastView.textColor = [self colorWithHexString:@"#999999"];
    dowm.textAlignment = lastView.textAlignment = NSTextAlignmentCenter;
    dowm.font = lastView.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    
    [view addSubview:dowm];
    [view addSubview:lastView];
    [self.view addSubview:view];
}



-(void)abc{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
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
