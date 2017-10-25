//
//  LSRegisterController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSRegisterController.h"
#import "LSAuthenticationController.h"
#import "NSString+Mark.h"

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

@property (nonatomic,strong) UILabel *phoneNoticeLabel;

@end

@implementation LSRegisterController
{
    BOOL isFirst;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self initNavView];
    [self initForView];
    [self initTouchEvents];
    
    isFirst = YES;
}

-(void)initNavView{
    
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
    [self.view addSubview:self.phoneNoticeLabel];
    
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
    
    [self.phoneNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLine);
        make.top.equalTo(self.phoneLine.mas_bottom).offset(2);
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

-(void)phoneTextChangged:(UITextField *)sender{
    if (sender.text.length>0) {
        self.phoneClearButton.hidden = NO;
    }else{
        self.phoneClearButton.hidden = YES;
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//键盘滑落
-(void)keyboardHide{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)phoneClearButtonClick{
    self.phoneClearButton.hidden = YES;
    self.phoneTextField.text = nil;
}

-(void)sendCodeButtonClick{
    if (self.phoneTextField.text == nil || self.phoneTextField.text.length == 0) {
        [LSUtil showAlter:self.view withText:@"请输入手机号码" withOffset:-20];
        return;
    }
    
    if (![self isMobile:self.phoneTextField.text]) {
        self.phoneLine.backgroundColor = [UIColor redColor];
        self.phoneNoticeLabel.text = @"手机号码格式不正确";
        return;
    }
    
    NSString* url = PATH(@"%@/misc/code");
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:AccessToken forKey:@"accessToken"];
    [param setValue:self.phoneTextField.text forKey:@"phone"];
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary * dict = responseObj;
            if (dict[@"status"] && [dict[@"status"] isEqualToString:@"0"]) {
                //返回成功
                //获取验证码成功
                NSString* showMessage = @"验证码已发送到手机，请注意查收";
                if (dict[@"message"]) {
                    showMessage = dict[@"message"];
                }
                [XHToast showCenterWithText:showMessage];
                
                [self buttonTitleTime:self.sendCodeButton withTime:@"60"];
            }else{
                NSLog(@"返回格式输出错误");
            }
        }
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
}

- (BOOL)isMobile:(NSString *)string {
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

- (void)buttonTitleTime:(UIButton *)button withTime:(NSString *)time
{
    __block int timeout=[time intValue]-1; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if (isFirst) {
                    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                }else{
                    [button setTitle:@"重新获取" forState:UIControlStateNormal];
                }
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                
                
                button.enabled = YES;
                button.alpha = 1;
                isFirst = NO;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateDisabled];
                button.titleLabel.font = [UIFont systemFontOfSize:13];
                button.enabled = NO;
                button.alpha = 0.4;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

-(void)nextButtonClick{
    
    if (self.phoneTextField.text.length <= 0)
    {
        [XHToast showCenterWithText:@"请输入手机号"];
    }
    
    if (self.codeTextField.text.length <= 0)
    {
        [XHToast showCenterWithText:@"输入验证码"];
    }
    
    if (self.pswTextField.text.length <= 0)
    {
        [XHToast showCenterWithText:@"请设置登录密码"];
    }
    
    if (![self.pswTextField.text isEqualToString:self.confPswTextField.text])
    {
        [XHToast showCenterWithText:@"密码不相同"];
    }
    
    LSAuthenticationController *authenticationController = [[LSAuthenticationController alloc]init];
    authenticationController.phoneNumStr = self.phoneTextField.text;
    authenticationController.verNumStr = self.codeTextField.text;
    authenticationController.pwdStr = self.pswTextField.text;
    [self.navigationController pushViewController:authenticationController animated:YES];
}

-(void)agreementButtonClick{
    
}

#pragma mark - setter && getter

-(UITextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]init];
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.font = [UIFont systemFontOfSize:14];
        _phoneTextField.tintColor = [UIColor colorFromHexString:LSGREENCOLOR];
        [_phoneTextField addTarget:self action:@selector(phoneTextChangged:) forControlEvents:UIControlEventEditingChanged];

    }
    return _phoneTextField;
}

