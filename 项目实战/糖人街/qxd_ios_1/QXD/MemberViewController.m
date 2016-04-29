//
//  MemberViewController.m
//  QXD
//
//  Created by wzp on 15/12/1.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "MemberViewController.h"
#import "MemberView.h"
#import "DeleteLienLabel.h"
#import "MemberPriceTableViewCell.h"
#import "MemberModel.h"
#import "SingleManager.h"
#import "MemberOrderViewController.h"

@interface MemberViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)UITableView * memberPriceTableView;
@property(nonatomic,strong)NSMutableArray * memberModelArr;
@property(nonatomic,retain)MemberView * halfAYearMemberView;
@property(nonatomic,retain)MemberView * aYearMemberView;
@property(nonatomic,retain)SingleManager * singleManage;


@end


#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation MemberViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.singleManage=[SingleManager single];
    [self memberNetWorking];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.scrollView.contentSize=CGSizeMake(WIDTH, HEIGHT*2);
    self.scrollView.backgroundColor=[UIColor grayColor];
    self.navigationItem.title=@"成为会员";
    float setY=0;
    UILabel * memberTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, setY, WIDTH, 50)];
    memberTitleLabel.textAlignment=1;
    memberTitleLabel.backgroundColor=[UIColor orangeColor];
    memberTitleLabel.font=[UIFont systemFontOfSize:12];
    memberTitleLabel.text=@"只有开通会员才可以享受我们的低价购买哦";
    [self.scrollView addSubview:memberTitleLabel];
    
    setY+=60;
    self.halfAYearMemberView=[[MemberView alloc] initWithFrame:CGRectMake(0, setY, WIDTH, 200)];
    _halfAYearMemberView.openVIPBut.tag=11;
    [_halfAYearMemberView.openVIPBut addTarget:self action:@selector(buyVIPWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:_halfAYearMemberView];
    setY+=210;
    
    self.aYearMemberView=[[MemberView alloc] initWithFrame:CGRectMake(0, setY, WIDTH, 200)];
    _aYearMemberView.titleLable.text=@"年费会员特权";
    _aYearMemberView.explain.text=@"全家人的护肤货低价购买";
    [_aYearMemberView.openVIPBut setTitle:@"开通年费会员" forState:0];
    _aYearMemberView.openVIPBut.tag=12;
    [_aYearMemberView.openVIPBut addTarget:self action:@selector(buyVIPWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:_aYearMemberView];
    setY+=210;
    
    UIView * memberHeadView=[[UIView alloc] initWithFrame:CGRectMake(0, setY, WIDTH, 30)];
    memberHeadView.backgroundColor=[UIColor whiteColor];
    UILabel * memberPriceLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 30)];
    memberPriceLab.text=@"会员价格";
    [memberHeadView addSubview:memberPriceLab];
    
    [self.scrollView addSubview:memberHeadView];
    setY+=29;
    
    _memberPriceTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, setY, WIDTH, 210)];
    _memberPriceTableView.delegate=self;
    _memberPriceTableView.dataSource=self;
    
    
    [self.scrollView addSubview:_memberPriceTableView];
    setY+=210;
    self.scrollView.contentSize=CGSizeMake(WIDTH, setY);
    
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 点击
- (void)buyVIPWithButton:(UIButton*)button{
    if (button.tag==10) {
        NSLog(@"购买一个月会员");
        for (MemberModel * memberModel in self.memberModelArr) {
            if ([memberModel.vip_descript isEqualToString:@"一个月"]) {
                [self.singleManage setModel:memberModel];
                self.singleManage.title=@"一个月会员特权";
            }
        }
    }else if (button.tag==11){
        NSLog(@"购买半年会员");
        for (MemberModel * memberModel in self.memberModelArr) {
            if ([memberModel.vip_descript isEqualToString:@"半年"]) {
                [self.singleManage setModel:memberModel];
                self.singleManage.title=@"半年会员特权";

            }
        }
    }else{
        NSLog(@"购买年费会员");
        for (MemberModel * memberModel in self.memberModelArr) {
            if ([memberModel.vip_descript isEqualToString:@"一年"]) {
                [self.singleManage setModel:memberModel];
                self.singleManage.title=@"年费会员特权";

            }
        }
    }
    
    MemberOrderViewController * viewController=[[MemberOrderViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
    
    
}

#pragma mark dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.memberModelArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberPriceTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"qq"];
    if (cell==nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:@"MemberPriceTableViewCell" owner:self options:nil][0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    MemberModel * model=self.memberModelArr[indexPath.row];
    [cell setModel:model];
    [cell.openBut addTarget:self action:@selector(buyVIPWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString * oldPriceStr=model.vip_original_price;
    
    CGRect rect=cell.deleteLab.frame;
//    DeleteLineLabel * oldPrice=[[DeleteLineLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) withTitle:[oldPriceStr stringByAppendingString:@"元"]];
//    oldPrice.font=[UIFont systemFontOfSize:12];
//    [cell.deleteLab addSubview:oldPrice];
    
    
    
    return cell;
    
    
}
#pragma mark delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
#pragma mark 网络请求

- (void)memberNetWorking{
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    NSString * url=@"http://192.168.1.51:8080/sns/mobile/customer/vipType";
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"VIP数据成功 %@",responseObject);
        NSString * succeed=[responseObject objectForKey:@"code"];
        if ([succeed isEqualToString:@"0"]) {
            NSArray * modelArr=[responseObject objectForKey:@"model"];
            for (NSDictionary * vipDic in modelArr) {
                MemberModel * model=[[MemberModel alloc] init];
                [model setValuesForKeysWithDictionary:vipDic];
                NSLog(@"会员描述:%@",model.vip_descript);
                [self.memberModelArr addObject:model];
            }
            //赋值特权
            for (MemberModel * memberModel in self.memberModelArr) {
                if ([memberModel.vip_descript isEqualToString:@"半年"]) {
                    [_halfAYearMemberView setMemberModel:memberModel];
                }else if ([memberModel.vip_descript isEqualToString:@"一年"]){
                    [_aYearMemberView setMemberModel:memberModel];
                }
            }
            [self.memberPriceTableView reloadData];
        }else{
            NSLog(@"请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"VIP数据失败 %@",error);
    }];
    
}



#pragma mark 懒加载
- (NSMutableArray *)memberModelArr{
    if (_memberModelArr==nil) {
        _memberModelArr=[NSMutableArray arrayWithCapacity:1];
    }
    return _memberModelArr;
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
