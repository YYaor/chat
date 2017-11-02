//
//  MDSikerWeekReportVC.m
//  MyDoctor
//
//  Created by 惠生 on 17/8/3.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDSikerWeekReportVC.h"
#import "CureReportViewController.h"

@interface MDSikerWeekReportVC ()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;//身高
@property (weak, nonatomic) IBOutlet UILabel *sexLab;//性别
@property (weak, nonatomic) IBOutlet UILabel *ageLab;//年龄
@property (weak, nonatomic) IBOutlet UILabel *heightLab;//身高
@property (weak, nonatomic) IBOutlet UILabel *weightLab;//体重
@property (weak, nonatomic) IBOutlet UIView *markView;//标签
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markViewHeight;//标签的高度

@property (weak, nonatomic) IBOutlet UIView *bodyView;//具体报告

@end

@implementation MDSikerWeekReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者7日报告";
    self.view.backgroundColor = [UIColor whiteColor];
    self.nameLab.text = [NSString stringWithFormat:@"姓名：%@",self.sickerModel.username];
    NSString* sickerSex = self.sickerModel.sex;
    if ([self.sickerModel.sex isEqualToString:@"1"]) {
        sickerSex = @"男";
    }else if ([self.sickerModel.sex isEqualToString:@"2"]){
        sickerSex = @"女";
    }
    self.sexLab.text = sickerSex;
    self.ageLab.text = [NSString stringWithFormat:@"年龄：%@",[NSString getAgeFromBirthday:self.sickerModel.birthday]];
    
    if (self.sickerModel.user_height) {
        self.heightLab.text = [NSString stringWithFormat:@"身高：%@cm",self.sickerModel.user_height];
    }
    if (self.sickerModel.user_weight) {
        self.weightLab.text = [NSString stringWithFormat:@"体重：%@kg",self.sickerModel.user_weight];
    }
    
    [self setUpUI];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark -- 创建界面
- (void)setUpUI
{
    
    NSInteger numRow = 1;//取行数，向上取整
    if (self.sickerLabelsArr.count + 1 >= 4) {
        numRow = (NSInteger)ceilf(((float)self.sickerLabelsArr.count + 1)/4);
        numRow = numRow > 2 ? 2 : numRow;
    }
    
    CGFloat labelWidth = (LSSCREENWIDTH - 25)/4;
    CGFloat labelHeight = labelWidth/3;
    
    self.markViewHeight.constant = numRow * labelHeight + 16;
    
    if (self.sickerLabelsArr.count + 1 > 0) {
        
        for (int i = 0; i < numRow; i++) {
            for(int j = 0 ;j < 4; j ++){
                
                UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake((labelWidth + 5)*j , (labelHeight + 8)*i, labelWidth, labelHeight)];
                
               
                label.textAlignment = NSTextAlignmentCenter;
                
                
                if (4 * i + j  > self.sickerLabelsArr.count) {
                    label.text = @"测试";
                }else if(4 * i + j == 0){
                    label.text = @"标签：";
                    label.textColor = BaseColor;
                    label.font = [UIFont systemFontOfSize:18];
                }else{
                    label.textColor = BaseColor;
                    label.layer.cornerRadius = labelHeight/2;
                    label.layer.borderColor = BaseColor.CGColor;
                    label.layer.borderWidth = 1.0f;
                    label.font = [UIFont systemFontOfSize:16];
                    label.text = self.sickerLabelsArr[4*i+j - 1];
                }
                
                [self.markView addSubview:label];
                if (4 * i + j  > self.sickerLabelsArr.count) {
                    label.hidden = YES;
                }else{
                    label.hidden = NO;
                }
                
            }
            
        }
        
    }
    
//    self.bodyView.backgroundColor = [UIColor redColor];
    
    //添加报告页面
    
    UIStoryboard *selfCureSB = [UIStoryboard storyboardWithName:@"SelfCure" bundle:nil];
    CureReportViewController *reportVC = [selfCureSB instantiateViewControllerWithIdentifier:@"CureReportViewController"];
    reportVC.module = @"PatientReport";
    reportVC.userIdStr = self.sickerModel.user_id;
    reportVC.date = [NSDate getCurrentDate];
    reportVC.isHiddenDateLabel = YES;
    reportVC.reportId = @"101";//布局置顶使用
    reportVC.cycle = @"weekly";
    CGFloat addWidth = 0.0f;
    CGFloat addHeight = 0.0f;
    if (IS_IPHONE5) {
        addWidth = 55.0f;
        addHeight = 100.0f;
    }
    reportVC.view.frame = CGRectMake(0, 0, kScreenWidth + addWidth, kScreenHeight - 25 - self.markViewHeight.constant - 80 + addHeight);
    [self addChildViewController:reportVC];
    [self.bodyView addSubview:reportVC.view];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
