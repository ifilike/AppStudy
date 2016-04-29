//
//  DetailsViewController.m
//  QXD
//
//  Created by WZP on 15/11/16.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "DetailsViewController.h"
#import "NaviagtionBarShareView.h"              //自定义的导航栏(分享)
#import "UserID.h"                              //用户信息
#import "UserIDModle.h"                         //用户信息
#import "UserInfoViewController.h"              //用户信息
#import "CommentModel.h"                        //主题评论数据模型
#import "ZTProductListModel.h"                  //立即购买商品的数据模型
#import "MoreProductCommentViewController.h"    //全部评论页面控制器
#import <AVFoundation/AVFoundation.h>           //系统框架(播放视频用的)
#import <MediaPlayer/MediaPlayer.h>             //系统框架(播放视频用的)
#import "DeTaiilsViewController2.h"             //单品页控制器
#import "UMSocial.h"                            //友盟第三方
#import "CommentView.h"                         //发送评论的控件
#import "MasterViewController.h"                //申请摩选师的控制器
#import "MoxuanshiView.h"                       //2个摩选师信息展示图(头像,昵称,工作产品)
#import "BuyNowProductView.h"                   //立即购买的View
#import "MoxuanshiModel.h"                      //摩选师信息数据模型
#import "MovieDetailsView.h"                    //视频介绍的View
#import "BuyNowTableViewCell.h"                 //立即购买的Cell
#import "FriendsModel.h"                        //判断登陆所用
#import "CalucateViewController.h"              //确认订单
#import "ZtCommentView.h"                       //主题评论的展示View
#import "CommentLienView.h"                     //所有10条评论下的一条灰色的线
#import "MovieModel.h"                          //视频的信息模型
#import "WXApiObject.h"                         //微信第三方

#import "VideoPlayerViewController.h"           //播放视频
#import "KMPMoviePlayerController.h"            //播放视频
#import "UIView+Extension.h"                    //播放视频此三个类高手所写(小武哥)

#define kSMainWidth [UIScreen mainScreen].bounds.size.width
#define kSMainHeight [UIScreen mainScreen].bounds.size.height
#define kNavViewHeight 64
#define kVideoViewHeight kSMainWidth*(9.0/16.0)
#define kVideoViewMaxBottom kSMainWidth*(9.0/16.0)+kNavViewHeight

@interface DetailsViewController ()<UITextFieldDelegate,UIWebViewDelegate,ViewSizeDelegate,UMSocialUIDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,KMPMoviePlayerControllerDelegate>
{
    CGFloat scrollViewOffY;
    CGFloat lastPosition;
}
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIView *navView;

@property (nonatomic, strong) KMPMoviePlayerController *videoController;//播放视频的控制器(小武哥写的)



@property(nonatomic,retain)UIScrollView * scrollView;
@property(nonatomic,assign)float setY;   //记录坐标
@property(nonatomic,retain)MovieDetailsView * movieDetailsView;   //视频介绍的View
@property(nonatomic,retain)UIView * moxuanView;   //申请摩选师按钮的View
@property(nonatomic,retain)UIImageView * moxuanshiView;   //申请摩选师的底图
@property(nonatomic,retain)NaviagtionBarShareView * navigationView;   //分享导航栏
@property(nonatomic,retain)MoxuanshiView * moxuanModelView1;   //摩选师1信息View
@property(nonatomic,retain)MoxuanshiView * moxuanModelView2;   //摩选师2的信息View
@property(nonatomic,retain)UITableView * productListTabelView;   //立即购买列表
@property(nonatomic,strong)NSMutableArray * ztProductListArr;   //立即购买的模型数组
@property(nonatomic,retain)ZtCommentView * commentTable;   //展示评论的tableView
@property(nonatomic,strong)NSMutableArray * commentModelArr;   //存放评论数据模型的数组
@property(nonatomic,assign)int numberOfComment;   //记录总评论条数
@property(nonatomic,retain)UILabel * numberOfCommentLabel;   //展示评论总条数的Label
@property(nonatomic,retain)CommentLienView * commentlienView;   //一条灰色的线
@property(nonatomic,retain)CommentView * sendCommentView;       //发送评论的控件
@property(nonatomic,retain)UIButton * moreCommentBut;   //馋看更多评论的按钮
@property(nonatomic,retain)NSMutableArray * moxuanArr;   //存放摩选师数据的数组
@property(nonatomic,assign)float webViewSetY1;          //第1个webView的位置
@property(nonatomic,assign)float webViewHeight1;        //第1个webView的高度
@property(nonatomic,assign)float webViewSetY2;          //第2个webView的位置
@property(nonatomic,assign)float webViewHeight2;        //第1个webView的高度
@property(nonatomic,assign)float requestViewSetY;       //申请摩选师按钮的位置
@property(nonatomic,assign)float productListSetY;       //立即购买产品列表的位置
@property(nonatomic,assign)float commentListSetY;       //评论列表的位置


