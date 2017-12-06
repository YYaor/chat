//
//  LSWorkActivityAddController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/20.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkActivityAddController.h"

#import "LSWorkActivitySubController.h"

#import "LSWorkScanController.h"

@interface LSWorkActivityAddController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, PGDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *centView;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *cutoff_time;
@property (weak, nonatomic) IBOutlet UITextField *activity_time;
@property (weak, nonatomic) IBOutlet UITextField *total_number;
@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *content;

@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (nonatomic, strong) PGDatePicker *picker;

@property (nonatomic, copy) NSString *files;

@end

@implementation LSWorkActivityAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
    
}

- (void)viewDidLayoutSubviews
{
    self.centView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 500);
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 500);
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"创建活动";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 60, 40);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    self.content.placeholder = @"请输入内容";
    
    [self.scrollView addSubview:self.centView];
    
    if (self.data) {
        self.name.text = self.data[@"name"];
        self.address.text = self.data[@"address"];
        self.cutoff_time.text = self.data[@"cutoff_time"];
        self.activity_time.text = self.data[@"activity_time"];
        self.total_number.text = self.data[@"total_number"];
        self.content.text = self.data[@"content"];
        if (self.data[@"files"]) {
            [self.imgBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST, self.data[@"files"]]]];
            self.imgBtn.enabled = NO;
            self.delBtn.hidden = NO;
            self.files = self.data[@"files"];
        }
        else
        {
            self.imgBtn.enabled = YES;
            self.delBtn.hidden = YES;
        }
    }

}

