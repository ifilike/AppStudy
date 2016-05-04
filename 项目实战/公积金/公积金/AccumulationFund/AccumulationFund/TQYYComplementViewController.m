//
//  TQYYComplementViewController.m
//  AccumulationFund
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "TQYYComplementViewController.h"
#import "GJJAPI.h"
#import "UserAccountInfo.h"
#import "TTTAttributedLabel.h"
#import "UICopyLabel.h"

@interface TQYYComplementViewController ()
@property (strong, nonatomic) UIScrollView *sv;
@property (strong, nonatomic) UICopyLabel *label;
@end

@implementation TQYYComplementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"预约详情";
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.sv = sv;
    [self.view addSubview:sv];
    sv.translatesAutoresizingMaskIntoConstraints = false;
    
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:sv attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:sv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:sv attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.bounds.size.width]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:sv attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.bounds.size.height]];

    
    
    UICopyLabel *label = [[UICopyLabel alloc] initWithFrame:CGRectZero];
    self.label = label;
    [sv addSubview:label];
    label.font = [UIFont fontWithName:@"Helvetica" size:17];
    label.numberOfLines = 0;
    
    label.translatesAutoresizingMaskIntoConstraints = false;
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:sv attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 40]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sv attribute:NSLayoutAttributeTop multiplier:1.0 constant:20]];

    
    [self.view addConstraints:constraints];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDateFormatter *fmt2 = [[NSDateFormatter alloc] init];
    fmt2.dateFormat = @"yyyy年MM月dd日";
    NSDate *appointedDate = [fmt dateFromString:self.appointedDate];
    NSString *dateString = [fmt2 stringFromDate:appointedDate];
    label.text = [NSString stringWithFormat:@"您的预约编号是: \n%@\n请您于%@, 携带以下材料到%@办理提取业务。请牢记预约编号。", self.yybh, dateString, self.appointedOutlet];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendString:self.label.text];
    [stringM appendString:@"\n\n"];
    [GJJAPI drawDetail_职工编号:[UserAccountInfo sharedUserAccountInfo].staffNumber 提取原因:self.drawReasonCode completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        for (NSDictionary *dict in result[@"data"]) {
            [stringM appendString:dict[@"mc"]];
        }
        self.label.text = stringM.copy;
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.sv.contentSize = CGSizeMake(self.label.bounds.size.width + 40, self.label.bounds.size.height + 40);
}


@end
