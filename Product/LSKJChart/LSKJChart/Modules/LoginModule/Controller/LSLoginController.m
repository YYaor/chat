//
//  LSLoginController.m
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSLoginController.h"
#import "YYShopMainTypeView.h"
#import "NSString+Mark.h"
@interface LSLoginController ()<UITextFieldDelegate,YYShopMainTypeViewDelegate>

@property (nonatomic,strong) UITextField *phoneTextFiled;

@property (nonatomic,strong) UITextField *pswTextFiled;

@property (nonatomic,strong) UIButton *phoneClearButton;

@property (nonatomic,strong) UIButton *sendCodeButton;

@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic,strong) UIButton *registButton;

@property (nonatomic,strong) UILabel *phoneNoticeLabel;

@property (nonatomic,strong) UILabel *pswNoticeLabel;

@property (nonatomic,strong) UILabel *registLabel;

@property (nonatomic,strong) UIView *phoneLine;

@property (nonatomic,strong) UIView *pswLine;

@property (nonatomic,strong) YYShopMainTypeView *typeView;

@end

@implementation LSLoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self initNavView];
    [self initForView];
    [self initTouchEvents];

}

-(void)initNavView{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,64)];
    navView.backgroundColor = [UIColor colorFromHexString:@"555555"];
    [self.view addSubview:navView];

    [self.view addSubview:self.typeView];
}

-(void)initForView{
    [self.view addSubview:self.typeView];
    [self.view addSubview:self.phoneTextFiled];
    [self.view addSubview:self.pswTextFiled];
    [self.view addSubview:self.phoneNoticeLabel];
    [self.view addSubview:self.pswNoticeLabel];
    [self.view addSubview:self.phoneLine];
    [self.view addSubview:self.pswLine];
    [self.view addSubview:self.phoneClearButton];
    [self.view addSubview:self.sendCodeButton];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registLabel];
    [self.view addSubview:self.registButton];
    
    [self.phoneTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(100);
    }];
    
    [self.phoneClearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.phoneTextFiled.mas_right);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.phoneTextFiled);
    }];
    
    [self.phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTextFiled);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.phoneTextFiled.mas_bottom).offset(2);
    }];
    
    [self.pswTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLine.mas_bottom).offset(50);
        make.left.right.equalTo(self.phoneTextFiled);
    }];
    
    [self.pswLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.pswTextFiled);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.pswTextFiled.mas_bottom).offset(2);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pswLine).offset(50);
        make.left.right.equalTo(self.phoneTextFiled);
        make.height.mas_equalTo(40);
    }];
    
    [self.registLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
    }];
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.registLabel);
    }];
    
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pswTextFiled.mas_right);
        make.centerY.equalTo(self.pswTextFiled);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
}

-(void)initTouchEvents{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - YYShopMainTypeViewDelegate

-(void)selectTypeIndex:(NSInteger)index{
    if (index == 0) {
        //密码登录
        self.sendCodeButton.hidden = YES;
        self.pswTextFiled.placeholder =@"请输入密码";
    }else{
        //验证码登录
        self.sendCodeButton.hidden = NO;
        self.pswTextFiled.placeholder =@"输入验证码";

    }
}

#pragma mark - click events
//键盘滑落
-(void)keyboardHide{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)phoneClearButtonClick{
    self.phoneTextFiled.text = nil;
}

-(void)sendCodeButtonClick{
    
    if (self.phoneTextFiled.text == nil || self.phoneTextFiled.text.length == 0) {
        [LSUtil showAlter:self.view withText:@"请输入手机号码" withOffset:-20];
        return;
    }
    
    if (![NSString isMobile:self.phoneTextFiled.text]) {
        self.phoneLine.backgroundColor = [UIColor redColor];
        self.phoneNoticeLabel.text = @"手机号码格式不正确";
        return;
    }
}

-(void)loginButtonClick{
    
    if (self.phoneTextFiled.text == nil || self.phoneTextFiled.text.length == 0) {
        [LSUtil showAlter:self.view withText:@"请输入手机号码" withOffset:-20];
        return;
    }
    
    if (![NSString isMobile:self.phoneTextFiled.text]) {
        self.phoneLine.backgroundColor = [UIColor redColor];
        self.phoneNoticeLabel.text = @"手机号码格式不正确";
        return;
    }

}

-(void)registButtonClick{
    
}

#pragma mark - setter && getter

-(YYShopMainTypeView *)typeView{
    if (!_typeView) {
        _typeView = [[YYShopMainTypeView alloc]initFrame:CGRectMake((self.view.frame.size.width-200)/2 , 17, 200, 49) filters:@[@"密码登录",@"验证码登录"]];
        _typeView.backgroundColor = [UIColor clearColor];
        _typeView.delegate = self;
    }
    return _typeView;
}

-(UITextField *)phoneTextFiled{
    if (!_phoneTextFiled) {
        _phoneTextFiled = [[UITextField alloc]init];
        _phoneTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextFiled.delegate = self;
        _phoneTextFiled.placeholder = @"请输入手机号";
    }
    return _phoneTextFiled;
}

-(UITextField *)pswTextFiled{
    if (!_pswTextFiled) {
        _pswTextFiled = [[UITextField alloc]init];
        _pswTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _pswTextFiled.placeholder =@"请输入密码";
        _pswTextFiled.delegate = self;

    }
    return _pswTextFiled;
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

-(UIButton *)registButton{
    if (!_registButton) {
        _registButton = [[UIButton alloc]init];
        [_registButton addTarget:self action:@selector(registButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registButton;
}

-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.backgroundColor = [UIColor grayColor];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 20;
    }
    return _loginButton;
}

-(UILabel *)phoneNoticeLabel{
    if (!_phoneNoticeLabel) {
        _phoneNoticeLabel = [[UILabel alloc]init];
        _phoneNoticeLabel.text = @"手机号码格式不正确";
        _phoneNoticeLabel.hidden = YES;
    }
    return _phoneNoticeLabel;
}

-(UILabel *)pswNoticeLabel{
    if (!_pswNoticeLabel) {
        _pswNoticeLabel = [[UILabel alloc]init];
        _pswNoticeLabel.text = @"验证码已发送到手机，请注意查收";
        _pswNoticeLabel.hidden = YES;
    }
    return _pswNoticeLabel;
}

-(UILabel *)registLabel{
    if (!_registLabel) {
        _registLabel = [[UILabel alloc]init];
        _registLabel.textColor = [UIColor grayColor];
        NSString *string = @"还没有账号？点击注册";
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(string.length-4, 4)];
        _registLabel.attributedText = attString;
    }
    return _registLabel;
}

-(UIView *)phoneLine{
    if (!_phoneLine) {
        _phoneLine = [[UIView alloc]init];
        _phoneLine.backgroundColor = [UIColor grayColor];
    }
    return _phoneLine;
}

-(UIView *)pswLine{
    if (!_pswLine) {
        _pswLine = [[UIView alloc]init];
        _pswLine.backgroundColor = [UIColor grayColor];
    }
    return _pswLine;
}

@end
