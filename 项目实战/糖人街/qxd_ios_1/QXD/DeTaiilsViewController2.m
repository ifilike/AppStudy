//
//  DeTaiilsViewController2.m
//  QXD
//
//  Created by WZP on 15/11/17.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "DeTaiilsViewController2.h"
#import "ProductTypeView.h"
#import "NavigationBarLikeView.h"
#import "WithLabelImageView.h"
#import "SelectView.h"
#import "DetailsAndCommentView.h"
#import "CommentWithStarsTableViewCell.h"
#import "CommentModel.h"
#import "InterestListView.h"
#import "InterestTableViewCell.h"
#import "MemberViewController.h"
#import "UserID.h"
#import "UserIDModle.h"
#import "WishListModel.h"
#import "UserInfoViewController.h"
#import "ProductCommentModel.h"
#import "WithLabelImageScrollView.h"
#import "MoreProductCommentViewController.h"
#import "DetailsProductModel.h"
#import "ProductInfoModel.h"
#import "InterestProductModel.h"
#import "DetailsTableViewCell2.h"
#import "EightLabelView.h"
#import "InterestSubView.h"
#import "FriendsModel.h"
#import "CalucateViewController.h"
#import "BuyView.h"
#import "ProductImgsTableViewCell.h"
#import "FriendsViewController.h"
#import "AppDelegate.h"
#import "CommentTableViewCell9.h"
#import "CommentNavigationView.h"


@interface DeTaiilsViewController2 ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,InterestViewProtocol>

@property(nonatomic,retain)UITableView * tableView;
@property(nonatomic,retain)NavigationBarLikeView * likeView;
@property(nonatomic,retain)CommentNavigationView * likeView2;
@property(nonatomic,retain)UIButton * wishBut;
@property(nonatomic,strong)NSMutableArray * interestModelArr;
@property(nonatomic,assign)int productNum;
@property(nonatomic,retain)NSString * standardStr;
@property(nonatomic,strong)NSMutableArray * wishListModelArr;
@property(nonatomic,retain)NSString * userID;
@property(nonatomic,copy)NSString * deleteWishID;
@property(nonatomic,retain)NSMutableArray * productCommentModelArr;
@property(nonatomic,assign)BOOL loaded;
@property(nonatomic,assign)BOOL is_VIP;
@property(nonatomic,retain)DetailsProductModel * model;
@property(nonatomic,retain)ProductInfoModel * infoModel;
@property(nonatomic,strong)NSMutableArray * imageStrArr;
@property(nonatomic,strong)NSArray * effectArr;
@property(nonatomic,retain)SelectView * selectView;
@property(nonatomic,retain)DetailsAndCommentView * detaiView;
@property(nonatomic,retain)EightLabelView * labelView;
@property(nonatomic,assign)float detailsCellHeight;
@property(nonatomic,retain)UIImageView * imageView2;
@property(nonatomic,retain)UIImageView * imageView3;
@property(nonatomic,retain)NSArray * imageArr;
@property(nonatomic,assign)NSInteger numOfThirdSection;
@property(nonatomic,retain)UIView * leftLien;
@property(nonatomic,retain)UIView * rightLien;
@property(nonatomic,retain)UILabel * likeLabel;
@property(nonatomic,retain)WithLabelImageScrollView * imageScrollView;
@property(nonatomic,retain)NSString * allOfCommentCount;
@property(nonatomic,retain)BuyView * buyView;
@property(nonatomic,retain)UILabel * countLabel;
@property(nonatomic,assign) NSInteger totalNum;//购物车的总数
//@property(nonatomic,retain)UIImageView * gifView;//320*240的动态图

@end



#define HEIGHT [[UIScreen mainScreen] bounds].size.height


