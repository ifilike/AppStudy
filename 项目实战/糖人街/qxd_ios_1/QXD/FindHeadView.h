//
//  FindHeadView.h
//  QXD
//
//  Created by wzp on 15/12/22.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WithLabelImageView;



@protocol FindTouchEvent <NSObject>

@required
- (void)doSomethingWithString:(NSString*)ID;

@end

@interface FindHeadView : UIView

@property(nonatomic,retain)WithLabelImageView * imageView1;
@property(nonatomic,retain)WithLabelImageView * imageView2;
@property(nonatomic,retain)WithLabelImageView * imageView3;
@property(nonatomic,retain)WithLabelImageView * imageView4;
@property(nonatomic,retain)WithLabelImageView * imageView5;
@property(nonatomic,assign)id <FindTouchEvent> delegate;
@property(nonatomic,retain)NSMutableArray * foundZTIDArr;




- (void)reloadDataWithFoundZTModelArr:(NSMutableArray*)modelArr;




@end
