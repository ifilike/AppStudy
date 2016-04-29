//
//  WithLabelImageScrollView.m
//  QXD
//
//  Created by wzp on 15/12/14.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "WithLabelImageScrollView.h"
#import "ImagedataModel.h"




#define WiDtH self.frame.size.width
#define HeIgHt self.frame.size.height


@implementation WithLabelImageScrollView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
}




- (instancetype)initWithFrame:(CGRect)frame labelArr:(NSArray*)labelArr imageStringArr:(NSMutableArray*)imageStringArr{
    self=[super initWithFrame:frame];
    if (self) {
        //添加一个滚动试图
        self.imageScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageScrollView.delegate=self;
        self.imageScrollView.contentSize=CGSizeMake(frame.size.width*3, frame.size.height);

        _imageScrollView.pagingEnabled=YES;
        _imageScrollView.bounces=NO;
        [self addSubview:_imageScrollView];
        [self getImagesWithImageUrlArr:imageStringArr];
        
        _count2=(int)[imageStringArr count];
        _currentNum=0;

        //添加一个显示图片个数的控制器
        _scrollPage=[[UIPageControl alloc] initWithFrame:CGRectMake(0, HeIgHt-30, WIDTH, 25)];
        _scrollPage.currentPageIndicatorTintColor=[self colorWithHexString:@"#FD681F"];
        _scrollPage.pageIndicatorTintColor=[self colorWithHexString:@"#DDDDDD"];
        _scrollPage.numberOfPages=_count2;
        _scrollPage.currentPage=_currentNum;
        [self addSubview:_scrollPage];
        
        
//        //添加一个显示图片数量的Label
//        self.numLabel=[[UILabel alloc] initWithFrame:CGRectMake(WiDtH-60, 10, 50, 30)];
//        [self addSubview:_numLabel];
//        
//        _count2=(int)[imageStringArr count];
//        _currentNum=1;
//        NSString * currentNum=[NSString stringWithFormat:@"%d",_currentNum];
//        NSString * allNum=[NSString stringWithFormat:@"%@%d",@"/",_count2];
//        _numLabel.text=[currentNum stringByAppendingString:allNum];
        
        
        if (_count2==1) {
            self.imageScrollView.contentSize=CGSizeMake(WiDtH,HeIgHt);
            ImagedataModel * imageModel=self.imageArr[0];

            UIImageView * imageView=[self getImageViewWithModel:imageModel];
            imageView.frame=CGRectMake(WiDtH, 0, WiDtH, HeIgHt);
            [self.imageScrollView addSubview:imageView];
        }else if (_count2==2){
            for (int i=0; i<3; i++) {
                if (i==2) {
                    ImagedataModel * imageModel=self.imageArr[0];
                    UIImageView * imageView=[self getImageViewWithModel:imageModel];
                    imageView.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                    [self.imageScrollView addSubview:imageView];

                }else{
                    ImagedataModel * imageModel=self.imageArr[i];
                    UIImageView * imageView=[self getImageViewWithModel:imageModel];
                    imageView.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                    [self.imageScrollView addSubview:imageView];
               }
            }
        }else if(_count2>=3){
            
            for (int i=0; i<3; i++) {
                ImagedataModel * imageModel=self.imageArr[i];
                UIImageView * imageView=[self getImageViewWithModel:imageModel];
                imageView.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                [self.imageScrollView addSubview:imageView];
            }
        }

        
        
        self.imageScrollView.contentOffset=CGPointMake(WiDtH, 0);
        UIView * lien=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 0.5)];
        lien.backgroundColor=[self colorWithHexString:@"#DDDDDD"];
        [self addSubview:lien];
        
    }
    return self;
    
}
- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

