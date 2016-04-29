//
//  AgreementViewController.m
//  QXD
//
//  Created by wzp on 16/2/19.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "AgreementViewController.h"
#import "CommentNavigationView.h"

@interface AgreementViewController ()


@property(nonatomic,strong)CommentNavigationView * navigationView;
@property(nonatomic,retain)UIWebView * webView;

@end



#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestContent];
    self.view.backgroundColor=[UIColor whiteColor];
    
    _navigationView=[[CommentNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64) withName:@"注册协议"];
//    _navigationView.backgroundColor=[UIColor whiteColor];
    [_navigationView.cancellBut addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_navigationView];
    
    
    
//    
//    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, SCREEN_H-64)];
//    [self.view addSubview:_webView];
    
    [self creatUI];
    
    
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"糖人街注册协议" ofType:@"html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
//
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)creatUI{
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    label.showsVerticalScrollIndicator=NO;
    label.backgroundColor = [self colorWithHexString:@"#EEEEEE"];
    label.font = [UIFont systemFontOfSize:375.00*PROPORTION_WIDTH/26];
    label.textColor=[self colorWithHexString:@"#555555"];
    label.text = [self string];
    label.textAlignment=0;
//    label.userInteractionEnabled=NO;
    label.editable=NO;
    
    
    
    //    label.numberOfLines = 0;
    
    [self.view addSubview:label];
}


