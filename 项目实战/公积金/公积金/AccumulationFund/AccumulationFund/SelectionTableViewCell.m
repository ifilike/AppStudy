//
//  SelectionTableViewCell.m
//  SelectedList
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "SelectionTableViewCell.h"

@implementation SelectionTableViewCell

- (instancetype)initWithSelectionType:(SelectionViewType)type reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self != nil) {

        self.selectionView = [[SelectionView alloc] initWithType:SelectionViewTypeSingleSelection];
        [self addSubview:self.selectionView];
        self.selectionView.userInteractionEnabled = false;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectionView.frame = self.bounds;
}



@end
