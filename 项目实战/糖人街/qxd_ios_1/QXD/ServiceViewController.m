//
//  ServiceViewController.m
//  QXD
//
//  Created by zhujie on 平成28-01-19.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "ServiceViewController.h"
#import "ProductInfoModel.h"
#import "CalucateTableViewCell.h"
#import "FriendsModel.h"
#import "UserID.h"
#import "UserIDModle.h"



@interface ServiceViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *dataArray1;
@property(nonatomic,strong) NSArray *dataArray2;
@property(nonatomic,strong) NSArray *dataArray3;
@property(nonatomic,strong) UITextView *resoneTextView;//退货原因
@property(nonatomic,assign) BOOL isEdit;//退货原因有没有编辑

@property(nonatomic,strong) UserIDModle *userModle;

@property(nonatomic,strong) UIView *iconV;//四个按钮的底层视图
@property(nonatomic,assign) NSInteger tagWithBtn;//四个按钮的tag值
@property(nonatomic,strong) UIImage *image1;
@property(nonatomic,strong) UIImage *image2;
@property(nonatomic,strong) UIImage *image3;
@property(nonatomic,strong) UIImage *image4;

@property(nonatomic,strong) UIImageView *imageV1;
@property(nonatomic,strong) UIImageView *imageV2;
@property(nonatomic,strong) UIImageView *imageV3;
@property(nonatomic,strong) UIImageView *imageV4;

@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) NSMutableArray *pickerDataArray;
@property(nonatomic,strong) NSString *pickerString;//纪录选择的数据
@property(nonatomic,assign) BOOL isPickerImag;//是否是从图片选择 重新刷新的
@property(nonatomic,strong) UIButton * serviceBtn;//拥有全局的提交按钮

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatNav];
    self.tableView.showsVerticalScrollIndicator = NO;
}




#pragma mark --- 代理 ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.dataArray objectAtIndex:section];
    return array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 130*PROPORTION_WIDTH;
    }
    if (section == 2) {
        return 0.1*PROPORTION_WIDTH;
    }
    return 15*PROPORTION_WIDTH;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return 43*PROPORTION_WIDTH;
    }
    return 0.1*PROPORTION_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 130*PROPORTION_WIDTH;
    }
    if (indexPath.section == 1) {
        return 53*PROPORTION_WIDTH;
    }
    return 220*PROPORTION_WIDTH;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CalucateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ser"];
        if (!cell) {
            cell = [[CalucateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ser"];
        }
        NSArray *array1 = [self.dataArray objectAtIndex:indexPath.section];
        for (ProductInfoModel *modd  in array1) {
            FriendsModel *modle = [[FriendsModel alloc] init];
            modle.customer_id = @"";
            modle.ID = @"";
            modle.product_id = modd.ID;
            modle.product_img = modd.product_img1;
            modle.product_name = modd.product_name;
            modle.product_num = self.product_num;
            modle.product_price = modd.product_present_price;
            modle.product_standard = modd.product_standard;
            
            
            [cell configCellWithShopCarModel:modle];
        }
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serviceell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"serviceCell"];
        }
        NSArray *arraya = [self.dataArray objectAtIndex:indexPath.section];
        NSString *string = [arraya objectAtIndex:indexPath.row];
        cell.textLabel.text = string;
        cell.textLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        cell.textLabel.textColor = [self colorWithHexString:@"#555555"];
        //添加
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W - 115*PROPORTION_WIDTH, 15, 100*PROPORTION_WIDTH, 23*PROPORTION_WIDTH)];
        detailLabel.backgroundColor = [UIColor whiteColor];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.textColor = [self colorWithHexString:@"FD681F"];
        detailLabel.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        
        
        if (indexPath.row == 0) {
            detailLabel.frame = CGRectMake(SCREEN_W - 145*PROPORTION_WIDTH, 15, 100*PROPORTION_WIDTH, 23*PROPORTION_WIDTH);
            detailLabel.text = [NSString stringWithFormat:@"%ld",[self.pickerString integerValue]];
            
            UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W - 35, 18*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, 15*PROPORTION_WIDTH)];
            iconImg.image = [UIImage imageNamed:@"arrow_icon_icon"];
            [cell addSubview:iconImg];
        }else{
            detailLabel.text = [NSString stringWithFormat:@"￥%.2f",([self.product_price floatValue] *[self.pickerString intValue])];
        }
        [cell addSubview:detailLabel];
        
        return cell;
        
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serviceCel"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"serviceCel"];
    }
    [cell addSubview:[self serviceView]];
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 43*PROPORTION_WIDTH)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 0, SCREEN_W - 40*PROPORTION_WIDTH, 43*PROPORTION_WIDTH)];
        label.text = @"退货商品";
        label.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        label.textColor = [self colorWithHexString:@"FD681F"];
        
        [view addSubview:label];
        view.backgroundColor = [UIColor whiteColor];
        if (section == 2) {
            label.text = @"上传凭证";
        }
        return view;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 130)];
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 115)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, SCREEN_W - 30*PROPORTION_WIDTH, 15*PROPORTION_WIDTH)];
        label.text = @"退货原因";
        label.textColor = [self colorWithHexString:@"#555555"];
        label.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        
        self.resoneTextView = [[UITextView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, CGRectGetMaxY(label.frame)+10*PROPORTION_WIDTH, SCREEN_W - 30*PROPORTION_WIDTH, 60*PROPORTION_WIDTH)];
        [self boolOfText];
        self.resoneTextView.delegate = self;
        [subView addSubview:self.resoneTextView];
        [subView addSubview:label];
        subView.backgroundColor = [UIColor whiteColor];
        [view addSubview:subView];
        return view;
    }
    return nil;
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    [self.pickerView removeFromSuperview];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self.view addSubview:self.pickerView];
    }
}
#pragma mark --- picker代理 ---
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerDataArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *name = self.pickerDataArray[row];
    return name;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *name = self.pickerDataArray[row];
    self.pickerString = name;
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path,path1,nil] withRowAnimation:UITableViewRowAnimationNone];
    //    [self.tableView reloadData];
}