-(UITextField *)pswTextField{
    if (!_pswTextField) {
        _pswTextField = [[UITextField alloc]init];
        _pswTextField.keyboardType = UIKeyboardTypeNumberPad;
        _pswTextField.placeholder =@"请设置登录密码";
        _pswTextField.font = [UIFont systemFontOfSize:14];
        _pswTextField.tintColor = [UIColor colorFromHexString:LSGREENCOLOR];
        
    }
    return _pswTextField;
}

-(UITextField *)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc]init];
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.placeholder =@"输入验证码";
        _codeTextField.font = [UIFont systemFontOfSize:14];
        _codeTextField.tintColor = [UIColor colorFromHexString:LSGREENCOLOR];
    }
    return _codeTextField;
}

-(UITextField *)confPswTextField{
    if (!_confPswTextField) {
        _confPswTextField = [[UITextField alloc]init];
        _confPswTextField.keyboardType = UIKeyboardTypeNumberPad;
        _confPswTextField.placeholder =@"再次输入登录密码";
        _confPswTextField.font = [UIFont systemFontOfSize:14];
        _confPswTextField.tintColor = [UIColor colorFromHexString:LSGREENCOLOR];
    }
    return _confPswTextField;
}

-(UIButton *)phoneClearButton{
    if (!_phoneClearButton) {
        _phoneClearButton = [[UIButton alloc]init];
        [_phoneClearButton addTarget:self action:@selector(phoneClearButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_phoneClearButton setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
        _phoneClearButton.hidden = YES;
    }
    return _phoneClearButton;
}

-(UIButton *)sendCodeButton{
    if (!_sendCodeButton) {
        _sendCodeButton = [[UIButton alloc]init];
        [_sendCodeButton addTarget:self action:@selector(sendCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:[UIColor colorFromHexString:@"8b8b8b"] forState:UIControlStateNormal];
        _sendCodeButton.layer.masksToBounds = YES;
        _sendCodeButton.layer.cornerRadius = 10;
        _sendCodeButton.layer.borderWidth = 1;
        _sendCodeButton.layer.borderColor = [UIColor colorFromHexString:@"e0e0e0"].CGColor;
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _sendCodeButton;
}

-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc]init];
        [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.cornerRadius = 20;
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nextButton;
}

-(UIButton *)agreementButton{
    if (!_agreementButton) {
        _agreementButton = [[UIButton alloc]init];
        _agreementButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_agreementButton addTarget:self action:@selector(agreementButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_agreementButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        NSString *string = @"点击注册即同意《佑格医生用户协议》";
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:LSGREENCOLOR] range:NSMakeRange(string.length-10, 10)];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"8b8b8b"] range:NSMakeRange(0, string.length-10)];
        [_agreementButton setAttributedTitle:attString forState:UIControlStateNormal];
    }
    return _agreementButton;
}

-(UIView *)phoneLine{
    if (!_phoneLine) {
        _phoneLine = [[UIView alloc]init];
        _phoneLine.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
    }
    return _phoneLine;
}

-(UIView *)codeLine{
    if (!_codeLine) {
        _codeLine = [[UIView alloc]init];
        _codeLine.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
    }
    return _codeLine;
}

-(UIView *)confPswLine{
    if (!_confPswLine) {
        _confPswLine = [[UIView alloc]init];
        _confPswLine.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
    }
    return _confPswLine;
}

-(UIView *)pswLine{
    if (!_pswLine) {
        _pswLine = [[UIView alloc]init];
        _pswLine.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
    }
    return _pswLine;
}

-(UILabel *)phoneNoticeLabel{
    if (!_phoneNoticeLabel) {
        _phoneNoticeLabel = [[UILabel alloc]init];
        _phoneNoticeLabel.text = @"手机号码有误";
        _phoneNoticeLabel.hidden = YES;
        _phoneNoticeLabel.font = [UIFont systemFontOfSize:13];
        _phoneNoticeLabel.textColor = [UIColor redColor];
    }
    return _phoneNoticeLabel;
}

@end
