//
//  FoundZTViewController.m
//  QXD
//
//  Created by wzp on 15/12/29.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "FoundZTViewController.h"
#import "NaviagtionBarShareView.h"
#import "UMSocial.h"
#import "CommentView.h"
#import "EmotionScrollView.h"
#import "DetailsTableViewCell2.h"
#import "CommentWithStarsTableViewCell.h"
#import "BuyNowProductView.h"
#import "BuyNowTableViewCell.h"
#import "UserID.h"
#import "UserInfoViewController.h"
#import "UserIDModle.h"
#import "MyIdeaTableViewCell.h"
#import "MasterViewController.h"
#import "CommentModel.h"
#import "MoreProductCommentViewController.h"
#import "ZTProductListModel.h"
#import "DeTaiilsViewController2.h"
#import "FriendsModel.h"
#import "CalucateViewController.h"
#import "MyIdeaWebView.h"
#import "MoxuanshiModel.h"
#import "WebViewHeight2.h"

//视频
#import "TCCloudPlayerSDK.h"

#import "TCReportEngine.h"


@interface FoundZTViewController ()<UMSocialUIDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,SizeDelegate>
//视频
{
    CGFloat _limitedSeconds;
}
@property(nonatomic,strong) UIButton *playBtn;//视频播放按钮
@property(nonatomic,strong) UIButton *iconBtn;//视频头像
@property(nonatomic,assign) BOOL isOne;//一次

@property(nonatomic,retain)CommentView * sendCommentView;
//@property(nonatomic,strong)EmotionScrollView * emotionView;
@property(nonatomic,assign)BOOL emotion_is;
@property(nonatomic,retain)UITableView * tableView;
@property(nonatomic,retain)UIImageView * moxuanshiView;
@property(nonatomic,retain)UILabel * numOfComment;
@property(nonatomic,retain)UIView * leftLien;
@property(nonatomic,retain)UIView * rightLien;
@property(nonatomic,retain)UILabel * movieLable;
@property(nonatomic,retain)UILabel * mutibleLabel;
@property(nonatomic,strong)NSMutableArray * commentModelArr;
@property(nonatomic,assign)int numberOfComment;
@property(nonatomic,retain)UIButton * moreCommentBut;
@property(nonatomic,strong)NSMutableArray * moxuanArr;
@property(nonatomic,strong)NSMutableArray * webViewHeightArr;
@property(nonatomic,strong)NSMutableArray * ztProductListArr;



@end


#define HEIGHT [[UIScreen mainScreen] bounds].size.height


@implementation FoundZTViewController


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=NO;

}
-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //视频
    [self addPlayerView];
    
    
    _emotion_is=NO;
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-54)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
//    _heightView=[[WebViewHeight2 alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 100)];
//    _heightView.delegate=self;
//    [self.view addSubview:_heightView];
//
    
    
    [self numberOfztCommentNetWorking];
    [self ztCommentNetWorking];
    [self ztProductListNetWorking];
    [self requestMoxuanshiInfo];


    
    
    
