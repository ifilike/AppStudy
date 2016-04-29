//
//  FoundImageButton.m
//  QXD
//
//  Created by wzp on 15/12/10.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "FoundImageButton.h"
#import "FoundModel.h"

@implementation FoundImageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setModel:(FoundModel*)model{
//    _BIG_TYPE_ID=model.BIG_TYPE_ID;
//    _BIG_TYPE_NAME=model.BIG_TYPE_NAME;
//    _TIME=model.TIME;
//    _TITLE=model.TITLE;
//    _SMALL_TYPE_ID=model.SMALL_TYPE_ID;
//    _SMALL_TYPE_NAME=model.SMALL_TYPE_NAME;
//    _ID=model.ID;
//    _IMG=model.IMG;
//    _IS_DELETE=model.IS_DELETE;
//    
    
    NSURL * url=[NSURL URLWithString:_IMG];
    NSData * data=[NSData dataWithContentsOfURL:url];
    UIImage * image=[UIImage imageWithData:data];
    [self setImage:image forState:0];

}



@end
