//
//  ThreeImageAndLabelView.h
//  QXD
//
//  Created by WZP on 15/11/19.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MutibleLabel;

@interface ThreeImageAndLabelView : UIView


@property(nonatomic,retain)UIImageView * leftView;
@property(nonatomic,retain)UIImageView * topView;
@property(nonatomic,retain)UIImageView * bottomView;
@property(nonatomic,retain)MutibleLabel * mutibleLab;





- (void)changeHeightWithString:(NSString*)string;






@end
