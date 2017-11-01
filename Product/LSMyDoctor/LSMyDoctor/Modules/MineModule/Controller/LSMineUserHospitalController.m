//
//  LSMineUserHospitalController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/31.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineUserHospitalController.h"

#import "LSMineUserSettingController.h"

@interface LSMineUserHospitalController () <ZHPickViewDelegate>

@property (nonatomic,strong)UIButton *cityButton;

@property (nonatomic,strong)UIButton *areaButton;

@property (nonatomic,strong)UIButton *hospitalButton;

@property (nonatomic,strong)UIButton *commitButton;

@property (nonatomic, strong) NSMutableArray* cityMutlArr;//城市
@property (nonatomic, strong) NSMutableArray* areaMutlArr;//区域
@property (nonatomic, strong) NSMutableArray* hospitalMutlArr;//医院

@property (nonatomic, strong) NSString *hospital_id;

@property (nonatomic, strong) ZHPickView *pickview;

@end

@implementation LSMineUserHospitalController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"编辑医院";
    
    self.cityMutlArr = [NSMutableArray array];
    self.areaMutlArr = [NSMutableArray array];
    self.hospitalMutlArr = [NSMutableArray array];
    
    [self.view addSubview:self.cityButton];
    [self.view addSubview:self.areaButton];
    [self.view addSubview:self.hospitalButton];
    [self.view addSubview:self.commitButton];
    
    UIView *line = nil;
    
    [self.cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(20);
    }];
    
    line = [self newLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cityButton).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.cityButton.mas_bottom).offset(2);
    }];
    
    [self.areaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(30);
        make.left.right.equalTo(self.cityButton);
        make.height.mas_equalTo(20);
    }];
    
    line = [self newLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cityButton).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.areaButton.mas_bottom).offset(2);
    }];
    
    [self.hospitalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(30);
        make.left.right.equalTo(self.cityButton);
        make.height.mas_equalTo(20);
    }];
    
    line = [self newLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cityButton).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.hospitalButton.mas_bottom).offset(2);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cityButton);
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
        [XHToast showTopWithText:@"请先获取所在城市"];
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
        [XHToast showTopWithText:@"请先获取所在城市"];
        return;
    }
    
    if ([self.areaButton.currentTitleColor isEqual:[UIColor colorFromHexString:@"BFBFBF"]])
    {
        [XHToast showTopWithText:@"请先获取所在区"];
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

-(void)commitButtonClick{
    
    if ([self.cityButton.currentTitleColor isEqual:[UIColor colorFromHexString:@"BFBFBF"]])
    {
        [XHToast showTopWithText:@"请先获取所在城市"];
        return;
    }
    
    if ([self.areaButton.currentTitleColor isEqual:[UIColor colorFromHexString:@"BFBFBF"]])
    {
        [XHToast showTopWithText:@"请先获取所在区"];
        return;
    }
    
    if ([self.hospitalButton.currentTitleColor isEqual:[UIColor colorFromHexString:@"BFBFBF"]])
    {
        [XHToast showTopWithText:@"请先获取所在医院"];
        return;
    }
    
    NSArray *vcs = self.navigationController.viewControllers;
    
    LSMineUserSettingController *vc = vcs[vcs.count-2];
    
    //姓名
    NSMutableArray *arr = [NSMutableArray arrayWithArray:vc.model.myBaseInfo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[2]];
    [dic setValue:self.hospital_id forKey:@"id"];
    [arr replaceObjectAtIndex:2 withObject:dic];
    vc.model.myBaseInfo = arr;
    
    [vc updateMainInfoData];
    
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
    }
    else if(pickView.tag == 2)
    {
        //所在区
        [self.areaButton setTitle:resultString forState:UIControlStateNormal];
        [self.areaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.hospitalButton setTitle:@"请选择所在医院" forState:UIControlStateNormal];
        [self.hospitalButton setTitleColor:[UIColor colorFromHexString:@"BFBFBF"] forState:UIControlStateNormal];
    }
    else if(pickView.tag == 3)
    {
        //医院
        [self.hospitalButton setTitle:resultString forState:UIControlStateNormal];
        [self.hospitalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        for (NSDictionary* dict in self.hospitalMutlArr) {
            if (dict[@"hospital_name"] && dict[@"hospital_name"] && [dict[@"hospital_name"] isEqualToString:self.hospitalButton.titleLabel.text]) {
                
                self.hospital_id = dict[@"hospital_id"];
            }
        }
    }
}

#pragma mark - getter & setter 

-(UIButton *)cityButton{
    if (!_cityButton) {
        _cityButton = [[UIButton alloc]init];
        [_cityButton addTarget:self action:@selector(cityButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_cityButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cityButton setTitle:@"请选择所在城市" forState:UIControlStateNormal];
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
        [_areaButton setTitle:@"请选择所在区" forState:UIControlStateNormal];
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
        [_hospitalButton setTitle:@"请选择所在医院" forState:UIControlStateNormal];
        _hospitalButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _hospitalButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_hospitalButton setTitleColor:[UIColor colorFromHexString:@"bfbfbf"] forState:UIControlStateNormal];
    }
    return _hospitalButton;
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