- (void)reloadDataWithLabelArr:(NSArray*)labelArr imageStringArr:(NSMutableArray*)imageStringArr{
    //改变图片数组
    [self changeImagesWithImageUrlArr:imageStringArr];
    //删除原有图片
    [self removeAllSubViews];
    //删除原有功效Label
//    [self removeAllLabels];
//    _count=(int)[labelArr count];
//    float setX=self.frame.size.width/25;
//    float setY=self.frame.size.height*6/8;
    //添加标签
//    for (int i=0; i<_count; i++) {
//        UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(setX, setY, self.frame.size.width/5, self.frame.size.height/12)];
//        lab.tag=i+1;
//        lab.text=labelArr[i];
//        lab.textAlignment=1;
//        lab.textColor=[UIColor blackColor];
//        lab.backgroundColor=[UIColor whiteColor];
//        lab.alpha=0.7;
//        lab.font=[UIFont systemFontOfSize:13];
//        lab.layer.borderWidth=1;
//        [self addSubview:lab];
//        if (i%4==3&&i!=_count-1) {
//            setX=self.frame.size.width/25;
//            setY+=self.frame.size.height/12+10;
//        }else{
//            setX+=self.frame.size.width*6/25;
//        }
//    }
    //改变显示数量的Label文字内容
    _count2=(int)[imageStringArr count];
    _currentNum=0;
    _scrollPage.numberOfPages=_count2;
    _scrollPage.currentPage=_currentNum;


    if (_count2==1) {
        self.imageScrollView.contentSize=CGSizeMake(WiDtH,HeIgHt);
        ImagedataModel * imageModel=self.imageArr[0];
        
        UIImageView * imageView=[self getImageViewWithModel:imageModel];
        imageView.frame=CGRectMake(WiDtH, 0, WiDtH, HeIgHt);
        [self.imageScrollView addSubview:imageView];
    }else if (_count2==2){
        for (int i=0; i<3; i++) {
            if (i==2) {
                ImagedataModel * imageModel=self.imageArr[0];
                UIImageView * imageView=[self getImageViewWithModel:imageModel];
                imageView.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                [self.imageScrollView addSubview:imageView];
                
            }else{
                ImagedataModel * imageModel=self.imageArr[i];
                UIImageView * imageView=[self getImageViewWithModel:imageModel];
                imageView.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                [self.imageScrollView addSubview:imageView];
            }
        }
    }else if(_count2>=3){
        
        for (int i=0; i<3; i++) {
            ImagedataModel * imageModel=self.imageArr[i];
            UIImageView * imageView=[self getImageViewWithModel:imageModel];
            imageView.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
            [self.imageScrollView addSubview:imageView];
        }
    }
    
    
    
    self.imageScrollView.contentOffset=CGPointMake(WiDtH, 0);

    
    
    
    
    
}


