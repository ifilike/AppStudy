//
//  ZJDropDown.h
//  ZJDropDownDemo
//
//  Created by babbage on 16/4/6.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZJIndexPaht : NSObject

@property(nonatomic,assign) NSInteger column;

//0 left      1 right
@property(nonatomic,assign) NSInteger leftOrRigth;
//left
@property(nonatomic,assign) NSInteger leftRow;
//right
@property(nonatomic,assign) NSInteger row;
-(instancetype)initWithjColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;

+(instancetype)indexPathWithcol:(NSInteger)col leftOrRitght:(NSInteger)leftOrRight leftRow:(NSInteger)leftrow row:(NSInteger)row;

@end

#pragma mark - data source protocol
@class ZJDropDown;
@protocol ZJDropDowmDataSource <NSObject>
@required
-(NSString *)menu:(ZJDropDown *)menu titleForColumn:(NSInteger)column;//self最上面的三个文字
//表视图显示时，左边显示的比例
-(CGFloat)widthRationOfLeftColumn:(NSInteger)column;
//是否需要两个表视图
-(BOOL)haveRightTableViewInColumn:(NSInteger)column;
//放回当前左视图选中的行
-(NSInteger)currentLeftSelectedRow:(NSInteger)column;

/**
 *  设计到数据问题
 */
-(NSInteger)menu:(ZJDropDown *)menu numberOrRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;

-(NSString *)menu:(ZJDropDown *)menu titleForRowAtIndexPath:(ZJIndexPaht *)indexPaht;


@optional
//default value is 1
-(NSInteger)numberofColumnsInMenu:(ZJDropDown *)menu;
/**
 *  是否需要显示UICollectionView 默认为否
 */
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end

#pragma mark - delegate
@protocol ZJDropDownDelegate<NSObject>
@optional
-(void)menu:(ZJDropDown *)menu didSelectRowAtIndexPath:(ZJIndexPaht *)indexPath;
@end


@interface ZJDropDown : UIView

@property(nonatomic,weak) id <ZJDropDowmDataSource> dataSource;
@property(nonatomic,weak) id <ZJDropDownDelegate> delegate;


-(instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic,strong) UIColor *indicatorColor;
@property(nonatomic,strong) UIColor *separatorColor;

@end
