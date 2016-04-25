//
//  ViewController.m
//  CoreText
//
//  Created by babbage on 16/4/13.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ViewController.h"
#import "SimpleTextViewController.h"
#import "LabelXibViewController.h"
#import "AttributedTextViewController.h"
#import "LinkTextViewController.h"
#import "AutoLayoutLinkImageTextViewController.h"
#import "ImageTextViewController.h"
#import "AddViewTextViewController.h"
#import "TextContainerViewController.h"
#import "ParseTextViewController.h"
#import "TextTableViewController.h"
#import "AutoLayoutTableViewController.h"

@interface tableViewItem : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *detailText;
@property (nonatomic,assign) Class destVcClass;

@end

@implementation tableViewItem

@end

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *itemArrays;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self addTableView];
    [self addTableItems];
}

-(NSMutableArray *)itemArrays{
    if (!_itemArrays) {
        _itemArrays = [NSMutableArray array];
    }
    return _itemArrays;
}

-(void)addTableView{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView =  tableView;
}
-(void)viewWillLayoutSubviews{
    self.tableView.frame = self.view.bounds;
}

- (void)addTableItems{
    [self addTableItemWithTitle:@"SimpleText" detailText:@"简单文本显示" destVcClass:[SimpleTextViewController class]];
    
    [self addTableItemWithTitle:@"XibLabelText" detailText:@"简单文本显示(xib)" destVcClass:[LabelXibViewController class]];
    
    [self addTableItemWithTitle:@"AttributedText" detailText:@"属性文本显示" destVcClass:[AttributedTextViewController class]];
    
    [self addTableItemWithTitle:@"LinkText" detailText:@"属性链接文本显示" destVcClass:[LinkTextViewController class]];
    
    [self addTableItemWithTitle:@"AutoLayoutLinkText" detailText:@"AutoLayout属性链接文本显示" destVcClass:[AutoLayoutLinkImageTextViewController class]];
    
    [self addTableItemWithTitle:@"ImageText" detailText:@"属性文本和Image(URL)混排显示" destVcClass:[ImageTextViewController class]];
    
    [self addTableItemWithTitle:@"AddViewText" detailText:@"属性文本和UIView混排显示" destVcClass:[AddViewTextViewController class]];
    
    [self addTableItemWithTitle:@"TextContainer" detailText:@"文本容器提前生成" destVcClass:[TextContainerViewController class]];
    
    [self addTableItemWithTitle:@"ParseText" detailText:@"自定义排版解析图文混排显示" destVcClass:[ParseTextViewController class]];
    
    [self addTableItemWithTitle:@"AttributedTextCell" detailText:@"tableViewCell显示图文混排" destVcClass:[TextTableViewController class]];
    [self addTableItemWithTitle:@"AutoLayoutAttributedTextCell" detailText:@"Autolayout tableViewCell显示图文混排" destVcClass:[AutoLayoutTableViewController class]];
    
}

-(void)addTableItemWithTitle:(NSString *)title detailText:(NSString *)detailText destVcClass:(Class)destVcClass{
    tableViewItem *item = [[tableViewItem alloc] init];
    item.title = title;
    item.detailText = detailText;
    item.destVcClass = destVcClass;
    
    [self.itemArrays addObject:item];
}
#pragma mark --tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArrays.count;
}

#pragma mark --tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    tableViewItem *item = [self.itemArrays objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.detailText;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableViewItem *item = [self.itemArrays objectAtIndex:indexPath.row];
    if (item.destVcClass) {
        UIViewController *vc = [[item.destVcClass alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.title = item.title;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