@implementation DeTaiilsViewController2


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden = YES;
    //获取用户信息
    
    [self showShopCarNum];
    
    [self getUserInfo];
    
    if (self.userID!=nil) {
        [self requestWishList];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    self.productNum=1;
    self.standardStr=@"50ml";
    //设置控制器的属性,滚动视图的子视图位置不会受到navigationbar的影响;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    //页面布局
    [self mainLayout];
    //请求心愿单
    [self requestWishList];
    //请求商品评论
    [self requestCommentWithProductID:self.productID];
    [self requestNumberOfCommentWithProductID:self.productID];
    //请求商品详细信息
    [self requestDetailedInformationWithProductID:self.productID];
    
    
}
- (void)showShopCarNum{
    //先判断有没有登录
    UserID *user = [UserID shareInState];
    UserIDModle *model = [[user redFromUserListAllData] lastObject];
    
    NSArray *array = [user redFromUserListAllData];
    if (array.count != 0) {
        NSDictionary *dict = @{@"customer_id":model.ID};
        AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
        [manger GET:ShopCarList parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功%@",responseObject);
                self.totalNum = 0;
                NSArray *arraya = [responseObject objectForKey:@"model"];
                for (NSDictionary *dict in arraya) {
                    NSString *string = [dict objectForKey:@"product_num"];
                    self.totalNum += [string integerValue];
                }
                NSLog(@"%ld",self.totalNum);
                //显示购物车的数量
                _countLabel=[[UILabel alloc] initWithFrame:CGRectMake(30*PROPORTION_WIDTH, 12*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, 16*PROPORTION_WIDTH)];
                _countLabel.textAlignment=1;
                _countLabel.backgroundColor=[self colorWithHexString:@"#FD681F"];
                _countLabel.layer.cornerRadius=_countLabel.frame.size.width/2;
                _countLabel.layer.masksToBounds=YES;
                _countLabel.textColor=[UIColor whiteColor];
                [_buyView addSubview:_countLabel];
                _countLabel.text=[NSString stringWithFormat:@"%ld",self.totalNum];
                _countLabel.font=[UIFont systemFontOfSize:11*PROPORTION_WIDTH];
                if (self.totalNum!=0) {
                    _countLabel.hidden=NO;
                }else{
                    _countLabel.hidden=YES;
                }
                
            }else{
                NSLog(@"数据格式不对");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
        
    }
    
    
}
- (void)getUserInfo{
    //先判断有没有登录
    UserID *user = [UserID shareInState];
    NSArray *array = [user redFromUserListAllData];
    if (array.count == 0) {
        self.loaded=NO;
    }else{
        self.loaded=YES;
    
        UserIDModle *model =[[user redFromUserListAllData] lastObject];
        self.userID=model.ID;
        //        NSLog(@"头像网址 :%@",model.userIcon);
        if ([model.is_vip isEqualToString:@"1"]) {
            NSLog(@"此账号是会员");
            self.is_VIP=YES;
        }else{
            NSLog(@"此账号不是会员");
            self.is_VIP=NO;
        }
        
        
        
    }
    
}
//弹出登陆提示框
- (void)goToLoading{
    
    
    UserInfoViewController *userinfo = [[UserInfoViewController alloc] init];
    userinfo.VC = @"MineViewController";
    [self.navigationController pushViewController:userinfo animated:YES];
    userinfo.blockWithUser = ^(){
        [self viewWillAppear:YES];
    };
    //    UIAlertController * control=[UIAlertController alertControllerWithTitle:@"提示" message:@"还没登陆" preferredStyle:UIAlertControllerStyleAlert];
    //    [control addAction:[UIAlertAction actionWithTitle:@"去登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        UserInfoViewController *userinfo = [[UserInfoViewController alloc] init];
    //        userinfo.VC = @"MineViewController";
    //        [self.navigationController pushViewController:userinfo animated:YES];
    //        userinfo.blockWithUser = ^(){
    //            [self viewWillAppear:YES];
    //        };
    //    }]];
    //    [control addAction:[UIAlertAction actionWithTitle:@"不登陆" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //        NSLog(@"不登陆");
    //    }]];
    //    [self presentViewController:control animated:YES completion:nil];
    
}

#pragma mark 布局
- (void)mainLayout{
    //   代替导航栏的View
    
    _likeView2=[[CommentNavigationView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64) withName:@" "];
    _likeView2.backgroundColor=[self colorWithHexString:@"#F7F7F7"];
    [_likeView2.cancellBut addTarget:self action:@selector(cancell) forControlEvents:UIControlEventTouchUpInside];
    _wishBut=[[UIButton alloc] initWithFrame:CGRectMake(WIDTH*4/5, 20, WIDTH/5, 44)];
    //    _wishBut.backgroundColor=[UIColor redColor];
    [_wishBut addTarget:self action:@selector(addToList) forControlEvents:UIControlEventTouchUpInside];
   // [_wishBut setImage:[UIImage imageNamed:@"attention_icon"] forState:0];
    [_likeView2 addSubview:_wishBut];
    
    //    _likeView=[[NavigationBarLikeView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    ////    _likeLabel.backgroundColor=[self colorWithHexString:@"#333333"];
    //    [_likeView.cancellBut addTarget:self action:@selector(cancell) forControlEvents:UIControlEventTouchUpInside];
    //    [_likeView.likeBut addTarget:self action:@selector(addToList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_likeView2];
    
    _imageScrollView=[[WithLabelImageScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 363*PROPORTION_WIDTH) labelArr:nil imageStringArr:nil];
    _imageScrollView.backgroundColor=[UIColor whiteColor];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-54*PROPORTION_WIDTH)];
    _tableView.tag=123;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableHeaderView=_imageScrollView;
    _tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.alpha=0;;
    
    [self.view addSubview:_tableView];
    
    //选择商品的控制台
    _selectView=[[SelectView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 176*PROPORTION_WIDTH+20)];
    //    [_selectView.addBut addTarget:self action:@selector(addProducts) forControlEvents:UIControlEventTouchUpInside];
    //   NSString * sele=@"规格：";
    //   NSString * stand=@"100ml";
    //   _selectView.selectLable.text=[NSString stringWithFormat:@"%@%@",sele,stand];
    
    _selectView.backgroundColor=[UIColor whiteColor];
    
    
    //功效标签
    //  NSArray * arrr=@[@"",@"",@"",@"",@"",@"",@"",@""];
    _labelView=[[EightLabelView alloc] initWithFrame:CGRectMake(0, 176*PROPORTION_WIDTH+20, WIDTH, 90*PROPORTION_WIDTH) withEffectStrArr:nil];
    
    
    
    //图片展示以及评论View
    _detaiView=[[DetailsAndCommentView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    [_detaiView.detailsControl addTarget:self action:@selector(valueChangeedWith:) forControlEvents:UIControlEventValueChanged];
    _detaiView.backgroundColor=[UIColor whiteColor];
    
    //记录商品介绍时的cell的高度
    
    _detailsCellHeight=_detaiView.frame.size.height;
    //赋值给tableview代理方法的返回值
    
    NSLog(@"+++++%f",_detaiView.frame.size.height);
    
    
    //第一张图片
    _imageView2=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH-32*PROPORTION_WIDTH)];
    // _imageView2.layer.borderWidth=1;
    // _imageView2.layer.borderColor=[self colorWithHexString:@"#DDDDDD"].CGColor;
    _imageView2.image=[UIImage imageNamed:@"图片"];
    
    //第二张图片
    _imageView3=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH-32*PROPORTION_WIDTH)];
    // _imageView3.layer.borderWidth=1;
    // _imageView3.layer.borderColor=[self colorWithHexString:@"#DDDDDD"].CGColor;
    _imageView3.image=[UIImage imageNamed:@"图片"];
    
    _imageArr=[NSArray arrayWithObjects:_imageView2,_imageView3, nil];
    
    _numOfThirdSection=[_imageArr count];
    
    
    //猜你喜欢的标志
    _leftLien=[[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 55*PROPORTION_WIDTH, 133*PROPORTION_WIDTH, 1)];
    _leftLien.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
    
    _rightLien=[[UIView alloc] initWithFrame:CGRectMake(WIDTH-148*PROPORTION_WIDTH, 55*PROPORTION_WIDTH, 133*PROPORTION_WIDTH, 1)];
    _rightLien.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
    
    _likeLabel=[[UILabel alloc] initWithFrame:CGRectMake(159*PROPORTION_WIDTH, 40*PROPORTION_WIDTH, WIDTH-318*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
    _likeLabel.text=@"猜你喜欢";
    _likeLabel.textAlignment=1;
    _likeLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    _likeLabel.textColor=[self colorWithHexString:@"#FD681F"];
    
    //单品评论的条数
    _allOfCommentCount=[NSString stringWithFormat:@"%@",@"0"];
//    
//    UIImage * image1=[UIImage imageNamed:@"加载1"];
//    UIImage * image2=[UIImage imageNamed:@"加载2"];
//    UIImage * image3=[UIImage imageNamed:@"加载3"];
//    UIImage * image4=[UIImage imageNamed:@"加载4"];
//    UIImage * image5=[UIImage imageNamed:@"加载5"];
//    UIImage * image6=[UIImage imageNamed:@"加载6"];
//    UIImage * image7=[UIImage imageNamed:@"加载7"];
//    UIImage * image8=[UIImage imageNamed:@"加载8"];
//    UIImage * image9=[UIImage imageNamed:@"加载9"];
//    UIImage * image10=[UIImage imageNamed:@"加载10"];
//    UIImage * image11=[UIImage imageNamed:@"加载11"];
//    UIImage * image12=[UIImage imageNamed:@"加载12"];
//
//    //数组
//    NSArray * gifArr=[NSArray arrayWithObjects:image1,image2,image3,image4,image5,image6,image7,image8,image9,image10,image11,image12, nil];
//    //动态图
//    UIImage * gifImage=[UIImage animatedImageWithImages:gifArr duration:1];
//    self.gifView=[[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-128)/2, (HEIGHT-128)/2, 128, 128)];
//    _gifView.image=gifImage;
//    [self.view addSubview:_gifView];
    
//    self.loadView=[[LoadingImageView alloc] initWithFrame:CGRectMake((WIDTH-320)/2, (HEIGHT-240)/2, 320, 240)];
//    [self.view addSubview:_loadView];
//    
}
#pragma mark 网络请求
- (void)requestWishList{
    if (self.loaded) {
        [self.wishListModelArr removeAllObjects];
        //本页面的商品ID
        NSString * productID=self.productID;
        AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
        NSDictionary * wishDic=[NSDictionary dictionaryWithObject:self.userID forKey:@"customer_id"];
        [manager GET:@"http://www.qiuxinde.com/mobile/customer/showlist" parameters:wishDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString * succeed=[responseObject objectForKey:@"code"];
            if ([succeed isEqualToString:@"0"]) {
                NSArray * modelArr=[responseObject objectForKey:@"model"];
                for (NSDictionary * wishDic in modelArr) {
                    NSLog(@"+++%@",[wishDic objectForKey:@"id"]);
                    WishListModel * model=[[WishListModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:wishDic];
                    NSLog(@"model+++%@",model.ID);
                    
                    [self.wishListModelArr addObject:model];
                }
                for (WishListModel * model in self.wishListModelArr) {
                    //心愿单里的商品ID
                    NSString * product_ID=model.product_id;
                    //判断本商品是否在心愿单里
                    if ([productID isEqualToString:product_ID]) {
                        [_wishBut setImage:[UIImage imageNamed:@"attention_selected_icon"] forState:0];
                        _wishBut.tag=1;
                        _deleteWishID=model.ID;
                        break;
                    }
                }
                
            }else{
                NSLog(@"请求失败");
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"心愿单请求失败%@",error);
        }];
    }
    
}
- (void)requestCommentWithProductID:(NSString*)productID{
    //请求评论
    NSString * getUrl=@"http://www.qiuxinde.com/mobile/product/productCommentList";
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSDictionary * productDic2=[NSDictionary dictionaryWithObjectsAndKeys:productID,@"product_id",@"1",@"pageNum",@"4",@"pageSize", nil];
    
    
    [manager GET:getUrl parameters:productDic2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSArray * modelArr=[responseObject objectForKey:@"model"];
            self.productCommentModelArr=[NSMutableArray arrayWithCapacity:1];
            for (NSDictionary * commnetDic in modelArr) {
                ProductCommentModel * model=[[ProductCommentModel alloc] init];
                [model setValuesForKeysWithDictionary:commnetDic];
                [_productCommentModelArr addObject:model];
            }
        }else{
            
            NSLog(@"请求失败");
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"商品评论请求失败 :%@",error);
    }];
    
}
- (void)requestNumberOfCommentWithProductID:(NSString*)productID{
    //请求评论mobile/product/productCommentCount
    NSString * getUrl=@"http://www.qiuxinde.com/mobile/product/productCommentCount";
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    //  manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSDictionary * productDic2=[NSDictionary dictionaryWithObjectsAndKeys:productID,@"product_id", nil];
    [manager GET:getUrl parameters:productDic2 progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSString *str = [responseObject objectForKey:@"model"];
            //赋值评论条数
            _allOfCommentCount=str;
            NSLog(@"%@",str);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"商品评论数请求失败 :%@",error);
    }];
    
}

