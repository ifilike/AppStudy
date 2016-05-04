//
//  WJLoadMoreFooter.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/8.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJLoadMoreFooter.h"

@interface WJLoadMoreFooter()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@end

@implementation WJLoadMoreFooter


+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WJLoadMoreFooter" owner:nil options:nil] lastObject];
}

- (void)beginRefreshing
{
    self.statusLabel.text = @"正在拼命加载更多数据...";
    [self.loadingView startAnimating];
    self.refreshing = YES;
}

- (void)endRefreshing
{
    self.statusLabel.text = @"上拉可以加载更多数据";
    [self.loadingView stopAnimating];
    self.refreshing = NO;
}


@end
