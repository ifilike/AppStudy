//
//  SelectionViewDelegate.h
//  AccumulationFund
//
//  Created by mac on 15/11/17.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectionView.h"

@protocol SelectionViewDelegate <NSObject>

@optional
- (void)selection:(id)selectionView didChangeSelected:(BOOL)selected;

@end
