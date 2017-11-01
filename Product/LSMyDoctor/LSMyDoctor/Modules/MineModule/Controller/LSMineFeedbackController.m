//
//  LSMineFeedbackController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineFeedbackController.h"

#import "YYPlaceholderTextView.h"

@interface LSMineFeedbackController ()

@property (nonatomic,strong)YYPlaceholderTextView *infoTextView;

@property (nonatomic,strong)YYPlaceholderTextView *phoneTextView;

@property (nonatomic,strong)UIButton *sureButton;

@end

@implementation LSMineFeedbackController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

-(void)initForView{
    
    self.navigationItem.title = @"意见反馈";
    
    [self.view addSubview:self.infoTextView];
    [self.view addSubview:self.phoneTextView];
    [self.view addSubview:self.sureButton];
    
    [self.infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.top.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.height.mas_equalTo(200);
    }];
    
    [self.phoneTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(self.infoTextView.mas_bottom).offset(12);
        make.height.mas_equalTo(35);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(self.phoneTextView.mas_bottom).offset(40);
        make.height.mas_equalTo(40);
    }];
}

-(void)sureButtonClick{
    
    if ([self.infoTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<=0)
    {
        [XHToast showCenterWithText:@"请输入您的意见或建议"];
        return;
    }
    
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.infoTextView.text forKey:@"feedback"];
    
    NSString* url = PATH(@"%@/my/feedback");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [XHToast showCenterWithText:responseObj[@"提交成功"]];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

-(YYPlaceholderTextView *)infoTextView{
    if (!_infoTextView) {
        _infoTextView = [[YYPlaceholderTextView alloc]init];
        _infoTextView.tintColor = [UIColor colorFromHexString:LSGREENCOLOR];
        _infoTextView.font = [UIFont systemFontOfSize:14];
        _infoTextView.placeholder = @"请输入您的意见或建议";
        _infoTextView.layer.masksToBounds = YES;
        _infoTextView.layer.cornerRadius = 4;
        _infoTextView.layer.borderWidth = 1;
        _infoTextView.layer.borderColor = [UIColor colorFromHexString:@"e0e0e0"].CGColor;
    }
    return _infoTextView;
}

-(YYPlaceholderTextView *)phoneTextView{
    if (!_phoneTextView) {
        _phoneTextView = [[YYPlaceholderTextView alloc]init];
        _phoneTextView.tintColor = [UIColor colorFromHexString:LSGREENCOLOR];
        _phoneTextView.font = [UIFont systemFontOfSize:14];
        _phoneTextView.placeholder = @"请输入您的联系方式(QQ/手机号)";
        _phoneTextView.layer.masksToBounds = YES;
        _phoneTextView.layer.cornerRadius = 4;
        _phoneTextView.layer.borderWidth = 1;
        _phoneTextView.layer.borderColor = [UIColor colorFromHexString:@"e0e0e0"].CGColor;
    }
    return _phoneTextView;
}

-(UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [[UIButton alloc]init];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.backgroundColor = [UIColor colorFromHexString:LSGREENCOLOR];
        [_sureButton setTitle:@"确认提交" forState:UIControlStateNormal];
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 20;
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _sureButton;
}

@end
