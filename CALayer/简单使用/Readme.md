-----------------CALayer-------------------

1. 简介

* 其实UIView之所以能显示在屏幕上，完全是因为它内部的一个层。

* 在创建UIView对象时，UIView内部会自动创建一个层(即CALayer对象)，通过UIView的layer属性可以访问这个层。当UIView需要显示到屏幕上时，会调用drawRect:方法进行绘图，并且会将所有内容绘制在自己的层上，绘图完毕后，系统会将层拷贝到屏幕上，于是就完成了UIView的显示。

* 换句话说，UIView本身不具备显示的功能，是它内部的层才有显示功能。

2. 选择

* 其实，对比CALayer，UIView多了一个事件处理的功能。也就是说，CALayer不能处理用户的触摸事件，而UIView可以

* 所以，如果显示出来的东西需要跟用户进行交互的话，用UIView；如果不需要跟用户进行交互，用UIView或者CALayer都可以

* 当然，CALayer的性能会高一些，因为它少了事件处理的功能，更加轻量级

3. 属性

* position和anchorPoint属性都是CGPoint类型的

* position可以用来设置CALayer在父层中的位置，它是以父层的左上角为坐标原点(0, 0)

* anchorPoint称为"定位点"，它决定着CALayer身上的哪个点会在position属性所指的位置。它的x、y取值范围都是0~1，默认值为(0.5, 0.5)

4. 使用
* 方法描述：创建一个CALayer的子类，然后覆盖drawInContext:方法，使用Quartz2D API进行绘图
* 方法描述：设置CALayer的delegate，然后让delegate实现drawLayer:inContext:方法，当CALayer需要绘图时，会调用delegate的drawLayer:inContext:方法进行绘图。