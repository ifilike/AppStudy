//
//  MemberView.m
//  QXD
//
//  Created by wzp on 15/12/1.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "MemberView.h"
#import "MemberModel.h"

@implementation MemberView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _titleLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        _titleLable.textAlignment=1;
        _titleLable.text=@"半年会员特权";
        [self addSubview:_titleLable];
        _explain=[[UILabel alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, 40)];
        _explain.textAlignment=1;
        _explain.text=@"基础护肤进低价购买";
        [self addSubview:_explain];
        _openVIPBut=[[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2-125, 150, 250, 40)];
        _openVIPBut.layer.cornerRadius=10;
        _openVIPBut.backgroundColor=[UIColor orangeColor];
        [_openVIPBut setTitle:@"开通半年会员" forState:0];
        [self addSubview:_openVIPBut];
        
        
        
    }
    return self;
}

- (void)setMemberModel:(MemberModel*)model{
    _explain.text=model.vip_privilege;
    
}




@end
