//
//  LSMineNewPswController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/27.
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
    
    [self initForView];
}

-(void)initForView{
    
    self.navigationItem.title = @"设置密码";
    
    [self.view addSubview:self.oldPswTextField];
    [self.view addSubview:self.nPswTextField];
    [self.view addSubview:self.secPswTextField];
    [self.view addSubview:self.sureButton];
    
    [self.oldPswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
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

-(void)sureButtonClick{
    
    if ([self.oldPswTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<=0)
    {
        [XHToast showCenterWithText:@"请输入旧密码"];
        return;
    }
    
    if ([self.oldPswTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<=0)
    {
        [XHToast showCenterWithText:@"请输入新密码"];
        return;
    }
    
    if ([self.oldPswTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<=0)
    {
        [XHToast showCenterWithText:@"请输入确认密码"];
        return;
    }
    
    if (![self.nPswTextField.text isEqualToString:self.secPswTextField.text])
    {
        [XHToast showCenterWithText:@"两次密码不一致，请重新输入"];
        return;
    }
    
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];

    [param setValue:[NSString md5String:self.oldPswTextField.text] forKey:@"oldPasswd"];
    [param setValue:[NSString md5String:self.nPswTextField.text] forKey:@"passwd"];
    
    NSString* url = PATH(@"%@/my/passwd");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
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
