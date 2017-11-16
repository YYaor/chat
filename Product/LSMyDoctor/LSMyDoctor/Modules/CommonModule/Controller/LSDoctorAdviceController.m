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
    
    if (!self.messageType)
    {
        //下达医嘱
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    if ([self.messageType isEqualToString:@"1"])
    {
        //收到的下达医嘱
        self.view.userInteractionEnabled = NO;
        
    }
    
    
    
}

- (void)rightItemClick
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:self.textF1.text forKey:@"zhenduan"];
    [data setValue:self.textF2.text forKey:@"yizhu"];
    [data setValue:self.textF3.text forKey:@"chufang"];
    [data setValue:self.textF4.text forKey:@"time"];
    [data setValue:@"1" forKey:@"messageType"];

    if (self.sureBlock) {
        self.sureBlock(data);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dateTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    
    if (!self.picker)
    {
        self.picker = [[ZHPickView alloc] initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
        self.picker.delegate = self;
    }
    
    [self.picker show];
}

#pragma mark - ZHPickViewDelegate

- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    self.textF4.text = [resultString stringByReplacingOccurrencesOfString:@" +0000" withString:@""];
}

@end
