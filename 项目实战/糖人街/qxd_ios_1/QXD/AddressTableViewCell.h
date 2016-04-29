//
//  AddressTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-11-25.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;

@interface AddressTableViewCell : UITableViewCell
@property(nonatomic,strong) NSString *province;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *phoneNumber;
@property(nonatomic,strong) UILabel *detailLabel;
@property(nonatomic,strong) UIButton *selectBtn;
-(void)configCellWithAddressModel:(AddressModel *)model;
//@property(nonatomic,strong) UIButton *buttonSelected;
//@property(nonatomic,strong) NSMutableArray *array;
@property(nonatomic,strong) void (^cellSelect)(UIButton *);
@property(nonatomic,strong) void (^isSelcect)(UIButton *);
@property(nonatomic,strong) UIButton *buttonSelcect;
//@property(nonatomic,strong) void (^dismiss)(NSString *);
//-(void)bbb;
//@property(nonatomic,strong) void(^cellBtn)(NSString *string);
@end