-(void)backBtnClicked{
    [AlertHelper InitMyAlertWithTitle:@"温馨提示" AndMessage:@"是否保存此活动" And:self CanCleBtnName:@"取消" SureBtnName:@"保存" AndCancleBtnCallback:^(id data) {
        [self.navigationController popViewControllerAnimated:YES];
    } AndSureBtnCallback:^(id data) {
        NSMutableArray *saveArr = [LSCacheManager unarchiverObjectByKey:@"saveactivity" WithPath:@"activity"];
        if (!saveArr) {
            saveArr  = [NSMutableArray array];
        }
        for (NSDictionary *dic in saveArr) {
            if ([self.data[@"savetime"] doubleValue] == [dic[@"savetime"] doubleValue]) {
                [saveArr removeObject:dic];
            }
        }
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        [infoDic setValue:self.name.text forKey:@"name"];
        [infoDic setValue:self.address.text forKey:@"address"];
        [infoDic setValue:self.cutoff_time.text forKey:@"cutoff_time"];
        [infoDic setValue:self.activity_time.text forKey:@"activity_time"];
        [infoDic setValue:self.total_number.text forKey:@"total_number"];
        [infoDic setValue:self.content.text forKey:@"content"];
        [infoDic setValue:self.files forKey:@"files"];//文章图像地址    string
        
        //        [infoDic setObject:[NSNumber numberWithInt:1] forKey:@"isMine"];
        if (self.delBtn.hidden)
        {
            //无图
            [infoDic setObject:[NSNumber numberWithInt:4] forKey:@"type"];
        }
        else
        {
            //有图
            [infoDic setObject:[NSNumber numberWithInt:1] forKey:@"type"];
        }
        
        [infoDic setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"savetime"];
        [saveArr addObject:infoDic];
        
        [[LSCacheManager sharedInstance] archiverObject:saveArr ByKey:@"saveactivity" WithPath:@"activity"];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

- (void)rightItemClick
{
//    接口名称 新增活动
//    请求类型 post
//    请求Url  /dr/addActivity
//    请求参数列表
//    变量名	含义	类型	备注
//    activity_time	活动时间	string	yyyy-MM-dd HH:mm
//    address	活动地址	string
//    content	活动内容	string
//    cookie	医生cookie	string
//    cutoff_time	报名截止时间	string	yyyy-MM-dd HH:mm
//    disease_group	患者疾病分类	string	常用标签，全部传空，多个以“、”分隔
//    img_url	活动图片	string
//    name	活动名称	string	
//    total_number	总人数	number
    
    if ([self.name.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0)
    {
        [XHToast showCenterWithText:@"请输入活动名"];
        return;
    }
    
    if ([self.address.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0)
    {
        [XHToast showCenterWithText:@"请完善发布内容"];
        return;
    }
    
    if ([self.cutoff_time.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0)
    {
        [XHToast showCenterWithText:@"请完善发布内容"];
        return;
    }
    
    if ([self.activity_time.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0)
    {
        [XHToast showCenterWithText:@"请完善发布内容"];
        return;
    }
    
    if ([self.total_number.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0)
    {
        [XHToast showCenterWithText:@"请完善发布内容"];
        return;
    }
    
    if ([self.content.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0)
    {
        [XHToast showCenterWithText:@"请完善发布内容"];
        return;
    }
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    
    [infoDic setValue:self.name.text forKey:@"name"];
    [infoDic setValue:self.address.text forKey:@"address"];
    [infoDic setValue:self.cutoff_time.text forKey:@"cutoff_time"];
    [infoDic setValue:self.activity_time.text forKey:@"activity_time"];
    [infoDic setValue:self.total_number.text forKey:@"total_number"];
    [infoDic setValue:self.content.text forKey:@"content"];
    
    if (self.files)
    {
        [infoDic setValue:self.files forKey:@"files"];//文章图像地址	string
    }
    
    LSWorkActivitySubController *vc = [[LSWorkActivitySubController alloc] initWithNibName:@"LSWorkActivitySubController" bundle:nil];
    vc.infoDic = [infoDic copy];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)cutoff_timeTap:(UITapGestureRecognizer *)sender
{
//    self.picker = [[ZHPickView alloc] initDatePickWithDefaultDate:[NSDate getNowDateFromatAnDate:[NSDate date]] selectDate:[NSDate getNowDateFromatAnDate:[NSDate date]] minDate:[NSDate getNowDateFromatAnDate:[NSDate date]] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
    self.picker = [[PGDatePicker alloc] init];
    self.picker.delegate = self;
    self.picker.datePickerMode = PGDatePickerModeDateHourMinute;
    self.picker.minimumDate = [NSDate date];
    [self.picker show];
    self.picker.tag = 1;
}

- (IBAction)activity_timeTap:(UITapGestureRecognizer *)sender
{
//    self.picker = [[ZHPickView alloc] initDatePickWithDefaultDate:[NSDate getNowDateFromatAnDate:[NSDate date]] selectDate:[NSDate getNowDateFromatAnDate:[NSDate date]] minDate:[NSDate getNowDateFromatAnDate:[NSDate date]] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
//    self.picker.tag = 2;
//    self.picker.delegate = self;
//    [self.picker show];
    
    self.picker = [[PGDatePicker alloc] init];
    self.picker.delegate = self;
    self.picker.datePickerMode = PGDatePickerModeDateHourMinute;
    self.picker.minimumDate = [NSDate date];
    [self.picker show];
    self.picker.tag = 2;
}

- (IBAction)scanBtnClick:(UIButton *)btn
{
    if (!self.files && self.content.text.length == 0) {
        return;
    }
    LSWorkScanController *vc = [[LSWorkScanController alloc]init];
    if (self.files) {
        vc.imageURL = self.files;
    }
    vc.content = self.content.text;
    vc.titleStr = self.name.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)delBtnClick:(UIButton *)btn
{
    btn.hidden = YES;
    self.files = nil;
    [self.imgBtn setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    self.imgBtn.enabled = YES;
}



- (IBAction)imgBtnClick:(UIButton *)btn
{
    NSString *message = [NSString stringWithFormat:@""];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"选照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //首先需要判断资源是否可用
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //获得相机模式下支持的媒体类型
            //        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            pickerImage.delegate = self;
            //设置允许编辑
            pickerImage.allowsEditing = YES;
            
            [self presentViewController:pickerImage animated:YES completion:^{
            }];
        }
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"拍照片");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//设置类型为相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;//设置代理
            picker.allowsEditing = YES;//设置照片可编辑
            picker.sourceType = sourceType;
            //设置是否显示相机控制按钮 默认为YES
            picker.showsCameraControls = YES;
            
            //        //创建叠加层(例如添加的相框)
            //        UIView *overLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 120, 320, 254)];
            //        //取景器的背景图片，该图片中间挖掉了一块变成透明，用来显示摄像头获取的图片；
            //        UIImage *overLayImag=[UIImage imageNamed:@"zhaoxiangdingwei.png"];
            //        UIImageView *bgImageView=[[UIImageView alloc]initWithImage:overLayImag];
            //        [overLayView addSubview:bgImageView];
            //        picker.cameraOverlayView=overLayView;
            
            //选择前置摄像头或后置摄像头
            picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
            [self presentViewController:picker animated:YES completion:^{
            }];
        }
        else {
            [AlertHelper InitMyAlertMessage:@"您的设备不支持相机" And:self];
        }
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

#pragma mark - 从相册选择图片后操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    LSWEAKSELF;
    
    //NSLog(@"%@",info);
    
    //获取源图像（未经裁剪）
    //    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //获取裁剪后的图像
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    //如果是拍照，将照片存到媒体库
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    //将照片存到沙盒
    //    [self saveImage:image];
    
    //上传图片
    //上传的图片对象
    TLUploadParam *uploadImage = [[TLUploadParam alloc] init];
    uploadImage.data = UIImageJPEGRepresentation(image, 0.8);
    uploadImage.fileName = [uploadImage fileName];
    uploadImage.paramKey = @"1";
    uploadImage.mimeType = [uploadImage mimeType];
    
    //根据图片返回图片地址
    NSMutableDictionary *params = [MDRequestParameters shareRequestParameters];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", UGAPI_HOST, @"/common/upload/pictrues"];
    
    [TLAsiNetworkHandler uploadWithImageArray:[NSMutableArray arrayWithObject:uploadImage] url:url params:params showHUD:YES progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id responseObj) {
        if ([responseObj[@"status"] longValue] == 0)
        {
            weakSelf.files = responseObj[@"data"][@"urls"][0];
            weakSelf.imgBtn.enabled = NO;
            weakSelf.delBtn.hidden = NO;
            
            [weakSelf.imgBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST, weakSelf.files]]];
        }
        else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 照片存到本地后的回调
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"存储成功");
    } else {
        NSLog(@"存储失败：%@", error);
    }
}

#pragma mark - PGDatePickerDelegate

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *year = [NSString stringWithFormat:@"%ld", dateComponents.year];
    NSString *month = [NSString stringWithFormat:@"%ld", dateComponents.month];
    NSString *day = [NSString stringWithFormat:@"%ld", dateComponents.day];
    NSString *hour = [NSString stringWithFormat:@"%ld", dateComponents.hour];
    NSString *minute = [NSString stringWithFormat:@"%ld", dateComponents.minute];
    
    if (dateComponents.month<10)
    {
        month = [NSString stringWithFormat:@"0%@", month];
    }
    
    if (dateComponents.day<10)
    {
        day = [NSString stringWithFormat:@"0%@", day];
    }
    
    if (dateComponents.hour<10)
    {
        hour = [NSString stringWithFormat:@"0%@", hour];
    }
    
    if (dateComponents.minute<10)
    {
        minute = [NSString stringWithFormat:@"0%@", minute];
    }
    
    if (datePicker.tag == 1)
    {
        self.cutoff_time.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@", year, month, day, hour, minute];
    }
    
    if (datePicker.tag == 2)
    {
        self.activity_time.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@", year, month, day, hour, minute];
    }
}


#pragma mark ZhpickVIewDelegate 点击确定方法的回调

- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    if (pickView.tag == 1)
    {
        self.cutoff_time.text = [[resultString stringByReplacingOccurrencesOfString:@" +0000" withString:@""] substringToIndex:16];
    }
    
    if (pickView.tag == 2)
    {
        self.activity_time.text = [[resultString stringByReplacingOccurrencesOfString:@" +0000" withString:@""] substringToIndex:16];
    }
}

@end
