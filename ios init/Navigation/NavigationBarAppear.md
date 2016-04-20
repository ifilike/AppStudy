//导航栏出现的状态 放在appdelegate中可控制全部的controller 实现统一布局navigation
1. tabBar出现 的时候
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"8f8f8f"]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : YRedColor} forState:UIControlStateSelected];
2. navigation出现的时候
    Bar的设置
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationHead"] forBarMetrics:(UIBarMetricsDefault)];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName :[UIFont boldSystemFontOfSize:20]}];

    // [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    Item的设置
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor]; //设置箭头的颜色，字体的颜不可以设置需要在Navigation中这只可以自定义navigation中统一设置见代码ZJNavigationController.m
    //[[UIBarButtonItem appearance]setBackButtonBackgroundImage:[UIImage imageNamed:@"yitemback"] forState:(UIControlStateNormal) barMetrics:UIBarMetricsDefault];
    // [UIBarButtonItem appearance]. = [UIImage imageNamed:@"yitemback"];
    // [[UINavigationBar appearance].backItem.backBarButtonItem setImage:[UIImage imageNamed:@"yitemback"]];
    // [[UIBarButtonItem appearance]setBackButtonBackgroundImage:[UIImage imageNamed:@"yitemback"]  forState:(UIControlStateNormal) barMetrics:UIBarMetricsDefault];


//统一布局navigation后 若要单独控制某一个controller 中的navigation可使用下面的方法控制
    titleBt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [titleBt setTitle:@"项目" forState:(UIControlStateNormal)];
    [titleBt setImage:[UIImage imageNamed:@"xiajiantou"] forState:(UIControlStateNormal)];
    [titleBt setImage:[UIImage imageNamed:@"shangjiantou"] forState:(UIControlStateSelected)];
    titleBt.titleLabel.font = YBFont(20);
    [titleBt setTitleEdgeInsets:(UIEdgeInsetsMake(0, 5, 5, 25))];
    [titleBt setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 5, -70)];

    titleBt.frame = CGRectMake(0, 0, 100, 30);

    [titleBt addTarget:self action:@selector(titleBtClick:) forControlEvents:(UIControlEventTouchUpInside)];
    titleBt.selected = NO;

    self.navigationItem.titleView = titleBt;

    //搜索按钮
    UIButton *searchBt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [searchBt setImage:[UIImage imageNamed:@"search_bt"] forState:(UIControlStateNormal)];

    searchBt.frame = CGRectMake(0, 0, 25, 25);
    [searchBt addTarget:self action:@selector(searchBtClick) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:searchBt];

    //浏览足迹按钮
    UIButton *scanBt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [scanBt setImage:[UIImage imageNamed:@"scan_bt"] forState:(UIControlStateNormal)];
    scanBt.frame = CGRectMake(0, 0, 25, 25);
    [scanBt addTarget:self action:@selector(scanBtClick) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:scanBt];

    self.navigationItem.rightBarButtonItems = @[item2,item1];