//    //轻点手势
//    UITapGestureRecognizer * tap1=[[UITapGestureRecognizer alloc] init];
//    [tap1 addTarget:self action:@selector(keyboardHidden)];
//    [self.view addGestureRecognizer:tap1];
//    
    //状态栏
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    view.backgroundColor = [self colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:view];
    
    //自定义导航栏
    NaviagtionBarShareView * shareBar=[[NaviagtionBarShareView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    
    [shareBar.cancellBut addTarget:self action:@selector(cancell) forControlEvents:UIControlEventTouchUpInside];
    [shareBar.wxBut addTarget:self action:@selector(shareToWX) forControlEvents:UIControlEventTouchUpInside];
    [shareBar.friendBut addTarget:self action:@selector(shareToWB) forControlEvents:UIControlEventTouchUpInside];
    [shareBar.moreBut addTarget:self action:@selector(moreShare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBar];
    
    
    //发送评论的控件
    _sendCommentView=[[CommentView alloc] initWithFrame:CGRectMake(0, HEIGHT-54, SCREEN_W, 54)];
    _sendCommentView.contentField.delegate=self;
    _sendCommentView.contentField.text=@"评论一下";
    _sendCommentView.backgroundColor=[UIColor whiteColor];
    _sendCommentView.contentField.returnKeyType=UIReturnKeyDone;
    _sendCommentView.contentField.font=[UIFont systemFontOfSize:16];
  //  [_sendCommentView.faceBut addTarget:self action:@selector(addEmotionView) forControlEvents:UIControlEventTouchUpInside];
    [_sendCommentView.sendBut addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendCommentView];
    
    //表情面板
  //  [self.view addSubview:self.emotionView];
    
    
    
    
    //视频介绍的标志
    _leftLien=[[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 35*PROPORTION_WIDTH, 133*PROPORTION_WIDTH, 1)];
    _leftLien.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
    
    _rightLien=[[UIView alloc] initWithFrame:CGRectMake(WIDTH-148*PROPORTION_WIDTH, 35*PROPORTION_WIDTH, 133*PROPORTION_WIDTH, 1)];
    _rightLien.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
    
    _movieLable=[[UILabel alloc] initWithFrame:CGRectMake(159*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, WIDTH-318*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    _movieLable.text=@"视频介绍";
    _movieLable.textAlignment=1;
    _movieLable.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    _movieLable.textColor=[self colorWithHexString:@"#FD681F"];
    
    
    //视频介绍的内容
    _mutibleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16*PROPORTION_WIDTH, 0, WIDTH-32*PROPORTION_WIDTH, 40)];
    [_mutibleLabel setTextColor:[self colorWithHexString:@"#555555"]];
    [_mutibleLabel setNumberOfLines:0];
    _mutibleLabel.font=[UIFont systemFontOfSize:14];
    _mutibleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    NSString *labelText = @"韩国MBS/KBS/SBS三大电视台共同推荐!销量超一千万片,绝对是赴韩必买!韩国MBS/KBS/SBS三大电视台共同推荐!销量超一千万片,绝对是赴韩必买!	";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    _mutibleLabel.attributedText = attributedString;
    NSLog(@"高5555度是:%f",_mutibleLabel.frame.size.height);
    
    [_mutibleLabel sizeToFit];
    NSLog(@"高度是:%f",_mutibleLabel.frame.size.height);
    
    
    
    
    
    
    //摩选师
    _moxuanshiView=[[UIImageView alloc] initWithFrame:CGRectMake(16*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, 343*PROPORTION_WIDTH, 70*PROPORTION_WIDTH)];
    _moxuanshiView.layer.borderWidth=1;
    _moxuanshiView.layer.cornerRadius=6;
    _moxuanshiView.backgroundColor=[UIColor yellowColor];
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
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"申请加入摩选师"];
    NSRange blackRange = NSMakeRange(0, [[noteStr string] rangeOfString:@"摩"].location);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#555555"] range:blackRange];
    [noteLabel setAttributedText:noteStr] ;
    [_moxuanshiView addSubview:noteLabel];
    
    UIImageView * nextView=[[UIImageView alloc] initWithFrame:CGRectMake(343*PROPORTION_WIDTH-24*PROPORTION_WIDTH-27*PROPORTION_WIDTH, 21.5*PROPORTION_WIDTH, 27*PROPORTION_WIDTH, 27*PROPORTION_WIDTH)];
    //    nextView.backgroundColor=[UIColor redColor];
    nextView.image=[UIImage imageNamed:@"enter_icon"];
    [_moxuanshiView addSubview:nextView];
    
    
    
    
    
    
    
    
    //headOfCommentView
    _numOfComment=[[UILabel alloc] initWithFrame:CGRectMake(16*PROPORTION_WIDTH, 0, WIDTH, 30*PROPORTION_WIDTH)];
    _numOfComment.text=@"所有0条评论";
    _numOfComment.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    _numOfComment.textColor=[self colorWithHexString:@"#555555"];
    
    _moreCommentBut=[[UIButton alloc] initWithFrame:CGRectMake(0, 18*PROPORTION_WIDTH, WIDTH, 18*PROPORTION_WIDTH)];
    [_moreCommentBut setTitleColor:[self colorWithHexString:@"#999999"] forState:0];
    [_moreCommentBut setTitle:@"没有更多了" forState:0];
    [_moreCommentBut addTarget:self action:@selector(allComment) forControlEvents:UIControlEventTouchUpInside];
    _moreCommentBut.userInteractionEnabled=NO;
    _moreCommentBut.titleLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];

    
    //添加键盘通知
   // [self addNotification];
    
    
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

//单品详情

- (void)presentProductDetailsViewControllerWithProductID:(NSString*)productID{

    DeTaiilsViewController2 * viewController=[[DeTaiilsViewController2 alloc] init];
    viewController.productID=productID;
    viewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

//跳转申请摩选师
- (void)requestMoxuanshi{
    NSLog(@"摩选师");
    MasterViewController * masterViewController=[[MasterViewController alloc] init];
    [self.navigationController pushViewController:masterViewController animated:YES];
    
    
    
}
//全部评论
- (void)allComment{
    MoreProductCommentViewController * moreCommentViewController=[[MoreProductCommentViewController alloc] init];
    moreCommentViewController.content=@"zt";
    moreCommentViewController.ztID=_ztID;
    [self.navigationController pushViewController:moreCommentViewController animated:YES];
}
#pragma mark 关于网络请求的方法
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
            _numberOfComment=[numberOfComment intValue];
            NSString * str=@"所有";
            NSString * num=[NSString stringWithFormat:@"%d",_numberOfComment];
            NSString * str2=@"条评论";
            _numOfComment.text=[NSString stringWithFormat:@"%@%@%@",str,num,str2];
            if (_numberOfComment>4) {
                [_moreCommentBut setTitle:@"查看全部评论" forState:0];
                _moreCommentBut.userInteractionEnabled=YES;
            }
            
            [_tableView reloadData];
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
            NSArray * modelArr=[responseObject  objectForKey:@"model"];
            for (NSDictionary * commentDic in modelArr) {
                CommentModel * commentModel=[[CommentModel alloc] init];
                [commentModel setValuesForKeysWithDictionary:commentDic];
                NSLog(@"%@",commentModel.comment_content);
                
                [self.commentModelArr addObject:commentModel];
            }
            [_tableView reloadData];
            
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
            for (int i=0; i<modelArr.count; i++) {
                NSString * height=[NSString stringWithFormat:@"%d",1];
                [self.webViewHeightArr addObject:height];
                NSLog(@"%@",height);
            }
         
            [self.tableView reloadData];
            
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
            [_tableView reloadData];

        }else{
            NSLog(@"请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"列表数据失败 %@",error);
    }];
}


