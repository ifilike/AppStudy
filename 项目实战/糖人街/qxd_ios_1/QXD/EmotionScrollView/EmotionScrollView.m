//
//  EmotionScrollView.m
//  WeiSheFramework
//
//  Created by temp on 15/8/9.
//
//

#import "EmotionScrollView.h"
#import "UIImage+GIF.h"

#define kEmotionWH 30
#define kEmotionCount 97

@interface EmotionScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;    /**< scrollView */
@property (nonatomic, strong) UIPageControl *pageControl;    /**< pageControl */


@end

@implementation EmotionScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupData];
        self.backgroundColor=[self colorWithHexString:@"#DDDDDD"];
        
    }
    return self;
}

- (void)setupData{
    
    // 初始化pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, WIDTH, 20)];
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self addSubview:self.pageControl];
    
    // 初始化scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width*5, self.frame.size.height);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    int name=1,page=1;
    float x=10+self.frame.size.width*(page-1), y=0, h=1;
    for (int i=1; i<=102; i++) {
        NSLog(@"现在是第%d页  第%f行 : 第%d个",page,h,i);
        NSLog(@"%f  %f",x,y);
        NSString * imageName =[NSString stringWithFormat:@"em_%d",name];
        NSString * emotionName = [NSString stringWithFormat:@"[em_%d]",name];
        
        UIImage * image=[UIImage imageNamed:imageName];
        
        if (i==102) {
            UIButton * imageView=[[UIButton alloc] initWithFrame:CGRectMake(x, y, 28, 28)];
            imageView.backgroundColor=[UIColor cyanColor];
            [self.scrollView addSubview:imageView];
        }else{
            if (i%21!=0) {
                if (i%7!=0) {
                    UIButton *emotionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [emotionBtn setBackgroundImage:image forState:0];
                    [emotionBtn addTarget:self action:@selector(selectedEmotionBtn:) forControlEvents:UIControlEventTouchUpInside];
                    emotionBtn.frame = CGRectMake(x, y, 30, kEmotionWH);
                    [emotionBtn setTitle:emotionName forState:0];
                    [emotionBtn setTitleColor:[UIColor clearColor] forState:0];
                    [self.scrollView addSubview:emotionBtn];
                    x+=40;
                    name+=1;
                }else if(i%7==0){
                    UIButton *emotionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [emotionBtn setBackgroundImage:image forState:0];
                    [emotionBtn addTarget:self action:@selector(selectedEmotionBtn:) forControlEvents:UIControlEventTouchUpInside];
                    emotionBtn.frame = CGRectMake(x, y, 30, kEmotionWH);
                    [emotionBtn setTitle:emotionName forState:0];
                    [emotionBtn setTitleColor:[UIColor clearColor] forState:0];
                    
                    [self.scrollView addSubview:emotionBtn];
                    x=10+self.frame.size.width*(page-1);
                    y+=40;
                    name+=1;                }
            }else if(i%21==0){
                UIButton * imageView=[[UIButton alloc] initWithFrame:CGRectMake(x, y, 30, 30)];
                imageView.backgroundColor=[UIColor cyanColor];
                [self.scrollView addSubview:imageView];
                page+=1;
                x=10+self.frame.size.width*(page-1);
                y=0;
                
            }
        }
        
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / WIDTH;
}

- (void)selectedEmotionBtn:(UIButton *)emotionBtn
{
    if ([self.delegate respondsToSelector:@selector(emotionScrollView:selected:)]) {
        [self.delegate emotionScrollView:self selected:emotionBtn];
    }
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

@end
