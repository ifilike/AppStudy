//
//  SelectView.h
//  QXD
//
//  Created by WZP on 15/11/20.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeleteLienLabel;
@class NumberOfProductLable;
@class StandardOfProductLable;

@interface SelectView : UIView

@property(nonatomic,retain)UILabel * nameLable;
@property(nonatomic,retain)UILabel * priceLable;
@property(nonatomic,retain)DeleteLienLabel * oldPriceLable;
@property(nonatomic,retain)UILabel * selectLable;
@property(nonatomic,retain)UILabel * serviceLable;
//@property(nonatomic,retain)UIButton * addBut;



- (void)reloadDataWithName:(NSString*)name price:(NSString*)price oldPrice:(NSString*)oldPrice stand:(NSString*)stand;




@end
