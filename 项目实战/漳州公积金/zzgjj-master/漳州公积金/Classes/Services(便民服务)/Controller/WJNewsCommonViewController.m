//
//  WJNewsCommonViewController.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/6.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJNewsCommonViewController.h"
#import "WJLoadMoreFooter.h"
#import "WJNews.h"
#import "WJNewsCommonCell.h"
#import "WJWebViewController.h"
#import "WJNewsParam.h"
#import "WJNewsReturn.h"
#import "WJNewsTool.h"
#import "SCHttpClient.h"
#import "MJExtension.h"

@interface WJNewsCommonViewController ()
/**
 *  新闻数组
 */
@property (nonatomic, strong) NSMutableArray *arrayNews;
/**
 *  上拉时tableView的刷新控件
 */
@property (nonatomic, weak) UIRefreshControl *refreshControl;
/**
 *  下拉加载更多时的刷新控件
 */
@property (nonatomic, weak) WJLoadMoreFooter *footer;
@end

@implementation WJNewsCommonViewController

#pragma mark - 初始化
- (NSMutableArray *)arrayNews
{
    if (_arrayNews == nil) {
        _arrayNews = [NSMutableArray array];
    }
    return _arrayNews;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // 监听SoapWebServices的通知(返回XML数据解析成功后，会发出通知)
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soapXMLNotification:) name:WJSoapXMLNotification object:nil];
    
    self.tableView.backgroundColor = WJGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupRefresh];
}
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
///**
// *  SoapWebServices的通知(返回XML数据解析成功后，会发出通知)
// */
//- (void)soapXMLNotification:(NSNotification *)note
//{
//    NSArray *array =note.userInfo[WJSoapXML];
//    WJLog(@"soapXMLNotification---%@",array);
//    
//    //WJNewsReturn *result = [WJNewsReturn mj_objectWithKeyValues:array];
//    
//    NSArray *resultTemp = [WJNews mj_objectArrayWithKeyValuesArray:array];
//    
//}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.添加下拉刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    
    // 2.监听状态
    [refreshControl addTarget:self action:@selector(refreshControlStateChange:) forControlEvents:UIControlEventValueChanged];
    
    // 3.让刷新控件自动进入刷新状态
    [refreshControl beginRefreshing];
    
    // 4.加载数据
    [self refreshControlStateChange:refreshControl];
    
    // 5.添加上拉加载更多控件
    WJLoadMoreFooter *footer = [WJLoadMoreFooter footer];
    self.tableView.tableFooterView = footer;
    self.footer = footer;
}

/**
 *  当下拉刷新控件进入刷新状态（转圈圈）的时候会自动调用
 */
- (void)refreshControlStateChange:(UIRefreshControl *)refreshControl
{
    [self loadNewStatuses:refreshControl];
}


/**
 *  加载最新的微博数据
 */
- (void)loadNewStatuses:(UIRefreshControl *)refreshControl
{
    // 1.封装请求参数
    WJNewsParam *param = [WJNewsParam param];
    param.lmid = self.lmid;
    WJNews *news = [self.arrayNews firstObject];
    if (news) {
//        param.str =[NSString stringWithFormat: @" and datediff(day,indate,'%@')<0",news.Indate];
        param.mindate = news.Indate;
    }
    
    // 2.加载新闻列表
    [WJNewsTool newsWithParam:param success:^(WJNewsReturn *result) {
        // 获得最新的新闻News数组
        NSArray *newss = result.Details;
        
        // 将新数据插入到旧数据的最前面
        NSRange range = NSMakeRange(0, newss.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.arrayNews insertObjects:newss atIndexes:indexSet];
        
        // 重新刷新表格
        [self.tableView reloadData];
        
        // 让刷新控件停止刷新（恢复默认的状态）
        [refreshControl endRefreshing];
        
        // 提示用户最新的新闻数量
        [self showNewStatusesCount:newss.count];
    } failure:^(NSError *error) {
        WJLog(@"请求失败--%@", error);
        // 让刷新控件停止刷新（恢复默认的状态）
        [refreshControl endRefreshing];
    }];
}

/**
 *  提示用户最新的微博数量
 *
 *  @param count 最新的微博数量
 */
- (void)showNewStatusesCount:(int)count
{
//    // 0.清零提醒数字
//    [UIApplication sharedApplication].applicationIconBadgeNumber -= self.tabBarItem.badgeValue.intValue;
//    self.tabBarItem.badgeValue = nil;
    
    // 1.创建一个UILabel
    UILabel *label = [[UILabel alloc] init];
    
    // 2.显示文字
    if (count) {
        label.text = [NSString stringWithFormat:@"共有%d条新的数据", count];
    } else {
        label.text = @"没有最新的数据";
    }
    
    // 3.设置背景
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"timeline_new_status_background"]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    // 4.设置frame
    label.width = self.view.width;
    label.height = 35;
    label.x = 0;
    label.y = 64 - label.height;
    
    // 5.添加到导航控制器的view
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 6.动画
    CGFloat duration = 0.75;
    [UIView animateWithDuration:duration animations:^{
        // 往下移动一个label的高度
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) { // 向下移动完毕
        
        // 延迟delay秒后，再执行动画
        CGFloat delay = 1.0;
        
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // 恢复到原来的位置
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            // 删除控件
            [label removeFromSuperview];
        }];
    }];
}


//- (void)loadNewStatuses:(UIRefreshControl *)refreshControl
//{
//    SCHttpClient *client=[SCHttpClient new];
//    [client postRequestWithPhoneNumber:@""];
//}


/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatuses
{
    // 1.封装请求参数
    WJNewsParam *param = [WJNewsParam param];
    param.lmid = self.lmid;
    WJNews *lastNews = [self.arrayNews lastObject];
    if (lastNews) {
//        param.str =[NSString stringWithFormat: @" and datediff(day,indate,'%@')>0",lastNews.Indate];
        param.maxdate = lastNews.Indate;
    }
    // 2.加载新闻数据
    [WJNewsTool newsWithParam:param success:^(WJNewsReturn *result) {
        // 获得最新的新闻News数组
        NSArray *newss = result.Details;
        
        // 将新数据插入到旧数据的最后面
        [self.arrayNews addObjectsFromArray:newss];
        
        // 重新刷新表格
        [self.tableView reloadData];
        
        // 让刷新控件停止刷新（恢复默认的状态）
        [self.footer endRefreshing];
    } failure:^(NSError *error) {
        WJLog(@"请求失败--%@", error);
        // 让刷新控件停止刷新（恢复默认的状态）
        [self.footer endRefreshing];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayNews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJNewsCommonCell *cell = [WJNewsCommonCell cellWithTableView:tableView];
    
    cell.news = self.arrayNews[indexPath.row];
    [cell setIndexPath:indexPath rowsInSection: self.arrayNews.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJNews *news = self.arrayNews[indexPath.row];
    WJWebViewController *webVC = [[WJWebViewController alloc] init];
    webVC.strUrl = news.realRedirectUrl;
    webVC.title = news.FTitle;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.arrayNews.count <= 0 || self.footer.isRefreshing) return;
    
    // 1.差距
    CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
    // 刚好能完整看到footer的高度
    CGFloat sawFooterH = self.view.height - self.tabBarController.tabBar.height;
    
    // 2.如果能看见整个footer
    if (delta <= (sawFooterH - 0)) {
        // 进入上拉刷新状态
        [self.footer beginRefreshing];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 加载更多的微博数据
            [self loadMoreStatuses];
        });
    }
}

@end
