//
//  RegisterViewController.h
//  AccumulationFund
//
//  Created by mac on 15/11/23.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterDidSuccessDelegate <NSObject>

- (void)registerDidSuccessWithName:(NSString *)name cellphone:(NSString *)cellphone password:(NSString *)password;

@end

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) id <RegisterDidSuccessDelegate> delegate;

@end