-(NSString *)string{
    
    
    NSString *s = @"本协议是您与糖人街平台（手机APP：糖人街）（本站）所有者北京骁讯网络科技有限公司（以下简称为糖人街）之间就糖人街平台服务等相关事宜所订立的契约，请您仔细阅读本注册协议，您点击\“同意并继续\”按钮后，本协议即已经生效并构成对双方有约束力的法律文件。糖人街通过互联网依法为您提供互联网信息等服务，您在完全同意本协议及本站规定的情况下，方有权试用本站的相关服务。\n一、服务条款的确认和接纳\n\t1.本站的各项电子服务所有权和运营权归糖人街所有。您同意所有注册协议条款并完成注册程序，才能成为本站的正式用户。您确认：本协议条款是处理双方权利义务的契约，始终有效，法律另有强制性规定或双方令有特别约定的，依其规定执行。\n\t2.您点击同意本协议的，即视为您确认自己具有享受本站服务、下单购物等相应的权利能力和行为能力，能够独立承担法律责任。\n\t3.如果您在18周岁以下，您只能在父母或监护人的监护参与下才能使用本站。\n\t4.糖人街保留在中华人民共和国大陆地区相关法律允许的范围内独自决定拒绝提供服务、关闭用户账户、清楚或编辑内用或取消订单的权利。\n二、用户信息规范\n\t2.1 您应该以诚信、诚实为原则向本站提供注册资料，您应确保提供的注册资料真实、准备、完整、合法有效，您的用户资料如有变动的，应及时在本站更新注册资料。如果您提供的注册资料不合法、不真实、不准确、不详尽的，您需承担因此引起的相应责任和后果，并且糖人街保留终止您使用本站的各项服务的权利。\n\t2.2 您在本站进行浏览、下单购物等活动时，涉及您真实姓名/名称、通信地址、联系电话、电子邮箱等隐私信息的，本站将予以严格保密，除非得到您的授权或法律另有规定，本站不会向外界披露您的隐私信息。\n\t2.3 您注册成功后，将产生用户名和密码等账户信息，您可以根据本站规定改变您的密码。您应谨慎合理的保存、使用其用户名和密码。您若发现任何非法使用您的用户账户或存在安全漏洞的情况，请立即通知本站并向公安机关报案\n\t2.4 您同意，糖人街拥有通过邮件、短信电话等形式，向在本站注册用户、购物用户、收货人发送订单信息、促销活动等告知信息的权利。\n\t2.5 您不得将在本站注册获得的账户借给他人使用，否则您应承担又此长生的全部责任，并与实际使用人承担连带责任。\n\t2.6 您同意，糖人街有权使用您的注册信息，用户名、密码等信息，登陆进入您的注册账户，进行证据保全等行为，包括但不限于公证、见证等。\n三、 用户言行义务\n\t本协议依据国家相关法律法规规章制度，您同意严格遵守以下义务：\n\t(1)不得传输或发表反动言论：包括煽抗拒、破坏宪法和法律、行政法规实施的言论，煽动颠覆国家政权，推翻社会主义制度的言论，煽动分裂国家、破坏国家统一的言论，煽动民族仇恨、民族歧视、破坏民族团结的言论；\n\t(2)从中国大陆向境外传输资料信息时必须符合中国的有关法规；\n\t(3)不得利用本站从事洗钱、窃取商业机密、窃取个人信息等违法犯罪活动；\n\t(4)不得干扰本站的正常运转，不得侵入本站及国家计算机信息系统；\n\t(5)不得传输或发表任何违法犯罪的、性骚扰的、重伤他人的、辱骂性的、恐吓性的、伤害性的、庸俗的、淫秽的、不文明的等信息资料；\n\t(6)不得传输或发表损害国家社会公共利益和涉及国家安全的信息资料或言论；\n\t(7)不得教唆他人从事本条所禁止的行为；\n\t(8)不得利用在本站注册的账户进行牟利性经营活动；\n\t(9)不得发布任何侵犯他人著作权、商标权等知识产权或合法权利的内容\n您应密切关注并遵守本站不定期公布或修改的各类合法规则／公告。\n本站保有删除站内各类不符合法律政策、本站规则或不真实的信息内容而无须通知您的权利。\n若您未遵守以上规定的，本站有权作出独立判断并采取暂停或关闭您的用户账号等措施。您须对自己在网上的言论和行为承担法律责任。\n\n四、商品信息\n\t本站上的商品价格、数量、是否有货等商品信息随时都有可能发生变动，本站不作特别通知。由于网站上商品信息的数量极其庞大，虽然本站会尽最大努力保证您所浏览商品信息的准确性，但由于众所周知的互联网技术因素等客观原因存在，本站网页显示的信息可能会有一定的滞后性或差错，对此情形请您知悉并理解；糖人街欢迎纠错，并会视情况给予纠错者一定的奖励。\n    为表述便利，商品和服务下方统一简称为“商品”。\n\n五、关于订单\n\t5.1  在您下订单时，请您仔细确认所购商品的名称、价格、数量、型号、规格、尺寸、联系地址、电话、收货人等信息。收货人与您本人不一致的，收货人的行为和意思表示视为您的行为和意思表示，您应对收货人的行为及意思表示的法律后果承担连带责任。\n\t5.2  除法律另有强制性规定外，本站与您的双方约定如下：本站上所有商家（下文简称：“商家”）展示的商品和价格等信息仅仅是要约邀请，您下单时须填写您希望购买的商品数量、价款及支付方式、收货人、联系方式、收货地址（合同履行地点）、合同履行方式等内容；系统生成的订单信息是计算机信息系统根据您填写的内容自动生成的数据，仅是您向商家发出的合同要约，商家收到您的订单信息后，只有在商家将您在订单中订购的商品从仓库中实际直接向您发出时（以商品出库为标志），方视为您与商家之间就实际直接向您发出的商品建立了合同关系；如果您在一份订单里订购了多种商品并且商家只给您发出了部分商品时，您与商家之间仅就实际直接向您发出的商品建立了合同关系；只有在商家实际直接向您发出了订单中订购的其他商品时，您和商家之间就订单中该其他已实际直接向您发出的商品才成立合同关系。您可以随时登录您在本站注册的用户账户，查询您的订单状态。\n\t5.3  由于市场变化及各种以合理商业变化导致难以控制因素的影响，本站无法保证您提交的订单信息中希望购买的商品都会有货；如您拟购买的商品发生缺货，您有权取消订单。\n\n六、配送\n\t6.1  商家将会把商品送到您所指定的收货地址，所有在本站上列出的送货时间为参考时间，参考时间的计算是根据库存状况、正常的处理过程和送货时间、送货地点的基础上估计得出的。\n\t6.2  因如下情况造成订单延迟或无法配送等，商家不承担延迟配送的责任；\n\t(1) 您提供的信息错误、地址不详细等原因导致的；\n\t(2) 货物到达后无人签收，导致无法配送或延迟配送的；\n\t(3) 情势变更因素导致的；\n\t(4) 不可抗力因素导致的，例如：自然灾害、交通戒严、突发战争等。\n\n七、所有权及知识产权条款\n\t7.1 您一旦接受本协议，即表明您主动将其在任何时间段在本站发表的任何形式的信息内容（包括但不限于评价、咨询、各类话题文章等信息内容）的财产性权利等任何可转让的权利，如著作权财产权（包括并不限于：复制权、发行权、出租权、展览权、表演权、放映权、广播权、信息网络传播权、摄制权、改编权、翻译权、汇编权以及应当由著作权人享有的其他可转让权利），全部独家且不可撤销地转让给糖人街所有，您同意糖人街有权就任何主体侵权而单独提起诉讼。\n\t7.2 本协议已经构成《中华人民共和国著作权法》第二十五条（条文序号依照2011年版著作权法确定）及相关法律规定的著作财产权等权利转让书面协议，其效力适用于您在糖人街网站上发布的任何受著作权法保护的作品内容，无论内容形成于本协议订立前还是本协议订立后。\n\t7.3 您同意并已充分了解本协议的条款，承诺不将已发表于本站的信息，以任何形式发布或授权其它主体以任何方式使用（包括但不限于在各类网站、媒体上使用）。\t7.4 糖人街是本站的制作者，拥有此网站内容及资源的著作权等合法权利，受国家法律保护，有权不时地对本协议及本站的内容进行修改，并在本站张贴，无须另行通知您。在法律允许的最大限度范围内，糖人街对本协议及本站内容拥有解释权。\n\t7.5 除法律另有强制性规定外，未经糖人街书面明确许可，任何单位或个人不得以任何方式非法地全部或部分复制、转载、引用、链接、抓取或以其他方式使用本站的信息内容，否则，糖人街有权追究其法律责任。\n\t7.6 本站所刊登的资料信息（诸如文字、图表、标识、按钮图标、图像、声音文件片段、数字下载、数据编辑和软件），均是糖人街或其内容提供者的财产，受中国和国际版权法的保护。本站所有内容的汇编是糖人街的排他财产，受中国和国际版权法的保护。本站上所有软件都是糖人街或其关联公司或其软件供应商的财产，受中国和国际版权法的保护。\n\n八、责任限制及不承诺担保\n\t除非另有明确的书面说明，本站及其所包含的或以其他方式通过本站提供给您的全部信息、内容、材料、产品（包括软件）和服务，均是在“按现状”和“按现有”的基础上提供的。/n\t除非另有明确的书面说明，糖人街不对本站的运营及其包含在本网站上的信息、内容、材料、产品（包括软件）或服务作任何形式的、明示或默示的声明或担保（根据中华人民共和国法律另有规定的以外）。糖人街不担保本站所包含的或以其它方式通过本站提供给您的全部信息、内容、材料、产品（包括软件）和服务、其服务器或从本站发出的电子信件、信息没有病毒或其他有害成分。\n\t如因不可抗力或其它本站无法控制的原因使本站销售系统崩溃或无法正常使用导致网上交易无法完成或丢失有关的信息、记录等，糖人街不承担任何责任。糖人街会合理地尽力协助处理善后事宜。\n\n九、协议更新及用户关注义务\n\t根据国家法律法规变化及网站运营需要，糖人街有权对本协议条款不时地进行修改。修改后的协议一旦被张贴在本站上即时生效，并代替原来的协议。您可随时登录查阅最新协议；您有义务不时关注并阅读最新版的协议及网站公告。如您不同意更新后的协议，可以且应立即停止接受糖人街网站依据本协议提供的服务；如您继续使用本网站提供的服务的，即视为同意更新后的协议。糖人街建议您在使用本站之前阅读本协议及本站的公告。如果本协议中任何一条被视为废止、无效或因任何理由不可执行，该条应视为可分的且并不影响任何其余条款的有效性和可执行性。\n\n十、法律管辖和适用\n\t本协议的订立、执行和解释及争议的解决均应适用在中华人民共和国大陆地区适用之有效法律（但不包括其冲突法规则）。如发生本协议与适用之法律相抵触时，则这些条款将完全按法律规定重新解释，而其它有效条款继续有效。如缔约方就本协议内容或其执行发生任何争议，双方应尽力友好协商解决；协商不成时，任何一方均可向有管辖权的中华人民共和国大陆地区法院提起诉讼。\n\n十一、其他\n\t11.1 本站所有者是指在政府部门依法许可或备案的本站经营主体。\n\t11.2 糖人街尊重用户和消费者的合法权利，本协议及本网站上发布的各类规则、声明等其他内容，均是为了更好的、更加便利的为您和商家提供服务。本站欢迎您和社会各界提出意见和建议，糖人街将虚心接受并适时修改本协议及本站上的各类规则。\n\t11.3 您点击本协议下方的“同意并继续”按钮即视为您完全接受本协议，在点击之前请您再次确认已知悉并完全理解本协议的全部内容。";
    return s;
}
- (void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=YES;

}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.tabBarController.tabBar.hidden=NO;
}

#pragma mark -- 网络请求 --
- (void)requestContent{

    NSString * url=@"http://www.qiuxinde.com/mobile/index/agreement";
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSDictionary * model=[responseObject objectForKey:@"model"];
            NSString * str=[model objectForKey:@"content"];
            [self.webView loadHTMLString:str baseURL:nil];
            
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
    
    
    

}



#pragma mark -- 点击事件 --
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];

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