@property(nonatomic,retain)UIView * whiteview;
@property(nonatomic,assign)float  commH;
@property(nonatomic,retain)MovieModel * model;
@property(nonatomic,retain)NSDictionary * ztDic;


@end



#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation DetailsViewController



- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden=YES;

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    NSLog(@"将要出现");
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self detailsOfZt];
    [self ztProductListNetWorking];
    [self numberOfztCommentNetWorking];
    [self ztCommentNetWorking];
    [self requestMoxuanshiInfo];
    [self addNotification];

    
    
    
    self.navigationView=[[NaviagtionBarShareView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [_navigationView.cancellBut addTarget:self action:@selector(cancell) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView.wxBut addTarget:self action:@selector(shareToWX) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView.friendBut addTarget:self action:@selector(shareToWB) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView.moreBut addTarget:self action:@selector(moreShare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navigationView];
    
    
    

    
    
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.videoController.view.bottom, kSMainWidth,kSMainHeight-kVideoViewMaxBottom-54)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor=[self colorWithHexString:@"F7F7F7"];
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    
    
    
    
    //添加视频介绍
    [self addMovieView];
    //添加申请摩选师按钮
    [self addrequestMoxuanshiView];
    //添加第一个摩选师
    [self addMoxuanModelView1];
    //添加第二个摩选师
    [self addMoxuanModelView2];
    //添加产品列表
    //[self addProductListTabelView];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self.view addSubview:self.videoController.view];
    [self.view addSubview:_scrollView];
    [self.view addSubview:self.navigationView];
    
    [self.view bringSubviewToFront:self.navigationView];
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://video.szzhangchu.com/laohuangguachaohuajiaB.mp4"];
    _videoController.contentURL = url;
    _videoController.defaultImageUrl = @"http://images.tiantian.com/upload/Cosmetics/cd2/8tt11-19da4-3.jpg";
    
    
    
    //发送评论的控件
    _sendCommentView=[[CommentView alloc] initWithFrame:CGRectMake(0, HEIGHT-54, WIDTH, 54)];
    _sendCommentView.contentField.delegate=self;
    //    _sendCommentView.contentField.text=@"评论一下";
    _sendCommentView.contentField.placeholder=@"  评论一下";
    _sendCommentView.backgroundColor=[UIColor whiteColor];
    _sendCommentView.alpha=1;
    _sendCommentView.contentField.returnKeyType=UIReturnKeyDone;
    _sendCommentView.contentField.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    //  [_sendCommentView.faceBut addTarget:self action:@selector(addEmotionView) forControlEvents:UIControlEventTouchUpInside];
    [_sendCommentView.sendBut addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendCommentView];
}

- (void)addMovieView{
    self.setY=0*PROPORTION_WIDTH;

    _movieDetailsView= [[MovieDetailsView alloc] initWithFrame:CGRectMake(0, _setY, WIDTH, 55*PROPORTION_WIDTH+40)];

    [self.scrollView addSubview:_movieDetailsView];
    _setY+=_movieDetailsView.frame.size.height+15*PROPORTION_WIDTH;
    _requestViewSetY=_setY;

}

- (void)addrequestMoxuanshiView{
    
    _moxuanView=[[UIView alloc] initWithFrame:CGRectMake(0, _requestViewSetY, WIDTH, 100*PROPORTION_WIDTH)];
    _moxuanView.backgroundColor=[UIColor whiteColor];
    //摩选师
    _moxuanshiView=[[UIImageView alloc] initWithFrame:CGRectMake(16*PROPORTION_WIDTH,  15*PROPORTION_WIDTH,343*PROPORTION_WIDTH, 70*PROPORTION_WIDTH)];
    _moxuanshiView.layer.borderWidth=1;
    _moxuanshiView.layer.cornerRadius=12;
    _moxuanshiView.image=[UIImage imageNamed:@"申请试用师底图"];
//    _moxuanshiView.backgroundColor=[UIColor redColor];
    _moxuanshiView.layer.borderColor=[self colorWithHexString:@"#FFFFFF"].CGColor;

    //点击申请摩选师
    _moxuanshiView.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap2=[[UITapGestureRecognizer alloc] init];
    [tap2 addTarget:self action:@selector(requestMoxuanshi)];
    [_moxuanshiView addGestureRecognizer:tap2];

    
    UILabel* noteLabel = [[UILabel alloc] init];
    noteLabel.textAlignment=1;
    noteLabel.frame = CGRectMake(0, 10*PROPORTION_WIDTH, 343*PROPORTION_WIDTH, 50*PROPORTION_WIDTH);
    noteLabel.textColor = [self colorWithHexString:@"#FD681F"];
    noteLabel.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"申请加入严选师"];
    NSRange blackRange = NSMakeRange(0, [[noteStr string] rangeOfString:@"严"].location);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#555555"] range:blackRange];
    [noteLabel setAttributedText:noteStr] ;
    [_moxuanshiView addSubview:noteLabel];

    
    UIImageView * nextView=[[UIImageView alloc] initWithFrame:CGRectMake(343*PROPORTION_WIDTH-24*PROPORTION_WIDTH-27*PROPORTION_WIDTH, 21.5*PROPORTION_WIDTH, 27*PROPORTION_WIDTH, 27*PROPORTION_WIDTH)];
//        nextView.backgroundColor=[UIColor redColor];
    nextView.image=[UIImage imageNamed:@"enter_icon2"];
    [_moxuanshiView addSubview:nextView];
    
    [_moxuanView addSubview:_moxuanshiView];
    [self.scrollView addSubview:_moxuanView];
    
    _setY+=100*PROPORTION_WIDTH;

    self.webViewSetY1=_requestViewSetY+100*PROPORTION_WIDTH;
}

