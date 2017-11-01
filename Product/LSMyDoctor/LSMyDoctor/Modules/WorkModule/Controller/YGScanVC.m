//
//  YGScanVC.m
//  YouGeHealth
//
//  Created by 惠生 on 17/6/26.
//
//

#import "YGScanVC.h"

#import <AVFoundation/AVFoundation.h>
#import "FireflyQRCodeScan.h"

@interface YGScanVC ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic, strong) UIImageView *animationView;//动画图片视图
@property (nonatomic, strong) AVCaptureSession *captureSession;//
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机界面
@property (nonatomic, assign) BOOL isScanning;
@property (nonatomic, assign) int marginTop;


- (void)registerNotification;
- (void)initViews;
- (void)initCapture;//显示扫描相机
- (void)startScanning;//开始扫描
- (void)stopScanning;//停止扫面
- (void)onLightClicked:(id)sender;//开灯按钮
- (void)onPhotoClicked:(id)sender;//相册选取按钮
- (void)startScanAnimation;//启动扫描动画
- (void)actionAfterQRScan:(NSString *)aString;//扫描出结果后的处理方法


@end

@implementation YGScanVC

- (void)viewWillAppear:(BOOL)animated
{
    [self startScanAnimation];
    [self startScanning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopScanning];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    
    [self registerNotification];
    [self initCapture];//初始化相机
    [self initViews];//初始化界面
    
    // Do any additional setup after loading the view from its nib.
}

- (void)initCapture
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.captureSession = [[AVCaptureSession alloc] init];
        
        AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
        if (captureInput)
        {
            [self.captureSession addInput:captureInput];
            
            AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
            captureOutput.alwaysDiscardsLateVideoFrames = YES;
            
            AVCaptureMetadataOutput *metadataOutput=[[AVCaptureMetadataOutput alloc]init];
            [metadataOutput setMetadataObjectsDelegate:self
                                                 queue:dispatch_get_main_queue()];
            [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
            [self.captureSession addOutput:metadataOutput];
            metadataOutput.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
            
            
            
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"请进入设置,允许访问相机"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            
            [alertView show];
        }
    }
}


- (void)initViews
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.captureSession)
    {
        self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        self.captureVideoPreviewLayer.frame = CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT - 64);
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer: self.captureVideoPreviewLayer];
    }
    
//    if(IOS5_OR_LATER)
//    {
//        _marginTop = 70;
//    }
//    else
//    {
        _marginTop = 50;
//    }
//    CGFloat orignY = 64;
    CGFloat orignY = 0;
    CGRect  topImageRect = CGRectMake(0, orignY, LSSCREENWIDTH, _marginTop);
    UIImage *topImage = [UIImage imageNamed:@"scan_background"];
    UIImageView *topbgView = [[UIImageView alloc] initWithFrame:topImageRect];
    topbgView.image = topImage;
    [self.view addSubview:topbgView];
    
    UIImage *scaBgImage = [UIImage imageNamed:@"scan_bg"];
    CGRect  bgImageRect = CGRectMake(0, _marginTop + orignY, LSSCREENWIDTH, scaBgImage.size.height);
    UIImageView *bgView = [[UIImageView alloc] initWithFrame: bgImageRect];
    bgView.image = scaBgImage;
    [self.view addSubview:bgView];
    
    CGRect tipsFrame = CGRectMake((LSSCREENWIDTH - 320) / 2.0,
                                  CGRectGetMaxY(bgImageRect) - 40,
                                  320,
                                  40);
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:tipsFrame];
    tipsLabel.text = @"对准二维码，即可自动扫描";
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font=[UIFont systemFontOfSize:12];
    tipsLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipsLabel];
    
    //其他部分 用图片填充
    CGFloat bottomOriginY = CGRectGetMaxY(bgImageRect);
    CGRect bottomImageFrame = CGRectMake(0, bottomOriginY, LSSCREENWIDTH, LSSCREENHEIGHT - bottomOriginY);
    UIImage *bottomImage = [UIImage imageNamed:@"scan_background"];
    UIImageView *bottombgView = [[UIImageView alloc] initWithFrame:bottomImageFrame];
    bottombgView.image = bottomImage;
    [self.view addSubview:bottombgView];
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startScanAnimation)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)startScanning
{
    if (!self.isScanning)
    {
        self.isScanning = YES;
        [self.captureSession startRunning];
    }
}

- (void)stopScanning
{
    if (self.isScanning)
    {
        self.isScanning = NO;
        [self.captureSession stopRunning];
    }
    if (self.animationView != nil) {
        [self.animationView removeFromSuperview];
    }
}
#pragma mark -- 扫描成功后处理
- (void)actionAfterQRScan:(NSString *)aString
{
    [self stopScanning];
    
    NSLog(@"扫描成功:扫描数据：%@",aString);
    //请求数据
    
    
    
}

#pragma mark -- 开启扫描动画
- (void)startScanAnimation
{
    [self.animationView removeFromSuperview];
    
    UIImageView *tmpAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake((LSSCREENWIDTH - 320) / 2.0 + 50,
                                                                                  _marginTop + 60,
                                                                                  220,
                                                                                  2)];
    tmpAnimationView.image = [UIImage imageNamed:@"scan_animation"];
    self.animationView = tmpAnimationView;
    [self.view addSubview:self.animationView];
    
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewKeyframeAnimationOptionRepeat | UIViewKeyframeAnimationOptionAutoreverse
                     animations:^{
                         self.animationView.frame = CGRectMake((LSSCREENWIDTH - 320) / 2.0 + 50,
                                                               _marginTop + 260,
                                                               220,
                                                               2);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark -- 开灯
- (void)onLightClicked:(id)sender
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device.torchMode==AVCaptureTorchModeOff)
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        
    }else
    {
        [device setTorchMode:AVCaptureTorchModeOff];
    }
}

#pragma mark -- 打开相册
- (void)onPhotoClicked:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{
        [self stopScanning];
    }];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

// iOS6系统触发
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    UIImage *captureImage = [FireflyQRCodeScan imageFromSampleBuffer:sampleBuffer];
    NSString *qrString = [FireflyQRCodeScan decodeFromQRImage:captureImage];
    if (![self strNilOrEmpty:qrString])
    {
        [self actionAfterQRScan:qrString];
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

// IOS7及其以上的iOS系统触发
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        if (![self strNilOrEmpty:metadataObject.stringValue])
        {
            [self actionAfterQRScan:metadataObject.stringValue];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 NSString *qrString = [FireflyQRCodeScan decodeFromQRImage:image];
                                 if (![self strNilOrEmpty:qrString])
                                 {
                                     [self actionAfterQRScan:qrString];
                                 }
                                 
                                 [self startScanning];
                             }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self startScanning];
    }];
}


#pragma mark -- 弹框提示
- (void)creatShowView:(NSString*)message
{
    UIAlertView* showView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    showView.tag = 1000;
    [showView show];
    
}

#pragma mark -- 弹框确定事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
- (BOOL)strNilOrEmpty:(NSString *)aString
{
    if ([aString isKindOfClass:[NSString class]])
    {
        if (aString.length > 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
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
