//
//  CTColumnView.h
//  Magazine
//
//  Created by babbage on 16/4/20.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CTColumnView : UIView {
    id ctFrame;
    
    NSMutableArray* images;
}
@property (retain, nonatomic) NSMutableArray* images;


-(void)setCTFrame:(id)f;
@end

