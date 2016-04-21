//
//  CTView.h
//  Magazine
//
//  Created by babbage on 16/4/20.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTColumnView.h"

//@interface CTView : UIView{
@interface CTView : UIScrollView<UIScrollViewDelegate>{

    float frameXOffset;
    float frameYOffset;
    
    NSAttributedString* attString;
    
    NSMutableArray *frames;
    
    NSArray* images;
}
@property (retain, nonatomic) NSAttributedString* attString;

@property (retain, nonatomic) NSMutableArray *frames;
-(void)buildFrames;

@property (retain, nonatomic) NSArray* images;
-(void)setAttString:(NSAttributedString *)attString withImages:(NSArray*)imgs;
-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(CTColumnView*)col;

@end
