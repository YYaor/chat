//
//  LSMineUserInfoController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/1.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineUserInfoController.h"

#import "LSMineUserSettingController.h"

#import "YYPlaceholderTextView.h"

@interface LSMineUserInfoController ()

@property (nonatomic,strong)YYPlaceholderTextView *infoTextView;
@property (nonatomic,strong)UIButton *sureButton;

@end

@implementation LSMineUserInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.navigationItem.title = @"编辑个人简介";
    
    [self.view addSubview:self.infoTextView];
    [self.view addSubview:self.sureButton];
    
    [self.infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.top.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.height.mas_equalTo(200);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.top.equalTo(self.infoTextView.mas_bottom).offset(40);
        make.height.mas_equalTo(40);
    }];
    
    self.infoTextView.text = self.model.myBaseInfo[6][@"value"];
}

-(void)sureButtonClick{
    
    if ([self.infoTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<=0)
    {
        [XHToast showCenterWithText:@"请输入您的个人简介"];
        return;
    }
    
    NSArray *vcs = self.navigationController.viewControllers;
    
    LSMineUserSettingController *vc = vcs[vcs.count-2];
    
    //姓名
    NSMutableArray *arr = [NSMutableArray arrayWithArray:vc.model.myBaseInfo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[6]];
    [dic setValue:self.infoTextView.text forKey:@"value"];
    [arr replaceObjectAtIndex:6 withObject:dic];
    vc.model.myBaseInfo = arr;
    
    [vc updateMainInfoData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter & setter

-(YYPlaceholderTextView *)infoTextView
{
    if (!_infoTextView)
    {
        _infoTextView = [[YYPlaceholderTextView alloc]init];
        _infoTextView.tintColor = [UIColor colorFromHexString:LSGREENCOLOR];
        _infoTextView.font = [UIFont systemFontOfSize:14];
        _infoTextView.placeholder = @"请输入您的个人简介";
        _infoTextView.layer.masksToBounds = YES;
        _infoTextView.layer.cornerRadius = 4;
        _infoTextView.layer.borderWidth = 1;
        _infoTextView.layer.borderColor = [UIColor colorFromHexString:@"e0e0e0"].CGColor;
    }
    return _infoTextView;
}

-(UIButton *)sureButton
{
    if (!_sureButton)
    {
        _sureButton = [[UIButton alloc]init];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.backgroundColor = [UIColor colorFromHexString:LSGREENCOLOR];
        [_sureButton setTitle:@"保存" forState:UIControlStateNormal];
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 20;
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _sureButton;
}

@end
