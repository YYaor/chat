//
//  MDSickerRemarkVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/31.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSickerRemarkVC.h"

@interface MDSickerRemarkVC ()<UITextViewDelegate>
{
    UITextView* valueTxt;//文本框
    UILabel* commonLab;//提醒语句
}

@end

@implementation MDSickerRemarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备注";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUpUi];
}
#pragma mark -- 创建界面
- (void)setUpUi
{
    //创建界面
    valueTxt = [[UITextView alloc] initWithFrame:CGRectMake(30, 30, LSSCREENWIDTH - 60, 200)];
    valueTxt.textColor = Style_Color_Content_Black;
    valueTxt.font = [UIFont systemFontOfSize:17.0f];
    valueTxt.text = self.remarkStr;
    valueTxt.delegate = self;
    valueTxt.layer.masksToBounds = YES;
    valueTxt.layer.cornerRadius = 6.0f;
    valueTxt.layer.borderWidth = 1.0f;
    valueTxt.layer.borderColor = [UIColor colorFromHexString:LSLIGHTGRAYCOLOR].CGColor;
    [self.view addSubview:valueTxt];
    
    //提示语句
    commonLab = [[UILabel alloc] init];
    commonLab.text = @"请在此处编辑内容";
    commonLab.font = [UIFont systemFontOfSize:16.0f];
    commonLab.textColor = [UIColor lightGrayColor];
    if (valueTxt.text.length != 0) {
        commonLab.hidden = YES;
    }else{
        commonLab.hidden = NO;
    }
    [valueTxt addSubview:commonLab];
    [commonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(valueTxt.mas_top).offset(8);
        make.left.equalTo(valueTxt.mas_left).offset(8);
    }];
    
    //保存按钮
    UIButton* saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, LSSCREENHEIGHT - 50 - 60, LSSCREENWIDTH - 60, 40)];
    [saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:BaseColor];
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 6.0f;
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    
    
}
#pragma mark -- 保存按钮点击
- (void)saveBtnClick
{
    NSLog(@"保存按钮点击");
    if (valueTxt.text.length <= 0) {
        [XHToast showCenterWithText:@"内容不可以为空"];
        return;
    }
    
    [self changeSickerDetailWithRemark:valueTxt.text];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        commonLab.hidden = YES;
    }
    
    if([text isEqualToString:@""] && range.location == 0 && range.length == 1){
        commonLab.hidden = NO;
    }
    
    //    [self textViewDidChange:textView withLength:45];
    
    return YES;
}

#pragma mark -- 修改患者资料
- (void)changeSickerDetailWithRemark:(NSString*)remark
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:remark forKey:@"remark"];
    [param setValue:self.userIdStr forKey:@"userid"];
    [param setValue:self.userNameStr forKey:@"username"];
    
    NSString* url = PATH(@"%@/updatePatientRemark");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            [XHToast showCenterWithText:@"更改失败"];
        }
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
}




@end