- (void)addMoxuanModelView1{
    _moxuanModelView1=[[MoxuanshiView alloc] initWithFrame:CGRectMake(0, _webViewSetY1, WIDTH, 315*PROPORTION_WIDTH)];
    _moxuanModelView1.delegate=self;
    [self.scrollView addSubview:_moxuanModelView1];
    _setY+=315*PROPORTION_WIDTH;

    self.webViewSetY2=_setY;

}
- (void)addMoxuanModelView2{
    _moxuanModelView2=[[MoxuanshiView alloc] initWithFrame:CGRectMake(0, _webViewSetY2, WIDTH, 315*PROPORTION_WIDTH)];
    _moxuanModelView2.delegate=self;
    [self.scrollView addSubview:_moxuanModelView2];
    
    self.productListSetY=_webViewSetY2+315*PROPORTION_WIDTH;
}

- (void)addProductListTabelView{
    int count=(int)self.ztProductListArr.count;

    int high=count*150;
    
    self.productListTabelView=[[UITableView alloc] initWithFrame:CGRectMake(0, _productListSetY, WIDTH, high*PROPORTION_WIDTH)];
    _productListTabelView.backgroundColor=[UIColor whiteColor];
    _productListTabelView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _productListTabelView.dataSource=self;
    _productListTabelView.delegate=self;
    _productListTabelView.tag=11;
    _productListTabelView.scrollEnabled=NO;
    
    
    [self.scrollView addSubview:_productListTabelView];
    
    self.commentListSetY=_productListSetY+_productListTabelView.frame.size.height;
    
    

}
- (void)commentViewRemoveFromSuperView{

    [_numberOfCommentLabel removeFromSuperview];
    [_commentTable removeFromSuperview];
    [_commentlienView removeFromSuperview];
    [_whiteview removeFromSuperview];
    [_moreCommentBut removeFromSuperview];
}
- (void)viewDidAppear:(BOOL)animated{

    [self.scrollView reloadInputViews];


}
- (void)addCommentTableView{
    self.commH=0;
    
    //headOfCommentView
    _numberOfCommentLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, _commentListSetY, WIDTH, 30*PROPORTION_WIDTH)];
    _numberOfCommentLabel.backgroundColor=[UIColor whiteColor];
    _numberOfCommentLabel.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    NSString * str=@"   所有";
    NSString * num=[NSString stringWithFormat:@"%d",_numberOfComment];
    NSString * str2=@"条评论";
    NSString * allStr=[NSString stringWithFormat:@"%@%@%@",str,num,str2];
    NSInteger loca=[allStr length];
    NSLog(@"%ld",loca);
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#555555"] range:NSMakeRange(0,5)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#FD681F"] range:NSMakeRange(5,loca-7)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#555555"] range:NSMakeRange(loca-3,3)];
    _numberOfCommentLabel.attributedText=attributeStr;
    
    [self.scrollView addSubview:_numberOfCommentLabel];
    
    self.commentlienView=[[CommentLienView alloc] initWithFrame:CGRectMake(0, _commentListSetY+30*PROPORTION_WIDTH, WIDTH, 20*PROPORTION_WIDTH)];
    _commentlienView.backgroundColor=[UIColor whiteColor];
    [self.scrollView addSubview:_commentlienView];
    
    for (CommentModel * model in self.commentModelArr) {
        
     float hh= [self getHeightWithStr:model.comment_content];
        NSLog(@"%f",hh);
        
        self.commH=self.commH+hh;
        NSLog(@"%f",self.commH);

    }
    
    self.commentTable=[[ZtCommentView alloc] initWithFrame:CGRectMake(0, _commentListSetY+50*PROPORTION_WIDTH, WIDTH,self.commH+54*PROPORTION_WIDTH) withModelArr:self.commentModelArr];
    [self.scrollView addSubview:_commentTable];
    
    //更多评论的按钮
    _moreCommentBut  =[[UIButton alloc] initWithFrame:CGRectMake(0, _commentListSetY+50*PROPORTION_WIDTH+self.commH, WIDTH, 54*PROPORTION_WIDTH)];
    _moreCommentBut.titleLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    _moreCommentBut.backgroundColor=[UIColor whiteColor];
    [self.scrollView addSubview:_moreCommentBut];
    
    [_moreCommentBut addTarget:self action:@selector(allComment) forControlEvents:UIControlEventTouchUpInside];
    [_moreCommentBut setTitleColor:[self colorWithHexString:@"#999999"] forState:0];
    if (_numberOfComment<=4) {
        [_moreCommentBut setTitle:@"没有更多了" forState:0];
        _moreCommentBut.userInteractionEnabled=NO;
    
    }else{
        [_moreCommentBut setTitle:@"查看全部评论 >" forState:0];
        _moreCommentBut.userInteractionEnabled=YES;
        //        _moreCommentBut.backgroundColor=[UIColor redColor];
                
    }

    
    float ll=_commentListSetY+50*PROPORTION_WIDTH+self.commH+54*PROPORTION_WIDTH;
    //_whiteview=[[UIView alloc] initWithFrame:CGRectMake(0, ll, WIDTH, 18*PROPORTION_WIDTH)];
   // [self.scrollView addSubview:_whiteview];
    
    
    self.scrollView.contentSize=CGSizeMake(WIDTH, ll);
    
    
    
    
}

