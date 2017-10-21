//
//  MDSetPasswordVC.m
//  MyDoctor
//
//  Created by 惠生 on 17/5/22.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDSetPasswordVC.h"

@interface MDSetPasswordVC () <UITextFieldDelegate>
{
    UITextField* pswTF;//输入密码框
    UITextField* aginPswTF;//再次输入
}

@end

@implementation MDSetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpUI];
    // Do any additional setup after loading the view.
}
#pragma mark -- 创建View
- (void)setUpUI
{
    //输入密码框
    pswTF = [[UITextField alloc] init];
    pswTF.placeholder = @"密码";
    pswTF.keyboardType = UIKeyboardTypeNumberPad;
    pswTF.delegate = self;
    pswTF.borderStyle = UITextBorderStyleRoundedRect;
    [pswTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:pswTF];
    [pswTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(104);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.height.equalTo(@40);
    }];
    
    //再次输入
    aginPswTF = [[UITextField alloc] init];
    aginPswTF.placeholder = @"再次输入密码";
    aginPswTF.keyboardType = UIKeyboardTypeNumberPad;
    aginPswTF.delegate = self;
    [aginPswTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    aginPswTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:aginPswTF];
    [aginPswTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(pswTF.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.height.equalTo(@40);
    }];
    
    //按钮视图
    UIView* btnView = [[UIView alloc] init];
    [self.view addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(aginPswTF.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@60);
    }];
    
    
    //确定按钮
    UIButton* sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(30 , 10, LSSCREENWIDTH - 60, 40)];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor colorFromHexString:LSGREENCOLOR]];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4.5f;
    sureBtn.layer.borderWidth = 1.0f;
    sureBtn.layer.borderColor = [UIColor colorFromHexString:LSGREENCOLOR].CGColor;
    [btnView addSubview:sureBtn];
    
    
}

#pragma mark -- 确认按钮点击
- (void)sureBtnClick
{
    NSLog(@"确认按钮点击");
    
    if (pswTF.text.length <= 0 || aginPswTF.text.length <= 0) {
        [XHToast showCenterWithText:@"请输入密码"];
        return;
    }
    
    if (pswTF.text != aginPswTF.text) {
        [XHToast showCenterWithText:@"两次输入不一致，请重新输入"];
        return;
    }
    
    [self setNewPasswordRequestWithNewPassword:aginPswTF.text];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 设置新密码
- (void)setNewPasswordRequestWithNewPassword:(NSString*)password
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:[NSString md5String:password] forKey:@"passwd"];
    
    NSString* url = PATH(@"%@/my/passwd");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary * dict = responseObj;
            if (dict[@"status"] && [dict[@"status"] isEqualToString:@"0"]) {
                //返回成功
                //获取banner成功
//                MDTabbarVC* tabbarVC = [[MDTabbarVC alloc] init];
//                [self presentViewController:tabbarVC animated:YES completion:^{
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }];
                
                AppDelegate *app = LSAPPDELEGATE;
                [app intoRootForMain];
                
            }else{
                [XHToast showCenterWithText:dict[@"message"]];
            }
            
        }else{
            NSLog(@"返回格式输出错误");
        }
        
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
    
    
}

#pragma mark -- 限制输入字数
- (void) textFieldDidChange:(UITextField *)textField
{
    //最大长度
    NSInteger kMaxLength = 6;
    
    NSString *toBeString = textField.text;
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        
        UITextRange *selectedRange = [textField markedTextRange];
        
        //获取高亮部分
        
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            
            if (toBeString.length > kMaxLength) {
                
                textField.text = [toBeString substringToIndex:kMaxLength];
                [textField resignFirstResponder];
                
            }
            
        }
        
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
        
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > kMaxLength) {
            
            textField.text = [toBeString substringToIndex:kMaxLength];
            
        }
        
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
