//
//  LSAuthenticationController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSAuthenticationController.h"

#import "ZHPickView.h"

#import "FMDBTool.h"

@interface LSAuthenticationController () <ZHPickViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)UITextField *nameTextField;

@property (nonatomic,strong)UIButton *clearButton;

@property (nonatomic,strong)UIButton *cityButton;

@property (nonatomic,strong)UIButton *areaButton;

@property (nonatomic,strong)UIButton *hospitalButton;

@property (nonatomic,strong)UIButton *roomButton;

@property (nonatomic,strong)UIButton *careerButton;

@property (nonatomic,strong)UIButton *commitButton;

@property (nonatomic, strong) NSMutableArray* cityMutlArr;//城市
@property (nonatomic, strong) NSMutableArray* areaMutlArr;//区域
@property (nonatomic, strong) NSMutableArray* hospitalMutlArr;//医院
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

@implementation LSAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self initNavView];
    [self initForView];
}

-(void)initNavView{
    
    self.cityMutlArr = [NSMutableArray array];
    self.areaMutlArr = [NSMutableArray array];
    self.hospitalMutlArr = [NSMutableArray array];
    self.projectMutlArr = [NSMutableArray array];
    self.titleMutlArr = [NSMutableArray array];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,64)];
    navView.backgroundColor = [UIColor colorFromHexString:LSGREENCOLOR];
    [self.view addSubview:navView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"认证信息";
    titleLabel.backgroundColor = [UIColor clearColor];
    [navView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navView);
        make.centerY.equalTo(navView).offset(8);
   }];
}

-(void)initForView{
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.clearButton];
    [self.view addSubview:self.cityButton];
    [self.view addSubview:self.areaButton];
    [self.view addSubview:self.hospitalButton];
    [self.view addSubview:self.careerButton];
    [self.view addSubview:self.commitButton];
    [self.view addSubview:self.roomButton];
    
    UIView *line = nil;
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(100);
    }];
    
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameTextField.mas_right);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.nameTextField);
    }];
    
    line = [self newLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameTextField).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.nameTextField.mas_bottom).offset(2);
    }];
    
    [self.cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(30);
        make.left.right.equalTo(self.nameTextField);
        make.height.mas_equalTo(20);
    }];
    
    line = [self newLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameTextField).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.cityButton.mas_bottom).offset(2);
    }];
    
    [self.areaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(30);
        make.left.right.equalTo(self.nameTextField);
        make.height.mas_equalTo(20);
    }];
    
    line = [self newLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameTextField).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.areaButton.mas_bottom).offset(2);
    }];
    
    [self.hospitalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(30);
        make.left.right.equalTo(self.nameTextField);
        make.height.mas_equalTo(20);
    }];
    
    line = [self newLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameTextField).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.hospitalButton.mas_bottom).offset(2);
    }];
    
    [self.roomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(30);
        make.left.right.equalTo(self.nameTextField);
        make.height.mas_equalTo(20);
    }];
    
    line = [self newLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameTextField).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.roomButton.mas_bottom).offset(2);
    }];
    
    [self.careerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(30);
        make.left.right.equalTo(self.nameTextField);
        make.height.mas_equalTo(20);
    }];
    
    line = [self newLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameTextField).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.careerButton.mas_bottom).offset(2);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameTextField);
        make.bottom.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView *chooseImageView = nil;
    chooseImageView = [self newImageView];
    [chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cityButton);
        make.right.equalTo(line.mas_right);
        make.size.mas_equalTo(CGSizeMake(9, 15));
    }];
    
    chooseImageView = [self newImageView];
    [chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.areaButton);
        make.right.equalTo(line.mas_right);
        make.size.mas_equalTo(CGSizeMake(9, 15));
    }];
    
    chooseImageView = [self newImageView];
    [chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hospitalButton);
        make.right.equalTo(line.mas_right);
        make.size.mas_equalTo(CGSizeMake(9, 15));
    }];
    
    chooseImageView = [self newImageView];
    [chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.roomButton);
        make.right.equalTo(line.mas_right);
        make.size.mas_equalTo(CGSizeMake(9, 15));
    }];
    
    chooseImageView = [self newImageView];
    [chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.careerButton);
        make.right.equalTo(line.mas_right);
        make.size.mas_equalTo(CGSizeMake(9, 15));
    }];
    
    [self setupPickerView];
}