- (float)getHeightWithStr:(NSString*)content{
    
    UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH-61*PROPORTION_WIDTH-23*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
    label.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    label.numberOfLines=0;
    [self.view addSubview:label];
    label.alpha=0;
    NSString * labelText =content;
    //设置行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    //    NSLog(@"%f",_commentLabel.frame.size.height);
    [label sizeToFit];
    
    if (label.frame.size.height+34*PROPORTION_WIDTH>90*PROPORTION_WIDTH) {
        return label.frame.size.height+34*PROPORTION_WIDTH;

    }else{
        return 90*PROPORTION_WIDTH;
    }
    
    
}
















#pragma mark 关于网络请求的方法

- (void)detailsOfZt{

    NSString * urlStr =@"http://www.qiuxinde.com/mobile/index/themeInfo";
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    // manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary * countDic=[NSDictionary dictionaryWithObject:_ztID forKey:@"id"];
    [manager GET:urlStr parameters:countDic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code=[responseObject objectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSDictionary * dictionary=[responseObject objectForKey:@"model"];

            _model=[[MovieModel alloc] init];
            [_model setValuesForKeysWithDictionary:dictionary];
            
        
            NSURL *url = [NSURL URLWithString:_model.mv_url];
            _videoController.contentURL = url;
            _videoController.defaultImageUrl = _model.mv_img_url;
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据错误:  %@",error);
    }];



}


