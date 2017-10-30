//
//  LSMineUserSettingController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineUserSettingController.h"

#import "LSMineUserNameController.h"

#import "LSMineUserSettingCell.h"

@interface LSMineUserSettingController ()<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZHPickViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)UITableView *dataTableView;

@property (nonatomic, strong) NSMutableArray* projectMutlArr;//科室
@property (nonatomic, strong) NSMutableArray* titleMutlArr;//职称

@property (nonatomic, strong) NSString *projectId;//科室
@property (nonatomic, strong) NSString *department_name;

@property (nonatomic, strong) NSString *hospital_id;

@property (nonatomic, strong) ZHPickView *pickview;

//选项选择器
@property (strong, nonatomic)  UIPickerView *myPicker;//选择器
@property (strong, nonatomic)  UIView *pickerBgView;//背景
@property (strong, nonatomic)  UIView *maskView;

//data
@property (copy, nonatomic) NSArray *cityArray;//2列

@end

@implementation LSMineUserSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initForView];
}

-(void)initForView{
    
    self.navigationItem.title = @"基本资料";
    
    self.projectMutlArr = [NSMutableArray array];
    self.titleMutlArr = [NSMutableArray array];
    
    [self.view addSubview:self.dataTableView];
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self setupPickerView];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LSWEAKSELF;
    
    if (indexPath.row == 0)
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
    
    if (indexPath.row == 1)
    {
        //姓名
        LSMineUserNameController *vc = [[LSMineUserNameController alloc] initWithNibName:@"LSMineUserNameController" bundle:nil];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 3)
    {
        //科室
        NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
        
        NSString* url = PATH(@"%@/department");
        
        [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                
                if ([responseObj[@"data"] isKindOfClass:[NSArray class]]) {
                    [weakSelf.projectMutlArr removeAllObjects];
                    [weakSelf.projectMutlArr addObjectsFromArray:responseObj[@"data"]];
                    weakSelf.cityArray = [weakSelf.projectMutlArr firstObject][@"depList"];
                    
                    NSArray* projectArr = [self.projectMutlArr copy];//将mutlArr转成Arr
                    
                    if (projectArr.count == 0)
                    {
                        [XHToast showCenterWithText:@"无数据"];
                        return ;
                    }
                    
                    [self.view addSubview:self.maskView];
                    [self.view addSubview:self.pickerBgView];
                    self.maskView.alpha = 0;
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        self.maskView.alpha = 0.3;
                    }];
                    
                }else{
                    NSLog(@"返回数据有误");
                }
            }else
            {
                [XHToast showCenterWithText:@"获取科室列表失败"];
            }
            
        } failBlock:^(NSError *error) {
            //[XHToast showCenterWithText:@"fail"];
        }];
    }
    
    if (indexPath.row == 4)
    {
        //职称
        NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
        
        NSString* url = PATH(@"%@/title");
        
        [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                if ([responseObj[@"data"] isKindOfClass:[NSArray class]]) {
                    [weakSelf.titleMutlArr removeAllObjects];
                    NSArray* hospital_projectArr = responseObj[@"data"];
                    
                    for (NSDictionary* dict in hospital_projectArr ) {
                        if (dict[@"title_name"]) {
                            [weakSelf.titleMutlArr addObject:dict[@"title_name"]];
                        }
                        
                    }
                    
                    NSArray* titleArr = [weakSelf.titleMutlArr copy];//将mutlArr转成Arr
                    
                    if (titleArr.count == 0)
                    {
                        [XHToast showCenterWithText:@"无数据"];
                        return ;
                    }
                    
                    weakSelf.pickview=[[ZHPickView alloc] initPickviewWithArray:@[titleArr] isHaveNavControler:NO];
                    weakSelf.pickview.tag = 5;
                    weakSelf.pickview.delegate=self;
                    [weakSelf.pickview show];
                    
                }else{
                    NSLog(@"返回数据有误");
                }
            }else
            {
                [XHToast showCenterWithText:@"获取职称列表失败"];
            }
            
        } failBlock:^(NSError *error) {
            //[XHToast showCenterWithText:@"fail"];
        }];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSMineUserSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSMineUserSettingCell"];
    if (!cell) {
        cell = [[LSMineUserSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMineUserSettingCell"];
    }
    
    NSArray *titleArray = @[@"头 像",@"姓 名",@"医 院",@"科 室",@"职 称",@"擅 长",@"简 介"];
    [cell updateTitle:titleArray[indexPath.row]];
    
    if (indexPath.row == 0) {
        [cell hideHeadImageView:NO];
        [cell updateHead:nil];
    }else{
        [cell hideHeadImageView:YES];
        if (indexPath.row == 1) {
            [cell updateName:self.model.myName];
        }
        if (indexPath.row == 2) {
            [cell updateHospital:[self.model.myBaseInfo[2] valueForKey:@"value"]];
        }
        if (indexPath.row == 3) {
            [cell updateRoom:[self.model.myBaseInfo[3] valueForKey:@"value"]];
        }
        if (indexPath.row == 4) {
            [cell updateCareer:[self.model.myBaseInfo[4] valueForKey:@"value"]];
        }
        if (indexPath.row == 5) {
            [cell updateGoodat:[self.model.myBaseInfo[5] valueForKey:@"value"]];
        }
        if (indexPath.row == 6) {
            [cell updateInfo:[self.model.myBaseInfo[6] valueForKey:@"value"]];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90;
    }else{
        return 50;
    }
}


#pragma mark - 从相册选择图片后操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
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
    [self saveImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - 保存图片
- (void) saveImage:(UIImage *)currentImage {
    //设置照片的品质
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    NSLog(@"%@",NSHomeDirectory());
    // 获取沙盒目录
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/currentImage.png"];
    // 将图片写入文件
    [imageData writeToFile:filePath atomically:NO];
    //将选择的图片显示出来
    
    [self upLoadFile:filePath WithImg:currentImage];
    
}

#pragma mark -- 文件上传请求
- (void)upLoadFile:(NSString*)fileStr WithImg:(UIImage*)img
{
    TLUploadParam *uploadImage = [[TLUploadParam alloc] init];
    
    if(img){
        uploadImage.data = UIImageJPEGRepresentation(img, 0.8);
        uploadImage.fileName = [uploadImage fileName];
        uploadImage.paramKey = @"1";
        uploadImage.mimeType = [uploadImage mimeType];
    }
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* lasturl = @"/common/upload/file";
    NSString* headUrl = [API_HOST substringToIndex:API_HOST.length - 3];
    NSString* url = [NSString stringWithFormat:@"%@%@",headUrl,lasturl];
    
    [param setObject:fileStr forKey:@"keyName"];
    
    [self uploadFileWithURL:url params:param successBlock:^(id responseObj) {
        
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"]) {
                if (responseObj[@"data"] && responseObj[@"data"][@"url"]) {
                    
                    NSString* url = responseObj[@"data"][@"url"];
                    //上传Url给后台
                    [self savePhotoWithUrl:url];
                    
                }else{
                    [XHToast showCenterWithText:@"返回数据错误"];
                }
            }else{
                [XHToast showCenterWithText:@"返回数据错误"];
            }
        }else{
            [XHToast showCenterWithText:@"返回数据错误"];
        }
        NSLog(@"成功");
        
    } failureBlock:^(NSError *error) {
        NSLog(@"失败");
    } uploadParam:[NSMutableArray arrayWithObject:uploadImage] showHUD:NO];
}


#pragma mark - 照片存到本地后的回调
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"存储成功");
    } else {
        NSLog(@"存储失败：%@", error);
    }
}