- (void)sendComment{
    //先判断有没有登录
    UserID *user = [UserID shareInState];
    NSArray *array = [user redFromUserListAllData];
    if (array.count == 0) {
        UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
        userInfo.VC = @"abcd";
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
                    [self numberOfztCommentNetWorking];
                    [self ztCommentNetWorking];
                    [_sendCommentView.contentField resignFirstResponder];
                    [_sendCommentView.sendBut setTitleColor:[self colorWithHexString:@"#FFFFFF"] forState:0];
                    _sendCommentView.sendBut.backgroundColor=[self colorWithHexString:@"#FD681F"];
                    _sendCommentView.contentField.text=@"评论一下";
                }else{
                    NSLog(@"上传失败");
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"错误  : %@", error);
            }];
            
        }
    }

}




#pragma mark 关于键盘弹出的方法

//- (void)addEmotionView{
//    
//    if (_emotion_is) {
//        NSLog(@"存在");
//        [UIView animateWithDuration:0.25 animations:^{
//            self.emotionView.frame=CGRectMake(0, SCREEN_H, SCREEN_W, 200);
//        }];
//        _emotion_is=NO;
//        [_sendCommentView.contentField becomeFirstResponder];
//        
//    }else{
//        [_sendCommentView.contentField resignFirstResponder];
//        [UIView animateWithDuration:0.25 animations:^{
//            self.emotionView.frame=CGRectMake(0, SCREEN_H-200, SCREEN_W, 200);
//            _emotion_is=YES;
//            
//        }];
//        [UIView animateWithDuration:0.25 animations:^{
//            _sendCommentView.frame=CGRectMake(0, SCREEN_H-54-200, WIDTH, 54);
//            
//        }];
//    }
//    
//}
- (void)keyboardHidden{
//    //当前屏幕手势方法让键盘收起
//    _emotion_is=NO;
//    
//    NSLog(@"收起键盘");
//
//    [_sendCommentView.contentField resignFirstResponder];
//    [UIView animateWithDuration:0.25 animations:^{
//        _sendCommentView.frame=CGRectMake(0, SCREEN_H-54, WIDTH, 54);
//        self.emotionView.frame=CGRectMake(0, SCREEN_H, SCREEN_W, 200);
//        
//        
//    }];
//    
    
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
    
 //   self.emotionView.frame=CGRectMake(0, SCREEN_H, SCREEN_W, 200);
    _emotion_is=NO;
    
    
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
    
    [UIView animateWithDuration:duration animations:^{
        _sendCommentView.frame=CGRectMake(0, SCREEN_H-54-keyboardHeight, WIDTH, 54);
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    NSLog(@"将要消失");
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
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    
//    
//    NSLog(@"开始输入");
//    return YES;
//    
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//
//    NSLog(@"sssss");
//    return YES;
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    NSLog(@"aaaaaa");
//
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%ld",range.location);
    NSLog(@"%ld",range.length);

    int length=(int)range.length;
//
    if (length>0) {
        NSString * contentText=_sendCommentView.contentField.text;
        NSLog(@"%@",contentText);
        if (contentText.length==1) {
            [_sendCommentView.sendBut setTitleColor:[self colorWithHexString:@"#666666"] forState:0];
            _sendCommentView.sendBut.backgroundColor=[self colorWithHexString:@"#FFFFFF"];
        }else{
            [_sendCommentView.sendBut setTitleColor:[self colorWithHexString:@"#FFFFFF"] forState:0];
            _sendCommentView.sendBut.backgroundColor=[self colorWithHexString:@"#FD681F"];
        }
        
        
    }else{
        NSString * contentText=_sendCommentView.contentField.text;
        NSLog(@"%@",contentText);
        [_sendCommentView.sendBut setTitleColor:[self colorWithHexString:@"#FFFFFF"] forState:0];
        _sendCommentView.sendBut.backgroundColor=[self colorWithHexString:@"#FD681F"];
    }
    
    
    return YES;

}   // return NO to not change text

//返回上一页
- (void)cancell{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 关于分享的方法
- (void)shareToWX{
    NSLog(@"分享给微信好友");
    [[UMSocialControllerService defaultControllerService] setShareText:@"分享给微信好友" shareImage:[UIImage imageNamed:@"保湿"] socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}
- (void)shareToWB{
    NSLog(@"分享到新浪微博");
    
    [[UMSocialControllerService defaultControllerService] setShareText:@"分享给微信好友" shareImage:[UIImage imageNamed:@"保湿"] socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}
- (void)moreShare{
    NSLog(@"更多分享");
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAppKey
                                      shareText:@"求新的美妆社区美妆社区美妆社区撒地方撒地方啊但是 的发多少 http://umeng.com/social"
                                     shareImage:[UIImage imageNamed:@"保湿"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToWechatSession,UMShareToQQ,UMShareToWechatTimeline,nil]
                                       delegate:self];
}




#pragma mark 表情代理

- (void)emotionScrollView:(EmotionScrollView *)emotionView selected:(UIButton *)emotionBtn{
    
//    NSLog(@"aaa");
//    
//    UITextView * textView=_sendCommentView.contentField;
//    
//    
//    
//    
////    NSString * title=emotionBtn.currentTitle;
////    NSLog(@"%@",title);
//    UIImage * image=emotionBtn.currentBackgroundImage;
//    
//    
//    
//    
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
//    
//    
//    NSTextAttachment *emojiTextAttachment = [NSTextAttachment new];
//    UIFont * font=[UIFont systemFontOfSize:16];
//    //设置表情图片
//    emojiTextAttachment.image = image;
//    
//    emojiTextAttachment.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
//    
//    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:emojiTextAttachment];
//    
//    // 记录表情的插入位置
//    NSUInteger insertIndex = textView.selectedRange.location;
//    
//    
//    // 插入表情图片到光标位置
//    [attributedText insertAttributedString:attachString atIndex:insertIndex];
//    
//    // 设置字体
//    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
//    
//    // 重新赋值(光标会自动回到文字的最后面)
//    textView.attributedText = attributedText;
//    
//    // 让光标回到表情后面的位置
//    textView.selectedRange = NSMakeRange(insertIndex + 1, 0);
//    
    
    
    
}
#pragma mark 懒加载



//- (EmotionScrollView *)emotionView{
//    if (_emotionView==nil) {
//        _emotionView=[[EmotionScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_H, WIDTH, 200)];
//        _emotionView.delegate=self;
//        
//    }
//    return _emotionView;
//}
- (NSMutableArray *)commentModelArr{
    if (!_commentModelArr) {
        _commentModelArr=[NSMutableArray arrayWithCapacity:1];
    }
    return _commentModelArr;
}
- (NSMutableArray *)moxuanArr{
    if (_moxuanArr==nil) {
        _moxuanArr=[NSMutableArray arrayWithCapacity:1];
        
    }
    return _moxuanArr;
}

- (NSMutableArray *)webViewHeightArr{
    if (_webViewHeightArr==nil) {
        _webViewHeightArr=[NSMutableArray arrayWithCapacity:1];
    }
    return _webViewHeightArr;
    
}

- (NSMutableArray *)ztProductListArr{
    if (!_ztProductListArr) {
        _ztProductListArr=[NSMutableArray arrayWithCapacity:1];
    }
    return _ztProductListArr;
    
}

#pragma mark tableView  datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 2;
    }else if (section==1){
        int count=(int)self.moxuanArr.count;
        return count+1;
    }else if (section==2){
        int count=(int)self.ztProductListArr.count;
        return count;
    }else if (section==3){
        int count=(int)self.commentModelArr.count;
        return count+1;
    }else if (section==4){
        return 1;
    }
    return 0;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
         return 266*PROPORTION_WIDTH+64;
    }
    return 0.01*PROPORTION_WIDTH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"qq"];
        if (cell==nil) {
            cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qq"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        if (indexPath.row==0) {
            //视频介绍的标志
            [cell addSubview:_leftLien];
            [cell addSubview:_rightLien];
            [cell addSubview:_movieLable];
        }else{
            //视频介绍的内容
            [cell addSubview:_mutibleLabel];
        }
        return cell;
    }else if (indexPath.section==1) {
        if (indexPath.row==0) {
            //摩选师
            DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"ww"];
            if (cell==nil) {
                cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ww"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            [cell addSubview:_moxuanshiView];
            return cell;
        }else{
            //设计师
            
            
//            WebTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"rq"];
//            if (cell==nil) {
//                cell=[[WebTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rq"];
//                cell.delegate=self;
//                
//            }
//            cell.backgroundColor=[UIColor redColor];
//            MoxuanshiModel * model=self.moxuanArr[indexPath.row-1];
//            
//            [cell setMoxuanshiModel:model withIndex:indexPath.row-1];
            
            MyIdeaTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"we"];
            if (cell==nil) {
                cell=[[MyIdeaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"we"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.delegate=self;
            }
            MoxuanshiModel * model=self.moxuanArr[indexPath.row-1];
            
            [cell setMoxuanModel:model withIndex:indexPath.row-1];

            
            return cell;
        }
    }else if (indexPath.section==2){
        
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
    }else if (indexPath.section==3){
        if (indexPath.row==0) {
            //评论总条数
            DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"r"];
            if (cell==nil) {
                cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"r"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            [cell addSubview:_numOfComment];
            return cell;
        }else{
            //评论
            
            CommentWithStarsTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"rr"];
            if (cell==nil) {
                cell=[[CommentWithStarsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rr"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            CommentModel * model=self.commentModelArr[indexPath.row-1];
            
            [cell setZTCommentModel:model];
            
            return cell;
        }
        
    }else if (indexPath.section==4){
        DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"qe"];
        if (cell==nil) {
            cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qe"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        [cell addSubview:_moreCommentBut];
        return cell;
    }
    
    return nil;
}

- (void)HeightWith:(CGFloat)height withIndex:(NSInteger)index{

    NSLog(@"%f------%ld",height,index);
    NSString * high=[NSString stringWithFormat:@"%f",height];
    NSLog(@"%@",high);
    
    NSString * jj=self.webViewHeightArr[index];
    NSLog(@"%@",jj);
    [self.webViewHeightArr removeObjectAtIndex:index];
    [self.webViewHeightArr insertObject:high atIndex:index];
    
    
    
    
    
//    [self.tableView reloadData];

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0 &&!self.isOne) {
        UIView *view = [[UIView alloc] init];
        
        [view addSubview:_playerView];
        self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake(10*PROPORTION_WIDTH, CGRectGetMaxY(_playerView.frame) - 35*PROPORTION_WIDTH, 25*PROPORTION_WIDTH, 25*PROPORTION_WIDTH)];
        self.playBtn.backgroundColor = [UIColor clearColor];
        [self.playBtn addTarget:self action:@selector(playvideoWithBtn) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.playBtn];
//        self.iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(320*PROPORTION_WIDTH, CGRectGetMaxY(_playerView.frame) - 45*PROPORTION_WIDTH, 50*PROPORTION_WIDTH, 40*PROPORTION_WIDTH)];
//        self.iconBtn.backgroundColor = [UIColor clearColor];
//        [self.iconBtn addTarget:self action:@selector(playvideoWithBtn) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:self.iconBtn];
        return view;
    }
    return nil;
}



