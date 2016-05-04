//
//  WJHomeButtonSmall.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/8.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJHomeButtonSmall.h"

@interface WJHomeButtonSmall()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *labelText;

@end

@implementation WJHomeButtonSmall

+ (instancetype)homeButtonSmall
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WJHomeButtonSmall" owner:nil options:nil] lastObject];
}
-(void)setImageName:(NSString *)imageName text:(NSString *)text
{
    self.imageView.image = [UIImage imageNamed:imageName];
    self.labelText.text = text;
    self.text = text;
}

@end
