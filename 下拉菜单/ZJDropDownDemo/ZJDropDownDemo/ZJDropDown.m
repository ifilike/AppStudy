//
//  ZJDropDown.m
//  ZJDropDownDemo
//
//  Created by babbage on 16/4/6.
//  Copyright © 2016年 babbage. All rights reserved.
//
#define BackColor [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0]
#define SelectColor [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0]//选中的颜色
#import "ZJDropDown.h"
@interface ZJDropDown()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) UIView *bottomShadow;//layer最底下的分割线
@property(nonatomic,assign) NSInteger numOfMenu;//menu的数量
//menu的layer布局
@property(nonatomic,copy) NSArray *bgLayers;
@property(nonatomic,copy) NSArray *titles;
@property(nonatomic,copy) NSArray *indicators;

//backGroundView  全屏
@property(nonatomic,strong) UIView *backGroundView;
//tableView CollectionView
@property(nonatomic,strong) UITableView *leftTableView;
@property(nonatomic,strong) UITableView *rightTableView;
@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,assign) NSInteger currentSelectedMenudIndex;//当前选择的第几个menu 记录的作用当前后相同时 让tableView或者collectionView消失
@property(nonatomic,assign) BOOL show;//根据上面的条件判断是否需要隐藏

@property(nonatomic,assign) CGPoint origin;//记录原点 当显示tableview或者collecionView时候 根据origin给自己定位

@property(nonatomic,assign) BOOL hasSelected;// YES==已经选中
@property(nonatomic,assign) NSInteger leftSelectedRow;//左视图选中的行
@end

#pragma mark ------------CollectionView---------------
@interface ZJCollectionViewCell:UICollectionViewCell
@property(nonatomic,strong) UILabel *textLabel;
@property(nonatomic,strong) UIImageView *accessoryView;
-(void)removeAccessoryView;
@end
@implementation ZJCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return self;
}
-(void)setAccessoryView:(UIImageView *)accessoryView{
    [self removeAccessoryView];
    _accessoryView = accessoryView;
    _accessoryView.frame = CGRectMake(self.frame.size.width - 10 - 16, (self.frame.size.height - 12)/2, 16, 12);
    [self addSubview:_accessoryView];
}

-(void)removeAccessoryView{
    if (_accessoryView) {
        [_accessoryView removeFromSuperview];
    }
}
@end
#pragma mark ------------Size---------------
@implementation NSString (Size)
-(CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        NSDictionary *attributes  = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        textSize = [self sizeWithAttributes:attributes];
    }else{
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
        //NSSringDrawingTruncatesLastVisibleLine如果文本超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。如果指定了NSStringDrawingUseLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（字体大小+行间距=行高）
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes context:nil];
        textSize = rect.size;
    }
    
    return textSize;
}
@end

#pragma mark ------------TableView---------------
@interface ZJTableViewCell : UITableViewCell
@property(nonatomic,readonly) UILabel *cellTextLabel;
@property(nonatomic,strong) UIImageView *cellAccessoryView;

-(void)setCellText:(NSString *)text align:(NSString *)align;

@end
@implementation ZJTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellTextLabel = [[UILabel alloc] init];
        _cellTextLabel.textAlignment = NSTextAlignmentCenter;
        _cellTextLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_cellTextLabel];
    }
    return self;
}
-(void)setCellText:(NSString *)text align:(NSString *)align{
    _cellTextLabel.text = text;
    //只取宽度
    CGSize textSize = [text textSizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 14) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat marginX = 20;
    if (![@"left" isEqualToString:align]) {
        marginX = (self.frame.size.width - textSize.width)/2;
    }
    _cellTextLabel.frame = CGRectMake(marginX, 0, textSize.width, self.frame.size.height);
    
    if (_cellAccessoryView) {
        _cellAccessoryView.frame = CGRectMake(_cellTextLabel.frame.origin.x + _cellTextLabel.frame.size.width + 10, (self.frame.size.height - 12)/2, 16, 12);
    }
}
-(void)setCellAccessoryView:(UIImageView *)cellAccessoryView{
    if (_cellAccessoryView) {
        [_cellAccessoryView removeFromSuperview];
    }
    _cellAccessoryView = cellAccessoryView;
    _cellAccessoryView.frame = CGRectMake(_cellTextLabel.frame.origin.x + _cellTextLabel.frame.size.width + 10, (self.frame.size.height - 12)/2, 16, 12);
    [self addSubview:_cellAccessoryView];
}