#pragma mark -- 将返回的图片Url发给后台保存

- (void)savePhotoWithUrl:(NSString*)imgUrl
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:imgUrl forKey:@"imgUrl"];
    NSString* url = PATH(@"%@/my/doctorImg");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [self getMineInfoData];
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
        
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
}

- (void)uploadFileWithURL:(NSString*)url
                   params:(NSDictionary*)paramsDict
             successBlock:(TLResponseSuccessBlock)successBlock
             failureBlock:(TLResponseFailBlock)failureBlock
              uploadParam:(NSMutableArray *)uploadParams
                  showHUD:(BOOL)showHUD
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:paramsDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < uploadParams.count; i++) {
            if ([uploadParams[i] isKindOfClass:[TLUploadParam class]]) {
                TLUploadParam *uploadParam = (TLUploadParam *)uploadParams[i];
                [formData appendPartWithFileData:uploadParam.data name:uploadParam.paramKey fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
            }else{
                NSLog(@"文件数组不是TLUploadParam对象，请检查文件数组类型");
                return;
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"上传中"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        // 根据服务器返回状态判定请求是否成功
        if ([responseObject[@"api_code"] integerValue] != 0) {
            
            if (failureBlock) {
                failureBlock(nil);
            }
            [[DSToast toastWithText:responseObject[@"api_message"]] show];
            
            return;
        }
        if (successBlock) {
            NSLog(@"----> 接口请求成功");
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"----> %@",error.domain);
    }];
}

