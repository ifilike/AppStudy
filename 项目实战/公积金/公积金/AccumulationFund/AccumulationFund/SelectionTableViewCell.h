//
//  SelectionTableViewCell.h
//  SelectedList
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionView.h"

@class SelectionView;

@interface SelectionTableViewCell : UITableViewCell

@property (strong, nonatomic) SelectionView * selectionView;

- (instancetype)initWithSelectionType:(SelectionViewType)type reuseIdentifier:(NSString *)reuseIdentifier;

@end