@end
#pragma mark -------------IndexPaht-----------------
@implementation ZJIndexPaht
-(instancetype)initWithjColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row{
    self = [super init];
    if (self) {
        _column = column;
        _leftOrRigth = leftOrRight;
        _leftRow = leftRow;
        _row = row;
    }
    return self;
}


+(instancetype)indexPathWithcol:(NSInteger)col leftOrRitght:(NSInteger)leftOrRight leftRow:(NSInteger)leftrow row:(NSInteger)row{
    ZJIndexPaht *indexPath = [[self alloc] initWithjColumn:col leftOrRight:leftOrRight leftRow:leftrow row:row];
    return indexPath;
}

@end

#pragma mark ----------------DropDown-------------------

@implementation ZJDropDown


#pragma mark - initmethod
-(instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //最底下的分割线
        _bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, screenSize.width, 0.5)];
        [self addSubview:_bottomShadow];
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;//??
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        // self tapped
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];

        //tableView and collectionView
        self.autoresizesSubviews = NO;
        _leftTableView.autoresizesSubviews = NO;
        _rightTableView.autoresizesSubviews = NO;
        _collectionView.autoresizesSubviews = NO;
        
        _origin = origin;
        _currentSelectedMenudIndex = -1;
        _show = NO;
        _hasSelected = NO;
        
        //UICollection
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(origin.x, origin.y + self.frame.size.height, self.frame.size.width, 0) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        
        [_collectionView registerClass:[ZJCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        //tableView init
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStyleGrouped];
        _leftTableView.rowHeight = 38;
        _leftTableView.separatorColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
      
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStyleGrouped];
        _rightTableView.rowHeight = 38;
        _rightTableView.separatorColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        
    }
    return self;
}
#pragma gesture handle
-(void)menuTapped:(UIGestureRecognizer *)paramSender{
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    
    for (int i = 0; i < _numOfMenu; i ++) {
        if (i != tapIndex) {
            //点击的那个不会走这个方法 其他的都会走这个方法
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
               [self animateTitle:_titles[i] show:NO complete:^{
                   
               }];
            }];

            [(CALayer*)self.bgLayers[i] setBackgroundColor:BackColor.CGColor];
        }

    }
    // 点击是所有的都会走这个方法
    BOOL displayByCollectionView = NO;
    
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)]) {
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:tapIndex];
    }
    if (displayByCollectionView) {
        UICollectionView *collectionView = _collectionView;
        
        if (tapIndex == _currentSelectedMenudIndex && _show) {
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:collectionView titile:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _currentSelectedMenudIndex = tapIndex;
                _show = NO;
            }];
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:BackColor.CGColor];
        }else{
            _currentSelectedMenudIndex = tapIndex;
            [_collectionView reloadData];
            
            if (_currentSelectedMenudIndex != -1) {
                //需要隐藏tableView
                [self animateLeftTableView:_leftTableView rightTableView:_rightTableView show:NO complete:^{
                    //隐藏后 调整self
                    [self animateIdicator:_indicators[tapIndex] background:_backGroundView collectionView:collectionView titile:_titles[tapIndex] forward:YES complecte:^{
                        _show = YES;
                    }];
                }];
            }else{
                [self animateIdicator:_indicators[tapIndex] background:_backGroundView collectionView:collectionView titile:_titles[tapIndex] forward:YES complecte:^{
                    _show = YES;
                }];
            }
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:SelectColor.CGColor];
        }
    }else{
    //上面是点击collectionView 的所有方法  下面是点击tableView的点击方法
        BOOL haveRightTableView = [_dataSource haveRightTableViewInColumn:tapIndex];
        UITableView *rightTableView = nil;
        if (haveRightTableView) {
            rightTableView = _rightTableView;
            //修正左右tableView显示比例 可以使用代理完成封装
        }
        if (tapIndex == _currentSelectedMenudIndex && _show) {
           
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTabaleView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _currentSelectedMenudIndex = tapIndex;
                _show = NO;
            }];
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:BackColor.CGColor];
        }else{
            _hasSelected = NO;
            _currentSelectedMenudIndex = tapIndex;
            if ([_dataSource respondsToSelector:@selector(currentLeftSelectedRow:)]) {
                _leftSelectedRow = [_dataSource currentLeftSelectedRow:_currentSelectedMenudIndex];
            }
            if (rightTableView) {
                [rightTableView reloadData];
            }
            [_leftTableView reloadData];
            CGFloat ratio = [_dataSource widthRationOfLeftColumn:_currentSelectedMenudIndex];
            if (_leftTableView) {
                _leftTableView.frame = CGRectMake(_leftTableView.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width *ratio, 0);
            }
            if (_rightTableView) {
                _rightTableView.frame = CGRectMake(_origin.x + _leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width * (1 - ratio), 0);
            }
            
            if (_currentSelectedMenudIndex != -1) {
                //需要隐藏collecitonView
                [self animateCollectionView:_collectionView show:NO complete:^{
                    [self animateIdicator:_indicators[tapIndex] background:_backGroundView leftTableView:_leftTableView rightTabaleView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:YES complecte:^{
                        _show = YES;
                    }];
                }];
            }else{
                [self animateIdicator:_indicators[tapIndex] background:_backGroundView leftTableView:_leftTableView rightTabaleView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:YES complecte:^{
                    _show = YES;
                }];
            }
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:SelectColor.CGColor];
        }
    }
}
-(void)backgroundTapped:(UITapGestureRecognizer *)paramSender{
    //点击空白的页面点击事件
    BOOL displayByCollectionView = NO;
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)]) {
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:_currentSelectedMenudIndex];
    }
    if (displayByCollectionView) {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView titile:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
    }else{
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTabaleView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
    }
    [(CAShapeLayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:BackColor.CGColor];
}
#pragma mark - animation method
//是否旋转箭头
-(void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    complete();
}
//调整文字
-(void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete{
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    complete();
}
//background 动画
-(void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete{
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}
/**
 *  动画显示下拉 菜单
 */
-(void)animateCollectionView:(UICollectionView *)collectionView show:(BOOL)show complete:(void(^)())complete{
    if (show) {
        CGFloat collectionViewHeight = 0;
        if (collectionView) {
            collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            [self.superview addSubview:collectionView];
            collectionViewHeight = ([collectionView numberOfItemsInSection:0] > 10) ? (5 * 38) : (ceil([collectionView numberOfItemsInSection:0]/2.0) *38);
        }
        [UIView animateWithDuration:0.2 animations:^{
            if (collectionView) {
                collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, collectionViewHeight);
            }
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            if (collectionView) {
                collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            }
        } completion:^(BOOL finished) {
            if (collectionView) {
                [collectionView removeFromSuperview];
            }
        }];
    }
    complete();
}

-(void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)backfround collectionView:(UICollectionView *)collectionView titile:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:backfround show:forward complete:^{
                [self animateCollectionView:collectionView show:forward complete:^{
                    
                }];
            }];
        }];
    }];
    complete();
}
/**
 *  动画显示下拉菜单
 */
