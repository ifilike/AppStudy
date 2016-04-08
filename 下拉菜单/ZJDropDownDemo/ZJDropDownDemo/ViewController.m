//
//  ViewController.m
//  ZJDropDownDemo
//
//  Created by babbage on 16/4/6.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ViewController.h"
#import "ZJDropDown.h"

@interface ViewController ()<ZJDropDowmDataSource,ZJDropDownDelegate>{
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    NSInteger _currentData1SelectedIndex;
    ZJDropDown *menu;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createDropDown];
}
-(void)createDropDown{
    
    // 指定默认选中
    _currentData1Index = 1;
    _currentData1SelectedIndex = 0;
    
    NSArray *food = @[@"全部美食", @"火锅", @"川菜", @"西餐", @"自助餐"];
    NSArray *travel = @[@"全部旅游", @"周边游", @"景点门票", @"国内游", @"境外游"];
    
    _data1 = [NSMutableArray arrayWithObjects:@{@"title":@"美食", @"data":food}, @{@"title":@"旅游", @"data":travel}, nil];
    _data2 = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高", nil];
    _data3 = [NSMutableArray arrayWithObjects:@"不限人数", @"单人餐", @"双人餐", @"3~4人餐", nil];
    
    
    
    menu = [[ZJDropDown alloc] initWithOrigin:CGPointMake(0, 20) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
}
#pragma mark - dataSource
//选择性
-(NSInteger)numberofColumnsInMenu:(ZJDropDown *)menu{
    return 3;
}
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    if (column == 2) {
        return YES;
    }
    return NO;
}
//必须执行
-(NSString *)menu:(ZJDropDown *)menu titleForColumn:(NSInteger)column{
    switch (column) {
        case 0:
            return [[_data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex];
            break;
        case 1:
            return _data2[_currentData2Index];
            break;
        case 2:
            return _data3[_currentData3Index];
            break;
        default:
            return nil;
            break;
    }
}
//表视图左边tableView 占用的比例
-(CGFloat)widthRationOfLeftColumn:(NSInteger)column{
    if (column == 0) {
        return 0.3;
    }
    return 1;
}
//是否需要右视图
-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    if (column == 0) {
        return YES;
    }
    return NO;
}
//返回当前左视图选中的行
-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    if (column == 0) {
        return _currentData1Index;
    }
    if (column == 1) {
        return _currentData2Index;
    }
    return 0;
}
/**
 *  设计到数据问题
 */
-(NSInteger)menu:(ZJDropDown *)menu numberOrRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (column == 0) {
        if (leftOrRight == 0) {
            return _data1.count;
        }else{
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    }else if (column == 1){
        return _data2.count;
    }else if (column == 2){
        return _data3.count;
    }
    return 0;
}
-(NSString *)menu:(ZJDropDown *)menu titleForRowAtIndexPath:(ZJIndexPaht *)indexPaht{
    if (indexPaht.column == 0) {
        if (indexPaht.leftOrRigth == 0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPaht.row];
            return [menuDic objectForKey:@"title"];
        }else{
            NSInteger leftRow = indexPaht.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPaht.row];
        }
    }else if(indexPaht.column == 1){
        return _data2[indexPaht.row];
    }else{
        return _data3[indexPaht.row];
    }
}
-(void)menu:(ZJDropDown *)menu didSelectRowAtIndexPath:(ZJIndexPaht *)indexPath{
    if (indexPath.column == 0) {
        if (indexPath.leftOrRigth == 0) {
            _currentData1Index = indexPath.row;
            return;
        }
    }else if(indexPath.column == 1){
        _currentData2Index = indexPath.row;
    }else{
        _currentData3Index = indexPath.row;
    }
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
