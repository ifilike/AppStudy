//
//  EmotionScrollView.h
//  WeiSheFramework
//
//  Created by temp on 15/8/9.
//
//

#import <UIKit/UIKit.h>
@class EmotionScrollView;
@protocol EmotionScrollViewDelegate <NSObject>

- (void)emotionScrollView:(EmotionScrollView *)emotionView selected:(UIButton *)emotionBtn;

@end

@interface EmotionScrollView : UIView
@property (nonatomic,weak)id<EmotionScrollViewDelegate> delegate;
@end
