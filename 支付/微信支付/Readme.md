-----------------微信支付------------------
1. 导入文件夹（微信支付文档）注意下DataMD5.m文件（需要修改）否则会无法完成支付
2. 使用pod导入AFNetworking
3. 创建pch填写必要的信息 以下信息为微信开放平台注册后得到的信息
//微信支付商户号
#define MCH_ID  @"1300181901"
//开户邮件中的（公众账号APPID或者应用APPID）
#define WX_AppID @"wx6331e9f3100a2435"
//#define WX_AppID @"wxb4ba3c02aa476ea1"
//安全校验码（MD5）密钥，商户平台登录账户和密码登录http://pay.weixin.qq.com 平台设置的“API密钥”，为了安全，请设置为以数字和字母组成的32字符串。
#define WX_PartnerKey @"QiuxindeTangrenjie11111120160217"
//获取用户openid，可使用APPID对应的公众平台登录http://mp.weixin.qq.com 的开发者中心获取AppSecret。
#define WX_AppSecret @"1f4d84cf1aa2892e0940788bd5bcf928"
可以考虑是否导入AFNetworking
#ifdef __OBJC__
#import "AFNetworking.h"//下载
#endif
4. 导入链接 官方文档提示
    4.1 导入libWeChatSDK.a，WXApi.h，WXApiObject.h 三个文件（因为微信支付涉及到了加密和格式转化问题，导入集成好的微信支付文档更加方便，不仅含有这三个文件还有加密需要的文件，如果导入了微信支付文档这个步骤可以省掉）
    4.2 链接SystemConfiguration.framework,libz.dylib,libsqlite3.0.dylib,libc++.dylib
    4.3 在你的工程文件中选择Build Setting，在Search Paths中添加 libWeChatSDK.a ，WXApi.h，WXApiObject.h 三个文件所在位置（注意：创建工程后吧文件夹为微信支付文档的文案拖拽到工程 进入工程点击添加文件夹即可省掉这个步骤 系统会给我们导入）
5. 编译程序 解决问题 如若出现 .a文件contain bitcode 修改setting --> ENABLE_BITCODE == NO即可
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        // Override point for customization after application launch.
        /****************       注册微信支付信息    *****************/
        [WXApi registerApp:WX_AppID];
        return YES;
    }
    完成跳转支付页面 支付结果后 跳转的app（添加URLScheme：wx6331e9f3100a2435）此处的URLScheme是WX_AppID；
6. 支付结果处理
    6.1 跳转到appDelegat中然后让代理执行方法
        -(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
            BOOL result = FALSE;
            if (result == FALSE) {
                if ([url.host isEqualToString:@"pay"]) {//微信支付的主机名为pay
                    WXPayViewController *pay = [[WXPayViewController alloc] init];
                    return [WXApi handleOpenURL:url delegate:pay];
                }

            }

        return result;
}

@end

    6.2 代理根据结果做判断 处理完的结果要发送通知 这样的话可以得到self的所有成员变量
        #pragma mark - WXApiDelegate
        -(void)onResp:(BaseResp *)resp {

            if (resp.errCode == 0) {
                NSLog(@"微信支付成功");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"WXPaySucceed" object:nil];//发送通知
            }else{
                NSLog(@"微信支付失败");
            }
        }

        - (void)onReq:(BaseReq *)req {

        }
------微信支付原理------
两次签名加密 保证安全 






