//
//  DKYYXQViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "DKYYXQViewController.h"
#import "UICopyLabel.h"

@interface DKYYXQViewController ()

@end

@implementation DKYYXQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"贷款预约详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
}

- (void)createUI {
    UICopyLabel *label = [[UICopyLabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, self.view.frame.size.height)];
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Helvetica" size:17];
    [self.view addSubview:label];
    
    NSMutableString *textString = [NSMutableString string];
    [textString appendFormat:@"您的预约号: %@\n\n", self.appointedNumber];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *fmt2 = [[NSDateFormatter alloc] init];
    fmt2.dateFormat = @"yyyy年MM月dd日";
    NSDate *appointedDate = [fmt dateFromString:self.appointedDate];
    NSString *dateString = [fmt2 stringFromDate:appointedDate];
    [textString appendFormat:@"请与 %@ , 携带以下材料, 到 %@ 办理公积金贷款 ; \n\n", dateString, self.appointedOutlet];
    [textString appendString:@"1. 借款人(所有产权人及配偶)身份证原件(距失效期在一年以上)；\n"
     "2. 借款人(所有产权人及配偶)结婚证原件；\n"
     "3. 首套房提供不低于购房总价的20%的首付款发票原件,二套房提供不低于购房总价的30%的首付款发票原件；\n"
     "4. 房屋出售单位出具的《担保承诺书》 原件; \n"
     "5.《房屋预告登记证明》 原件; \n"
     "6.《商品房买卖合同》 原件; \n"
     "7.《住房公积金缴存及贷款情况证明》 原件; \n"
     "8. 同一居民户口簿或独生子女证或医学出生证明原件(父母与成年子女共同购房的需提供); \n"
     ];
    label.text = textString.copy;
}



@end
