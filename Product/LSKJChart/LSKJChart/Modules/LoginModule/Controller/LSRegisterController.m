//
//  LSRegisterController.m
//  LSKJChart
//
//  Created by 刘博宇 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSRegisterController.h"

@interface LSRegisterController ()

@property (nonatomic,strong) UITextField *phoneTextField;

@property (nonatomic,strong) UITextField *codeTextField;

@property (nonatomic,strong) UITextField *pswTextField;

@property (nonatomic,strong) UITextField *confPswTextField;

@property (nonatomic,strong) UIButton *phoneClearButton;

@property (nonatomic,strong) UIButton *sendCodeButton;

@property (nonatomic,strong) UIButton *nextButton;

@property (nonatomic,strong) UIButton *agreementButton;

@property (nonatomic,strong) UIView *phoneLine;

@property (nonatomic,strong) UIView *pswLine;

@property (nonatomic,strong) UIView *codeLine;

@property (nonatomic,strong) UIView *confPswLine;

@end

@implementation LSRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self initNavView];
    [self initForView];
    [self initTouchEvents];
}

-(void)initNavView{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,64)];
    navView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:navView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"down-back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"注册佑格医生";
    titleLabel.backgroundColor = [UIColor clearColor];
    [navView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navView);
        make.centerY.equalTo(navView).offset(8);
    }];
}

-(void)initForView{
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.pswTextField];
    [self.view addSubview:self.confPswTextField];
    [self.view addSubview:self.phoneClearButton];
    [self.view addSubview:self.sendCodeButton];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.agreementButton];
    [self.view addSubview:self.phoneLine];
    [self.view addSubview:self.codeLine];
    [self.view addSubview:self.pswLine];
    [self.view addSubview:self.confPswLine];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(100);
    }];
    
    [self.phoneClearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.phoneTextField.mas_right);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.phoneTextField);
    }];
    
    [self.phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTextField);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(2);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLine.mas_bottom).offset(50);
        make.left.right.equalTo(self.phoneTextField);
    }];
    
    [self.codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTextField);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.codeTextField.mas_bottom).offset(2);
    }];
    
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.codeTextField.mas_right);
        make.centerY.equalTo(self.codeTextField);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];

    [self.pswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLine.mas_bottom).offset(25);
        make.left.right.equalTo(self.phoneTextField);
    }];

    [self.pswLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTextField);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.pswTextField.mas_bottom).offset(2);
    }];

    [self.confPswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pswLine.mas_bottom).offset(25);
        make.left.right.equalTo(self.phoneTextField);
    }];

    [self.confPswLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTextField);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.confPswTextField.mas_bottom).offset(2);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confPswLine).offset(50);
        make.left.right.equalTo(self.confPswTextField);
        make.height.mas_equalTo(40);
    }];
    
    [self.agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nextButton.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
    }];
}

-(void)initTouchEvents{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - clickEvents

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//键盘滑落
-(void)keyboardHide{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)phoneClearButtonClick{
    
}

-(void)sendCodeButtonClick{
    
}

-(void)nextButtonClick{
    
}

#pragma mark - setter && getter

-(UITextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]init];
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.placeholder = @"请输入手机号";
    }
    return _phoneTextField;
}

-(UITextField *)pswTextField{
    if (!_pswTextField) {
        _pswTextField = [[UITextField alloc]init];
        _pswTextField.keyboardType = UIKeyboardTypeNumberPad;
        _pswTextField.placeholder =@"请设置登录密码";
    }
    return _pswTextField;
}

-(UITextField *)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc]init];
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.placeholder =@"输入验证码";
    }
    return _codeTextField;
}

-(UITextField *)confPswTextField{
    if (!_confPswTextField) {
        _confPswTextField = [[UITextField alloc]init];
        _confPswTextField.keyboardType = UIKeyboardTypeNumberPad;
        _confPswTextField.placeholder =@"再次输入登录密码";
    }
    return _confPswTextField;
}

-(UIButton *)phoneClearButton{
    if (!_phoneClearButton) {
        _phoneClearButton = [[UIButton alloc]init];
        _phoneClearButton.backgroundColor = [UIColor blackColor];
        [_phoneClearButton addTarget:self action:@selector(phoneClearButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneClearButton;
}

-(UIButton *)sendCodeButton{
    if (!_sendCodeButton) {
        _sendCodeButton = [[UIButton alloc]init];
        [_sendCodeButton addTarget:self action:@selector(sendCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _sendCodeButton.layer.masksToBounds = YES;
        _sendCodeButton.layer.cornerRadius = 10;
        _sendCodeButton.layer.borderWidth = 1;
        _sendCodeButton.layer.borderColor = [UIColor grayColor].CGColor;
        _sendCodeButton.hidden = YES;
    }
    return _sendCodeButton;
}

-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc]init];
        [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.backgroundColor = [UIColor grayColor];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.cornerRadius = 20;
    }
    return _nextButton;
}

-(UIButton *)agreementButton{
    if (!_agreementButton) {
        _agreementButton = [[UIButton alloc]init];
        [_agreementButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        NSString *string = @"点击注册即同意《佑格医生用户协议》";
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(string.length-10, 10)];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length-10)];
        [_agreementButton setAttributedTitle:attString forState:UIControlStateNormal];
    }
    return _agreementButton;
}

-(UIView *)phoneLine{
    if (!_phoneLine) {
        _phoneLine = [[UIView alloc]init];
        _phoneLine.backgroundColor = [UIColor grayColor];
    }
    return _phoneLine;
}

-(UIView *)codeLine{
    if (!_codeLine) {
        _codeLine = [[UIView alloc]init];
        _codeLine.backgroundColor = [UIColor grayColor];
    }
    return _codeLine;
}

-(UIView *)confPswLine{
    if (!_confPswLine) {
        _confPswLine = [[UIView alloc]init];
        _confPswLine.backgroundColor = [UIColor grayColor];
    }
    return _confPswLine;
}

-(UIView *)pswLine{
    if (!_pswLine) {
        _pswLine = [[UIView alloc]init];
        _pswLine.backgroundColor = [UIColor grayColor];
    }
    return _pswLine;
}

@end
