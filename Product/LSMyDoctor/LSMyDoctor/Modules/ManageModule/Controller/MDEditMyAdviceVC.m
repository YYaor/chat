//
//  MDEditMyAdviceVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDEditMyAdviceVC.h"


@interface MDEditMyAdviceVC ()<UITextViewDelegate>
{
    UILabel* valueLab;
    UITextView* valueTV;//输入框
}

@end

@implementation MDEditMyAdviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.index == 1) {
        self.title = @"医生诊断";
    }else if (self.index == 2) {
        self.title = @"医嘱";
    }else{
        self.title = @"用药";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    //创建界面
    [self setUpUi];
}

#pragma mark -- 创建界面
- (void)setUpUi
{
    UILabel* titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30,  10, kScreenWidth - 60, 40)];
    if (self.index == 1) {
        titleLab.text = @"医生诊断";
    }else if (self.index == 2) {
        titleLab.text = @"医嘱";
    }else{
        titleLab.text = @"用药";
    }
    titleLab.textColor = Style_Color_Content_Black;
    [self.view addSubview:titleLab];
    
    //疾病名称
    valueTV = [[UITextView alloc] init];
    valueTV.layer.masksToBounds = YES;
    valueTV.layer.cornerRadius = 6.0f;
    valueTV.layer.borderWidth = 0.5f;
    valueTV.text = self.haveStr;
    valueTV.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
    valueTV.font = [UIFont systemFontOfSize:15.0f];
    valueTV.delegate = self;
    [self.view addSubview:valueTV];
    [valueTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(titleLab.mas_bottom).offset(10);
        make.height.equalTo(@120);
        make.left.equalTo(self.view.mas_left).offset(20);
    }];
    
    valueLab = [[UILabel alloc] init];
    if (self.index == 1) {
        valueLab.text = @"请输入医生诊断内容，不超过100个字";
    }else if (self.index == 2) {
        valueLab.text = @"请输入医嘱内容，不超过100个字";
    }else{
        valueLab.text = @"请输入用药内容，不超过100个字";
    }
    valueLab.font = [UIFont systemFontOfSize:15.0f];
    valueLab.textColor = UIColorFromRGB(0xC7C7C7);
    if (valueTV.text.length != 0) {
        valueLab.hidden = YES;
    }else{
        valueLab.hidden = NO;
    }
    [valueTV addSubview:valueLab];
    [valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(valueTV.mas_top).offset(8);
        make.left.equalTo(valueTV.mas_left).offset(8);
    }];
    //提交按钮
    UIButton* submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"确 认" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:BarColor];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 6.0f;
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.height.equalTo(@40);
    }];
    
    
}
#pragma mark -- 提交按钮点击
- (void)submitBtnClick
{
    NSLog(@"提交按钮点击");
    if (valueTV.text.length <= 0) {
        [XHToast showCenterWithText:@"请填写内容"];
        return;
    }
    self.submitBlock(valueTV.text);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        valueLab.hidden = YES;
    }
    
    if([text isEqualToString:@""] && range.location == 0 && range.length == 1){
        valueLab.hidden = NO;
    }
    
    [self textViewDidChange:textView];
    
    return YES;
}


#pragma mark -- 限制输入字数
- (void) textViewDidChange:(UITextView *)textView
{
    //最大长度
    NSInteger kMaxLength = 100;
    if (self.index == 1) {
        kMaxLength = 10;
    }
    NSString *toBeString = textView.text;
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        
        UITextRange *selectedRange = [textView markedTextRange];
        
        //获取高亮部分
        
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            
            if (toBeString.length > kMaxLength) {
                
                textView.text = [toBeString substringToIndex:kMaxLength];
                [textView resignFirstResponder];
                
            }
            
        }
        
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
        
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > kMaxLength) {
            
            textView.text = [toBeString substringToIndex:kMaxLength];
            
        }
        
    }
    
    
}


@end
