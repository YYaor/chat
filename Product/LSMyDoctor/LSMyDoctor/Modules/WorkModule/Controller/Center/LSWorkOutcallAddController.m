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
@interface LSWorkOutcallAddController ()<ZHPickViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *choosePatientButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;

//患者
@property (weak, nonatomic) IBOutlet UIView *view1;


//性别
@property (weak, nonatomic) IBOutlet UIView *view2;


//年龄
@property (weak, nonatomic) IBOutlet UIView *view3;


//主诉
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *textView4;


//现病史
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *textView5;


//诊断
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *textView6;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *sexTF;
@property (weak, nonatomic) IBOutlet UIButton *ageTF;


@end

@implementation LSWorkOutcallAddController
{
    MDChooseSickerModel *patientModel;
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
    [param setObject:patientModel.username forKey:@"username"];
    [param setObject:patientModel.user_id forKey:@"userid"];
    
    NSString *url = PATH(@"%@/addVisit");
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:NO httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            if ([responseObj[@"status"] integerValue] == 0) {
                
                if (responseObj[@"data"]) {
                    [XHToast showCenterWithText:@"新增成功"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}
- (IBAction)chooseButtonClick:(id)sender {
    
    MDChooseSickerVC *vc = [[MDChooseSickerVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.chooseBlock = ^(NSArray *modelArray) {
        MDChooseSickerModel *model = modelArray[0];
        patientModel = model;
        self.nameTF.text = model.username;
        [self.ageTF setTitle:[NSString getAgeFromBirthday:model.birthday] forState:UIControlStateNormal];
        [self.sexTF setTitle:model.sex forState:UIControlStateNormal];
    };
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
    
    self.contentView.frame = CGRectMake(20, 40, LSSCREENWIDTH-40, 611);
    [self.scrollView addSubview:self.contentView];
    
    self.scrollView.contentSize = CGSizeMake(LSSCREENWIDTH, LSHEIGHT(self.contentView)+80);
}


@end
