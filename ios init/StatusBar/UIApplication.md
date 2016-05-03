
#warming
------
View controller-based status bar appearance 设置为NO;
------
//隐藏状态栏
[UIApplication sharedApplication].statusBarHidden = YES;
//状态栏的文字颜色 statusBarStyle 类型可以改变相对应的颜色
[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

--------------------
还有一种就是通过导航栏来控制
--------------------
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
当需要给以上方法改变返回值是可以调用这个方法刷新
[self setNeedsStatusBarAppearanceUpdate];

--------------------
控制器中，当没有导航栏的时候上面的方法试用于控制器VC，这时候我们试用VC的导航栏进而控制如
--------------------
[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];//白色的

**************启动页的导航栏****************
1.隐藏导航栏
在<AppName>-info.plist 文件中加入选项 "Status bar is initially hidden", 值为 YES
2.显示白色导航栏

--------------------
状态栏菊花
--------------------
[UIApplication sharedApplication].networkActivityIndicatorVisible = YES；