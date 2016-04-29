//
//  MemberOrderViewController.m
//  QXD
//
//  Created by wzp on 15/12/25.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "MemberOrderViewController.h"
#import "SingleManager.h"
#import "MemberView.h"
#import "PayModeView.h"

@interface MemberOrderViewController ()
@property (strong, nonatomic)  UILabel *discountLabel;
@property (strong, nonatomic)  UILabel *priceLabel;
@property (strong, nonatomic)  UILabel *discountLabel2;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)PayModeView * payModeView;
@property(nonatomic,retain)PayModeView * payModeView2;




@end

#define HEIGHT [[UIScreen mainScreen] bounds].size.height


@implementation MemberOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize=CGSizeMake(WIDTH, HEIGHT*2);
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.title=@"确认订单";
    SingleManager * memberSingle=[SingleManager single];
    
    float setY=20;
    MemberView * memberView=[[MemberView alloc] initWithFrame:CGRectMake(0, setY , WIDTH, 200)];
    memberView.backgroundColor=[UIColor whiteColor];
    memberView.titleLable.text=memberSingle.title;
    memberView.explain.text=memberSingle.vip_privilege;
    [memberView.openVIPBut setTitle:[memberSingle.vip_present_price stringByAppendingString:@"元"] forState:0];
    [memberView.openVIPBut setTitleColor:[UIColor blackColor] forState:0];
    memberView.openVIPBut.userInteractionEnabled=NO;
    memberView.openVIPBut.backgroundColor=[UIColor whiteColor];
    [self.scrollView addSubview:memberView];
    setY+=210;
    
    _discountLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, setY, WIDTH-10, 30)];
    _discountLabel.text=@"VIP减免15元优惠券";
    _discountLabel.textAlignment=1;
    _discountLabel.backgroundColor=[UIColor whiteColor];
    [self.scrollView addSubview:_discountLabel];
    setY+=40;
    
    UILabel * payLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, setY, 80, 30)];
    payLabel.text=@"支付方式";
    [self.scrollView addSubview:payLabel];
    setY+=40;
    
    _payModeView=[[PayModeView alloc] initWithFrame:CGRectMake(0, setY, WIDTH, 30)];
    _payModeView.nameOfLabel.text=@"支付宝";
    _payModeView.backgroundColor=[UIColor whiteColor];
    [_payModeView.selectedBut addTarget:self action:@selector(payModeSelectedZhiFuBao) forControlEvents:UIControlEventTouchUpInside];
    _payModeView.imageView2.backgroundColor=[UIColor redColor];
    [self.scrollView addSubview:_payModeView];
    setY+=30;
    _payModeView2=[[PayModeView alloc] initWithFrame:CGRectMake(0, setY, WIDTH, 30)];
    _payModeView2.nameOfLabel.text=@"微信支付";
    _payModeView2.backgroundColor=[UIColor whiteColor];
    [_payModeView2.selectedBut addTarget:self action:@selector(payModeSelectedWeiXin) forControlEvents:UIControlEventTouchUpInside];

    _payModeView2.imageView2.backgroundColor=[UIColor greenColor];
    [self.scrollView addSubview:_payModeView2];
    setY+=40;
    
    _priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, setY, WIDTH-20, 20)];
    _priceLabel.text=@"商品总价89元";
    _priceLabel.textAlignment=2;
    _priceLabel.font=[UIFont systemFontOfSize:11];
    [self.scrollView addSubview:_priceLabel];
    setY+=25;
    
    _discountLabel2=[[UILabel alloc] initWithFrame:CGRectMake(10, setY, WIDTH-20, 20)];
    _discountLabel2.textAlignment=2;
    _discountLabel2.font=[UIFont systemFontOfSize:11];
    _discountLabel2.text=@"优惠15元";
    [self.scrollView addSubview:_discountLabel2];
    setY+=70;
    
    
    self.scrollView.contentSize=CGSizeMake(WIDTH, setY);
    
    
    _priceLabel2.text=@"总计74元";
    
    
    
    
    
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)confirmPay:(id)sender {
}

- (void)payModeSelectedWeiXin{
    [_payModeView.selectedBut setBackgroundImage:[UIImage imageNamed:@"Unselected"] forState:0];
    [_payModeView2.selectedBut setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:0];

}
- (void)payModeSelectedZhiFuBao{
    [_payModeView2.selectedBut setBackgroundImage:[UIImage imageNamed:@"Unselected"] forState:0];
    [_payModeView.selectedBut setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:0];
    
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
