//
//  LSLoginController.m
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSLoginController.h"
#import "YYShopMainTypeView.h"
@interface LSLoginController ()<UITextFieldDelegate,YYShopMainTypeViewDelegate>

@property (nonatomic,strong) UITextField *phoneTextFiled;

@property (nonatomic,strong) UITextField *pswTestFiled;

@property (nonatomic,strong) UIButton *phoneClearButton;

@property (nonatomic,strong) UIButton *sendCodeButton;

@property (nonatomic,strong) UIButton *loginButton;

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
    [self.view addSubview:self.pswTestFiled];
    [self.view addSubview:self.phoneNoticeLabel];
    [self.view addSubview:self.pswNoticeLabel];
    [self.view addSubview:self.phoneLine];
    [self.view addSubview:self.pswLine];
    [self.view addSubview:self.phoneClearButton];
    [self.view addSubview:self.sendCodeButton];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registLabel];
    
    [self.phoneTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(100);
    }];
    
    [self.phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTextFiled);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.phoneTextFiled.mas_bottom).offset(2);
    }];
}

#pragma mark -YYShopMainTypeViewDelegate

-(void)selectTypeIndex:(NSInteger)index{
    if (index == 0) {
        //密码登录
        self.sendCodeButton.hidden = YES;
        self.pswTestFiled.placeholder =@"请输入密码";
    }else{
        //验证码登录
        self.sendCodeButton.hidden = NO;
        self.pswTestFiled.placeholder =@"输入验证码";

    }
}

#pragma mark - click events

-(void)back{
    
}

-(void)phoneClearButtonClick{
    
}

-(void)sendCodeButtonClick{
    
}

-(void)loginButtonClick{
    
}

#pragma mark - setter && getter

-(YYShopMainTypeView *)typeView{
    if (!_typeView) {
        _typeView = [[YYShopMainTypeView alloc]initFrame:CGRectMake((self.view.frame.size.width-200)/2 , 0, 200, 49) filters:@[@"密码登录",@"验证码登录"]];
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

-(UITextField *)pswTestFiled{
    if (!_pswTestFiled) {
        _pswTestFiled = [[UITextField alloc]init];
        _pswTestFiled.keyboardType = UIKeyboardTypeNumberPad;
        _pswTestFiled.delegate = self;

    }
    return _pswTestFiled;
}

-(UIButton *)phoneClearButton{
    if (!_phoneClearButton) {
        _phoneClearButton = [[UIButton alloc]init];
        [_phoneClearButton addTarget:self action:@selector(phoneClearButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneClearButton;
}

-(UIButton *)sendCodeButton{
    if (!_sendCodeButton) {
        _sendCodeButton = [[UIButton alloc]init];
        [_sendCodeButton addTarget:self action:@selector(sendCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendCodeButton;
}

-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
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
        
        NSString *string = @"还没有账号？点击注册";
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(string.length-4, 4)];
        
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
