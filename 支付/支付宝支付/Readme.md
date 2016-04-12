----支付宝支付集成---技术文档
（一）进入支付宝开放平台下载demo 把oppnssl放在windows系统下打开进入bin目录打开exe文件 
1.公钥加密，私钥解密。 他是2个算法而已，不是密码，把公钥加密好的一串字符发送到服务器端后，他通过私钥把这串字符还原成你原来输入的原始数据
2.如何生成公钥和私钥
执行txt命令 会在bin文件下生成两个pem 一个是公钥一个是私钥 可转化为txt文件读取 
该pem文件为RSA加密文件 复制命令行上的私钥（该私钥是RSA私钥转化的PKCS8格式的私钥  支付宝支付的时候需要妆花为PCKS8格式！--->privect is nil---->如果不能解决可以试图修改代码RSADAtaVerifier.m：
//	[result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
[result appendString:@"-----BEGIN RSA PRIVATE KEY-----\n"];
//	[result appendString:@"\n-----END PUBLIC KEY-----\n"];
[result appendString:@"\n-----END RSA PRIVATE KEY-----"];）

3.注册账号 获取partner seller 提交公钥 拷贝PCKS8私钥


（二）提取demo中的ios客户端代码 
1.提取文件已保存为AlipaSDK
2.添加pch文件导入
#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif
添加pch路径
3.按照官方文档添加依赖库和导入文件路径 如果是9.0的需要在info中添加字段为：NSAppTransportSecurity 类型为字典，字典中key：Allow Arbitrary Loads value：YES

 （三）支付问题
1. 无法跳转支付宝网页版
NSArray *array = [[UIApplication sharedApplication] windows];
UIWindow* win = [array objectAtIndex:0];
[win setHidden:NO];
2. 解决ALI64和ALI59 ------> 保证partner，seller 和 privateKey保证一致 三者一致

 （四） 支付完成
在appdelegate.m中调用方法
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.host isEqualToString:@"safepay"]) {//阿里主机为safepay根据这个判断是否为阿里的回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {

        }];
    }
}
回调的放在在支付之后的block
[[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
    NSLog(@"reslut = %@",resultDic);//支付完成后回调，可根据成功参数进行下续操作
}];