//
//  MemberView.h
//  QXD
//
//  Created by wzp on 15/12/1.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MemberModel;

@interface MemberView : UIView


@property(nonatomic,retain)UILabel * titleLable;
@property(nonatomic,retain)UILabel * explain;
@property(nonatomic,retain)UIButton * openVIPBut;








- (void)setMemberModel:(MemberModel*)model;
@end