- (void)requestDetailedInformationWithProductID:(NSString*)productID{
    
    //请求商品详细信息
    NSString * getUrl=@"http://www.qiuxinde.com/mobile/product/selectProduct";
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSDictionary * productDic=[NSDictionary dictionaryWithObject:productID forKey:@"id"];
    [manager GET:getUrl parameters:productDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSDictionary * dic=[responseObject objectForKey:@"model"];
            self.model=[[DetailsProductModel alloc] init];
            [_model setValuesForKeysWithDictionary:dic];
            //产品信息
            _infoModel=[[ProductInfoModel alloc] init];
            [_infoModel setValuesForKeysWithDictionary:_model.product];
            _likeView2.controllerName.text=self.infoModel.product_name;
            
            self.effectArr=_infoModel.product_effect_name;
            
            NSLog(@"%@",_infoModel.product_img1);
            NSLog(@"%@",_infoModel.product_img2);
            NSLog(@"%@",_infoModel.product_img3);
            NSLog(@"%@",_infoModel.product_img4);
            NSLog(@"%@",_infoModel.product_img5);
            NSLog(@"%@",_infoModel.product_img6);
            NSLog(@"%@",_infoModel.product_img7);
            NSLog(@"%@",_infoModel.product_img8);
            
            
            if ([_infoModel.product_img1 hasSuffix:@"jpg"]) {
                [self.imageStrArr addObject:_infoModel.product_img1];
            }
            if ([_infoModel.product_img2 hasSuffix:@"jpg"]) {
                [self.imageStrArr addObject:_infoModel.product_img2];
            }
            if ([_infoModel.product_img3 hasSuffix:@"jpg"]) {
                [self.imageStrArr addObject:_infoModel.product_img3];
            }
            if ([_infoModel.product_img4 hasSuffix:@"jpg"]) {
                [self.imageStrArr addObject:_infoModel.product_img4];
            }
            if ([_infoModel.product_img5 hasSuffix:@"jpg"]) {
                [self.imageStrArr addObject:_infoModel.product_img5];
            }
            if ([_infoModel.product_img6 hasSuffix:@"jpg"]) {
                [self.imageStrArr addObject:_infoModel.product_img6];
            }
            if ([_infoModel.product_img7 hasSuffix:@"jpg"]) {
                [self.imageStrArr addObject:_infoModel.product_img7];
            }
            if ([_infoModel.product_img8 hasSuffix:@"jpg"]) {
                [self.imageStrArr addObject:_infoModel.product_img8];
            }
            
            
            
            
            for (NSDictionary * interestDic in _model.like) {
                //猜你喜欢商品信息
                InterestProductModel * interestModel=[[InterestProductModel alloc] init];
                [interestModel setValuesForKeysWithDictionary:interestDic];
                [self.interestModelArr addObject:interestModel];
            }
            NSLog(@"猜你喜欢有%lu个",(unsigned long)[self.interestModelArr count]);
            
            self.buyView=[[BuyView alloc] initWithFrame:CGRectMake(0, HEIGHT-54*PROPORTION_WIDTH, WIDTH, 54*PROPORTION_WIDTH)];
            [_buyView.addButton addTarget:self action:@selector(addToShoppingCart) forControlEvents:UIControlEventTouchUpInside];
            [_buyView.buyButton addTarget:self action:@selector(nowToBuy) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_buyView];
            [self showShopCarNum];
            
            [self reloadData];
            
            self.tableView.alpha=1;
            
        }else{
            NSLog(@"请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"商品评论请求失败 :%@",error);
    }];
    
    
}
- (void)reloadData{
    NSLog(@"刷新页面");
    //改变图片
    [_imageScrollView reloadDataWithLabelArr:nil imageStringArr:self.imageStrArr];
    
    //选择商品的控制台
    self.standardStr=_infoModel.product_standard;
    [_selectView reloadDataWithName:_infoModel.product_name price:_infoModel.product_present_price oldPrice:_infoModel.product_original_price stand:_infoModel.product_standard];
    
    //改变功效标签
    [_labelView reloadDataWithLabelArr:_effectArr];
    
    
    //    //改变商品说明
    [_detaiView reloadDataWithDetailsText:_infoModel.product_details];
    _detailsCellHeight=_detaiView.frame.size.height;
    
    //改变图片
    NSURL * url2=[NSURL URLWithString:_infoModel.product_img1];
    [_imageView2 sd_setImageWithURL:url2];
    NSURL * url3=[NSURL URLWithString:_infoModel.product_img2];
    [_imageView3 sd_setImageWithURL:url3];
    
    
    
    //    //猜你喜欢
    [self.tableView reloadData];
    
}

