//
//  OrderTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-11-22.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "OrderDetailTableViewCell.h"
#import "OrderDetailModel.h"
//#import "PayViewController.h"
#import "TrackViewController.h"
//#import "ConfirmViewController.h"
#import "EvaluateViewController.h"
//#import "DeleteOrderViewController.h"
#import "DetailViewController.h"
#import "WXPayViewController.h"




//支付宝
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        self.detailTableView.delegate = self;
        self.detailTableView.dataSource = self;
        self.detailTableView.userInteractionEnabled = YES;
        self.detailTableView.scrollEnabled = NO;
        self.detailTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 0, 235*PROPORTION_WIDTH, 40*PROPORTION_WIDTH)];
    [self.contentView addSubview:self.timeLabel];
    
    self.payStatueLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLabel.frame), 0, WIDTH - 15*PROPORTION_WIDTH -CGRectGetMaxX(self.timeLabel.frame), 40*PROPORTION_WIDTH)];
    self.payStatueLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.payStatueLabel];
    
    self.timeLabel.textColor = [self colorWithHexString:@"#999999"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.payStatueLabel.textColor = [self colorWithHexString:@"#555555"];
    self.payStatueLabel.font = [UIFont systemFontOfSize:14];
    
    
    self.payView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 140*PROPORTION_WIDTH)];
    [self.contentView addSubview:self.payView];
    
    self.totalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*PROPORTION_WIDTH, WIDTH, 15*PROPORTION_WIDTH)];
    [self.payView addSubview:self.totalCountLabel];

    self.moneyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 14*PROPORTION_WIDTH +CGRectGetMaxY(self.totalCountLabel.frame), WIDTH, 14*PROPORTION_WIDTH)];
    [self.payView addSubview:self.moneyCountLabel];
    self.totalCountLabel.font = self.moneyCountLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    self.totalCountLabel.textAlignment = self.moneyCountLabel.textAlignment = NSTextAlignmentCenter;
    self.totalCountLabel.textColor = self.moneyCountLabel.textColor = [self colorWithHexString:@"#555555"];
    
    
    self.payDetailButton = [[UIButton alloc] init];
    self.payButton = [[UIButton alloc] init];
    [self.payView addSubview:self.payDetailButton];
    [self.payView addSubview:self.payButton];
    
    self.payDetailButton.layer.cornerRadius = self.payButton.layer.cornerRadius = 5;
    self.payButton.layer.masksToBounds = YES;
    
    
    
    [self.contentView addSubview:self.detailTableView];
    //画线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10*PROPORTION_WIDTH, 39*PROPORTION_WIDTH, WIDTH - 20, 0.5*PROPORTION_WIDTH)];
    lineView.backgroundColor = [self colorWithHexString:@"#DDDDDD"];