-(UIImageView *)newImageView{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"right_Green_Public"];
    [self.view addSubview:imageView];
    return imageView;
}

-(UIView *)newLine{
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorFromHexString:@"dedede"];
    [self.view addSubview:line];
    return line;
}

#pragma mark - clickEvents

-(void)nameTextChangged:(UITextField *)sender{
    if (sender.text.length>0) {
        self.clearButton.hidden = NO;
    }else{
        self.clearButton.hidden = YES;
    }
}

-(void)clearButtonClick{
    self.clearButton.hidden = YES;
    self.nameTextField.text = nil;
}

-(void)cityButtonClick{
    
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/city");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            //成功
            if ([responseObj[@"data"] isKindOfClass:[NSArray class]]) {
                [weakSelf.cityMutlArr removeAllObjects];
                NSArray* hospital_cityArr = responseObj[@"data"];
                
                for (NSDictionary* dict in hospital_cityArr ) {
                    if (dict[@"hospital_city"]) {
                        [weakSelf.cityMutlArr addObject:dict[@"hospital_city"]];
                    }
                    
                }
                
                NSArray* cityArr = [weakSelf.cityMutlArr copy];//将mutlArr转成Arr
                
                if (cityArr.count == 0)
                {
                    [XHToast showCenterWithText:@"无数据"];
                    return ;
                }
                
                weakSelf.pickview = [[ZHPickView alloc] initPickviewWithArray:@[cityArr] isHaveNavControler:NO];
                weakSelf.pickview.tag = 1;
                weakSelf.pickview.delegate=self;
                [weakSelf.pickview show];
                
            }else{
                NSLog(@"返回数据有误");
            }
            
        }else
        {
            [XHToast showCenterWithText:@"获取城市列表失败"];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

-(void)areaButtonClick{

    if ([self.cityButton.currentTitleColor isEqual:[UIColor colorFromHexString:@"BFBFBF"]])
    {
        [XHToast showCenterWithText:@"请选择您所在的城市"];
        return;
    }
    
    LSWEAKSELF;

    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.cityButton.titleLabel.text forKey:@"city"];
    
    NSString* url = PATH(@"%@/county");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            
            if ([responseObj[@"data"] isKindOfClass:[NSArray class]]) {
                [weakSelf.areaMutlArr removeAllObjects];
                NSArray* hospital_cityArr = responseObj[@"data"];
                
                for (NSDictionary* dict in hospital_cityArr ) {
                    if (dict[@"hospital_county"]) {
                        [weakSelf.areaMutlArr addObject:dict[@"hospital_county"]];
                    }
                    
                }
                
                NSArray* areaArr = [self.areaMutlArr copy];//将mutlArr转成Arr
                
                if (areaArr.count == 0)
                {
                    [XHToast showCenterWithText:@"无数据"];
                    return ;
                }
                
                weakSelf.pickview=[[ZHPickView alloc] initPickviewWithArray:@[areaArr] isHaveNavControler:NO];
                weakSelf.pickview.tag = 2;
                weakSelf.pickview.delegate=self;
                [weakSelf.pickview show];
                
            }else{
                NSLog(@"返回数据有误");
            }
        }else
        {
            [XHToast showCenterWithText:@"获取区域列表失败"];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

-(void)hospitalButtonClick{
    
    if ([self.cityButton.currentTitleColor isEqual:[UIColor colorFromHexString:@"BFBFBF"]])
    {
        [XHToast showCenterWithText:@"请选择您所在的城市"];
        return;
    }
    
    if ([self.areaButton.currentTitleColor isEqual:[UIColor colorFromHexString:@"BFBFBF"]])
    {
        [XHToast showCenterWithText:@"请选择您所在的地区"];
        return;
    }
    
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.areaButton.titleLabel.text forKey:@"county"];
    
    NSString* url = PATH(@"%@/hospital");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            
            if ([responseObj[@"data"] isKindOfClass:[NSArray class]]) {
                [weakSelf.hospitalMutlArr removeAllObjects];
                [weakSelf.hospitalMutlArr addObjectsFromArray:responseObj[@"data"]];
                
                NSMutableArray* hospitalNameArr = [NSMutableArray array];
                [hospitalNameArr removeAllObjects];
                for (NSDictionary* dict in weakSelf.hospitalMutlArr ) {
                    if (dict[@"hospital_name"]) {
                        [hospitalNameArr addObject:dict[@"hospital_name"]];
                    }
                    
                }
                
                NSArray* hospitalArr = [hospitalNameArr copy];//将mutlArr转成Arr
                
                if (hospitalArr.count == 0)
                {
                    [XHToast showCenterWithText:@"无数据"];
                    return ;
                }
                
                weakSelf.pickview=[[ZHPickView alloc] initPickviewWithArray:@[hospitalArr] isHaveNavControler:NO];
                weakSelf.pickview.tag = 3;
                weakSelf.pickview.delegate=self;
                [weakSelf.pickview show];
                
            }else{
                NSLog(@"返回数据有误");
            }
            
        }else
        {
            [XHToast showCenterWithText:@"获取医院列表失败"];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

-(void)roomButtonClick{
    
    LSWEAKSELF;
    
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

-(void)careerButtonClick{
    
    LSWEAKSELF;
    
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

-(void)commitButtonClick{
    
    if (self.nameTextField.text.length <= 0)
    {
        [XHToast showCenterWithText:@"请填写您的真实姓名"];
        return;
    }
    
    if ([self.cityButton.currentTitleColor isEqual:[UIColor colorFromHexString:@"BFBFBF"]])
    {
        [XHToast showCenterWithText:@"请选择您所在的城市"];
        return;
    }
    
    if ([self.areaButton.currentTitleColor isEqual:[UIColor colorFromHexString:@"BFBFBF"]])
    {
        [XHToast showCenterWithText:@"请选择您所在的地区"];
        return;
    }
    
    if ([self.hospitalButton.currentTitleColor isEqual:[UIColor colorFromHexString:@"BFBFBF"]])
    {
        [XHToast showCenterWithText:@"请选择您所在的科室"];
        return;
    }
    
    if ([self.careerButton.currentTitleColor isEqual:[UIColor colorFromHexString:@"BFBFBF"]])
    {
        [XHToast showCenterWithText:@"请选择您的职称"];
        return;
    }
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.phoneNumStr forKey:@"phone"];
    [param setValue:self.verNumStr forKey:@"code"];
    [param setValue:[NSString md5String:self.pwdStr] forKey:@"pwd"];
    [param setValue:self.nameTextField.text forKey:@"doctorname"];
    [param setValue:self.projectId forKey:@"dep"];
    [param setValue:self.careerButton.titleLabel.text forKey:@"title"];
    [param setValue:self.hospital_id forKey:@"hosid"];
    
    NSString* url = PATH(@"%@/my/register");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            
            NSLog(@"注册会话成功");
            
            if (responseObj[@"message"]) {
                [XHToast showCenterWithText:responseObj[@"message"]];
                //注册成功后去登录
                
                
                
                [self loginData];
            }
        }else
        {
            [XHToast showCenterWithText:@"保存失败"];
        }
        
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

#pragma mark -- 自动登录请求
- (void)loginData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.phoneNumStr forKey:@"phone"];
    [param setValue:[NSString md5String:self.pwdStr] forKey:@"passwd"];
    
    NSString* url = PATH(@"%@/login/passwd");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary * dict = responseObj;
            
            if (dict[@"status"] && [dict[@"status"] isEqualToString:@"0"]&& dict[@"cookie"]) {
                //登录成功
                [Defaults setBool:YES forKey:@"isLogin"];
                [Defaults setValue:dict[@"cookie"] forKey:@"cookie"];
                [Defaults setValue:self.phoneNumStr forKey:@"phoneNum"];
                [Defaults setValue:dict[@"username"] forKey:@"username"];

                NSString* cookie = dict[@"cookie"];
                NSRange rang = {32,1};
                NSString* doctorId = [cookie substringWithRange:rang];
                
                [Defaults setValue:doctorId forKey:@"doctorid"];
                
                [Defaults synchronize];
                
                [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"ug369D%@",doctorId]
                                                  password:@"000000"
                                                completion:^(NSString *aUsername, EMError *aError) {
                                                    if (!aError) {
                                                        NSLog(@"环信登录成功");
                                                    } else {
                                                        NSLog(@"环信登录失败");
                                                    }
                                                }];

                [self asyncGroupFromServer];
                
                //注册成功直接登录，并不用验证个人信息
                
//                MDTabbarVC* tabbarVC = [[MDTabbarVC alloc] init];
//                [self presentViewController:tabbarVC animated:YES completion:^{
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }];
                AppDelegate *app = LSAPPDELEGATE;
                [app intoRootForMain];
                
            }else{
                //当返回status不为0时
                if (responseObj[@"message"]) {
                    [XHToast showCenterWithText:responseObj[@"message"]];
                }
            }
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

