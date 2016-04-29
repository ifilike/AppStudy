//
//  KnowledgeViewController.m
//  QXD
//
//  Created by wzp on 16/1/20.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "NaviagtionBarShareView.h"
#import "UMSocial.h"
#import "DetailsTableViewCell2.h"
#import "BuyNowProductView.h"
#import "BuyNowTableViewCell.h"
#import "InterestTableViewCell.h"
#import "ZTProductListModel.h"
#import "FoundModel.h"
#import "DeTaiilsViewController2.h"
#import "UserID.h"
#import "UserInfoViewController.h"
#import "UserIDModle.h"
#import "FriendsModel.h"
#import "CalucateViewController.h"
#import "KnowLedgeTableViewCell.h"
#import "HeightWebView.h"



@interface KnowledgeViewController ()<UMSocialUIDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>


@property(nonatomic,retain)UITableView * tableView;
@property(nonatomic,retain)NaviagtionBarShareView * navigationView;
@property(nonatomic,retain)UIView * leftLien;
@property(nonatomic,retain)UIView * rightLien;
@property(nonatomic,retain)UILabel * movieLable;
@property(nonatomic,retain)UILabel * mutibleLabel;
@property(nonatomic,retain)UIView * leftLien2;
@property(nonatomic,retain)UIView * rightLien2;
@property(nonatomic,retain)UILabel * likeLabel;
@property(nonatomic,retain)UIImageView * selectImageView;
@property(nonatomic,strong)NSMutableArray * foundModelArr;
@property(nonatomic,strong)NSMutableArray * productArr;
@property(nonatomic,retain)FoundModel * webModel;
@property(nonatomic,assign)float height;


@property(nonatomic,retain)HeightWebView * heightView;



@end

