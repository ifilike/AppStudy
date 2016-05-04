//
//  WDCXViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/14.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "WDCXViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "RouteAnnotation.h"
#import "UIImage+Rotate.h"
#import "BMKGeometry.h"
#import "YDSearchViewController.h"
#import "FundReferences.h"

@interface WDCXViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKRouteSearchDelegate,UISearchResultsUpdating,UISearchBarDelegate,DataSearchDelegate>

@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) BMKLocationService *locService;
@property (strong, nonatomic) BMKRouteSearch *routesearch;
@property (strong, nonatomic) UIButton *locButton;
@property (nonatomic,strong)  UISearchController *searchController;
@property (nonatomic,strong)  YDSearchViewController *searchVC;
@end

@implementation WDCXViewController
-(YDSearchViewController *)searchVC{

    if (!_searchVC) {
        _searchVC = [[YDSearchViewController alloc]init];
        _searchVC.delegate = self;
    }
    return _searchVC;
}
//-(UISearchController *)searchCOntroller{
//
//    if (!_searchController) {
//        _searchController = [[UISearchController alloc]initWithSearchResultsController:self.searchVC];
//        _searchController.searchResultsUpdater = self;
//        [_searchController.searchBar sizeToFit];
//        _searchController.searchBar.frame = CGRectMake(0, 0, k_screen_width,100);
//        _searchController.searchBar.delegate = self;
//    }
//    return _searchController;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    _searchController = [[UISearchController alloc]initWithSearchResultsController:self.searchVC];
    _searchController.searchResultsUpdater = self;
    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.frame = CGRectMake(0, 0, k_screen_width,k_screen_width/8);
    _searchController.searchBar.delegate = self;
   _searchController.searchBar.tintColor = [UIColor whiteColor];
    _searchController.searchBar.barTintColor = BarColor;
   // _searchController.view.backgroundColor = [UIColor redColor];
    self.navigationItem.title = @"网点查询";
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    self.mapView = mapView;
   [self.view addSubview:mapView];
    //添加searchBar
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, k_screen_width, k_screen_width/8)];
    searchView.backgroundColor = [UIColor clearColor ];
    [searchView addSubview:self.searchController.searchBar];
    [self.view addSubview:searchView];
    self.definesPresentationContext = YES;
    UIButton *changeMapTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 50, self.view.bounds.size.height - 50, 40, 40)];
    changeMapTypeButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:changeMapTypeButton];
    [changeMapTypeButton addTarget:self action:@selector(changeMapTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    mapView.showMapScaleBar = true;
    mapView.mapScaleBarPosition = CGPointMake(10, self.view.bounds.size.height - 30);
    
    for (UIView *aView in self.mapView.subviews.lastObject.subviews) {
        if ([aView isKindOfClass:[UIImageView class]]) {
            aView.hidden = true;
        }
    }
    
    // 定位
    //设置定位精确度，默认：kCLLocationAccuracyBest
    _locService.distanceFilter = 10.0f;
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //[BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
  //  [BMKLocationService setLocationDistanceFilter:10.f];
    
    // 利用百度地图api定位
    //初始化BMKLocationService
   // _locService = [[BMKLocationService alloc]init];
    _locService.delegate =self;
    //启动LocationService
    [_locService startUserLocationService];
//    _locService = [[BMKLocationService alloc]init];
//    _locButton = [[UIButton alloc] init];
//    [self.view addSubview:_locButton];
//    _locButton.frame = CGRectMake(self.view.bounds.size.width - 50, 10, 40, 40);
//    [_locButton addTarget:self action:@selector(useLocationServiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    _locButton.backgroundColor = [UIColor redColor];
    

    
    
}
- (void)didStopLocatingUser{

    NSLog(@"======");
}
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

    NSLog(@"-----%@",userLocation);
     NSLog(@"定位经纬度： lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //[Global setCurrentPosition:userLocation.location.coordinate];
}
- (void)useLocationServiceButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    
    
}

- (void)changeMapTypeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.mapView.mapType = BMKMapTypeSatellite;
    } else {
        self.mapView.mapType = BMKMapTypeStandard;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locService.delegate = self;
    self.routesearch.delegate = self;

//    dh = " ";
//    mc = "\U5efa\U884c\U5efa\U8bbe\U8def\U652f\U884c\Uff08\U6b66\U9675\Uff09";
//    wddz = " ";
//    zb = "116.358665,39.991564";
    
    
    for (NSDictionary *outletDict in self.mapBranches) {
        
        NSArray *coorArray = [outletDict[@"zb"] componentsSeparatedByString:@","];
        if (coorArray.count == 2) {
            double latitude = [coorArray.lastObject doubleValue];
            double longitude = [coorArray.firstObject doubleValue];
            
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
            CLLocationCoordinate2D coor;
            coor.latitude = latitude;
            coor.longitude = longitude;
            annotation.coordinate = coor;
            annotation.title = outletDict[@"mc"];
            [self.mapView addAnnotation:annotation];
        }
        
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locService.delegate = nil;
    self.routesearch.delegate = nil;
}




- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.mapBranches.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未找到网点信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertOk = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:alertOk];
        [self presentViewController:alertController animated:true completion:nil];
    }
    
}



- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
    }

    BMKPinAnnotationView *pinAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"outletAnnotation"];
    if (pinAnnotationView == nil) {
        pinAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"outletAnnotation"];
    }
    pinAnnotationView.pinColor = BMKPinAnnotationColorPurple;
    pinAnnotationView.animatesDrop = true;
    return pinAnnotationView;

}

- (void)mapView:(BMKMapView *)mapView onClickedBMKOverlayView:(BMKOverlayView *)overlayView {
    NSLog(@"ss");
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    _routesearch = [[BMKRouteSearch alloc]init];

    [self onClickWalkSearch];

}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    return [[NSBundle mainBundle] pathForResource:@"mapapi" ofType:@"bundle"];

}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}





- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

- (IBAction)onClickBusSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    
#warning  开始地点
    start.name = @"天安门";
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
#warning 结束地点
    end.name = @"百度大厦";
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= @"北京市";
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
    }
}


- (void)onClickDriveSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = @"天安门";
    start.cityName = @"北京市";
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = @"百度大厦";
    end.cityName = @"北京市";
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}

- (void)onClickWalkSearch
{
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = @"天安门";
    start.cityName = @"北京市";
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = @"百度大厦";
    end.cityName = @"北京市";
    
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }
    
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}
#pragma  mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self updateSearchResultsForSearchController:self.searchController];
}
#pragma mark - UISearchResultUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    //获取到用户输入的数据
    NSString *searchText = searchController.searchBar.text;
    //获取到scope中选中的按钮的下标
   // NSInteger selectedType = searchController.searchBar.selectedScopeButtonIndex;
    NSMutableArray *searchResult = [NSMutableArray array];
    if ([searchText isEqualToString:@" "]) {
        for (NSDictionary *searchStr in self.mapBranches) {
                [searchResult addObject:searchStr];
        }
    }else{
        for (NSDictionary *searchStr in self.mapBranches) {
            NSRange range = [searchStr[@"mc"] rangeOfString:searchText];
            if (range.length >0 ) {
                [searchResult addObject:searchStr];
            }
        }
    }
    self.searchVC.searchDataArr = searchResult;
    [self.searchVC.tableview reloadData];
}
-(void)dataSearch:(YDSearchViewController *)controller didSelectWithObject:(NSDictionary *)aObject{

   // NSLog(@"---object--%@",aObject);
    self.searchController.searchBar.text = aObject[@"mc"];
}


@end