#pragma mark -- 获取个人信息
- (void)getMineInfoData
{
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/my/info");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            weakSelf.model = [LSMineModel yy_modelWithJSON:responseObj];
            [weakSelf.dataTableView reloadData];
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

#pragma mar - 修改个人信息

- (void)updateMainInfoData
{
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@"" forKey:@"depid"];//科室ID
    [param setValue:@"" forKey:@"experience"];//执业经验
    [param setValue:@"" forKey:@"hosid"];//医院ID
    [param setValue:@"" forKey:@"imgUrl"];//医生头像
    [param setValue:@"" forKey:@"introduction"];//医生介绍
    [param setValue:@"" forKey:@"name"];//医生姓名
    [param setValue:@"" forKey:@"specialty"];//医生擅长
    [param setValue:@"" forKey:@"title"];//医生职称
    
    NSString* url = PATH(@"%@/my/updateInfo");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
//        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
//        {
//            weakSelf.model = [LSMineModel yy_modelWithJSON:responseObj];
//            [weakSelf.dataTableView reloadData];
//        }else
//        {
//            [XHToast showCenterWithText:responseObj[@"message"]];
//        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

#pragma mark ZhpickVIewDelegate 点击确定方法的回调
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    NSLog(@"%@",resultString);
    if(pickView.tag == 5)
    {
        //职称
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.model.myBaseInfo];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[4]];
        [dic setValue:resultString forKey:@"value"];
        [arr replaceObjectAtIndex:4 withObject:dic];
        self.model.myBaseInfo = arr;

        [self.dataTableView reloadData];
    }
}

#pragma mark - pickerView
- (void)setupPickerView{
    
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    self.pickerBgView=[[UIView alloc] initWithFrame:CGRectMake(0, LSSCREENHEIGHT-255, LSSCREENWIDTH, 255)];
    [self.pickerBgView setBackgroundColor:[UIColor whiteColor]];
    
    self.myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 34, LSSCREENWIDTH, 216)];
    self.myPicker.delegate=self;
    self.myPicker.dataSource=self;
    [self.pickerBgView addSubview:self.myPicker];
    
    UIButton *btnCanel=[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 34)];
    [btnCanel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCanel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCanel addTarget:self action:@selector(hideMyPicker) forControlEvents:UIControlEventTouchUpInside];
    [btnCanel.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [self.pickerBgView addSubview:btnCanel];
    
    UIButton *btnOK=[[UIButton alloc] initWithFrame:CGRectMake(LSSCREENWIDTH-50, 0, 50, 34)];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnOK.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [btnOK addTarget:self action:@selector(btnOk) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:btnOK];
}

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

//确定
-(void)btnOk{
    
    for (NSInteger i=0; i<self.cityArray.count; i++)
    {
        NSString *name = self.cityArray[i][@"department_name"];
        if ([name isEqualToString:self.department_name])
        {
            self.projectId = self.cityArray[i][@"department_id"];
        }
    }
    
    //所在科室
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.model.myBaseInfo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[3]];
    [dic setValue:self.department_name forKey:@"value"];
    [arr replaceObjectAtIndex:3 withObject:dic];
    self.model.myBaseInfo = arr;
    
    [self.dataTableView reloadData];
    
    [self hideMyPicker];
    
}
#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.projectMutlArr.count;
    } else {
        self.department_name = self.cityArray[0][@"department_name"];
        return self.cityArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return LSSCREENWIDTH / 2;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, LSSCREENWIDTH/2, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:17.0f];         //用label来设置字体大小
    myView.backgroundColor = [UIColor clearColor];
    
    if (component == 0) {
        myView.text = self.projectMutlArr[row][@"specialty_name"];
    } else if (component == 1) {
        NSArray *temp = self.cityArray;
        myView.text = temp[row][@"department_name"];
    }
    
    return myView;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //第一列
    if (component == 0) {
        self.cityArray = self.projectMutlArr[row][@"depList"];
        
        [pickerView reloadAllComponents];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        self.department_name = self.cityArray[0][@"department_name"];
    }
    
    //第二列
    if (component == 1) {
        
        NSArray *temp = self.cityArray;
        self.department_name = temp[row][@"department_name"];
    }
}

#pragma mark - getter & setter

-(UITableView *)dataTableView{
    if (!_dataTableView) {
        _dataTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dataTableView.delegate = self;
        _dataTableView.dataSource = self;
        _dataTableView.backgroundColor = [UIColor colorFromHexString:@"dedede"];
    }
    return _dataTableView;
}

@end