- (void)numberOfztCommentNetWorking{
    NSString * urlStr =@"http://www.qiuxinde.com/mobile/index/commentCount";
    [self.commentModelArr removeAllObjects];
    
    NSDictionary * countDic=[NSDictionary dictionaryWithObject:_ztID forKey:@"id"];
    //请求主题评论条数
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    // manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager GET:urlStr parameters:countDic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSString * numberOfComment=[responseObject objectForKey:@"model"];
            NSLog(@"%@",numberOfComment);
            self.numberOfComment=[numberOfComment intValue];
            NSString * str=@"   所有";
            NSString * num=[NSString stringWithFormat:@"%d",_numberOfComment];
            NSString * str2=@"条评论";
            NSString * allStr=[NSString stringWithFormat:@"%@%@%@",str,num,str2];
            NSInteger loca=[allStr length];
            NSLog(@"%ld",loca);
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:allStr];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#555555"] range:NSMakeRange(0,5)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#FD681F"] range:NSMakeRange(5,loca-7)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#555555"] range:NSMakeRange(loca-3,3)];
            _numberOfCommentLabel.attributedText=attributeStr;
            
            
            if (self.numberOfComment>4) {
                [_moreCommentBut setTitle:@"查看全部评论 >" forState:0];
                _moreCommentBut.userInteractionEnabled=YES;
            }
            
            
            
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"评论数据错误:  %@",error);
    }];
}
- (void)ztCommentNetWorking{
    NSString * urlStr =@"http://www.qiuxinde.com/mobile/index/queryById/";
    [self.commentModelArr removeAllObjects];
    
    NSDictionary * ztDic=[NSDictionary dictionaryWithObjectsAndKeys:_ztID,@"id",@"1",@"pageNum",@"4",@"pageSize", nil];
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    
    //请求主题评论数据
    [manager GET:urlStr parameters:ztDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            [self.commentModelArr removeAllObjects];

            NSArray * modelArr=[responseObject  objectForKey:@"model"];
            
            NSLog(@"%@",modelArr);
            NSLog(@"%ld",modelArr.count);

            
            for (NSDictionary * commentDic in modelArr) {
                CommentModel * commentModel=[[CommentModel alloc] init];
                [commentModel setValuesForKeysWithDictionary:commentDic];
                
                NSLog(@"%@",commentModel.comment_customer_head);

                [self.commentModelArr addObject:commentModel];
            }

            
            [_commentTable reloadDataWithModelArr:self.commentModelArr];
            self.commH=0;
            for (CommentModel * model in self.commentModelArr) {
                
                float hh= [self getHeightWithStr:model.comment_content];
                NSLog(@"%f",hh);
                
                self.commH=self.commH+hh;
                NSLog(@"%f",self.commH);
                
            }
            _commentTable.frame=CGRectMake(_commentTable.frame.origin.x, _commentTable.frame.origin.y, WIDTH, _commH);
//            _commentTable.backgroundColor=[UIColor redColor];
            
            _moreCommentBut.frame=CGRectMake(0, _commentTable.frame.origin.y+self.commH, WIDTH, 54*PROPORTION_WIDTH);
            
            float ll=_commentTable.frame.origin.y+self.commH+36*PROPORTION_WIDTH;
            
            
            //_whiteview.frame=CGRectMake(0, ll, WIDTH, 18*PROPORTION_WIDTH);
            self.scrollView.contentSize=CGSizeMake(WIDTH, ll+18*PROPORTION_WIDTH);
        }else{
            NSLog(@"请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"评论数据错误:  %@",error);
    }];
}

- (void)requestMoxuanshiInfo{
    NSString * urlStr =@"http://www.qiuxinde.com/mobile/customer/getExperienceDivision";
    
    NSDictionary * ztDic=[NSDictionary dictionaryWithObjectsAndKeys:_ztID,@"theme_id", nil];
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    
    //请求摩选师数据
    [manager GET:urlStr parameters:ztDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"摩选师的信息%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSArray * modelArr=[responseObject objectForKey:@"model"];
            NSLog(@"%ld",modelArr.count);
            for (NSDictionary * moxuanDic in modelArr) {
                MoxuanshiModel * model=[[MoxuanshiModel alloc] init];
                [model setValuesForKeysWithDictionary:moxuanDic];
                [self.moxuanArr addObject:model];
                
            }
            [self reloadWebViewData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"摩选师的信息错误:  %@",error);
    }];
}
- (void)ztProductListNetWorking{
    NSString * url=@"http://www.qiuxinde.com/mobile/index/themeProduct";
    NSDictionary * dic=[NSDictionary dictionaryWithObject:_ztID forKey:@"id"];
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    [manager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"列表数据成功 %@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSArray * modelArr=[responseObject  objectForKey:@"model"];
            for (NSDictionary * ztListDic in modelArr) {
                ZTProductListModel * model=[[ZTProductListModel alloc] init];
                [model setValuesForKeysWithDictionary:ztListDic];
                [self.ztProductListArr addObject:model];
                NSLog(@"添加一次列表");
            }
           // [self addProductListTabelView];
            //[_productListTabelView reloadData];
        }else{
            NSLog(@"请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"列表数据失败 %@",error);
    }];
}


