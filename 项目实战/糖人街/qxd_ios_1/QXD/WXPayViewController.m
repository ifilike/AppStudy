//
//  WXPayViewController.m
//  QXD
//
//  Created by zhujie on 平成28-02-17.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "WXPayViewController.h"
#import "DataMD5.h"
#import "XMLDictionary.h"
#import "WXApi.h"
#import "getIPhoneIP.h"

@interface WXPayViewController ()<WXApiDelegate>

@end

@implementation WXPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - WXApiDelegate
-(void)onResp:(BaseResp *)resp {
    
    if (resp.errCode == 0) {
         NSLog(@"微信支付成功");
        NSLog(@"____%@",self.order_id);
        
        NSDictionary *dic = @{@"status":@"dfh",@"id":self.order_id};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
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
    }else{
        NSLog(@"微信支付失败");
    }
}

- (void)onReq:(BaseReq *)req {
    
}
#pragma mark - 微信支付相关方法
- (void)weixinChooseAct {
    NSString *appid,*mch_id,*nonce_str,*sign,*body,*out_trade_no,*total_fee,*spbill_create_ip,*notify_url,*trade_type,*partner;
    //应用APPID
    appid = WX_AppID;
    //微信支付商户号
    mch_id = MCH_ID;
    //产生随机字符串，这里最好使用和安卓端一致的生成逻辑
    nonce_str =[self generateTradeNO];
    body =@"微信支付";
    //随机产生订单号用于测试，正式使用请换成你从自己服务器获取的订单号
    out_trade_no = self.order_id;//self.gold_sn;
    //交易价格1表示0.01元，10表示0.1元
    total_fee = self.price;//self.payCount;
    //获取本机IP地址，请再wifi环境下测试，否则获取的ip地址为error，正确格式应该是8.8.8.8
    //spbill_create_ip = [getIPhoneIP getIPAddress];
    //交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
    notify_url =@"http://www.qiuxinde.com/mobile/wx/pay";
    trade_type =@"APP";
    //商户密钥
    partner = WX_PartnerKey;
    //获取sign签名
    DataMD5 *data = [[DataMD5 alloc] initWithAppid:appid mch_id:mch_id nonce_str:nonce_str partner_id:partner body:body out_trade_no:out_trade_no total_fee:total_fee spbill_create_ip:spbill_create_ip notify_url:notify_url trade_type:trade_type];
    sign = [data getSignForMD5];
    //设置参数并转化成xml格式
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:appid forKey:@"appid"];//公众账号ID
    [dic setValue:mch_id forKey:@"mch_id"];//商户号
    [dic setValue:nonce_str forKey:@"nonce_str"];//随机字符串
    [dic setValue:sign forKey:@"sign"];//签名
    [dic setValue:body forKey:@"body"];//商品描述
    [dic setValue:out_trade_no forKey:@"out_trade_no"];//订单号
    [dic setValue:total_fee forKey:@"total_fee"];//金额
    [dic setValue:spbill_create_ip forKey:@"spbill_create_ip"];//终端IP
    [dic setValue:notify_url forKey:@"notify_url"];//通知地址
    [dic setValue:trade_type forKey:@"trade_type"];//交易类型
    NSLog(@"dic:%@",dic);
    // 转换成xml字符串
    NSString *string = [dic XMLString];
    [self http:string];
    
}

#pragma mark - 拿到转换好的xml发送请求
- (void)http:(NSString *)xml {
    //   [MBProgressHUD showMessage:@"正在获取支付订单..."];
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //这里传入的xml字符串只是形似xml，但是不是正确是xml格式，需要使用af方法进行转义
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"https://api.mch.weixin.qq.com/pay/unifiedorder" forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return xml;
    }];
    //发起请求
    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:xml progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
            // LXLog(@"responseString is %@",responseString);
            //将微信返回的xml数据解析转义成字典
            NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
            //判断返回的许可
            NSLog(@"dictionary:%@",dic);
            //            if ([[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"]){
            //发起微信支付，设置参数
            PayReq *request = [[PayReq alloc] init];
            request.openID = [dic objectForKey:@"appid"];
            request.partnerId = [dic objectForKey:@"mch_id"];
            request.prepayId= [dic objectForKey:@"prepay_id"];
            request.package = @"Sign=WXPay";
            request.nonceStr= [dic objectForKey:@"nonce_str"];
            
            
            //将当前事件转化成时间戳
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            UInt32 timeStamp =[timeSp intValue];
            request.timeStamp= timeStamp;
            // 签名加密
            DataMD5 *md5 = [[DataMD5 alloc] init];
            request.sign=[md5 createMD5SingForPay:request.openID partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
            
            NSLog(@"openID:%@",request.openID);
            NSLog(@"partnerId:%@",request.partnerId);
            NSLog(@"prepayId:%@",request.prepayId);
            NSLog(@"package:%@",request.package);
            NSLog(@"nonceStr:%@",request.nonceStr);
            NSLog(@"timeStamp:%u",request.timeStamp);
            NSLog(@"sign:%@",request.sign);
            
            // 调用微信
            [WXApi sendReq:request];
            //                        [MBProgressHUD hideHUD];
            //                    }else{
            //                        LXLog(@"参数不正确，请检查参数");
            //                        [MBProgressHUD hideHUD];
            //                        [MBProgressHUD showError:@"支付错误！"];
            //            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark - 产生随机订单号
- (NSString *)generateTradeNO {
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0)); // 此行代码有警告:
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
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