#pragma mark tableView  delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"有%ld个高度",_webViewHeightArr.count);
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            //视频介绍的标志
            return 70*PROPORTION_WIDTH;
        }else{
            //视频介绍的内容
            return _mutibleLabel.frame.size.height+32*PROPORTION_WIDTH;
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            //摩选师
            return 100*PROPORTION_WIDTH;
        }else{
            //设计师
            
            NSString * cellH=self.webViewHeightArr[indexPath.row-1];
            float height=[cellH floatValue];
            NSLog(@"%f",height);
           // return height;
                return 315*PROPORTION_WIDTH+height+20;
            
        }
    }else if (indexPath.section==2){
        //立即购买
        return 170*PROPORTION_WIDTH;
        
    }else if (indexPath.section==3) {
        if (indexPath.row==0) {
            return 40*PROPORTION_WIDTH;
        }else{
            return 90*PROPORTION_WIDTH;
        }
        
    }else if (indexPath.section==4){
        return 54*PROPORTION_WIDTH;
    }
    return 0;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        ZTProductListModel * model=self.ztProductListArr[indexPath.row];
        [self presentProductDetailsViewControllerWithProductID:model.ID];
        
    }


}
#pragma mark--- 视频 ---
- (BOOL)prefersStatusBarHidden
{
    UIInterfaceOrientation ort = [UIApplication sharedApplication].statusBarOrientation;
    
    return !UIInterfaceOrientationIsPortrait(ort);
}