-(void)animateLeftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView show:(BOOL)show  complete:(void(^)())complete{
    CGFloat ratio = [_dataSource widthRationOfLeftColumn:_currentSelectedMenudIndex];
    if (show) {
        CGFloat leftTableViewHeight = 0;
        CGFloat rightTableViewHeight = 0;
        if (leftTableView) {
            leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width * ratio, 0);
            [self.superview addSubview:leftTableView];
            
            leftTableViewHeight = ([leftTableView numberOfRowsInSection:0] >5) ? (5 *leftTableView.rowHeight) : ([leftTableView numberOfRowsInSection:0] *leftTableView.rowHeight);
        }
        if ([self.dataSource haveRightTableViewInColumn:_currentSelectedMenudIndex]) {
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x +leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width * (1 - ratio), 0);
                [self.superview addSubview:rightTableView];
                
                rightTableViewHeight = ([rightTableView numberOfRowsInSection:0]>5)?(5*rightTableView.rowHeight) : ([rightTableView numberOfRowsInSection:0] *rightTableView.rowHeight);
            }
        }
        
        CGFloat tableViewHeight = MAX(leftTableViewHeight, rightTableViewHeight);
        [UIView animateWithDuration:0.2 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width * ratio, tableViewHeight);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x + leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width *(1 - ratio), tableViewHeight);
            }
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width *ratio, 0);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x + leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width *(1-ratio), 0);
            }
        } completion:^(BOOL finished) {
            if (leftTableView) {
                [leftTableView removeFromSuperview];
            }
            if (rightTableView) {
                [rightTableView removeFromSuperview];
            }
        }];
    }
    complete();
}
//影藏左右表视图 并且background隐藏掉
-(void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background leftTableView:(UITableView *)leftTableView rightTabaleView:(UITableView *)rightTableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateLeftTableView:leftTableView rightTableView:rightTableView show:forward complete:^{
                }];
            }];
        }];
    }];
    complete();
}