//    [self.contentView addSubview:lineView];
    //画线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10*PROPORTION_WIDTH, 0, WIDTH - 20*PROPORTION_WIDTH, 0.5*PROPORTION_WIDTH)];
    lineView1.backgroundColor = [self colorWithHexString:@"#DDDDDD"];
    [self.payView addSubview:lineView1];
    

    
    
    //按钮的点击
    [self.payDetailButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.payButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.payDetailButton.tag = 22;
    self.payButton.tag = 23;
}
-(void)configCellWithOrderModel:(OrderModel *)orderModel{
    //设置字体颜色
//    self.payDetailButton.titleLabel.textColor = [self colorWithHexString:@"#333333"];
    [self.payDetailButton setTitleColor:[self colorWithHexString:@"#555555"] forState:UIControlStateNormal];
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payButton.backgroundColor = [self colorWithHexString:@"#FD681F"];
    self.payDetailButton.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    
    //内容
    self.orderId = orderModel.ID;
    self.pay_type = orderModel.pay_type;
    self.timeLabel.text = orderModel.create_time;
    
//    self.payStatueLabel.text = orderModel.STATUS;
    
    self.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件",(unsigned long)[orderModel.products count]];
    
    self.moneyCountLabel.text = [NSString stringWithFormat:@"实付：%@",orderModel.total_money];
    
//    [self.payDetailButton setTitle:orderModel.STATUS forState:UIControlStateNormal];
    
//    [self.payButton setTitle:orderModel.STATUS forState:UIControlStateNormal];
    
    if ([orderModel.status isEqualToString:@"dfk"]) {
        //获取当前时间
        
        NSLog(@"currentTime:%@",[self getCurrentTimeWithBase]);
        double newTime = [[self getCurrentTimeWithBase] doubleValue];
        double oldTime = [[self getBaseTimeWithFormatter:orderModel.create_time] doubleValue];
        if ((newTime - 900) >= oldTime) {
//            self.BlockChangeGYGB(orderModel.ID);
        }
        
        
        self.payStatueLabel.text = @"待支付";
        self.payDetailButton.hidden = YES;
        [self.payButton setTitle:@"支付" forState:UIControlStateNormal];
//        self.payButton.backgroundColor = [UIColor orangeColor];
        
    }
    if ([orderModel.status isEqualToString:@"dfh"]) {
        self.payStatueLabel.text = @"待发货";
        self.payDetailButton.hidden = YES;
        [self.payButton setTitle:@"订单跟踪" forState:UIControlStateNormal];
    }
    
    if ([orderModel.status isEqualToString:@"dsh"]) {
        self.payStatueLabel.text = @"待收货";
        self.payDetailButton.hidden = NO;
        [self.payDetailButton setTitle:@"订单跟踪" forState:UIControlStateNormal];
        [self.payButton setTitle:@"确认收货" forState:UIControlStateNormal];
    }
    if ([orderModel.status isEqualToString:@"dpj"]) {
        self.payStatueLabel.text = @"交易成功";
        self.payDetailButton.hidden = NO;
        [self.payDetailButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.payButton setTitle:@"评价" forState:UIControlStateNormal];
    }
    if ([orderModel.status isEqualToString:@"jygb"]) {
        self.payStatueLabel.text = @"交易关闭";
        self.payDetailButton.hidden = YES;
        [self.payButton setTitle:@"删除订单" forState:UIControlStateNormal];
    }
    if ([orderModel.status isEqualToString:@"ypj"]) {
        self.payStatueLabel.text = @"交易成功";
        self.payDetailButton.hidden = NO;
        [self.payDetailButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.payButton setTitle:@"已评价" forState:UIControlStateNormal];
    }
    
    //重新给paybutton布局
    if (self.payDetailButton.hidden == YES) {
    self.payButton.frame = CGRectMake((WIDTH - 130*PROPORTION_WIDTH)/2.0, 20*PROPORTION_WIDTH + CGRectGetMaxY(self.moneyCountLabel.frame), 130*PROPORTION_WIDTH, 40*PROPORTION_WIDTH);
    }else{
        self.payDetailButton.frame = CGRectMake((WIDTH - 280*PROPORTION_WIDTH)/2.0, 20*PROPORTION_WIDTH + CGRectGetMaxY(self.moneyCountLabel.frame), 130*PROPORTION_WIDTH, 40*PROPORTION_WIDTH);
        self.payButton.frame = CGRectMake(20*PROPORTION_WIDTH+CGRectGetMaxX(self.payDetailButton.frame), 20*PROPORTION_WIDTH + CGRectGetMaxY(self.moneyCountLabel.frame), 130*PROPORTION_WIDTH, 40*PROPORTION_WIDTH);
    }
    self.payButton.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    self.payDetailButton.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
}
//时间转时间挫
-(NSString *)getBaseTimeWithFormatter:(NSString *)string{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *d = [formatter dateFromString:string];

    NSString *timeSp = [NSString stringWithFormat:@"%f",[d timeIntervalSince1970]];
    return timeSp;
}
//时间挫转化为时间
-(NSString *)getFormatterTimeWithBser:(NSString *)string{
    double timeBase = [string doubleValue];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:timeBase];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dataTime = [formatter stringFromDate:timeDate];
    return dataTime;
}

//获取当前时间挫
-(NSString *)getCurrentTimeWithBase{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timeString  = [NSString stringWithFormat:@"%f",a];
    return timeString;
}

//获取当前时间直接把当前时间转化为标准时间
-(NSString *)getCurrentTimeWithFormatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

#pragma mark --- 按钮的点击事件  需要写出来 ---
-(void)click:(UIButton *)button{
    if (button.tag == 22) {
        if ([button.titleLabel.text isEqualToString:@"订单跟踪"]) {
            NSLog(@"订单跟踪");
            TrackViewController *track = [[TrackViewController alloc] init];
            track.orderID = self.orderId;
            track.express_id = self.express_id;
            [self.VC.navigationController pushViewController:track animated:YES];
        }
        if ([button.titleLabel.text isEqualToString:@"删除订单"]) {
            NSLog(@"删除订单");
            self.deleteWtihSelf();
        }
        
    }else{
        if ([button.titleLabel.text isEqualToString:@"支付"]) {
            NSLog(@"支付");
            [self pay];
        }
        if ([button.titleLabel.text isEqualToString:@"订单跟踪"]) {
            NSLog(@"订单跟踪");
            TrackViewController *track = [[TrackViewController alloc] init];
            track.orderID = self.orderId;
            track.express_id = self.express_id;
            [self.VC.navigationController pushViewController:track animated:YES];
        }
        if ([button.titleLabel.text isEqualToString:@"确认收货"]) {
            NSLog(@"确认收货");
            [self confirm];
        }
        if ([button.titleLabel.text isEqualToString:@"评价"] ||[button.titleLabel.text isEqualToString:@"已评价"]) {
            NSLog(@"评价或者已评价");
            EvaluateViewController *evaluate = [[EvaluateViewController alloc] init];
            evaluate.orderID = self.orderId;
            [self.VC.navigationController pushViewController:evaluate animated:YES];
        }
        if ([button.titleLabel.text isEqualToString:@"删除订单"]) {
            NSLog(@"删除订单");
            self.deleteWtihSelf();
        }
    }
    
}
#pragma mark --- 确认收货 ---
-(void)confirm{
    NSDictionary *dic = @{@"status":@"dpj",@"id":self.orderId};   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:UpdateWithOrder parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
        self.BlockReloadWithOutTime();
        }else{
            NSLog(@"数据格式不对");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
}
#pragma mark --- 删除订单 ---
//-(void)deleteOrderWith:(){
//    
//}