- (CGRect)playViewFrame
{
    return CGRectMake(0, 64*PROPORTION_WIDTH, WIDTH , 266*PROPORTION_WIDTH);
}

-(void)playvideoWithBtn{
    
    NSMutableArray* mutlArray = [NSMutableArray array];
    TCCloudPlayerVideoUrlInfo* info = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info.videoUrlTypeName = @"原始";
    info.videoUrl = [NSURL URLWithString:@"http://4500.vod.myqcloud.com/4500_80db160778860658b284fe171aca3751d5b88471.f20.mp4"];
    [mutlArray addObject:info];
    
    TCCloudPlayerVideoUrlInfo* info1 = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info1.videoUrlTypeName = @"标清";
    info1.videoUrl = [NSURL URLWithString:@"http://4500.vod.myqcloud.com/4500_80db160778860658b284fe171aca3751d5b88471.f20.mp4"];
    [mutlArray addObject:info1];
    
    [self loadVideoPlaybackView:mutlArray defaultPlayIndex:0 startTime:0];
    self.playBtn.hidden = YES;
    self.isOne = YES;
    _playerView.frame = CGRectMake(0, 64, WIDTH, 266*PROPORTION_WIDTH);
    [self.view addSubview:_playerView];
    
}

- (void)addPlayerView
{
    
    _playerView = [[TCCloudPlayerView alloc] initWithNotFullFrame:[self playViewFrame]];
//    [self.view addSubview:_playerView];
    [_playerView changeBottomFullImage:[UIImage imageNamed:@"头像.png"] notFullImage:[UIImage imageNamed:@"attention_selected_icon"]];
    
    __weak typeof(self) ws = self;
    //    _playerView.playbackReadyBlock = ^(void){
    //        [ws playbackReadyBlock];
    //    };
    _playerView.playbackBeginBlock = ^(void){
        [ws playbackBeginBlock];
    };
    
    _playerView.playbackFailedBlock = ^(NSError* error){
        [ws playbackFailedBlock:error];
    };
    _playerView.playbackEndBlock = ^(void){
        [ws playbackEndBlock];
    };
    _playerView.playbackPauseBlock = ^(UIImage* curImg, TCCloudPlayerPauseReason reason){
        [ws playbackPauseBlock:curImg pauseReason:reason];
    };
    _playerView.singleClickblock = ^ (BOOL isInFullScreen) {
        
        if (ws.navigationController.topViewController == ws)
        {
            [[UIApplication sharedApplication] setStatusBarHidden:isInFullScreen withAnimation:UIStatusBarAnimationSlide];
            [ws.navigationController setNavigationBarHidden:YES animated:YES];
        }
        
    };
    
    _playerView.clickPlaybackViewblock = ^ (BOOL isFullScreen) {
        if (isFullScreen)
        {
            
            NSLog(@"当前是全屏");
        }
        else
        {
            NSLog(@"当前不是全屏");
            
        }
    };
    __weak typeof (UIView *)playV = _playerView;
    _playerView.enterExitFullScreenBlock = ^ (BOOL enterFullScreen) {
        if (ws.navigationController.topViewController == ws)
        {
            [[UIApplication sharedApplication] setStatusBarHidden:enterFullScreen withAnimation:UIStatusBarAnimationSlide];
            [ws.navigationController setNavigationBarHidden:YES animated:YES];
            if (enterFullScreen)
            {
                if (self.isOne == NO) {
                    [ws playvideoWithBtn];
                    
                    NSMutableArray* mutlArray = [NSMutableArray array];
                    TCCloudPlayerVideoUrlInfo* info = [[TCCloudPlayerVideoUrlInfo alloc]init];
                    info.videoUrlTypeName = @"原始";
                    info.videoUrl = [NSURL URLWithString:@"http://4500.vod.myqcloud.com/4500_80db160778860658b284fe171aca3751d5b88471.f20.mp4"];
                    [mutlArray addObject:info];
                    
                    TCCloudPlayerVideoUrlInfo* info1 = [[TCCloudPlayerVideoUrlInfo alloc]init];
                    info1.videoUrlTypeName = @"标清";
                    info1.videoUrl = [NSURL URLWithString:@"http://4500.vod.myqcloud.com/4500_80db160778860658b284fe171aca3751d5b88471.f20.mp4"];
                    [mutlArray addObject:info1];
                    
                    [ws loadVideoPlaybackView:mutlArray defaultPlayIndex:0 startTime:0];
                    
                    ws.isOne = YES;
                    playV.frame = CGRectMake(0, 0, WIDTH, ws.view.frame.size.height);
                    [ws.view addSubview:playV];
                }
                
                NSLog(@"进入全屏");
            }
            else
            {
                NSLog(@"退出全屏");
            }
        }
    };
}