#pragma mark - setter
-(void)setDataSource:(id<ZJDropDowmDataSource>)dataSource{
    _dataSource = dataSource;
    if ([_dataSource respondsToSelector:@selector(numberofColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberofColumnsInMenu:self];
    }else{
        _numOfMenu = 1;
    }
    //bglayer
    CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    //textLayer
    CGFloat textLayerInterval = self.frame.size.width / (_numOfMenu *2 );
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    //sharpeLayer
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    //spearator
    CGFloat separatorLineInterval = self.frame.size.width / _numOfMenu;
    
    
    for (int i = 0; i < _numOfMenu; i ++ ) {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height/2);
        CALayer *bgLayer = [self createBgLayerWithColor:BackColor andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        //title
        CGPoint titlePosition = CGPointMake((i * 2 +1)*textLayerInterval, self.frame.size.height/2);
        NSString *titleString = [_dataSource menu:self titleForColumn:i];
        CATextLayer *title = [self createTextLayerWithNSString:titleString wihtColor:self.textColor andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        //indicator
        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake(titlePosition.x + title.bounds.size.width /2 + 8, self.frame.size.height / 2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
        //separator
        if (1 != _numOfMenu - 1) {
            CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height / 2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:self.separatorColor andPostion:separatorPosition];
            [self.layer addSublayer:separator];
        }
    }
    _bottomShadow.backgroundColor = self.separatorColor;
    
    _bgLayers = [tempBgLayers copy];
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
}

#pragma mark - init support -
//BgLayer
-(CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position{
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width / self.numOfMenu, self.frame.size.height - 1);
    layer.backgroundColor = color.CGColor;
    return layer;
}
//TextLayer
-(CATextLayer *)createTextLayerWithNSString:(NSString *)string wihtColor:(UIColor *)color andPosition:(CGPoint)point{
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu)- 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 14.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];//??
    layer.position = point;
    
    return layer;
}
//计算textLayer的文字宽度
-(CGSize)calculateTitleSizeWithString:(NSString *)string{
    CGFloat fontSize = 14.0f;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
//indicator Shape
-(CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter,layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);//缺少这个会导致layer偏离 影响动画旋转效果
    CGPathRelease(bound);//????
    
    layer.position = point;
    
    return layer;
}
//separrator
-(CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPostion:(CGPoint)point{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160, 0)];
    [path addLineToPoint:CGPointMake(160, self.frame.size.height)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);//????
    
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}



#pragma mark - getter
-(UIColor *)textColor{
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}
-(UIColor *)indicatorColor{
    if (!_indicatorColor) {
        _indicatorColor = [UIColor blackColor];
    }
    return _indicatorColor;
}
-(UIColor *)separatorColor{
    if (!_separatorColor) {
        _separatorColor = [UIColor blackColor];
    }
    return _separatorColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma - ZJIndexPath

#pragma - UIcollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //为collectionView时 leftOrRight 为-1
    if ([self.dataSource respondsToSelector:@selector(menu:numberOrRowsInColumn:leftOrRight:leftRow:)]) {
        return [self.dataSource menu:self numberOrRowsInColumn:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1];
    }else{
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *collectionCell = @"CollectionCell";
    ZJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)]) {
        cell.textLabel.text = [self.dataSource menu:self titleForRowAtIndexPath:[ZJIndexPaht indexPathWithcol:self.currentSelectedMenudIndex leftOrRitght:-1 leftRow:-1 row:indexPath.row]];
    }else{
        NSAssert(0 == 1, @"dataSource mentod to be implemented");
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView.backgroundColor = BackColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.textColor = self.textColor;
    
    if ([cell.textLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex]string]]) {
        cell.backgroundColor = BackColor;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_make"]];
    }else{
        [cell removeAccessoryView];
    }
    return cell;
}
#pragma mark -- UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.frame.size.width - 1)/2, 38);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0.5);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
#pragma mark -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        [self confiMenuWithSelectRow:indexPath.row];
    }
}