#pragma mark --- 打开相册 ---
-(void)picker:(UIButton *)button{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:^{
        self.tagWithBtn = button.tag;
    }];
}
#pragma mark --- 相册代理 ---
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.isPickerImag = YES;
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.tagWithBtn == 180) {
            self.image1 = image;
            self.imageV1.image =image;
        }
        if (self.tagWithBtn == 181) {
            self.image2 = image;
            self.imageV2.image =image;
        }
        if (self.tagWithBtn == 182) {
            self.image3 = image;
            self.imageV3.image =image;
        }
        if (self.tagWithBtn == 183) {
            self.image4 = image;
            self.imageV4.image =image;
        }
        //让用户感觉不到卡顿
        UIButton *btn = (UIButton *)[self.view viewWithTag:self.tagWithBtn];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        //        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((self.tagWithBtn - 180)*85*PROPORTION_WIDTH, 0, 70*PROPORTION_WIDTH, 70*PROPORTION_WIDTH)];
        //        [imgV setImage:image];
        //        [self.iconV addSubview:imgV];
        
        [self.iconV addSubview:self.imageV1];
        [self.iconV addSubview:self.imageV2];
        [self.iconV addSubview:self.imageV3];
        [self.iconV addSubview:self.imageV4];
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    self.isPickerImag = YES;
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"_______取消");
        [self.iconV addSubview:self.imageV1];
        [self.iconV addSubview:self.imageV2];
        [self.iconV addSubview:self.imageV3];
        [self.iconV addSubview:self.imageV4];
    }];
}

#pragma mark --- 提交售后 ---
-(void)RequestService{
    
    NSData *data1 = [[NSData alloc] init];
    data1 = UIImageJPEGRepresentation(self.image1, 1);
    NSData *data2 = [[NSData alloc] init];
    data2 = UIImageJPEGRepresentation(self.image2, 1);
    NSData *data3 = [[NSData alloc] init];
    data3 =UIImageJPEGRepresentation(self.image3, 1);
    NSData *data4 = [[NSData alloc] init];
    data4 =UIImageJPEGRepresentation(self.image4, 1);
    //判断有没有填写完整数据
    if ([self.resoneTextView.text isEqualToString:@"请填写退货的原因"] || self.resoneTextView.text.length == 0 ) {
        [self.serviceBtn setTitle:@"完善信息" forState:UIControlStateNormal];
        
        return;
    }
    if ((data1.length == 0 && data2.length == 0 && data3.length == 0 && data4.length == 0)) {
        [self.serviceBtn setTitle:@"完善信息" forState:UIControlStateNormal];
        
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"正在上传图片...";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // do someting
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:InsertImage parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFormData:[self.userModle.ID dataUsingEncoding:NSUTF8StringEncoding] name:@"customer_id"];
            [formData appendPartWithFormData:[self.order_id dataUsingEncoding:NSUTF8StringEncoding] name:@"order_id"];
            [formData appendPartWithFormData:[self.resoneTextView.text dataUsingEncoding:NSUTF8StringEncoding] name:@"return_reason"];
            [formData appendPartWithFormData:[self.product_id dataUsingEncoding:NSUTF8StringEncoding] name:@"product_id"];
            [formData appendPartWithFormData:[self.pickerString dataUsingEncoding:NSUTF8StringEncoding] name:@"product_num"];
            [formData appendPartWithFormData:[self.product_price dataUsingEncoding:NSUTF8StringEncoding] name:@"product_price"];
            NSString * totalM = [NSString stringWithFormat:@"%.2f",[self.pickerString intValue] * [self.product_price floatValue]];
            [formData appendPartWithFormData:[totalM dataUsingEncoding:NSUTF8StringEncoding] name:@"total_money"];
            if (self.image1 != nil) {
                [formData appendPartWithFileData:data1 name:@"img_one" fileName:@"" mimeType:@".jpg"];
            }
            if (self.image2 != nil) {
                [formData appendPartWithFileData:data2 name:@"img_two" fileName:@"" mimeType:@".jpg"];
            }
            if (self.image3 != nil) {
                [formData appendPartWithFileData:data3 name:@"img_three" fileName:@"" mimeType:@".jpg"];
            }
            if (self.image4 != nil) {
                [formData appendPartWithFileData:data4 name:@"img_four" fileName:@"" mimeType:@".jpg"];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            float a = (float)(uploadProgress.completedUnitCount)/(uploadProgress.totalUnitCount);
            hud.progress = a ;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
                NSLog(@"成功");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"数据格式不对");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
    });
    
    
}