#pragma mark 点击事件


- (void)valueChangeedWith:(UISegmentedControl*)control{
    
    if (control.selectedSegmentIndex==0) {
        NSLog(@"商品详情");
        _numOfThirdSection=2;
        [self changeDetails];
        _detailsCellHeight=_detaiView.frame.size.height;
        [_tableView reloadData];
        
    }else if (control.selectedSegmentIndex==1){
        NSLog(@"用户评论");
        _numOfThirdSection=0;
        [self change2];
        _detailsCellHeight=_detaiView.frame.size.height;
        [_tableView reloadData];
    }
}
- (void)changeDetails{
    [_detaiView details];
    NSLog(@"添加详情图片");
}
- (void)moreProductComments{
    NSLog(@"hhhhh");
    MoreProductCommentViewController * moreCommentViewController=[[MoreProductCommentViewController alloc] init];
    moreCommentViewController.content=@"dp";
    moreCommentViewController.productID=self.productID;
    [self.navigationController pushViewController:moreCommentViewController animated:YES];
    
    
}
- (void)change2{
    //添加评论列表
    int num=[_allOfCommentCount intValue];
    
    [_detaiView commentWithNumberOfCommnet:num];
    if (num>4) {
        [_detaiView.moreCommentBut setTitle:@"查看全部评论 >" forState:0];
        [_detaiView.moreCommentBut addTarget:self action:@selector(moreProductComments) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_detaiView.moreCommentBut setTitle:@"没有更多了" forState:0];
    }
    
    _detaiView.commentTableView.delegate=self;
    _detaiView.commentTableView.dataSource=self;
    [_detaiView.commentTableView reloadData];
    
}
//返回上一页
- (void)cancell{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)presentProductDetailsViewControllerviewWithButton:(UIButton*)button{
    
    InterestSubView * view=(InterestSubView*)button;
    DeTaiilsViewController2 * viewController=[[DeTaiilsViewController2 alloc] init];
    viewController.hidesBottomBarWhenPushed=YES;
    viewController.productID=view.productID;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)addToList{
    //加入心愿单
    if (self.loaded) {
        if (_wishBut.tag==0) {
            NSString * url=@"http://www.qiuxinde.com/mobile/customer/addwish";
            AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
            //  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFormData:[self.userID dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_id"];
                [formData appendPartWithFormData:[self.productID dataUsingEncoding:NSUTF8StringEncoding] name:@"product_id"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"加入心愿单成功 %@",responseObject);
                NSString * succeed=[responseObject objectForKey:@"code"];
                if ([succeed isEqualToString:@"0"]) {
                    //返回值就是删除时要用的ID,赋值给self.deleteWishID
                    self.deleteWishID=[responseObject objectForKey:@"model"];
                    NSLog(@"%@",self.deleteWishID);
                    [_wishBut setImage:[UIImage imageNamed:@"attention_selected_icon"] forState:0];
                    _wishBut.tag=1;
                }else{
                    NSLog(@"加入失败");
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"加入心愿单失败 %@",error);
            }];
            
        }else if (_wishBut.tag==1){
            NSString * url=@"http://www.qiuxinde.com/mobile/customer/deletewish";
            
            AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
            //  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFormData:[self.deleteWishID dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                NSString * succeed=[responseObject objectForKey:@"code"];
                if ([succeed isEqualToString:@"0"]) {
                    _wishBut.tag=0;
                    [_wishBut setImage:[UIImage imageNamed:@"attention_icon"] forState:0];
                    NSLog(@"删除成功");
                }else{
                    NSLog(@"删除失败");
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"删除心愿单失败 %@",error);
            }];
        }
    }else{
        NSLog(@"还没有登陆");
        [self goToLoading];
        
        
    }
    
}
//加入购物车
- (void)addToShoppingCart{
    
    
    
    if (self.loaded) {
        UserID *user = [UserID shareInState];
        UserIDModle *model =[[user redFromUserListAllData] lastObject];
        
        NSString * url=@"http://www.qiuxinde.com/mobile/shopping/addcart";
        AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
        
        //  manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString * name=self.infoModel.product_name;
            NSLog(@"%@",name);
            NSString * useID=model.ID;
            
            NSString * price=self.infoModel.product_present_price;
            NSString * productID=self.productID;
            NSString * num=@"1";
            NSString * image=self.infoModel.product_img1;
            NSString * standard=self.infoModel.product_standard;
            NSLog(@"%@",standard);
            
            //用户ID
            [formData appendPartWithFormData:[useID dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_id"];
            //产品名称
            [formData appendPartWithFormData:[name dataUsingEncoding:NSUTF8StringEncoding] name:@"product_name"];
            //产品ID
            [formData appendPartWithFormData:[productID dataUsingEncoding:NSUTF8StringEncoding] name:@"product_id"];
            //产品图片
            [formData appendPartWithFormData:[image dataUsingEncoding:NSUTF8StringEncoding] name:@"product_img"];
            //产品价格
            [formData appendPartWithFormData:[price dataUsingEncoding:NSUTF8StringEncoding] name:@"product_price"];
            //产品数量
            [formData appendPartWithFormData:[num dataUsingEncoding:NSUTF8StringEncoding] name:@"product_num"];
            //产品规格
            [formData appendPartWithFormData:[standard dataUsingEncoding:NSUTF8StringEncoding] name:@"product_standard"];
            
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSString * succeed=[responseObject objectForKey:@"code"];
            if ([succeed isEqualToString:@"0"]) {
                [self tishidonghuaWith:@"加入成功"];
                
                self.totalNum+=1;
                _countLabel.hidden=NO;
                _countLabel.text=[NSString stringWithFormat:@"%ld",self.totalNum];
                
            }else{
                NSLog(@"加入失败");
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"加入购物车失败 %@",error);
        }];
        
    }else{
        NSLog(@"没有登录");
        [self goToLoading];
    }
    
}

