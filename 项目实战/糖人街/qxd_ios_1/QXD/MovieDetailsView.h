//
//  MovieDetailsView.h
//  QXD
//
//  Created by wzp on 16/1/31.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailsView : UIView

@property(nonatomic,retain)UIView * leftLien;
@property(nonatomic,retain)UIView * rightLien;
@property(nonatomic,retain)UILabel * movieLabel;
@property(nonatomic,retain)UILabel * mutibleLabel;
@property(nonatomic,assign)float mutableHigh;



- (void)changeContentWithText:(NSString*)contentText;



@end
