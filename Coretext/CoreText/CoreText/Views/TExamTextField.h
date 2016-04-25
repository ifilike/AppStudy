//
//  TExamTextField.h
//  TYAttributedLabelDemo
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TExamTextFieldState) {
    TExamTextFieldStateNormal,
    TExamTextFieldStateCorrect,
    TExamTextFieldStateError,
};

@interface TExamTextField : UITextField

@property (nonatomic, assign) TExamTextFieldState examState;

@end
