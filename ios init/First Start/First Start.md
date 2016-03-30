===========提醒用户更新版本============
在application didFinishLaunchiing中调用[self VersionButton];
-(void)VersionButton{
    //获取发布版本的Version
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=123456789"] encoding:NSUTF8StringEncoding error:nil];
    if (string != nil && [string length] > 0 && [string rangeOfString:@"version"].length == 7) {
        [self checkAppUpdate:string];
    }
}

-(void)checkAppUpdate:(NSString *)appInfo{
    //获取当前版本
    NSString *version = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
    NSString *appInfo1 = [appInfo substringFromIndex:[appInfo rangeOfString:@"\"version\":"].location + 10];
    appInfo1 = [[appInfo1 substringToIndex:[appInfo1 rangeOfString:@","].location]stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    /**
    *   判断，如果当前版本与发布的版本不相同，则进入更新，如果相等，那么久是最高版本
    */
    if (![appInfo1 isEqualToString:version]) {
        NSLog(@"新版本:%@,当前版本%@",appInfo1,version);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"新版本 已发布" delegate:self.class cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        alert.delegate = self;
        [alert addButtonWithTitle:@"前往更新"];
        [alert show];
        alert.tag = 20;
    }else{
        [[[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self.class cancelButtonTitle:@"" otherButtonTitles:nil, nil]show];
    }
}
#pragma mark --- UIAlertView代理 ---
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 && alertView.tag == 20) {
        NSString *url = @"https://itunes.apple.com/cn/app/che-ling-ling-fu-wu-ban/id1234567?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}


===========第一次启动============
在application didFinishLaunchiing中调用self.window.rootViewController = [self chooseFirstVC];
#pragma mark -- choose firstVC
-(UIViewController *)choseFirstVC{
    NSString *key = (__bridge NSString *)kCFBundleVersionKey;

    // 1. 获取当前软件版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 2. 沙盒中的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *standBoxVersion = [defaults valueForKey:key];
    // 3. 比较当前版本号 与沙盒版本号
    BOOL versionStatus = [currentVersion compare:standBoxVersion] == NSOrderedDescending;
    // 4. 根据版本号 判断下一级页面
    if (versionStatus) {
        // 保存版本号到手机沙盒
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];//防止没有保存

        ZJWelcomeViewController *welcome = [[ZJWelcomeViewController alloc] init];
        return welcome;
    }else{
        ZJTabBarViewController *zjTabBar = [[ZJTabBarViewController alloc] init];
        return zjTabBar;
    }
}

===========启动页无动画的scrollView============

-(void)creatUI{
    NSArray *imageNameArray = @[@"welcome1",@"welcome2",@"welcome3"];
    for (int i = 0; i < imageNameArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WINSIZEWIDTH * i, 0, WINSIZEWIDTH, WINSIZEHEIGHT)];
        imageView.image = [UIImage imageNamed:imageNameArray[i]];
        [self.scrollView addSubview:imageView];
// 添加跳转到tabbar
        if (i == imageNameArray.count - 1) {
            UIButton *scaleBtn = [[UIButton alloc] initWithFrame:imageView.frame];
            [scaleBtn addTarget:self action:@selector(scanle) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:scaleBtn];
            scaleBtn.backgroundColor = [UIColor clearColor];
        }
    }
    [self.view addSubview:self.scrollView];
}
-(void)scanle{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[ZJTabBarViewController alloc] init];
}

===========启动页有动画的且有时间倒计时的============

待完善......



