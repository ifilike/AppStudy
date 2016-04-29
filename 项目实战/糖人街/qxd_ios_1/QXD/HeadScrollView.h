//
//  HeadScrollView.h
//  QXD
//
//  Created by wzp on 15/12/8.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SubButtonProtocol <NSObject>

@required
- (void)addButtonEvent;
//- (void)doOtherThing;
@end


@interface HeadScrollView : UIView<UIScrollViewDelegate>




@property(nonatomic,retain)UIScrollView * scrollView;
@property(nonatomic,retain)NSMutableArray * imageArr;
@property(nonatomic,retain)NSMutableArray * imageButArr;
@property(nonatomic,assign)id<SubButtonProtocol> delegate;


- (instancetype)initWithFrame:(CGRect)frame withImageUrlArr:(NSMutableArray*)imageUrlArr;

- (void)upDataWithImageUrlStringArr:(NSMutableArray*)ImageUrlStringArr;
@end

