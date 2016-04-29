//
//  WithLabelImageScrollView.h
//  QXD
//
//  Created by wzp on 15/12/14.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithLabelImageScrollView : UIView<UIScrollViewDelegate>

@property(nonatomic,retain)UIScrollView * imageScrollView;
@property(nonatomic,retain)UIPageControl * scrollPage;
@property(nonatomic,assign)int count2;
//@property(nonatomic,assign)int count;
@property(nonatomic,retain)NSMutableArray * imageArr;
@property(nonatomic,assign)int currentNum;


- (instancetype)initWithFrame:(CGRect)frame labelArr:(NSArray*)labelArr imageStringArr:(NSArray*)imageStringArr;

- (void)reloadDataWithLabelArr:(NSArray*)labelArr imageStringArr:(NSMutableArray*)imageStringArr;


@end
