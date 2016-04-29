//
//  HeadScrollView.m
//  QXD
//
//  Created by wzp on 15/12/8.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "HeadScrollView.h"
#import "ImagedataModel.h"




#define WiDtH self.frame.size.width
#define HeIgHt self.frame.size.height

@implementation HeadScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame withImageUrlArr:(NSMutableArray*)imageUrlArr{
    self=[super initWithFrame:frame];
    if (self) {
        self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.scrollEnabled=YES;
        self.scrollView.contentSize=CGSizeMake(frame.size.width*3, frame.size.height);
        self.scrollView.showsVerticalScrollIndicator=NO;
        self.scrollView.showsHorizontalScrollIndicator=YES;
        self.scrollView.bounces=NO;
        self.scrollView.pagingEnabled=YES;
        self.scrollView.delegate=self;
        self.scrollView.contentOffset=CGPointMake(frame.size.width, 0);
        self.imageButArr=[NSMutableArray arrayWithCapacity:1];

        [self getImagesWithImageUrlArr:imageUrlArr];
        if ([self.imageArr count]==1) {
            
            self.scrollView.contentSize=CGSizeMake(WiDtH,HeIgHt);
            ImagedataModel * imageModel=self.imageArr[0];
            UIButton * imageBut=[self getImageButtonWithModel:imageModel];
            imageBut.frame=CGRectMake(WiDtH, 0, WiDtH, HeIgHt);
            [self.scrollView addSubview:imageBut];
            [self.imageButArr addObject:imageBut];

        }else if ([self.imageArr count]==2){

            for (int i=0; i<3; i++) {
                if (i==2) {
                    ImagedataModel * imageModel=self.imageArr[0];
                    UIButton * imageBut=[self getImageButtonWithModel:imageModel];
                    imageBut.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                    [self.scrollView addSubview:imageBut];
                    [self.imageButArr addObject:imageBut];
                }else{
                    ImagedataModel * imageModel=self.imageArr[i];
                    UIButton * imageBut=[self getImageButtonWithModel:imageModel];
                    imageBut.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                    [self.scrollView addSubview:imageBut];
                    [self.imageButArr addObject:imageBut];
                }
            }
        }else if([self.imageArr count]>=3){

            for (int i=0; i<3; i++) {
                ImagedataModel * imageModel=self.imageArr[i];
                UIButton * imageBut=[self getImageButtonWithModel:imageModel];
                imageBut.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                [self.scrollView addSubview:imageBut];
                [self.imageButArr addObject:imageBut];

            }
        }
        [self addSubview:self.scrollView];
    }
    return self;
}
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    CGFloat offset=self.scrollView.contentOffset.x;
    //向左滑动
    if (offset==WiDtH*2) {
        //数组元素个数==2
        if ([self.imageArr count]==2) {
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
                    UIButton * imageBut=[self getImageButtonWithModel:imageModel];
                    imageBut.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                    [self.scrollView addSubview:imageBut];
                    [self.imageButArr addObject:imageBut];
                }else{
                    ImagedataModel * imageModel=self.imageArr[i];
                    UIButton * imageBut=[self getImageButtonWithModel:imageModel];
                    imageBut.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                    [self.scrollView addSubview:imageBut];
                    [self.imageButArr addObject:imageBut];
                }
            }
            [self.delegate addButtonEvent];
        }else if([self.imageArr count]>=3){
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
                UIButton * imageBut=[self getImageButtonWithModel:imageModel];
                imageBut.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                [self.scrollView addSubview:imageBut];
                [self.imageButArr addObject:imageBut];
//                NSLog(@"现在添加了%lu个子视图",(unsigned long)[self.imageButArr count]);
            }
            [self.delegate addButtonEvent];

        }
        self.scrollView.contentOffset=CGPointMake(WiDtH, 0);
    }else if (offset==0){
    //向右滑动
        if ([self.imageArr count]==2) {
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
                    UIButton * imageBut=[self getImageButtonWithModel:imageModel];
                    imageBut.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                    [self.scrollView addSubview:imageBut];
                    [self.imageButArr addObject:imageBut];
//                    NSLog(@"现在添加了%lu个子视图",(unsigned long)[self.imageButArr count]);
                }else{
                    ImagedataModel * imageModel=self.imageArr[i];
                    UIButton * imageBut=[self getImageButtonWithModel:imageModel];
                    imageBut.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                    [self.scrollView addSubview:imageBut];
                    [self.imageButArr addObject:imageBut];
//                    NSLog(@"现在添加了%lu个子视图",(unsigned long)[self.imageButArr count]);
                }
            }
            [self.delegate addButtonEvent];

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
                UIButton * imageBut=[self getImageButtonWithModel:imageModel];
                imageBut.frame=CGRectMake(WiDtH*i, 0, WiDtH, HeIgHt);
                [self.scrollView addSubview:imageBut];
                [self.imageButArr addObject:imageBut];
//                NSLog(@"现在添加了%lu个子视图",(unsigned long)[self.imageButArr count]);
            }
            [self.delegate addButtonEvent];

        }
        self.scrollView.contentOffset=CGPointMake(WiDtH, 0);
    }
}
- (void)nextImage{
    self.scrollView.contentOffset=CGPointMake(WiDtH*2, 0);
    NSLog(@"滑动了一次");
}
//根据图片网址数组更新数据
- (void)upDataWithImageUrlStringArr:(NSMutableArray*)ImageUrlStringArr{
    [self getImagesWithImageUrlArr:ImageUrlStringArr];
    self.scrollView.contentOffset=CGPointMake(0, 0);
    
}

//移除全部子视图
- (void)removeAllSubViews{
    [self.imageButArr removeAllObjects];
//    NSLog(@"现在还剩下%lu个子视图",(unsigned long)[self.imageButArr count]);

    for (UIButton * button in [self.scrollView subviews]) {
        [button removeFromSuperview];
    }
}
//根据Model获得Button
- (UIButton*)getImageButtonWithModel:(ImagedataModel*)model{
    UIButton * imageBut=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, WiDtH, HeIgHt)];
    UIImage * image=[self getimageWithData:model.imageData];
    [imageBut setImage:image forState:0];
    imageBut.tag=model.tag;
    return imageBut;
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
//根据网址获得图片的NSData
- (NSData*)getImageDataWithUrlString:(NSString*)urlString{
//    NSLog(@"图片网址 %@",urlString);
    NSURL * url=[NSURL URLWithString:urlString];
    NSData * data=[NSData dataWithContentsOfURL:url];
    return data;
}
//根据NSData获得图片
- (UIImage*)getimageWithData:(NSData*)data{
    UIImage * image=[UIImage imageWithData:data];
    return image;
}



@end
