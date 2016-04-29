//
//  MutibleLabel.h
//  QXD
//
//  Created by WZP on 15/11/19.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MutibleLabel : UILabel


- (void)changeFrameWithString:(NSString*)string;
- (CGRect)getNewFrameWithString:(NSString*)string;


@end