- (void)tishidonghuaWith:(NSString*)text{
    
    UILabel * promptLabel=[[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-40, HEIGHT/2, 80, 30)];
    promptLabel.text=text;
    promptLabel.tag=88;
    promptLabel.textAlignment=1;
    promptLabel.textColor=[UIColor whiteColor];
    promptLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    promptLabel.layer.cornerRadius=10;
    promptLabel.layer.masksToBounds=YES;
    promptLabel.backgroundColor=[UIColor blackColor];
    [self.view addSubview:promptLabel];
    
    [UIView beginAnimations:nil context:(__bridge void * _Nullable)(promptLabel)];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    promptLabel.frame=CGRectMake(WIDTH/2-40, HEIGHT/3, 80, 30);
    promptLabel.alpha=0;
    [UIView commitAnimations];
    [self performSelector:@selector(removePromptLabel) withObject:nil afterDelay:2];
    
    
    
}
- (void)removePromptLabel{
    UILabel * label=[self.view viewWithTag:88];
    [label removeFromSuperview];
    
    
}

//立即购买
- (void)nowToBuy{
    NSLog(@"立即购买");
    //先判断有没有登录
    UserID *user = [UserID shareInState];
    NSArray *array = [user redFromUserListAllData];
    if (array.count == 0) {
        UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
        userInfo.VC = @"abcd";
        [self.navigationController pushViewController:userInfo animated:NO];
    }else{
        UserIDModle *model =[[user redFromUserListAllData] lastObject];
        //用户昵称
        FriendsModel * fmodel=[[FriendsModel alloc] init];
        fmodel.customer_id=model.ID;
        fmodel.product_id=self.infoModel.ID;
        fmodel.product_img=self.infoModel.product_img1;
        fmodel.product_name=self.infoModel.product_name;
        fmodel.product_num=@"1";
        fmodel.product_price=self.infoModel.product_present_price;
        fmodel.product_standard=self.infoModel.product_standard;
        CalucateViewController *caluctae = [[CalucateViewController alloc] init];
        caluctae.array1 = @[fmodel];
        caluctae.isBuy=YES;
        caluctae.totalMoney =[self.infoModel.product_present_price floatValue];
        [self.navigationController pushViewController:caluctae animated:YES];
    }
    
    
    
    
    
}
- (void)toDoSomethingWith:(NSString *)productID{
    DeTaiilsViewController2 * viewController=[[DeTaiilsViewController2 alloc] init];
    //    viewController.hidesBottomBarWhenPushed=YES;
    viewController.productID=productID;
    [self.navigationController pushViewController:viewController animated:YES];
    
    
    
}



