//
//  LSMineNewPswController.m
//  LSKJChart
//
//  Created by 刘博宇 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineNewPswController.h"

@interface LSMineNewPswController ()

@property (nonatomic,strong)UITextField * oldPswTextField;

@property (nonatomic,strong)UITextField * secPswTextField;

@property (nonatomic,strong)UITextField * nPswTextField;

@property (nonatomic,strong)UIButton *sureButton;

@end

@implementation LSMineNewPswController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initNavView];
    [self initForView];
    [self initTouchEvents];
}

//-(void)initNavView{
//    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,64)];
//    navView.backgroundColor = [UIColor colorFromHexString:LSGREENCOLOR];
//    [self.view addSubview:navView];
//    
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
//    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:backButton];
//    
//    
//    UILabel *titleLabel = [[UILabel alloc]init];
//    titleLabel.font = [UIFont systemFontOfSize:18];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.text = @"设置密码";
//    titleLabel.backgroundColor = [UIColor clearColor];
//    [navView addSubview:titleLabel];
//    
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(navView);
//        make.centerY.equalTo(navView).offset(8);
//    }];
//}

-(void)initForView{
    
    self.navigationItem.title = @"设置密码";
    
    [self.view addSubview:self.oldPswTextField];
    [self.view addSubview:self.nPswTextField];
    [self.view addSubview:self.secPswTextField];
    [self.view addSubview:self.sureButton];
    
    [self.oldPswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
//        make.top.equalTo(self.view).offset(64+18);
        make.top.equalTo(self.view).offset(18);
    }];
    
    UIView *line = [self getLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(self.oldPswTextField.mas_bottom).offset(8);
        make.height.mas_equalTo(1);
    }];
    
    [self.nPswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(line).offset(18);
    }];
    
    line = [self getLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(self.nPswTextField.mas_bottom).offset(8);
        make.height.mas_equalTo(1);
    }];
    
    [self.secPswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(line).offset(18);
    }];
    
    line = [self getLine];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(self.secPswTextField.mas_bottom).offset(4);
        make.height.mas_equalTo(1);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.height.mas_equalTo(40);
        make.top.equalTo(line).offset(50);
    }];
}

-(void)initTouchEvents{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

//键盘滑落
-(void)keyboardHide{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sureButtonClick{
    
}

-(UIView *)getLine{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorFromHexString:@"dedede"];
    [self.view addSubview:line];
    return line;
}

-(UITextField *)oldPswTextField{
    if (!_oldPswTextField) {
        _oldPswTextField = [[UITextField alloc]init];
        _oldPswTextField.font = [UIFont systemFontOfSize:14];
        _oldPswTextField.placeholder = @"请输入原密码";
        _oldPswTextField.tintColor = [UIColor colorFromHexString:LSGREENCOLOR];

    }
    return _oldPswTextField;
}

-(UITextField *)secPswTextField{
    if (!_secPswTextField) {
        _secPswTextField = [[UITextField alloc]init];
        _secPswTextField.font = [UIFont systemFontOfSize:14];
        _secPswTextField.placeholder = @"请再次输入新密码";
        _secPswTextField.tintColor = [UIColor colorFromHexString:LSGREENCOLOR];

    }
    return _secPswTextField;
}

-(UITextField *)nPswTextField{
    if (!_nPswTextField) {
        _nPswTextField = [[UITextField alloc]init];
        _nPswTextField.font = [UIFont systemFontOfSize:14];
        _nPswTextField.placeholder = @"请输入新密码";
        _nPswTextField.tintColor = [UIColor colorFromHexString:LSGREENCOLOR];
    }
    return _nPswTextField;
}

-(UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [[UIButton alloc]init];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
        [_sureButton setTitle:@"提交" forState:UIControlStateNormal];
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 20;
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _sureButton;
}

@end