#pragma mark 监听事件


- (void)reloadWebViewData{
    
    
    NSString  * text=self.model.title;
    
    if (text==nil) {
        
        text=@"   ";
        
        
    }
    
    
    NSLog(@"%@",text);
    [_movieDetailsView changeContentWithText:text];
    
    
    _requestViewSetY=0*PROPORTION_WIDTH+_movieDetailsView.frame.size.height+15*PROPORTION_WIDTH;
    
    
    [_moxuanView removeFromSuperview];
    
    [self addrequestMoxuanshiView];
    
    
    MoxuanshiModel * model=self.moxuanArr[0];
    
    [_moxuanModelView1 setMoxuanshiModel:model withIndex:1];


    


}
- (void)changeHeightWith:(CGFloat)height withIndex:(NSInteger)index{

    if (index==1) {
        self.webViewHeight1=height+315*PROPORTION_WIDTH;
        _moxuanModelView1.frame=CGRectMake(_moxuanModelView1.frame.origin.x, _webViewSetY1, WIDTH, self.webViewHeight1);
        NSLog(@"修改成功");
        MoxuanshiModel * model2=self.moxuanArr[1];
        
        [_moxuanModelView2 setMoxuanshiModel:model2 withIndex:2];
    }else if (index==2){
        self.webViewHeight2=height+315*PROPORTION_WIDTH;
        _moxuanModelView2.frame=CGRectMake(_moxuanModelView2.frame.origin.x, _webViewSetY1+_webViewHeight1+15*PROPORTION_WIDTH, WIDTH, self.webViewHeight2);
        NSLog(@"修改成功++++++++");
        _productListSetY=_webViewSetY1+_webViewHeight1+15*PROPORTION_WIDTH+self.webViewHeight2;
        [_productListTabelView removeFromSuperview];
        [self addProductListTabelView];
        [self commentViewRemoveFromSuperView];
        [self addCommentTableView];
    }



}

#pragma mark 点击事件
//跳转申请摩选师
- (void)requestMoxuanshi{
    NSLog(@"摩选师");
    MasterViewController * masterViewController=[[MasterViewController alloc] init];
    [self.navigationController pushViewController:masterViewController animated:YES];
    
    
    
}