#pragma mark --- 布局售后 ---
-(UIView *)serviceView{
    UIView *serviceV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 220*PROPORTION_WIDTH)];
    UIView *iconV = [[UIView alloc] initWithFrame:CGRectMake(25*PROPORTION_WIDTH, 20*PROPORTION_WIDTH, SCREEN_W - 50*PROPORTION_WIDTH, 70*PROPORTION_WIDTH)];
    //四个button
    for (int i =  0 ; i<4; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*85*PROPORTION_WIDTH, 0, 70*PROPORTION_WIDTH, 70*PROPORTION_WIDTH)];
        button.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [[self colorWithHexString:@"#BBBBBB"] CGColor];
        [button setImage:[UIImage imageNamed:@"矩形-1-拷贝-2"] forState:UIControlStateNormal];
        button.tag = 180+i;
        [button addTarget:self action:@selector(picker:) forControlEvents:UIControlEventTouchUpInside];
        
        [iconV addSubview:button];
    }
    //label
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(25*PROPORTION_WIDTH, CGRectGetMaxY(iconV.frame)+20*PROPORTION_WIDTH, SCREEN_W - 50*PROPORTION_WIDTH, 12*PROPORTION_WIDTH)];
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.text = @"最多上传3张，每张不超过5M，支持JPG/BMP/PNG";
    titleL.font = [UIFont systemFontOfSize:12*PROPORTION_WIDTH];
    titleL.textColor = [self colorWithHexString:@"#BBBBBB"];
    
    //button
    UIButton *serviceBtn  = [[UIButton alloc] initWithFrame:CGRectMake(110*PROPORTION_WIDTH, CGRectGetMaxY(titleL.frame)+30*PROPORTION_WIDTH, SCREEN_W - 220*PROPORTION_WIDTH, 40*PROPORTION_WIDTH)];
    serviceBtn.backgroundColor = [UIColor whiteColor];
    [serviceBtn setTitle:@"提交售后" forState:UIControlStateNormal];
    [serviceBtn setTitleColor:[self colorWithHexString:@"#FD681F"] forState:UIControlStateNormal];
    serviceBtn.font = [UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    serviceBtn.layer.borderWidth = 1;
    serviceBtn.layer.borderColor = [[self colorWithHexString:@"#FD681F"] CGColor];
    serviceBtn.layer.cornerRadius = 5;
    serviceBtn.layer.masksToBounds = YES;
    [serviceBtn addTarget:self action:@selector(RequestService) forControlEvents:UIControlEventTouchUpInside];
    
    [serviceV addSubview:serviceBtn];
    [serviceV addSubview:titleL];
    self.serviceBtn = serviceBtn;
    self.iconV = iconV;
    [serviceV addSubview:iconV];
    serviceV.backgroundColor = [UIColor whiteColor];
    
    return serviceV;
}


