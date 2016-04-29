//
//  EvaluateDetailViewController.m
//  QXD
//
//  Created by zhujie on 平成27-12-23.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "EvaluateDetailViewController.h"
#import "EvaluateModle.h"
#import "UserID.h"
#import "UserIDModle.h"

@interface EvaluateDetailViewController ()<UITextViewDelegate>

@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) UserIDModle *userModel;
@property(nonatomic,assign) NSInteger start;
@property(nonatomic,strong) NSString *startNum;

@property(nonatomic,strong) NSString *requestContext;
@property(nonatomic,strong) NSString *requestStart;
@property(nonatomic,assign) NSInteger requefstStatrNum;

//纪录中间位置坐条
@property(nonatomic,strong) UIView *nextView;
@end

@implementation EvaluateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    [self creatNav];
}
#pragma mark --- 创建导航栏 ---
-(void)creatNav{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    label.text = @"评价";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [self colorWithHexString:@"#555555"];
    label.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21*PROPORTION_WIDTH, 21*PROPORTION_WIDTH)];
    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"return_icon"]];
    [button addTarget:self action:@selector(backWithEa) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = left;

}
-(void)backWithEa{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatUI{
    [self.view addSubview:[self creatUP]];
    [self.view addSubview:[self creatNext]];
    [self.view addSubview:[self creatLast]];
    if (self.textView.text.length == 0) {
        self.textView.text = @"请写下对宝贝的感受吧，对他人帮助很大呦！";
    }
    if ([self.datailModel.is_comment isEqualToString:@"0"]) {
        [self.view addSubview:[self sendBtn]];
    }else{
        [self getDataSource];
        self.nextView.userInteractionEnabled = NO;
        self.textView.userInteractionEnabled = NO;
    } 
}
#pragma mark --- 已评价 请求获取内容 ---
-(void)getDataSource{
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    NSDictionary *dic = @{@"product_id":self.datailModel.product_id,@"order_id":self.orderId};
    [manage GET:OrderEvaluateTextShow parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            NSDictionary *dictionary = [responseObject objectForKey:@"model"];
        self.requestContext = [dictionary objectForKey:@"comment_content"];
        self.requestStart = [dictionary objectForKey:@"start_num"];
        self.requefstStatrNum = [self.requestStart intValue];
        self.textView.text = self.requestContext;
        UIButton *btn = (UIButton *)[self.view viewWithTag:(159+self.requefstStatrNum)];
        [self clickWithS:btn];
        }else{
            NSLog(@"数据格式不对 ");
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
//    [manage GET:OrderEvaluateTextShow parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"Succeed:%@",responseObject);
//        self.requestContext = [responseObject objectForKey:@"comment_content"];
//        self.requestStart = [responseObject objectForKey:@"start_num"];
//        self.requestStatrNum = [self.requestStart intValue];
//        self.textView.text = self.requestContext;
//        UIButton *btn = (UIButton *)[self.view viewWithTag:(159+self.requestStatrNum)];
//        [self clickWithS:btn];
//        
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"Error:%@",error);
//    }];
}

#pragma mark --- 创建发表视图 ---
-(UIButton *)sendBtn{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(110*PROPORTION_WIDTH, CGRectGetMaxY(self.textView.frame) + 20*PROPORTION_WIDTH, 155*PROPORTION_WIDTH, 40*PROPORTION_WIDTH)];
    [button setTitle:@"发送评价" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 5*PROPORTION_WIDTH;
    button.layer.borderColor = [[self colorWithHexString:@"FD681F"] CGColor];
    [button setTitleColor:[self colorWithHexString:@"FD681F"] forState:UIControlStateNormal];
    button.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    
    return button;
}
#pragma mark --- 点击发送按钮 ---
-(void)send{
    if (self.textView.text.length > 0) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.startNum = [NSString stringWithFormat:@"%ld",(long)self.start];
        
        [manager POST:OrderEvaluateText parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFormData:[self.orderId dataUsingEncoding:NSUTF8StringEncoding] name:@"order_id"];
            
            [formData appendPartWithFormData:[self.datailModel.product_id dataUsingEncoding:NSUTF8StringEncoding] name:@"product_id"];
            [formData appendPartWithFormData:[self.userModel.ID dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_id"];
            [formData appendPartWithFormData:[self.userModel.nickName dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_nick_name"];
            [formData appendPartWithFormData:[self.userModel.head_portrait dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_head_portrait"];
            
            //评论内容
            [formData appendPartWithFormData:[self.textView.text dataUsingEncoding:NSUTF8StringEncoding] name:@"comment_content"];
            //评论星级
            [formData appendPartWithFormData:[self.startNum dataUsingEncoding:NSUTF8StringEncoding] name:@"start_num"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
    }
}
#pragma mark --- 创建评价内容 ---
-(UITextView *)creatLast{
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, CGRectGetMaxY(self.nextView.frame), SCREEN_W - 30*PROPORTION_WIDTH, 115*PROPORTION_WIDTH)];
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    textView.font = [UIFont systemFontOfSize:15];
    self.textView = textView;
    self.textView.font = [UIFont systemFontOfSize:12*PROPORTION_WIDTH];
    self.textView.textColor = [self colorWithHexString:@"#BBBBBB"];
    self.textView.delegate = self;
    return textView;
}
#pragma mark ---textView代理--- 
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.textView.text isEqualToString: @"请写下对宝贝的感受吧，对他人帮助很大呦！"]) {
        self.textView.text = @"";
    }
}
#pragma mark --- 创建星星视图 ---
-(UIView *)creatNext{
    UIView *nextView = [[UIView alloc] initWithFrame:CGRectMake(0, 105*PROPORTION_WIDTH +64, SCREEN_W , 80*PROPORTION_WIDTH)];
    for (int i = 0 ; i<5; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(98*PROPORTION_WIDTH + i*39, 25*PROPORTION_WIDTH,24*PROPORTION_WIDTH, 24*PROPORTION_WIDTH)];
        [button setImage:[UIImage imageNamed:@"Evaluation_Unselected_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"Evaluation_Selected_icon"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickWithS:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 160;
        [nextView addSubview:button];
        button.selected = YES;
        self.start ++;
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 0, SCREEN_W - 30, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [nextView addSubview:lineView];
    self.nextView = nextView;
    return nextView;
}
#pragma mark --- 点击星星来确定给的级数 ---
-(void)clickWithS:(UIButton *)btn{
    self.start = 0;
    for (int i  = 160; i <= btn.tag +4 ; i++) {
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = NO;
    }
    for (int i  = 160; i <= btn.tag ; i++) {
        UIButton *btn = [self.view viewWithTag:i];
        btn.selected = YES;
        self.start ++;
    }
}
#pragma mark --- 最头部的视图 ---
-(UIView *)creatUP{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 105*PROPORTION_WIDTH)];
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(20*PROPORTION_WIDTH, 30*PROPORTION_WIDTH , 55*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImg.frame)+20*PROPORTION_WIDTH, 35*PROPORTION_WIDTH, 145*PROPORTION_WIDTH, 35*PROPORTION_WIDTH)];
    
    [iconImg setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    [iconImg sd_setImageWithURL:[NSURL URLWithString:self.datailModel.product_img]];
    nameLabel.text = [NSString stringWithFormat:@"%@",self.datailModel.product_name];
    nameLabel.textColor = [self colorWithHexString:@"#555555"];
    nameLabel.numberOfLines = 2;
    nameLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    //行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:nameLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3*PROPORTION_WIDTH];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [nameLabel.text length])];
    nameLabel.attributedText = attributedString;
    [nameLabel sizeToFit];
    
    [topView addSubview:iconImg];
    [topView addSubview:nameLabel];
    return topView;
}
#pragma mark --- 点击空白结束编辑 ---
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark --- 懒加载 ---
-(UserIDModle *)userModel{
    if (!_userModel) {
        UserID *user = [UserID shareInState];
        _userModel = [[user redFromUserListAllData] lastObject];
    }
    return _userModel;
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