- (void)asyncGroupFromServer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient].groupManager getJoinedGroups];
        EMError *error = nil;
        [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:nil pageSize:0 error:&error];
        if (!error) {
            
        }
    });
    
    if (![FMDBTool typeListWithTypeListName:CHATUSERTABLE]) {
        [FMDBTool createTypeListTableWithTyoeListName:CHATUSERTABLE type:CHATUSERKEYS];
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ZhpickVIewDelegate 点击确定方法的回调
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    NSLog(@"%@",resultString);
    if (pickView.tag == 1)
    {
        //城市名称
        [self.cityButton setTitle:resultString forState:UIControlStateNormal];
        [self.cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.areaButton setTitle:@"请选择所在区" forState:UIControlStateNormal];
        [self.areaButton setTitleColor:[UIColor colorFromHexString:@"BFBFBF"] forState:UIControlStateNormal];
        [self.hospitalButton setTitle:@"请选择所在医院" forState:UIControlStateNormal];
        [self.hospitalButton setTitleColor:[UIColor colorFromHexString:@"BFBFBF"] forState:UIControlStateNormal];
        [self.roomButton setTitle:@"请选择所在科室" forState:UIControlStateNormal];
        [self.roomButton setTitleColor:[UIColor colorFromHexString:@"BFBFBF"] forState:UIControlStateNormal];
    }
    else if(pickView.tag == 2)
    {
        //所在区
        [self.areaButton setTitle:resultString forState:UIControlStateNormal];
        [self.areaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.hospitalButton setTitle:@"请选择所在医院" forState:UIControlStateNormal];
        [self.hospitalButton setTitleColor:[UIColor colorFromHexString:@"BFBFBF"] forState:UIControlStateNormal];
        [self.roomButton setTitle:@"请选择所在科室" forState:UIControlStateNormal];
        [self.roomButton setTitleColor:[UIColor colorFromHexString:@"BFBFBF"] forState:UIControlStateNormal];
    }
    else if(pickView.tag == 3)
    {
        //医院
        [self.hospitalButton setTitle:resultString forState:UIControlStateNormal];
        [self.hospitalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.roomButton setTitle:@"请选择所在科室" forState:UIControlStateNormal];
        [self.roomButton setTitleColor:[UIColor colorFromHexString:@"BFBFBF"] forState:UIControlStateNormal];
        
        for (NSDictionary* dict in self.hospitalMutlArr) {
            if (dict[@"hospital_name"] && dict[@"hospital_name"] && [dict[@"hospital_name"] isEqualToString:self.hospitalButton.titleLabel.text]) {
                
                self.hospital_id = dict[@"hospital_id"];
            }
        }
    }
    else if(pickView.tag == 5)
    {
        //职称
        [self.careerButton setTitle:resultString forState:UIControlStateNormal];
        [self.careerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    [self.roomButton setTitle:self.department_name forState:UIControlStateNormal];
    [self.roomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

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

#pragma mark - setter && getter

-(UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc]init];
        _nameTextField.placeholder = @"请填写您的真实姓名";
        _nameTextField.tintColor = [UIColor colorFromHexString:LSGREENCOLOR];
        _nameTextField.font = [UIFont systemFontOfSize:14];
        [_nameTextField addTarget:self action:@selector(nameTextChangged:) forControlEvents:UIControlEventEditingChanged];

    }
    return _nameTextField;
}

-(UIButton *)clearButton{
    if (!_clearButton) {
        _clearButton = [[UIButton alloc]init];
        [_clearButton addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_clearButton setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
        _clearButton.hidden = YES;
    }
    return _clearButton;
}

-(UIButton *)cityButton{
    if (!_cityButton) {
        _cityButton = [[UIButton alloc]init];
        [_cityButton addTarget:self action:@selector(cityButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_cityButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cityButton setTitle:@"请选择您所在的城市" forState:UIControlStateNormal];
        _cityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _cityButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cityButton setTitleColor:[UIColor colorFromHexString:@"bfbfbf"] forState:UIControlStateNormal];
    }
    return _cityButton;
}

-(UIButton *)areaButton{
    if (!_areaButton) {
        _areaButton = [[UIButton alloc]init];
        [_areaButton addTarget:self action:@selector(areaButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_areaButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_areaButton setTitle:@"请选择您所在的区" forState:UIControlStateNormal];
        _areaButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _areaButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_areaButton setTitleColor:[UIColor colorFromHexString:@"bfbfbf"] forState:UIControlStateNormal];

    }
    return _areaButton;
}

-(UIButton *)hospitalButton{
    if (!_hospitalButton) {
        _hospitalButton = [[UIButton alloc]init];
        [_hospitalButton addTarget:self action:@selector(hospitalButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_hospitalButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_hospitalButton setTitle:@"请选择您所在的医院" forState:UIControlStateNormal];
        _hospitalButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _hospitalButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_hospitalButton setTitleColor:[UIColor colorFromHexString:@"bfbfbf"] forState:UIControlStateNormal];
    }
    return _hospitalButton;
}

-(UIButton *)roomButton{
    if (!_roomButton) {
        _roomButton = [[UIButton alloc]init];
        [_roomButton addTarget:self action:@selector(roomButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_roomButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_roomButton setTitle:@"请选择您所在的科室" forState:UIControlStateNormal];
        _roomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _roomButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_roomButton setTitleColor:[UIColor colorFromHexString:@"bfbfbf"] forState:UIControlStateNormal];
    }
    return _roomButton;
}

-(UIButton *)careerButton{
    if (!_careerButton) {
        _careerButton = [[UIButton alloc]init];
        [_careerButton addTarget:self action:@selector(careerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_careerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_careerButton setTitle:@"请选择您的职称" forState:UIControlStateNormal];
        _careerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _careerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_careerButton setTitleColor:[UIColor colorFromHexString:@"bfbfbf"] forState:UIControlStateNormal];
    }
    return _careerButton;
}

-(UIButton *)commitButton{
    if (!_commitButton) {
        _commitButton = [[UIButton alloc]init];
        [_commitButton addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _commitButton.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
        [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
        _commitButton.layer.masksToBounds = YES;
        _commitButton.layer.cornerRadius = 20;
        _commitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _commitButton;
}

@end