#pragma mark --- 点击空白结束编辑 ---
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark --- textView简单模仿textField placehold ---
-(void)boolOfText{
    if (self.resoneTextView.text.length == 0) {
        self.resoneTextView.text = @"请填写退货的原因";
        self.resoneTextView.textColor = [self colorWithHexString:@"#BBBBBB"];
        self.resoneTextView.font = [UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        self.isEdit = NO;
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.serviceBtn setTitle:@"提交售后" forState:UIControlStateNormal];
    [self.tableView setContentOffset:CGPointMake(0, 150*PROPORTION_WIDTH) animated:YES];
    if (!self.isEdit) {
        self.resoneTextView.text = @"";
        self.isEdit = YES;
    }else {
        [self boolOfText];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [self boolOfText];
}
-(void)textViewDidChange:(UITextView *)textView{
    //    self.resoneTextView.textColor = [UIColor redColor];
}

#pragma mark ---  页面将要出现 ---
-(void)viewWillAppear:(BOOL)animated{
    [self.dataArray removeAllObjects];
    [self getDataSource];
}

#pragma mark --- 创建数据元 ---
-(void)getDataSource{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict = @{@"id":self.product_id};
    [manager GET:ProductWithId parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && ![[responseObject objectForKey:@"code"] intValue]) {
            NSLog(@"成功");
            NSDictionary *dictionary = [responseObject objectForKey:@"model"];
        [self.dataArray removeAllObjects];
        [self.dataArray1 removeAllObjects];
        ProductInfoModel *model = [[ProductInfoModel alloc] init];
        [model setValuesForKeysWithDictionary:dictionary];
        [self.dataArray1 addObject:model];
        [self.dataArray addObject:self.dataArray1];
        [self.dataArray addObject:self.dataArray2];
        [self.dataArray addObject:self.dataArray3];
        if (!self.isPickerImag) {
            [self.tableView reloadData];
        }else{
            NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:2];
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        }
        }else{
            NSLog(@"数据格式不对");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}

#pragma mark --- 懒加载 ---
-(NSString *)pickerString{
    if (!_pickerString) {
        _pickerString = @"1";
    }
    return _pickerString;
}
-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_H-170*PROPORTION_WIDTH, SCREEN_W, 170*PROPORTION_WIDTH)];
        _pickerView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}
-(NSMutableArray *)pickerDataArray{
    if (!_pickerDataArray) {
        _pickerDataArray = [[NSMutableArray alloc] init];
        for (int i = 1; i<= [self.product_num integerValue]; i++) {
            NSString *string = [NSString stringWithFormat:@"%d",i];
            [_pickerDataArray addObject:string];
        }
    }
    return _pickerDataArray;
}

-(UserIDModle *)userModle{
    if (!_userModle) {
        UserID *user = [UserID shareInState];
        _userModle = [[user redFromUserListAllData] lastObject];
    }
    return _userModle;
    
}
-(UIImageView *)imageV1{
    if (!_imageV1) {
        _imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(0*85*PROPORTION_WIDTH, 0, 70*PROPORTION_WIDTH, 70*PROPORTION_WIDTH)];
    }
    return _imageV1;
}
-(UIImageView *)imageV2{
    if (!_imageV2) {
        _imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(1*85*PROPORTION_WIDTH, 0, 70*PROPORTION_WIDTH, 70*PROPORTION_WIDTH)];
    }
    return _imageV2;
}
-(UIImageView *)imageV3{
    if (!_imageV3) {
        _imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(2*85*PROPORTION_WIDTH, 0, 70*PROPORTION_WIDTH, 70*PROPORTION_WIDTH)];
    }
    return _imageV3;
}
-(UIImageView *)imageV4{
    if (!_imageV4) {
        _imageV4 = [[UIImageView alloc] initWithFrame:CGRectMake(3*85*PROPORTION_WIDTH, 0, 70*PROPORTION_WIDTH, 70*PROPORTION_WIDTH)];
    }
    return _imageV4;
}

-(NSArray *)dataArray1{
    if (!_dataArray1) {
        //网络请求产品数据
        _dataArray1 = [[NSMutableArray alloc] init];
        
    }
    return _dataArray1;
}
-(NSArray *)dataArray2{
    if (!_dataArray2) {
        _dataArray2 = @[@"退货数量",@"退货金额"];
    }
    return _dataArray2;
}
-(NSArray *)dataArray3{
    if (!_dataArray3) {
        _dataArray3 = @[@"上传凭证"];
    }
    return _dataArray3;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H +49) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark --- 创建导航栏 ---
-(void)creatNav{
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    [left setImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(abc) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UILabel *titileV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titileV.text = @"订单详情";
    titileV.textAlignment = NSTextAlignmentCenter;
    titileV.font = [UIFont systemFontOfSize:17];
    titileV.textColor = [self colorWithHexString:@"#555555"];
    self.navigationItem.titleView = titileV;
    //添加tableView
    [self.view addSubview:self.tableView];
}
-(void)abc{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 颜色 ---
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