- (void)sendComment{
    //先判断有没有登录
    UserID *user = [UserID shareInState];
    NSArray *array = [user redFromUserListAllData];
    if (array.count == 0) {
        UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
        userInfo.VC = @"details";
        [self.navigationController pushViewController:userInfo animated:NO];
    }else{
        if (![self.sendCommentView.contentField.text isEqualToString:@""]) {
            NSLog(@"可以上传");
            //上传用户评论
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            //            NSString * kk=@"http://www.qiuxinde.com/mobile/index/addcomment";
            NSString * kk=@"http://www.qiuxinde.com/mobile/index/addcomment";
            
            //  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:kk parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                UserIDModle *model =[[user redFromUserListAllData] lastObject];
                NSString * name=model.nickName;
                NSString * icon=model.head_portrait;
                NSString * useID=model.ID;
                NSString * content=self.sendCommentView.contentField.text;
                //                NSAttributedString * string=self.sendCommentView.contentField.attributedText;
                //                NSLog(@"%@",string);
                //                NSString * hhhhh=[[NSString alloc] initWithFormat:@"%@",string];
                //                NSLog(@"%@",hhhhh);
                
                NSLog(@"%@",content);
                
                //主题ID
                [formData appendPartWithFormData:[_ztID dataUsingEncoding:NSUTF8StringEncoding] name:@"mobile_index_id"];
                //客户ID
                [formData appendPartWithFormData:[useID dataUsingEncoding:NSUTF8StringEncoding] name:@"comment_customer_id"];
                //客户昵称
                [formData appendPartWithFormData:[name dataUsingEncoding:NSUTF8StringEncoding] name:@"comment_customer_nickname"];
                //客户头像
                [formData appendPartWithFormData:[icon dataUsingEncoding:NSUTF8StringEncoding] name:@"comment_customer_head"];
                //评论内容
                [formData appendPartWithFormData:[content dataUsingEncoding:NSUTF8StringEncoding] name:@"comment_content"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString * succeed=[responseObject objectForKey:@"code"];
                if ([succeed isEqualToString:@"0"]) {
                  //  [self numberOfztCommentNetWorking];
                  //  [self ztCommentNetWorking];
                    [_sendCommentView.contentField resignFirstResponder];
                    [_sendCommentView.sendBut setTitleColor:[self colorWithHexString:@"#FFFFFF"] forState:0];
                    _sendCommentView.sendBut.backgroundColor=[self colorWithHexString:@"#FD681F"];
//                    _sendCommentView.contentField.text=@"评论一下";
                    _sendCommentView.contentField.placeholder=@"评论一下";
                    [self numberOfztCommentNetWorking];
                    [self ztCommentNetWorking];
                }else{
                    NSLog(@"上传失败");
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"错误  : %@", error);
            }];
            
        }
    }
    
}
//返回上一页
- (void)cancell{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//全部评论
- (void)allComment{
    MoreProductCommentViewController * moreCommentViewController=[[MoreProductCommentViewController alloc] init];
    moreCommentViewController.content=@"zt";
    moreCommentViewController.ztID=_ztID;
    [self.navigationController pushViewController:moreCommentViewController animated:YES];
}

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
        
        ZTProductListModel * productModel=self.ztProductListArr[button.tag-1];
        
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

#pragma mark 关于键盘弹出的方法

- (void)keyboardHidden{
    
}

- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知，ios5.0新增的
    //#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSLog(@"将要弹出");
    _sendCommentView.contentField.text=nil;
    //   self.emotionView.frame=CGRectMake(0, SCREEN_H, SCREEN_W, 200);
    
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
    
}
- (void)moveInputBarWithKeyboardHeight:(float)keyboardHeight withDuration:(NSTimeInterval)duration{
    NSLog(@"%f  %f",keyboardHeight,duration);
    
    _sendCommentView.contentField.textColor=[self colorWithHexString:@"#555555"];
    [UIView animateWithDuration:duration animations:^{
        _sendCommentView.frame=CGRectMake(0, SCREEN_H-54-keyboardHeight, WIDTH, 54);
        [self.view addSubview:_sendCommentView];
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    NSLog(@"将要消失");
   // _sendCommentView.contentField.text=@"评论一下";
   //_sendCommentView.contentField.textColor=[self colorWithHexString:@"#999999"];
    NSDictionary* userInfo = [aNotification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%ld",range.location);
    NSLog(@"%ld",range.length);
    
    
    
    return YES;
    
}   // return NO to not change text


#pragma mark 关于分享的方法
- (void)shareToWX{
    NSLog(@"分享给微信好友");
    //分享纯图片
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
   
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"分享内嵌文字" image:[UIImage imageNamed:@"分享图"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];

    
}
- (void)shareToWB{
    NSLog(@"分享到朋友圈");
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"分享内嵌文字" image:[UIImage imageNamed:@"分享图"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];

    
    
}
- (void)moreShare{
    NSLog(@"QQ分享");
    
//    //QQ分享
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"分享内嵌文字" image:[UIImage imageNamed:@"分享图"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];

    
    
    
}




#pragma mark commentTableView  dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==11) {
        int count=(int)self.ztProductListArr.count;
        return count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==11) {
        BuyNowTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ee"];
        if (cell==nil) {
            cell=[[BuyNowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ee"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        //立即购买
        [cell.buyNowView.buyBut addTarget:self action:@selector(nowToBuyWithButton:) forControlEvents:UIControlEventTouchUpInside];
        ZTProductListModel * model=self.ztProductListArr[indexPath.row];
        NSInteger tag=indexPath.row+1;
        
        [cell setZTProductListModel:model tag:tag];
        return cell;
    }
    return nil;
    
}







#pragma mark commentTableView  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==11) {
        return 150*PROPORTION_WIDTH;
        
    }

    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ZTProductListModel * model=self.ztProductListArr[indexPath.row];
    DeTaiilsViewController2 * detailsController=[[DeTaiilsViewController2 alloc] init];
    detailsController.productID=model.ID;
    [self.navigationController pushViewController:detailsController animated:YES];
    
    
}




#pragma mark 懒加载

- (NSMutableArray *)moxuanArr{
    if (_moxuanArr==nil) {
        _moxuanArr=[NSMutableArray arrayWithCapacity:1];
    }
    return _moxuanArr;

}
- (NSMutableArray *)ztProductListArr{
    if (_ztProductListArr==nil) {
        _ztProductListArr=[NSMutableArray arrayWithCapacity:1];
        
    }
    return _ztProductListArr;
}
- (NSMutableArray *)commentModelArr{
    if (_commentModelArr==nil) {
        _commentModelArr=[NSMutableArray arrayWithCapacity:1];
    }
    return _commentModelArr;
}


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


#pragma 播放
#pragma mark - Property
- (KMPMoviePlayerController *)videoController
{
    if (!_videoController) {
        _videoController = [[KMPMoviePlayerController alloc] initWithFrame:CGRectMake(0, kNavViewHeight, kSMainWidth, kVideoViewHeight)];
        _videoController.delegate = self;
    }
    return _videoController;
}
- (UIView *)navView
{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSMainWidth, kNavViewHeight)];
        _navView.backgroundColor = [UIColor whiteColor];
    }
    return _navView;
}
- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton new];
        _button.frame = CGRectMake(0, 20, 60, 44);
        [_button setTitle:@"返回" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(dealBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.sendCommentView.contentField resignFirstResponder];
    
    
    ///!!!!!!如果类中有多个scrollView  则此处需要判断scrollView
    
    if (_videoController.isPlaying) {
        
        [self setVideoViewOriginalFrame];
        
    }else{
        // 保证是垂直方向滚动，而不是水平滚动
        if (scrollView.contentOffset.x == 0) {
            
            CGFloat y = scrollView.contentOffset.y;
            // 这个是非常关键的变量，用于记录上一次滚动到哪个偏移位置
            static CGFloat previousOffsetY = 0;
            // 向上滚动
            if (y > 0) {
                if (self.videoController.view.bottom <= kNavViewHeight) {
                    return;
                }
                // 计算两次回调的滚动差:fabs(y - previousOffsetY)值
                CGFloat bottom = self.videoController.view.bottom - fabs(y - previousOffsetY);
                bottom = bottom >= 0 ? bottom : 0;
                self.videoController.view.bottom = bottom;
                
                _scrollView.frame = CGRectMake(0, self.videoController.view.bottom,
                                                   scrollView.width,
                                                   kSMainHeight-self.videoController.view.bottom-54);
                previousOffsetY = y;
                // 如果一直不松手滑动，重复向上向下滑动时，如果没有设置还原为0，则会出现马上到顶的情况。
                if (previousOffsetY >= self.videoController.view.height) {
                    previousOffsetY = 0;
                }
            }
            // 向下滚动
            else if (y < 0) {
                if (self.videoController.view.originY >= 64) {
                    return;
                }
                CGFloat bottom = self.videoController.view.bottom + fabs(y);
                bottom = (bottom <= kVideoViewMaxBottom) ? bottom : kVideoViewMaxBottom;
                self.videoController.view.bottom = bottom;
                
                _scrollView.frame = CGRectMake(0,
                                                   self.videoController.view.bottom,
                                                   scrollView.width,
                                                   kSMainHeight - self.videoController.view.bottom);
            }
        }
    }
}
///改变VideoView.originY
- (void)setVideoViewOriginY:(CGFloat)originY
{
    _videoController.view.originY = originY;
}
///VideoView原始Frame
- (void)setVideoViewOriginalFrame
{
    if (self.videoController.view.originY != 64) {
        //禁止视频播放时,调用改变视频视图Frame的方法
        if (!_videoController.isPlaying) {
            [UIView animateWithDuration:0.5 animations:^{
                self.videoController.view.frame = CGRectMake(0, 64, kSMainWidth, kVideoViewHeight);
                self.scrollView.frame = CGRectMake(0, self.videoController.view.bottom, kSMainWidth, kSMainHeight-64);
            }];
        }
    }
}
-(void)KMPMoviePlayerScreenState:(BOOL)fullScreen
{
    ///当切换为半屏状态时  回复为初始状态 当滑动 tableView时 会判断self.videoController.view的归属 此处无需判断
    if (!fullScreen) {
        [self setVideoViewOriginalFrame];
    }
}
- (void)KMPMoviePlaybackState:(MPMoviePlaybackState)State
{
    if (State == MPMoviePlaybackStatePlaying) {
        [UIView animateWithDuration:0.5 animations:^{
            self.videoController.view.frame = CGRectMake(0, 64, kSMainWidth, kVideoViewHeight);
            self.scrollView.frame = CGRectMake(0, self.videoController.view.bottom, kSMainWidth, kSMainHeight-64);
        }];
    }
}
#pragma mark - Action
- (void)dealBtn
{
    [self dismissViewControllerAnimated:YES completion:^{
        [_videoController dismiss];
    }];
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