#pragma mark TableView  dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==123) {
        //单品页主列表
        if (section==0) {
            //第一个分区
            return 1;
        }else if (section==1){
            //第二个分区
            
            return 1;
        }else if (section==2){
            //第三个分区
            
            int count=(int)self.model.imgs.count;
            return count;
        }else if (section==3){
            //第四个分区
            
            return 1;
        }else if (section==4){
            //第五个分区
            int count=(int)self.interestModelArr.count;
            if (count%2==0) {
                return count/2;
            }else{
                return (count+1)/2;
                
            }
        }
    }else if (tableView.tag==10){
        //商品评论列表
        int num=(int)[self.productCommentModelArr count];
        return num;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==123) {
        //主列表
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                //第一个分区
                DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"qq"];
                if (cell==nil) {
                    cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qq"];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
                
                [cell addSubview:_selectView];
                [cell addSubview:_labelView];
                return cell;
            }
        }else if (indexPath.section==1){
            //第二个分区
            DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"ww"];
            if (cell==nil) {
                cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ww"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            [cell addSubview:_detaiView];
            return cell;
        }else if (indexPath.section==2){
            //第三个分区
            ProductImgsTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ee"];
            if (cell==nil) {
                cell=[[ProductImgsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ee"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            NSDictionary * imgDic=self.model.imgs[indexPath.row];
            
            [cell setImageWithUrlStr:[imgDic objectForKey:@"img"]];
            
            //            DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"ee"];
            //            if (cell==nil) {
            //                cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ee"];
            //                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            //                UIImageView * image2=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 375)];
            //
            //                [cell addSubview:image2];
            //
            //            }
            //            NSString * imageUrl=self.model.imgs[indexPath.row];
            //
            ////            UIImageView * imageView=_imageArr[indexPath.row];
            return cell;
        }else if (indexPath.section==3){
            //第四个分区
            DetailsTableViewCell2 * cell=[tableView dequeueReusableCellWithIdentifier:@"rr"];
            if (cell==nil) {
                cell=[[DetailsTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rr"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            
            [cell addSubview:_likeLabel];
            [cell addSubview:_leftLien];
            [cell addSubview:_rightLien];
            
            return cell;
        }else if (indexPath.section==4){
            InterestTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"yy"];
            if (cell==nil) {
                cell=[[NSBundle mainBundle] loadNibNamed:@"InterestTableViewCell" owner:self options:nil][0];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            int kk=(int)indexPath.row;
            int h=2*kk;
            int ll=h+1;
            int count=(int)self.interestModelArr.count;
            
            InterestProductModel * model1=self.interestModelArr[h];
            InterestProductModel * model2;
            if (ll<count) {
                model2=self.interestModelArr[ll];
            }else{
                model2=nil;
            }
            [cell setModel1:model1 model2:model2];
            for (InterestSubView * subView in cell.subButttonArr) {
                [subView addTarget:self action:@selector(presentProductDetailsViewControllerviewWithButton:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            return cell;
        }
    }else if (tableView.tag==10){
        //评论列表
        
        CommentTableViewCell9 * cell=[tableView dequeueReusableCellWithIdentifier:@"tt"];
        if (cell==nil) {
            cell=[[CommentTableViewCell9 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tt"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        ProductCommentModel * model=self.productCommentModelArr[indexPath.row];
        [cell setProductCommentModel:model];
        return cell;
        
        
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag==123) {
        return 5;
    }else if (tableView.tag==10){
        return 1;
    }
    
    
    return 0;
}

#pragma mark commentTableView  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==123) {
        if (indexPath.section==0) {
            //第一个分区
            return 176*PROPORTION_WIDTH+20+_labelView.frame.size.height;
        }else if (indexPath.section==1){
            //第二个分区
            return _detailsCellHeight;
        }else if (indexPath.section==2){
            //第三个分区
            //            if (indexPath.row==0) {
            //                return WIDTH-32*PROPORTION_WIDTH;
            //            }else{
            //                return WIDTH-32*PROPORTION_WIDTH+15*PROPORTION_WIDTH;
            //            }
            return 375;
        }else if (indexPath.section==3){
            //第四个分区
            return 90*PROPORTION_WIDTH;
        }else if (indexPath.section==4){
            //第五个分区
            return 266*PROPORTION_WIDTH;
            
        }
    }else if (tableView.tag==10){
        
        return 94*PROPORTION_WIDTH;
    }
    
    return 0;
}
#pragma mark 懒加载
- (NSMutableArray *)imageStrArr{
    if (_imageStrArr==nil) {
        _imageStrArr=[NSMutableArray arrayWithCapacity:1];
        
    }
    return _imageStrArr;
}
- (NSArray *)effectArr{
    if (_effectArr==nil) {
        _effectArr=[NSMutableArray arrayWithCapacity:1];
    }
    return _effectArr;
}


- (NSMutableArray *)interestModelArr{
    if (_interestModelArr==nil) {
        _interestModelArr=[NSMutableArray arrayWithCapacity:1];
        
    }
    return _interestModelArr;
}
- (NSMutableArray *)wishListModelArr{
    if (!_wishListModelArr) {
        _wishListModelArr=[NSMutableArray arrayWithCapacity:1];
    }
    return _wishListModelArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
