//
//  LSWorkArticleAddController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/13.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkArticleAddController.h"

#import "LSWorkArticleSubController.h"

#import "LSWorkScanController.h"

@interface LSWorkArticleAddController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZHPickViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextF;

@property (weak, nonatomic) IBOutlet UITextField *keyTextF;

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;

@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *contentTextV;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (weak, nonatomic) IBOutlet UIButton *imgBtn;

@property (nonatomic, strong) ZHPickView *pickview;

@property (nonatomic, copy) NSString *files;

@end

@implementation LSWorkArticleAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 60, 40);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)backBtnClicked{
    [AlertHelper InitMyAlertWithTitle:@"温馨提示" AndMessage:@"是否保存草稿" And:self CanCleBtnName:@"取消" SureBtnName:@"保存" AndCancleBtnCallback:^(id data) {
        [self.navigationController popViewControllerAnimated:YES];
    } AndSureBtnCallback:^(id data) {
        NSMutableArray *saveArr = [LSCacheManager unarchiverObjectByKey:@"savearticle" WithPath:@"article"];
        if (!saveArr) {
            saveArr  = [NSMutableArray array];
        }
        for (NSDictionary *dic in saveArr) {
            if ([self.data[@"savetime"] doubleValue] == [dic[@"savetime"] doubleValue]) {
                [saveArr removeObject:dic];
            }
        }
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        [infoDic setValue:self.titleTextF.text forKey:@"title"];//文章标题    string
        [infoDic setValue:self.keyTextF.text forKey:@"keyword"];//文章关键字    string
        [infoDic setValue:self.typeBtn.titleLabel.text forKey:@"classify"];//文章分类    string
        [infoDic setValue:self.contentTextV.text forKey:@"content"];//文章内容    string
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
        
        [[LSCacheManager sharedInstance] archiverObject:saveArr ByKey:@"savearticle" WithPath:@"article"];
        [self.navigationController popViewControllerAnimated:YES];

    }];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"创建文章";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.contentTextV.placeholder = @"请输入文章正文";
    
    if (self.data) {
        self.titleTextF.text = self.data[@"title"];
        self.keyTextF.text = self.data[@"keyword"];
        [self.typeBtn setTitle:self.data[@"classify"] forState:UIControlStateNormal];
        self.contentTextV.text = self.data[@"content"];
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

- (void)rightItemClick
{
    if ([self.titleTextF.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        [XHToast showCenterWithText:@"请完善发布内容"];
        return;
    }
    
    if ([self.keyTextF.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        [XHToast showCenterWithText:@"请完善发布内容"];
        return;
    }
    if ([self.contentTextV.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        [XHToast showCenterWithText:@"请完善发布内容"];
        return;
    }
    
    if (self.typeBtn.titleLabel.text.length == 0) {
        [XHToast showCenterWithText:@"请完善发布内容"];
        return;
    }
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    [infoDic setValue:self.titleTextF.text forKey:@"title"];//文章标题	string
    [infoDic setValue:self.keyTextF.text forKey:@"keyword"];//文章关键字	string
    [infoDic setValue:self.typeBtn.titleLabel.text forKey:@"classify"];//文章分类	string
    [infoDic setValue:self.contentTextV.text forKey:@"content"];//文章内容	string
    if (self.files)
    {
        [infoDic setValue:self.files forKey:@"files"];//文章图像地址	string
    }
    
    LSWorkArticleSubController *vc = [[LSWorkArticleSubController alloc] initWithNibName:@"LSWorkArticleSubController" bundle:nil];
    vc.infoDic = [infoDic copy];
    [self.navigationController pushViewController:vc animated:YES];
    
    NSMutableArray *saveArr = [LSCacheManager unarchiverObjectByKey:@"savearticle" WithPath:@"article"];
    
    for (NSDictionary *dic in saveArr) {
        if ([self.data[@"savetime"] doubleValue] == [dic[@"savetime"] doubleValue]) {
            [saveArr removeObject:dic];
        }
    }
}

- (IBAction)scanBtnClick:(UIButton *)btn
{
    if (!self.files && self.contentTextV.text.length == 0) {
        return;
    }
    LSWorkScanController *vc = [[LSWorkScanController alloc]init];
    if (self.files) {
        vc.imageURL = self.files;
    }
    vc.content = self.contentTextV.text;
    vc.titleStr = self.titleTextF.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)typeBtnClick:(UIButton *)sender
{
    LSWEAKSELF;
    
    //分类
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/getArticleClassify");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSArray *array = responseObj[@"data"][@"list"];
                
                if (array.count == 0)
                {
                    [XHToast showCenterWithText:@"无数据"];
                    return ;
                }
                
                weakSelf.pickview=[[ZHPickView alloc] initPickviewWithArray:@[array] isHaveNavControler:NO];
                weakSelf.pickview.delegate=self;
                [weakSelf.pickview show];
                
            }else{
                NSLog(@"返回数据有误");
            }
        }else
        {
            [XHToast showCenterWithText:@"获取分类列表失败"];
        }
        
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
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

#pragma mark ZhpickVIewDelegate 点击确定方法的回调
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    NSLog(@"%@",resultString);
    
    [self.typeBtn setTitle:resultString forState:UIControlStateNormal];
    [self.typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

@end