- (void)initPlayerView
{
    //    _playerView = [[TCCloudPlayerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    //playerView.backgroundColor = [UIColor redColor];
    //    //[self.view addSubview:playerView];
    //    self.view = _playerView;
    
    // 添加播放器上的控制操作
    //    [self addPlayerCtrlView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(onLeftBtnClick)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
}


- (void)addMaskView:(NSArray *)buttons size:(CGSize)btnSize
{
    if (buttons.count)
    {
        [_playerView addMaskView:buttons size:btnSize];
    }
}

-(void)onLeftBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark
#pragma mark 加载视频播放及回调
#pragma mark
-(void)loadVideoPlaybackView:(NSArray*)videoUrls defaultPlayIndex:(NSUInteger)defaultPlayIndex startTime:(Float64)startTimeInSeconds
{
    _playerView.isSilent = NO;
    _playerView.isCyclePlay = NO;
    
    
    
    BOOL loadVideoRet = [_playerView setUrls:videoUrls defaultPlayIndex:defaultPlayIndex startTime:startTimeInSeconds];
    //BOOL loadVideoRet = [_playerView setAVAsset:self.videoAsset startTime:[self.startTimeValue CMTimeValue]];
    if (!loadVideoRet) {
        //[[QQProgressHUD sharedInstance] showState:@"视频加载失败" success:NO];
        
    }
    
}