- (UIImage*)getAImageWithUrlString:(NSString*)urlString{
    NSURL * url=[NSURL URLWithString:urlString];
    NSData * data=[NSData dataWithContentsOfURL:url];
    UIImage * image=[UIImage imageWithData:data];
    return image;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    

    CGFloat offset=self.imageScrollView.contentOffset.x;
    //向左滑动
    if (offset==WiDtH*2) {
        if (_currentNum+1<_count2) {
            _currentNum+=1;
        }else{
            _currentNum=0;
        }
        //改变指示器的值
        _scrollPage.currentPage=_currentNum;
        
        //数组元素个数==2
        if (_count2==2) {
            //全部删除
            [self removeAllSubViews];
            //修改数据
            ImagedataModel * firstImageMOdel=self.imageArr[0];
            [self.imageArr removeObject:firstImageMOdel];
            [self.imageArr addObject:firstImageMOdel];
            //重新添加
            for (int i=0; i<3; i++) {
                if (i==2) {
                    ImagedataModel * imageModel=self.imageArr[0];
                    UIImageView * imageView=[self getImageViewWithModel:imageModel];
                    imageView.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                    [self.imageScrollView addSubview:imageView];
                    
                }else{
                    ImagedataModel * imageModel=self.imageArr[i];
                    UIImageView * imageView=[self getImageViewWithModel:imageModel];
                    imageView.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                    [self.imageScrollView addSubview:imageView];
                }
            }
        }else if(_count2>=3){
            //元素个数>=3
            //全部删除
            [self removeAllSubViews];
            //修改数据
            ImagedataModel * firstImageMOdel=self.imageArr[0];
            [self.imageArr removeObject:firstImageMOdel];
            [self.imageArr addObject:firstImageMOdel];
            //重新添加
            for (int i=0; i<3; i++) {
                ImagedataModel * imageModel=self.imageArr[i];
                UIImageView * imageView=[self getImageViewWithModel:imageModel];
                imageView.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                [self.imageScrollView addSubview:imageView];
            }
        }
        self.imageScrollView.contentOffset=CGPointMake(WiDtH, 0);
    }else if (offset==0){
        //向右滑动

            if (_currentNum>0) {
                _currentNum-=1;
            }else{
                _currentNum=_count2-1;
            }
        //改变指示器的值
        _scrollPage.currentPage=_currentNum;

        if (_count2==2) {
            //全部删除
            [self removeAllSubViews];
            //修改数据
            ImagedataModel * lastImageModel=[self.imageArr lastObject];
            [self.imageArr removeObject:lastImageModel];
            [self.imageArr insertObject:lastImageModel atIndex:0];
            //重新添加
            for (int i=0; i<3; i++) {
                if (i==2) {
                    ImagedataModel * imageModel=self.imageArr[0];
                    UIImageView * imageView=[self getImageViewWithModel:imageModel];
                    imageView.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                    [self.imageScrollView addSubview:imageView];
                    
                }else{
                    ImagedataModel * imageModel=self.imageArr[i];
                    UIImageView * imageView=[self getImageViewWithModel:imageModel];
                    imageView.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                    [self.imageScrollView addSubview:imageView];
                }
            }
            
        }else if([self.imageArr count]>=3){
            //全部删除
            [self removeAllSubViews];
            //修改数据
            ImagedataModel * lastImageModel=[self.imageArr lastObject];
            [self.imageArr removeObject:lastImageModel];
            [self.imageArr insertObject:lastImageModel atIndex:0];
            //重新添加
            for (int i=0; i<3; i++) {
                ImagedataModel * imageModel=self.imageArr[i];
                UIImageView * imageView=[self getImageViewWithModel:imageModel];
                imageView.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                [self.imageScrollView addSubview:imageView];
            }
            
        }
        self.imageScrollView.contentOffset=CGPointMake(WiDtH, 0);
    }

    
    
    
}

- (void)removeAllSubViews{
    for (UIImageView * button in [self.imageScrollView subviews]) {
        [button removeFromSuperview];
    }
}
//根据图片网址数组获得NSData数组
- (void)getImagesWithImageUrlArr:(NSMutableArray*)imageUrlArr{
    self.imageArr=[NSMutableArray arrayWithCapacity:1];
    int count=(int)[imageUrlArr count];
    for (int i=0; i<count; i++) {
        NSString * urlString=imageUrlArr[i];
        ImagedataModel * imageModel=[[ImagedataModel alloc] init];
        imageModel.imageData=[self getImageDataWithUrlString:urlString];
        imageModel.tag=i+1;
        NSLog(@"%d",imageModel.tag);
        [self.imageArr addObject:imageModel];
    }
}
//根据新的图片网址数组获得NSData数组
- (void)changeImagesWithImageUrlArr:(NSMutableArray*)imageUrlArr{
    [self.imageArr removeAllObjects];
    int count=(int)[imageUrlArr count];
    for (int i=0; i<count; i++) {
        NSString * urlString=imageUrlArr[i];
        ImagedataModel * imageModel=[[ImagedataModel alloc] init];
        imageModel.imageData=[self getImageDataWithUrlString:urlString];
        imageModel.tag=i+1;
        NSLog(@"%d",imageModel.tag);
        [self.imageArr addObject:imageModel];
    }
}

//根据Model获得imageView
- (UIImageView*)getImageViewWithModel:(ImagedataModel*)model{
    UIImageView * imageBut=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WiDtH, HeIgHt)];
    

    [imageBut sd_setImageWithURL:model.imageData];
    imageBut.tag=model.tag;
    return imageBut;
}
//根据网址获得图片的NSData
- (NSURL*)getImageDataWithUrlString:(NSString*)urlString{
    NSLog(@"图片网址 %@",urlString);
    NSURL * url=[NSURL URLWithString:urlString];
    return url;
}
//根据NSData获得图片
- (UIImage*)getimageWithData:(NSData*)data{
    UIImage * image=[UIImage imageWithData:data];
    return image;
}


@end
