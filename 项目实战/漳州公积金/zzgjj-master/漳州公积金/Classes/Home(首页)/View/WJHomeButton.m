//
//  WJHomeButtom.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/8.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJHomeButton.h"

@interface WJHomeButton()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *labelText;

@end

@implementation WJHomeButton

+ (instancetype)homeButton
{
     return [[[NSBundle mainBundle] loadNibNamed:@"WJHomeButton" owner:nil options:nil] lastObject];
}
-(void)setImageName:(NSString *)imageName text:(NSString *)text
{
    self.imageView.image = [UIImage imageNamed:imageName];
    self.labelText.text = text;
    self.text = text;
}


@end
