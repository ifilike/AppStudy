//
//  AdresTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-12-25.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdresTableViewCell : UITableViewCell
@property(nonatomic,strong) UIView *firstView;
@property(nonatomic,strong) UIView *secondeView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *phomeLabel;
@property(nonatomic,strong) UILabel *addressNameLabel;
@property(nonatomic,strong) UILabel *addressLabel;

-(void)configWithDictionary:(NSString *)name WithPhone:(NSString *)phone WithDetailAddress:(NSString *)address;

@end