//注意，退后台进入前台也会进入这个函数
- (void)playbackReadyBlock
{
    [_playerView setLimitTime:_limitedSeconds];
    //    [_playerView play];
}

-(void) playbackBeginBlock
{
    if (!_playerView.isInFullScreen)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
        [_playerView performSelector:@selector(reversionFullScreenState) withObject:nil afterDelay:2];
    }
    
    [self postPlayNotificaction];
}

-(void) playbackFailedBlock:(NSError*)error
{
    if (_playerView.isInFullScreen) {
        [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
        [_playerView reversionFullScreenState];
    }
    
    NSString* strTile = [NSString stringWithFormat:@"视频播放失败(%zd)",[error code]];
    NSString* errorDes = nil;
    //#if DEBUG
    errorDes = [error localizedDescription];
    //#endif
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTile message:errorDes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    //显示AlertView
    [alert show];
    
    [self postStopNotificationWithError:error];
}

-(void) playbackPauseBlock:(UIImage*)curImg pauseReason:(TCCloudPlayerPauseReason)reason
{
    [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
    if (_playerView.isInFullScreen)
    {
        [_playerView reversionFullScreenState];
    }
    
    [self postPauseNotificationWithReason:reason];
}

-(void) playbackEndBlock
{
    
    
    if (_playerView.isInFullScreen)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
        [_playerView reversionFullScreenState];
    }
    [self postStopNotificationWithError:nil];
}

#pragma mark
#pragma mark 全屏
#pragma mark
-(void)clickPlayView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
    [_playerView reversionFullScreenState];
    
    if (!_playerView.isInFullScreen && [_playerView isPlaying])
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
        [self performSelector:@selector(reversionFullScreenState) withObject:nil afterDelay:5];
    }
}


