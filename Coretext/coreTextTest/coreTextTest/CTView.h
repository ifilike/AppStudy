//
//  CTView.h
//  coreTextTest
//
//  Created by babbage on 16/4/19.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTColumnView.h"

//@interface CTView : UIView
@interface CTView : UIScrollView<UIScrollViewDelegate>

{
    float frameXOffset;
    float frameYOffset;
    
    NSAttributedString* attString;
    
    
    NSMutableArray *frames;
}
@property (retain, nonatomic) NSAttributedString* attString;

@property (retain, nonatomic) NSMutableArray *frames;
-(void)buildFrames;
@end