#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation KnowledgeViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
    [self removeObserver];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    self.heightView=[[HeightWebView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 200)];
    _heightView.delegate=self;
    _heightView.scrollView.scrollEnabled=NO;
    [self.view addSubview:_heightView];
    [_heightView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    self.height=0.0;
    
    [self requestWithID:_ztID];
    [self requestProductsWithID:_ztID];
    
    
    
    
    //    //轻点手势
    //    UITapGestureRecognizer * tap1=[[UITapGestureRecognizer alloc] init];
    //    [tap1 addTarget:self action:@selector(keyboardHidden)];
    //    [self.view addGestureRecognizer:tap1];
    
    
    
    //自定义导航栏
    self.navigationView=[[NaviagtionBarShareView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [_navigationView.cancellBut addTarget:self action:@selector(cancell) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView.wxBut addTarget:self action:@selector(shareToWX) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView.friendBut addTarget:self action:@selector(shareToWB) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView.moreBut addTarget:self action:@selector(moreShare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navigationView];
    
    
    
    
    
    
    //选择面膜的标志
    _leftLien=[[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 39*PROPORTION_WIDTH, 82*PROPORTION_WIDTH, 1)];
    _leftLien.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
    
    _rightLien=[[UIView alloc] initWithFrame:CGRectMake(WIDTH-97*PROPORTION_WIDTH, 39*PROPORTION_WIDTH, 82*PROPORTION_WIDTH, 1)];
    _rightLien.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
    
    _movieLable=[[UILabel alloc] initWithFrame:CGRectMake(97*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, WIDTH-194*PROPORTION_WIDTH, 39*PROPORTION_WIDTH)];
    _movieLable.text=@" ";
    _movieLable.textAlignment=1;
    _movieLable.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    _movieLable.textColor=[self colorWithHexString:@"#555555"];
    
    _selectImageView=[[UIImageView alloc] initWithFrame:CGRectMake(97*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, WIDTH-194*PROPORTION_WIDTH, 39*PROPORTION_WIDTH)];
    _selectImageView.image=[UIImage imageNamed:@"知识普及"];
    
    
    
    
    
    
    //猜你喜欢的标志
    _leftLien2=[[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 55*PROPORTION_WIDTH, 133*PROPORTION_WIDTH, 1)];
    _leftLien2.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
    
    _rightLien2=[[UIView alloc] initWithFrame:CGRectMake(WIDTH-148*PROPORTION_WIDTH, 55*PROPORTION_WIDTH, 133*PROPORTION_WIDTH, 1)];
    _rightLien2.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
    
    _likeLabel=[[UILabel alloc] initWithFrame:CGRectMake(159*PROPORTION_WIDTH, 40*PROPORTION_WIDTH, WIDTH-318*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    _likeLabel.text=@"猜你喜欢";
    _likeLabel.textAlignment=1;
    _likeLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    _likeLabel.textColor=[self colorWithHexString:@"#FD681F"];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 跳转的方法

- (void)nowToBuyWithButton:(UIButton*)button{
    NSLog(@"立即购买%ld",button.tag);
    //先判断有没有登录
    UserID *user = [UserID shareInState];
    NSArray *array = [user redFromUserListAllData];
    if (array.count == 0) {
        UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
        userInfo.VC = @"abcd";
        [self.navigationController pushViewController:userInfo animated:NO];
    }else{
        
        ZTProductListModel * productModel=self.productArr[button.tag-1];
        
        UserIDModle *model =[[user redFromUserListAllData] lastObject];
        FriendsModel * fmodel=[[FriendsModel alloc] init];
        fmodel.customer_id=model.ID;
        fmodel.product_id=productModel.ID;
        fmodel.product_img=productModel.product_img1;
        fmodel.product_name=productModel.product_name;
        fmodel.product_num=@"1";
        fmodel.product_price=productModel.product_present_price;
        fmodel.product_standard=productModel.product_standard;
        CalucateViewController *caluctae = [[CalucateViewController alloc] init];
        caluctae.array1 = @[fmodel];
        caluctae.isBuy=YES;
        caluctae.totalMoney =[productModel.product_present_price floatValue];
        [self.navigationController pushViewController:caluctae animated:YES];
    }
    
    
}
//单品详情

- (void)presentProductDetailsViewControllerWithProductID:(NSString*)productID{
    
    DeTaiilsViewController2 * viewController=[[DeTaiilsViewController2 alloc] init];
    viewController.productID=productID;
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark 关于网络请求的方法


- (void)requestWithID:(NSString*)ID{
    NSString * url=@"http://www.qiuxinde.com/mobile/found/oneFound";
    NSDictionary * urlDic=[NSDictionary dictionaryWithObject:_ztID forKey:@"id"];
    
    NSLog(@"%@",_ztID);
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    [manager GET:url parameters:urlDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发现请求成功%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSDictionary * dict=[responseObject objectForKey:@"model"];
            _webModel=[[FoundModel alloc] init];
            [_webModel setValuesForKeysWithDictionary:dict];
            _movieLable.text=_webModel.title;
            //设置行间距
            NSString *webviewText = @"<style>body{font:14px/24px Custom-Font-Name;}</style>";
            
            NSString *htmlString = [webviewText stringByAppendingFormat:@"%@", _webModel.content];
            [_heightView loadHTMLString:htmlString baseURL:nil];
        }else{
            NSLog(@"请求失败");
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发现请求失败%@",error);
    }];
}
- (void)requestProductsWithID:(NSString*)ID{
    NSString * url=@"http://www.qiuxinde.com/mobile/found/allFoundProduct";
    NSDictionary * urlDic=[NSDictionary dictionaryWithObject:_ztID forKey:@"id"];
    
    NSLog(@"%@",_ztID);
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    [manager GET:url parameters:urlDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"产品请求成功%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSArray * modelArr=[responseObject objectForKey:@"model"];
            for (NSDictionary * productDic in modelArr) {
                //默认
                ZTProductListModel * model=[[ZTProductListModel alloc] init];
                [model setValuesForKeysWithDictionary:productDic];
                [self.productArr addObject:model];
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"产品请求失败%@",error);
    }];
    
    
    
    
}




#pragma mark 关于键盘弹出的方法




//返回上一页
- (void)cancell{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 关于分享的方法
- (void)shareToWX{
    NSLog(@"分享给微信好友");
    //分享纯图片
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"分享内嵌文字" image:[UIImage imageNamed:@"图标白底"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    
    
    
    
}
- (void)shareToWB{
    NSLog(@"分享到朋友圈");
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"分享内嵌文字" image:[UIImage imageNamed:@"图标白底"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    
    
    
}
- (void)moreShare{
    NSLog(@"QQ分享");
    
    //    //QQ分享
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"分享内嵌文字" image:[UIImage imageNamed:@"图标白底"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    
    
    
    
}

#pragma mark 表情代理

#pragma mark 懒加载
- (NSMutableArray *)foundModelArr{
    if (_foundModelArr==nil) {
        _foundModelArr=[NSMutableArray arrayWithCapacity:1];
        
    }
    return _foundModelArr;
}
- (NSMutableArray *)productArr{
    if (_productArr==nil) {
        _productArr=[NSMutableArray arrayWithCapacity:1];
        
        
    }
    return _productArr;
    
}

#pragma mark tableView  datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1;
    }else if (section==1){
        return 1;
    }else if (section==2){
        //立即购买
        int count=(int)self.productArr.count;
        return count;
    }else if (section==3){
        return 0;
    }else if (section==4){
        return 0;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"qq"];
        if (cell==nil) {
            cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qq"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        //选择面膜的标志
        [cell addSubview:_leftLien];
        [cell addSubview:_rightLien];
        [cell addSubview:_selectImageView];
        [cell addSubview:_movieLable];
        return cell;
    }else if (indexPath.section==1) {
        KnowLedgeTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"qe"];
        if (cell==nil) {
            cell=[[KnowLedgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qe"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        
        [cell setFoundModel:_webModel withHeight:self.height];
        
        return cell;
    }else if (indexPath.section==2){
        
        BuyNowTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ee"];
        if (cell==nil) {
            cell=[[BuyNowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ee"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        //立即购买
        [cell.buyNowView.buyBut addTarget:self action:@selector(nowToBuyWithButton:) forControlEvents:UIControlEventTouchUpInside];
        ZTProductListModel * model=self.productArr[indexPath.row];
        
        NSInteger tag=indexPath.row+1;
        
        [cell setZTProductListModel:model tag:tag];
        
        
        return cell;
    }else if (indexPath.section==3){
        //            //猜你喜欢的标志
        //            DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"r"];
        //            if (cell==nil) {
        //                cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"r"];
        //                cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //
        //            }
        //        [cell addSubview:_leftLien2];
        //        [cell addSubview:_rightLien2];
        //        [cell addSubview:_likeLabel];
        //
        //        return cell;
    }else if (indexPath.section==4){
        //    //猜你喜欢
        //        InterestTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"rr"];
        //        if (cell==nil) {
        //            cell=[[NSBundle mainBundle] loadNibNamed:@"InterestTableViewCell" owner:self options:nil][0];
        //            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //        }
        //        int kk=(int)indexPath.row;
        //        int h=2*kk;
        //        int ll=h+1;
        //        int count=(int)self.productlistArr.count;
        //        InterestProductModel * model1=self.productlistArr[h];
        //        InterestProductModel * model2;
        //        if (ll<count) {
        //            model2=self.productlistArr[ll];
        //        }else{
        //            model2=nil;
        //        }
        //        [cell setModel1:model1 model2:model2];
        //        for (InterestSubView * subView in cell.subButttonArr) {
        //            [subView addTarget:self action:@selector(presentProductDetailsViewControllerviewWithButton:) forControlEvents:UIControlEventTouchUpInside];
        //
        //        }
        //        return cell;
    }
    
    
    return nil;
}

#pragma mark tableView  代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 80*PROPORTION_WIDTH;
    }else if (indexPath.section==1){
        
        NSLog(@"----------%f",self.height);
        return self.height;
    }else if (indexPath.section==2){
        //立即购买
        return 170*PROPORTION_WIDTH;
    }else if (indexPath.section==3) {
        return 90*PROPORTION_WIDTH;
    }else if (indexPath.section==4){
        return 266*PROPORTION_WIDTH;
    }
    return 0;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        ZTProductListModel * model=self.productArr[indexPath.row];
        [self presentProductDetailsViewControllerWithProductID:model.ID];
        
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Webview代理方法

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //   NSString * htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    //
    //    NSLog(@"%@",htmlHeight);
    //
    //    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"]floatValue];
    //    NSLog(@"%f",webViewHeight);
    
    //   NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    //  [webView stringByEvaluatingJavaScriptFromString:str];
    
    
    NSLog(@"%f",webView.scrollView.contentSize.height);
    
    
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = 300.0;" // UIWebView中显示的图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    NSLog(@"%f",webView.scrollView.contentSize.height);

    
    //  [webView sizeToFit];
    NSLog(@"++++++++%f",webView.scrollView.contentSize.height);

    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        float webViewHeight = [[_heightView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        CGRect newFrame	   = _heightView.frame;
        newFrame.size.height  = webViewHeight;
        _heightView.frame = newFrame;
        //返回Cell的高度
        self.height=webViewHeight;
        [self.tableView reloadData];
    }
}
- (void)removeObserver{
    [_heightView.scrollView removeObserver:self
                                forKeyPath:@"contentSize" context:nil];
}




#pragma mark 生成颜色的方法


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
