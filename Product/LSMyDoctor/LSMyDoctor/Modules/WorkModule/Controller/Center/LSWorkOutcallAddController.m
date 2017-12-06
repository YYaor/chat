//
//  LSWorkOutcallAddController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/8.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkOutcallAddController.h"
#import "MDChooseSickerModel.h"
#import "MDChooseSickerVC.h"
@interface LSWorkOutcallAddController ()<ZHPickViewDelegate, UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *choosePatientButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

//患者
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;


//性别
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIButton *sexTF;

//年龄
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIButton *ageTF;

//主诉
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *textView4;


//现病史
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *textView5;


//诊断
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *textView6;

@property (nonatomic, strong) MDChooseSickerModel *patientModel;

@end

@implementation LSWorkOutcallAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
    self.nameTF.delegate = self;
    self.textView4.delegate = self;
    self.textView5.delegate = self;
    self.textView6.delegate = self;

}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"新增记录";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.dateLab.text = [formatter stringFromDate:self.date];
    
    self.textView4.placeholder = @"请填写主诉内容";
    self.textView5.placeholder = @"请填写现病史";
    self.textView6.placeholder = @"请填写诊断内容";
    
    self.textView4.delegate = self;
    self.textView5.delegate = self;
    self.textView6.delegate = self;

    self.contentView.frame = CGRectMake(20, 40, LSSCREENWIDTH-40, 611);
    [self.scrollView addSubview:self.contentView];
    
    self.scrollView.contentSize = CGSizeMake(LSSCREENWIDTH, LSHEIGHT(self.contentView)+80);
    
    if (self.infoDic)
    {
        [self requestData];
        
        if ([self.infoDic[@"canModify"] longValue] == 0)
        {
            self.choosePatientButton.enabled = NO;
            self.nameTF.enabled = NO;
            self.sexTF.enabled = NO;
            self.ageTF.enabled = NO;
            self.textView4.userInteractionEnabled = NO;
            self.textView5.userInteractionEnabled = NO;
            self.textView6.userInteractionEnabled = NO;
            
            self.saveBtn.hidden = YES;
        }
    }
   
}

- (void)requestData
{
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.infoDic[@"id"] forKey:@"id"];
    
    NSString *url = PATH(@"%@/visitInfo");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:NO httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            NSDictionary *dic = responseObj[@"data"];
            
            weakSelf.nameTF.text = dic[@"user_name"];
            [weakSelf.sexTF setTitle:dic[@"sex"] forState:UIControlStateNormal];
            [weakSelf.ageTF setTitle:[NSString stringWithFormat:@"%@", dic[@"age"]] forState:UIControlStateNormal];
            weakSelf.textView4.text = dic[@"chief_complaint"];
            weakSelf.textView5.text = dic[@"disease_history"];
            weakSelf.textView6.text = dic[@"diagnosis"];
            
//            patientModel.username = dic[@"user_name"];
            self.patientModel.user_id = [NSString stringWithFormat:@"%@", dic[@"user_id"]];
        }
        else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        
    }];
}

- (IBAction)chooseSexClick:(id)sender {
    
    ZHPickView *picker = [[ZHPickView alloc]initPickviewWithArray:@[@[@"男",@"女"]] isHaveNavControler:NO];
    picker.tag = 1;
    picker.delegate=self;
    [picker show];
}
- (IBAction)chooseAgeClick:(id)sender {
    NSMutableArray *ageArr = [NSMutableArray array];
    for (int i = 1; i<101; i ++) {
        NSString *string = [NSString stringWithFormat:@"%d",i];
        [ageArr addObject:string];
    }
    ZHPickView *picker = [[ZHPickView alloc]initPickviewWithArray:@[ageArr] isHaveNavControler:NO];
    picker.tag = 2;
    picker.delegate=self;
    [picker show];
}
- (IBAction)saveClick:(id)sender {
    
//    age	患者年龄	number
//    chief_complaint	病情主诉	string
//    cookie	医生cookie	string
//    diagnosis	诊断	string
//    disease_history	现病史	string
//    sex	性别	number	1男，2女
//    userid	患者ID	number
//    username	患者姓名	string
//    visitdate
    if (self.nameTF.text.length == 0) {
        [LSUtil showAlter:self.view withText:@"请填写患者姓名" withOffset:-20];
        return;
    }
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    [param setObject:[formatter stringFromDate:self.date] forKey:@"visitdate"];
    [param setObject:[NSNumber numberWithInteger:[self.ageTF.titleLabel.text integerValue]] forKey:@"age"];
    [param setObject:self.textView4.text forKey:@"chief_complaint"];
    [param setObject:self.textView6.text forKey:@"diagnosis"];
    [param setObject:self.textView5.text forKey:@"disease_history"];
    if ([self.sexTF.titleLabel.text isEqualToString:@"男"]) {
        [param setObject:[NSNumber numberWithInt:1] forKey:@"sex"];
    }else{
        [param setObject:[NSNumber numberWithInt:2] forKey:@"sex"];
    }
    [param setObject:self.nameTF.text forKey:@"username"];
    
    if (self.patientModel)
    {
        [param setObject:[NSNumber numberWithInt:[self.patientModel.user_id intValue]] forKey:@"userid"];
    }
    
    NSString *url = @"";
    
    if (self.infoDic)
    {
        [param setValue:self.infoDic[@"id"] forKey:@"visitid"];
        url = PATH(@"%@/updateVisit");
    }
    else
    {
        url = PATH(@"%@/addVisit");
    }
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:NO httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            if ([responseObj[@"status"] integerValue] == 0) {
                
                if (responseObj[@"data"]) {
                    if (self.infoDic)
                    {
                        [XHToast showCenterWithText:@"修改成功"];
                    }
                    else
                    {
                        [XHToast showCenterWithText:@"新增成功"];
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
    
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString;
{
    if (pickView.tag == 1) {
        //sex
        [self.sexTF setTitle:resultString forState:UIControlStateNormal];
    }else{
        [self.ageTF setTitle:resultString forState:UIControlStateNormal];
    }
}


- (IBAction)chooseButtonClick:(id)sender {
    
    MDChooseSickerVC *vc = [[MDChooseSickerVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.chooseBlock = ^(NSArray *modelArray) {
        MDChooseSickerModel *model = modelArray[0];
        self.patientModel = model;
        self.nameTF.text = model.username;
        [self.ageTF setTitle:[NSString getAgeFromBirthday:model.birthday] forState:UIControlStateNormal];
        [self.sexTF setTitle:model.sex forState:UIControlStateNormal];
        self.nameTF.userInteractionEnabled = NO;
    };
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (textView.text.length>=100) {
        [LSUtil showAlter:self.view withText:@"最多输入100个字" withOffset:-20];
        return NO;
    }else{
        return YES;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField.text.length>=10) {
        [LSUtil showAlter:self.view withText:@"名字最多输入10个字" withOffset:-20];
        return NO;
    }else{
        return YES;
    }
}

- (void)textViewDidChange:(UITextField *)textView
{
    if (textView.text.length > 50)
    {
        textView.text = [textView.text substringToIndex:50];
    }
}


@end