#pragma mark -- tableView delegate --
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.detailTableView.frame = CGRectMake(0, 40*PROPORTION_WIDTH, WIDTH, 100*PROPORTION_WIDTH*self.dataArry.count);
    self.payView.frame = CGRectMake(0, CGRectGetMaxY(self.detailTableView.frame), WIDTH, 140*PROPORTION_WIDTH);
    
    return self.dataArry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailTableViewCell"];
    if (!cell) {
        cell = [[OrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderDetailTableViewCell"];
    }
    
    //此处要给model 数据

    //此处要给model 数据
    OrderDetailModel *detaaaa = [self.DataArray objectAtIndex:indexPath.row];
    [cell configCellWithModel:detaaaa];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*PROPORTION_WIDTH;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.navWithStatue = self.payButton.titleLabel.text;
    detail.ordreID = self.orderId;
    detail.payMoney = self.payMoney;
    //物流订单
    detail.express_id = self.express_id;
    
    [self.VC.navigationController pushViewController:detail animated:YES];
}
#pragma mark --- 支付 ---
-(void)pay{
    NSLog(@"_________支付___________");
    
    if ([self.pay_type isEqualToString:@"wx"]) {
        WXPayViewController *pay = [[WXPayViewController alloc] init];
        self.getPayMoney();
        float price = [self.payMoney floatValue]*100;
        pay.price = [NSString stringWithFormat:@"%.0f",price];
        
        pay.order_id = self.orderId;
        [pay weixinChooseAct];
        return ;
    }
    
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //    Product *product = [self.productList objectAtIndex:indexPath.row];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088121453371241";
    NSString *seller = @"2088121453371241";
    NSString *privateKey = @"MIICWwIBAAKBgQDcdPSwT3aZ/e9G1ZtZUvrNLOuCZO4MAPxnfyjWmmDlXiKisT461d2pSHQElEtLA9uMmBo+iXY6LeseBYPNAdEhZ8Iqb4LWYww1t8owrfYtfDrD2FwXU8KQSMSibnUWK/rNGA0quYUnB0D93PDtMXt9w6NViRU+olrUL3WeYB2MYwIDAQABAoGAQOOD6ilZhXYC6dyRvzb3b1DbeSPwFURtBqGdCZ2jC6ArnauB35t3hQ44Z+imSMw34SgcAXBAhlthqxKAeuUgAqMzGeBpU4YbmR1Nv5YH+exTR5FGgY8PUWn6uj/J3GAJ7056YJUoBxyQUOnp3L6uv/2AmbHtUzZJ0/w66BebfGECQQD10e3ZyaOIUA0djTA81/Hmtwc6/q7YN5IMP4nWyxun8xAU+K9I3w/G/E8soyplMCDU3mlEGGrmQyO+utA+xrkbAkEA5ZYjUrb/GsQ83mnz1lRaXnn/SA6eonE23D/RWJ/quXSmXbMO3KQfhj3DBFpOglq42FwXeSf4PEcd2MN0JSq2WQJAVrKFmsw8+vSQy51iJ/NZg6+Fw07Tx7pBrkQyjyjvRhq5z0uuNptFaz7Nhca+SxXgXnNa2QNroG6JitlEXP+lhQJAMu6y2WfFgl+kjUb+FD9UaP8xlf/AS5NIM2Zo//tCLHBndAQEOQikAbjz6aRLJHoR5dXQU019sYmpYmxB+PjXyQJAB+e2e3X0PqzNzeZAgaJDqPxAgLVoPlHfbXsBIhASTqMYkrS5UFH4t97gPweE5XXlulGpXVujWRaglJs1FmjSOg==";
    
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）  //移动到上面去了
    if (self.order == nil) {
        self.getPayMoney();
        order.productName = [NSString stringWithFormat:@"            糖人街商品:%@",self.orderId]; //商品标题
        order.amount = [NSString stringWithFormat:@"%@",self.payMoney]; //商品价格
    }else{
        order.productName = self.order.productName;
        order.amount  = self.order.amount;
    }
    self.order = order;
//    order.amount = @"0.01";
    order.productDescription = @"商品描述"; //商品描述
    
    order.notifyURL =  @"http://www.qxd.com/mobile/ali/pay"; //回调URL
//    order.notifyURL = @"http://192.168.1.51:8080/sns/mobile/ali/pay";//回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"qxd";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *statue = [resultDic objectForKey:@"resultStatus"];
            if ([statue isEqualToString:@"9000"]) {
            NSDictionary *dic = @{@"status":@"dfh",@"id":self.orderId};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:UpdateWithOrder parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                    NSLog(@"成功");
                    
                }else{
                    NSLog(@"数据格式不对");
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error:%@",error);
            }];
        }
         
        }];
    }
    
}
#pragma mark -
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
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


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//}

@end