#pragma mark - cellClick
-(void)confiMenuWithSelectRow:(NSInteger)row{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    title.string = [self.dataSource menu:self titleForRowAtIndexPath:[ZJIndexPaht indexPathWithcol:self.currentSelectedMenudIndex leftOrRitght:-1 leftRow:-1 row:row]];
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView titile:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}
#pragma mark - table dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //0 left    1 right
    NSInteger  leftOrRight = 0;
    if (_rightTableView == tableView) {
        leftOrRight = 1;
    }
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:numberOrRowsInColumn:leftOrRight:leftRow:)]) {
        return [self.dataSource menu:self numberOrRowsInColumn:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow];
        
    }else{
        return 0;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *identifier = @"DropDownMenuCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = BackColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = self.textColor;
    titleLabel.tag = 1;
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [cell addSubview:titleLabel];

    NSInteger leftOrRight = 0;
    if (_rightTableView == tableView) {
        leftOrRight = 1;
    }
    CGSize textSize;
    if ([self.dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)]) {
        titleLabel.text = [self.dataSource menu:self titleForRowAtIndexPath:[ZJIndexPaht indexPathWithcol:self.currentSelectedMenudIndex leftOrRitght:leftOrRight leftRow:_leftSelectedRow row:indexPath.row]];
        textSize = [titleLabel.text textSizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 14) lineBreakMode:NSLineBreakByCharWrapping];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.separatorInset = UIEdgeInsetsZero;
    
    // 根据有无右视图 判断tableview  有左右视图
    if (leftOrRight == 1) {
        CGFloat marginX = 20;
        titleLabel.frame = CGRectMake(marginX, 0, textSize.width, cell.frame.size.height);
        // right tableView
        cell.backgroundColor = BackColor;
        
        if ([titleLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex]string]]) {
            UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_make"]];
            
            accessoryImageView.frame = CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width + 10, (self.frame.size.height - 12)/2, 16, 12);
            
            [cell addSubview:accessoryImageView];
        }else{

        }
    }else{
    // only left
        CGFloat ratio = [_dataSource widthRationOfLeftColumn:_currentSelectedMenudIndex];
        CGFloat marginX = (self.frame.size.width * ratio - textSize.width)/2;
        
        titleLabel.frame = CGRectMake(marginX, 0, textSize.width, cell.frame.size.height);

        if (!_hasSelected && _leftSelectedRow == indexPath.row) {
            cell.backgroundColor = BackColor;
            BOOL haveRightTableViwe = [_dataSource haveRightTableViewInColumn:_currentSelectedMenudIndex];
            if (!haveRightTableViwe) {//only left
                UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_make"]];
                accessoryImageView.frame = CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width + 10, (self.frame.size.height - 12)/2, 16, 12);
                [cell addSubview:accessoryImageView];
            }
        }else{
            
        }
        
    }
    
    
    return cell;
}
#pragma mark - tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger leftOrRight = 0;
    if (_rightTableView == tableView) {
        leftOrRight = 1;
    }else{
        _leftSelectedRow = indexPath.row;
    }
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        BOOL haveRightTableView = [_dataSource haveRightTableViewInColumn:_currentSelectedMenudIndex];
        if ((leftOrRight == 0 && !haveRightTableView) || leftOrRight == 1) {
            [self configMenuWithSelectRow:indexPath.row leftOrRight:leftOrRight];
        }
        
        [self.delegate menu:self didSelectRowAtIndexPath:[ZJIndexPaht indexPathWithcol:self.currentSelectedMenudIndex leftOrRitght:leftOrRight leftRow:_leftSelectedRow row:indexPath.row]];
        if (leftOrRight == 0 && haveRightTableView) {
            if (!_hasSelected) {
                _hasSelected = YES;
                [_leftTableView reloadData];
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_leftSelectedRow inSection:0];
                [_leftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            [_rightTableView reloadData];
        }
        
    }else{
        //TODO:a
    }
    
}
-(void)configMenuWithSelectRow:(NSInteger)row leftOrRight:(NSInteger)leftOrRight{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    title.string = [self.dataSource menu:self titleForRowAtIndexPath:[ZJIndexPaht indexPathWithcol:self.currentSelectedMenudIndex leftOrRitght:leftOrRight leftRow:_leftSelectedRow row:row]];
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTabaleView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:BackColor.CGColor];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width /2 + 8, indicator.position.y);
    
}

@end





