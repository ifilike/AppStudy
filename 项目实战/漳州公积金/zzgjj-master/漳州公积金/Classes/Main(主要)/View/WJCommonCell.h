//
//  WJCommonCell.h
//  通用tableViewCell
//

#import <UIKit/UIKit.h>
@class WJCommonItem;

@interface WJCommonCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows;

/** cell对应的item数据 */
@property (nonatomic, strong) WJCommonItem *item;
@end