#pragma mark - 抛通知 -

- (NSMutableDictionary *)commVideoParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@([_playerView getCurVideoPlaybackTimeInSeconds]) forKey:kTCCloudPlayTime];
    [param setObject:@(_playerView.duration) forKey:kTCCloudPlayDuration];
    TCCloudPlayerVideoUrlInfo *url = [_playerView currentUrl];
    if (url) {
        [param setObject:url forKey:kTCCloudPlayQaulity];
    }
    return param;
}

- (void)postPlayNotificaction
{
    NSMutableDictionary *param = [self commVideoParam];
    [param setObject:@(1) forKey:kTCCloudPlayState];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TCCloudPlayStateChangeNotification object:nil userInfo:param];
}

- (void)postPauseNotificationWithReason:(TCCloudPlayerPauseReason)reason
{
    NSMutableDictionary *param = [self commVideoParam];
    [param setObject:@(2) forKey:kTCCloudPlayState];
    [param setObject:@(reason) forKey:kTCCloudPlayPauseReason];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TCCloudPlayStateChangeNotification object:nil userInfo:param];
}

- (void)postStopNotificationWithError:(NSError *)error
{
    NSMutableDictionary *param = [self commVideoParam];
    [param setObject:@(0) forKey:kTCCloudPlayState];
    if (error) {
        [param setObject:error forKey:kTCCloudPlayError];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TCCloudPlayStateChangeNotification object:nil userInfo:param];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
