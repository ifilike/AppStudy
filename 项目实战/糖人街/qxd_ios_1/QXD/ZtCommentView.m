//
//  ZtCommentView.m
//  QXD
//
//  Created by wzp on 16/1/31.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "ZtCommentView.h"
#import "CommentWithStarsTableViewCell.h"
#import "CommentModel.h"

@implementation ZtCommentView



- (instancetype)initWithFrame:(CGRect)frame withModelArr:(NSMutableArray*)modelArr{

    self=[super initWithFrame:frame];
    if (self) {
        self.commentModelArr=[NSMutableArray arrayWithCapacity:1];
        self.cellHighArr=[NSMutableArray arrayWithCapacity:1];
        
        
        for (CommentModel * model in modelArr) {
           float  hh= [self getHeightWithStr:model.comment_content];
            if (hh>90*PROPORTION_WIDTH) {
                NSString * height=[NSString stringWithFormat:@"%f",hh];
                [self.cellHighArr addObject:height];
            }else{
                NSString * height=[NSString stringWithFormat:@"%f",90*PROPORTION_WIDTH];
                [self.cellHighArr addObject:height];
            }
        }
        
        
        [_commentModelArr removeAllObjects];
        for (int i=0; i<modelArr.count; i++) {
            CommentModel * model=modelArr[i];
            [_commentModelArr addObject:model];
        }
        self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.scrollEnabled=NO;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        
        self.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    }
    return self;

}



- (float)getHeightWithStr:(NSString*)content{

    UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH-61*PROPORTION_WIDTH-23*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
    label.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    label.numberOfLines=0;
    [self addSubview:label];
    label.alpha=0;
    NSString * labelText =content;
    //设置行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    //    NSLog(@"%f",_commentLabel.frame.size.height);
    [label sizeToFit];
    
    if (label.frame.size.height+34*PROPORTION_WIDTH>90*PROPORTION_WIDTH) {
        return label.frame.size.height+34*PROPORTION_WIDTH;
        
    }else{
        return 90*PROPORTION_WIDTH;
    }


}


- (void)reloadDataWithModelArr:(NSMutableArray*)commentModelArr{
    [_commentModelArr removeAllObjects];
    self.frameH=0;
    
    
    for (CommentModel * model in commentModelArr) {
        
        [_commentModelArr addObject:model];
        
    }
    [self.cellHighArr removeAllObjects];
    for (int i=0; i<_commentModelArr.count; i++) {
        CommentModel * model=_commentModelArr[i];
        float high=[self getHeightWithStr:model.comment_content];
        self.frameH+=high;
        NSString * hight=[NSString stringWithFormat:@"%f",high];
        
        [self.cellHighArr addObject:hight];
    }
    
    [self.tableView reloadData];
    self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.frameH);
   // self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frameH);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentModelArr.count;
//    return self.commentModelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentWithStarsTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"rr"];
    if (cell==nil) {
        cell=[[CommentWithStarsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rr"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
       // cell.backgroundColor=[UIColor greenColor];
    }
    CommentModel * model=self.commentModelArr[indexPath.row];
    
    [cell setZTCommentModel:model];
//    NSLog(@"%f",cell.cellHigh);
//    if (cell.cellHigh>90*PROPORTION_WIDTH) {
//        NSString * height=[NSString stringWithFormat:@"%f",cell.cellHigh];
//        [self.cellHighArr removeObjectAtIndex:indexPath.row];
//        [self.cellHighArr insertObject:height atIndex:indexPath.row];
//        
//    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * height=self.cellHighArr[indexPath.row];
    float high=[height floatValue];
    if (high>90*PROPORTION_WIDTH) {
      //  self.frameH+=high;
       // NSLog(@"_____________%f",self.frameH);

        return high;
        
    }else{
       // self.frameH+=90*PROPORTION_WIDTH;
       // NSLog(@"++++++++%f",self.frameH);

        return 90*PROPORTION_WIDTH;
    }

}

//- (void)changeHeight{
//    self.frameH=0;
//    for (int i=0; i<4; i++) {
//        NSString * high=self.cellHighArr[i];
//        float hh=[high floatValue];
//        if (hh>90*PROPORTION_WIDTH) {
//            
//            self.frameH+=hh;
//        }else{
//            hh=90*PROPORTION_WIDTH;
//            self.frameH+=hh;
//
//        }
//
//    }
//    NSLog(@"%f",self.frameH);
//
//    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frameH);
//    
//    
//}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
