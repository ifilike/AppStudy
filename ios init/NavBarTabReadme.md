1. Navagation导致布局从64开始计算 解决办法
    1.这句话的意思就是让导航栏不透明且占空间位置，所以我们的坐标就会从导航栏下面开始算起。
    self.navigationController.navigationBar.translucent = NO;
    2.解决办法就是先判断在使用，可以通过判断系统版本，也可以通过判断方法是否可使用
<!--    edgesForExtendedLayout默认的值是UIRectEdgeAll就是全部布局的意思，改成UIRectEdgeNone就会和ios7一起的系统版本一样的效果-->
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    3. 为ios7单独定制位置,通过判断系统版本，个性为ios7定制位置
    const BOOL is_ios7 = [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0;
    int y= is_ios7 ? 64 : 0;
    NSLog(@"%d",y);