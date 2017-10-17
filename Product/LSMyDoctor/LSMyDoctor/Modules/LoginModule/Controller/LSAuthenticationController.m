//
//  LSAuthenticationController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSAuthenticationController.h"

@interface LSAuthenticationController ()

@property (nonatomic,strong)UITextField *nameTextField;

@property (nonatomic,strong)UIButton *clearButton;

@property (nonatomic,strong)UIButton *cityButton;

@property (nonatomic,strong)UIButton *areaButton;

@property (nonatomic,strong)UIButton *hospitalButton;

@property (nonatomic,strong)UIButton *roomButton;

@property (nonatomic,strong)UIButton *careerButton;

@property (nonatomic,strong)UIButton *commitButton;

@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSString *city;

@property (nonatomic,strong)NSString *area;

@property (nonatomic,strong)NSString *hospital;

@property (nonatomic,strong)NSString *career;

@end

@implementation LSAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self initNavView];
    [self initForView];
    [self initTouchEvents];
}

-(void)initNavView{
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
}

-(void)initTouchEvents{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
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

//键盘滑落
-(void)keyboardHide{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)clearButtonClick{
    self.clearButton.hidden = YES;
    self.nameTextField.text = nil;
}

-(void)cityButtonClick{
    
}

-(void)areaButtonClick{
    
}

-(void)hospitalButtonClick{
    
}

-(void)roomButtonClick{
    
}

-(void)careerButtonClick{
    
}

-(void)commitButtonClick{
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - setter && getter

-(UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc]init];
        _nameTextField.keyboardType = UIKeyboardTypeNumberPad;
        _nameTextField.placeholder = @"请输入昵称";
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
        _clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _commitButton;
}

@end
