//
//  TodayViewController.m
//  MyWidget
//
//  Created by maqj on 15/9/14.
//  Copyright (c) 2015年 maqj. All rights reserved.
//

#import "TodayViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <NotificationCenter/NotificationCenter.h>
#import "CustomCollectionViewCell.h"

@interface TodayViewController () <NCWidgetProviding, UICollectionViewDataSource, UICollectionViewDelegate>
- (IBAction)onClickTest:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonTest;
- (IBAction)fuckingTest:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;

@end

NSString *const kCollectionViewIdentifier = @"YxWidgetkCollectionViewIdentifier";

@implementation TodayViewController{
    NSMutableArray *_dataArray;
}

- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);
    
    //刷新图片列表
    [self refreshImages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"%s w = %f, h = %f", __FUNCTION__, self.view.frame.size.width, self.view.frame.size.height);
    
//    self.preferredContentSize = CGSizeMake(320, 150);

    _dataArray = [NSMutableArray arrayWithCapacity:10];
    [_dataArray addObject:@"0"];
    [_dataArray addObject:@"1"];
    [_dataArray addObject:@"2"];
    
    //初始化scrollview
    [self initImagesView];
    
    //刷新图片列表
    [self refreshImages];
}

- (void)initImagesView{
//    _imagesScrollView.pagingEnabled = YES;
//    _imagesScrollView.delegate = self;
//    _imagesScrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
//    _imagesScrollView.showsHorizontalScrollIndicator = YES;
//    _imagesScrollView.showsVerticalScrollIndicator = NO;
    _imagesCollectionView.delegate = self;
    _imagesCollectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 5.0f;
    flowLayout.minimumLineSpacing = 5.0f;
    flowLayout.itemSize = CGSizeMake(50.f, 100.f);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _imagesCollectionView.collectionViewLayout = flowLayout;
    
//    [_imagesCollectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewIdentifier];
}

- (void)refreshImages{
    //获取最新截图
    [self getScreenShots];
    //刷新scrollview
//    [_imagesCollectionView reloadData];
}

- (void)getScreenShots{
    
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewIdentifier forIndexPath:indexPath];
//    cell.itemImage = _dataArray[indexPath.row];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}
//- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
//    NSLog(@"%s w = %f, h = %f", __FUNCTION__, self.view.frame.size.width, self.view.frame.size.height);
//
//    return UIEdgeInsetsZero;
//}

- (IBAction)onClickTest:(id)sender {
    NSLog(@"%s w = %f, h = %f", __FUNCTION__, self.view.frame.size.width, self.view.frame.size.height);

    [self getImgs];

    return;
    
    [self.extensionContext openURL:[NSURL URLWithString:@"MaqjWidgetTest://"] completionHandler:nil];
    
    NSUserDefaults *user = [[NSUserDefaults alloc] initWithSuiteName:@"group.widgetmaqj"];
    [user setObject:@"I'm widget" forKey:@"kWidgetValue"];
    [user synchronize];
}
- (IBAction)fuckingTest:(id)sender {
    NSLog(@"%s w = %f, h = %f", __FUNCTION__, self.view.frame.size.width, self.view.frame.size.height);
    
    NSLog(@"%s ",__FUNCTION__);
    
}


- (void)screenShot{
    
}

//CGImageRef UIGetScreenImage();
//void SaveScreenImage(NSString *path)
//{
//    CGImageRef cgImage = UIGetScreenImage();
//    void *imageBytes = NULL;
//    if (cgImage == NULL) {
//        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
//        imageBytes = malloc(320 * 480 * 4);
//        CGContextRef context = CGBitmapContextCreate(imageBytes, 320, 480, 8, 320 * 4, colorspace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
//        CGColorSpaceRelease(colorspace);
////        UIApplication *application = 
//        
//        for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
//            CGRect bounds = [window bounds];
//            CALayer *layer = [window layer];
//            CGContextSaveGState(context);
//            if ([layer contentsAreFlipped]) {
//                CGContextTranslateCTM(context, 0.0f, bounds.size.height);
//                CGContextScaleCTM(context, 1.0f, -1.0f);
//            }
//            [layer renderInContext:(CGContextRef)context];
//            CGContextRestoreGState(context);
//        }
//        cgImage = CGBitmapContextCreateImage(context);
//        CGContextRelease(context);
//    }
//    NSData *pngData = UIImagePNGRepresentation([UIImage imageWithCGImage:cgImage]);
//    CGImageRelease(cgImage);
//    if (imageBytes)
//        free(imageBytes);
//    [pngData writeToFile:path atomically:YES];
//}
- (void)showImage:(NSString*)urlStr{
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    NSURL *url=[NSURL URLWithString:urlStr];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
        UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
        NSLog(@"%p", image);
    }failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }
     ];
}

-(void)getImgs{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    
                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    /*result.defaultRepresentation.fullScreenImage//图片的大图
                     result.thumbnail                             //图片的缩略图小图
                     //                    NSRange range1=[urlstr rangeOfString:@"id="];
                     //                    NSString *resultName=[urlstr substringFromIndex:range1.location+3];
                     //                    resultName=[resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];//格式demo:123456.png
                     */
                    
                    if (_dataArray == nil) {
                        _dataArray = [NSMutableArray array];
                    }
                    [_dataArray addObject:urlstr];
                    
                    if (urlstr) {
                        [self showImage:urlstr];
                    }
                }
            }
            
        };
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            
            if (group == nil)
            {
                
            }
            
            if (group!=nil) {
//                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
//                NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
//                
//                NSString *g1=[g substringFromIndex:16 ] ;
//                NSArray *arr=[[NSArray alloc] init];
//                arr=[g1 componentsSeparatedByString:@","];
//                NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
//                if ([g2 isEqualToString:@"Camera Roll"]) {
//                    g2=@"相机胶卷";
//                }
//                NSString *groupName=g2;//组的name
                
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
                
            }
            
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
    });
    
}

//------------------------根据图片的url反取图片－－－－－

//ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
//NSURL *url=[NSURL URLWithString:urlStr];
//[assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
//    UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
//    cellImageView.image=image;
//    
//}failureBlock:^(NSError *error) {
//    NSLog(@"error=%@",error);
//}
// ];
//－－－－－－－－－－－－－－－－－－－－－
@end
