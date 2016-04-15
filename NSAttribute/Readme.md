=============================系统表情===================================

--------------------NSString+Emoji---------------——

字符串添加额外的表情功能
用途就是：
系统的表情转化为字符串：当向服务器上传系统表情时候可以将用户输入的表情符号转化为字符串（:smile:）
或者将字符创转化为表情；当从服务器获取到的字符串可以将服务器里的字符串转化为系统输入法的表情（😄）

可以直接调用这份方法防止用户输入表情，当没有输入的表情的时候回不做任何操作当有表情的时候回替换


=============================自定义表情===================================

利用NSString+Emoji的思想我们可以也给字符串添加扩展，用[微笑]来替代自定义微笑😃表情.
    从而实现上传到服务器也可以类似的实现逆向转化

=========================label的字体===== NSAttributeString =================================
1. label字体的自适配高度 CGRect和CGSize
2. label字体的自适应高度 sizeToFit和sizeThatFits
3. lable字体的大小颜色字间距行间距下划线中划线等

扩展 下划线的另一种实现方法
继承label然后重绘
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize fontSize =[self.text sizeWithFont:self.font
    forWidth:self.frame.size.width
    lineBreakMode:NSLineBreakByTruncatingTail];

    CGContextSetStrokeColorWithColor(ctx, self.textColor.CGColor);  // set as the text's color
    CGContextSetLineWidth(ctx, 2.0f);

    CGPoint leftPoint = CGPointMake(0,
    self.frame.size.height);
    CGPoint rightPoint = CGPointMake(self.frame.size.width,
    self.frame.size.height);
    CGContextMoveToPoint(ctx, leftPoint.x, leftPoint.y);
    CGContextAddLineToPoint(ctx, rightPoint.x, rightPoint.y);
    CGContextStrokePath(ctx);
}