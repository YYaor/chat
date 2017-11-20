//
//  LSDoctorAdviceController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/15.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSDoctorAdviceController.h"

@interface LSDoctorAdviceController () <ZHPickViewDelegate>

@property (nonatomic, strong) ZHPickView *picker;

@property (weak, nonatomic) IBOutlet UITextField *textF1;
@property (weak, nonatomic) IBOutlet UITextField *textF2;
@property (weak, nonatomic) IBOutlet UITextField *textF3;
@property (weak, nonatomic) IBOutlet UITextField *textF4;


@end

@implementation LSDoctorAdviceController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationItem.title = @"编辑医嘱";

    //下达医嘱
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if (self.message.ext)
    {
        self.textF1.text = self.message.ext[@"diagnosis"];
        self.textF2.text = self.message.ext[@"advice"];
        self.textF3.text = self.message.ext[@"pharmacy"];
        self.textF4.text = self.message.ext[@"end_date"];
    }
    
}

- (void)rightItemClick
{
    if ([self.textF1.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)
    {
        [XHToast showCenterWithText:@"请填写诊断信息"];
        return;
    }
    
    if ([self.textF2.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)
    {
        [XHToast showCenterWithText:@"请填写医嘱信息"];
        return;
    }
    
    if ([self.textF3.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)
    {
        [XHToast showCenterWithText:@"请填写处方信息"];
        return;
    }
    
    if ([self.textF4.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)
    {
        [XHToast showCenterWithText:@"请选择时间信息"];
        return;
    }
    
//    NSMutableDictionary *data = [NSMutableDictionary dictionary];
//    [data setValue:self.textF1.text forKey:@"zhenduan"];
//    [data setValue:self.textF2.text forKey:@"yizhu"];
//    [data setValue:self.textF3.text forKey:@"chufang"];
//    [data setValue:self.textF4.text forKey:@"time"];
//    [data setValue:@"1" forKey:@"messageType"];
    
//    接口名称 新增病历医嘱信息
//    请求类型 post
//    请求Url  /dr/addCaseAdvice
//    请求参数列表
//    变量名	含义	类型	备注
//    advice	医嘱	string
//    cookie	医生cookie	string
//    diagnosis	医生诊断	string
//    end_date	任务截止日期(完成时间)	string	yyyy-MM-dd
//    pharmacy	用药及处方	string
//    userid	患者ID	string
//    
//    接口名称 修改病历医嘱信息
//    请求类型 post
//    请求Url  /dr/updateCaseAdvice
//    请求参数列表
//    变量名	含义	类型	备注
//    advice	医嘱	string
//    cookie	医生cookie	string
//    diagnosis	医生诊断	string
//    end_date	任务截止日期(完成时间)	string	yyyy-MM-dd
//    id	医嘱ID	number
//    pharmacy	用药及处方	string
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@"1" forKey:@"messageType"];
    [param setValue:self.textF1.text forKey:@"diagnosis"];//医生诊断	string
    [param setValue:self.textF2.text forKey:@"advice"];//医嘱	string
    [param setValue:self.textF3.text forKey:@"pharmacy"];//用药及处方	string
    [param setValue:self.textF4.text forKey:@"end_date"];//任务截止日期(完成时间)	string	yyyy-MM-dd

    NSString *url = @"";
    
    if (self.message)
    {
        //修改
        url = PATH(@"%@/updateCaseAdvice");
        [param setValue:[NSNumber numberWithLong:[self.message.ext[@"id"] longValue]] forKey:@"id"];//医嘱ID	number
    }
    else
    {
        //新增
        url = PATH(@"%@/addCaseAdvice");
        [param setValue:[[self.conversation.conversationId stringByReplacingOccurrencesOfString:@"ug369P" withString:@""] stringByReplacingOccurrencesOfString:@"ug369p" withString:@""] forKey:@"userid"];//患者ID	string
    }
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [param setValue:[NSNumber numberWithLong:[responseObj[@"data"][@"id"] longValue]] forKey:@"id"];
            if (self.sureBlock) {
                self.sureBlock(param);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

- (IBAction)dateTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    
    if (!self.picker)
    {
        self.picker = [[ZHPickView alloc] initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        self.picker.delegate = self;
    }
    
    [self.picker show];
}

#pragma mark - ZHPickViewDelegate

- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    NSArray *array = [resultString componentsSeparatedByString:@" "];
    self.textF4.text = array[0];
}

@end
