//
//  MDMyAdviceVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDMyAdviceVC.h"
#import "MDEditMyAdviceVC.h"
#import "YGBaseTableCell.h"
#import "MDMyAdviceListVC.h"
#import "MDMyAdviceDetailModel.h"

@interface MDMyAdviceVC ()<UITableViewDataSource,UITableViewDelegate,ZHPickViewDelegate>
{
    UITableView* adviceTab;//医嘱任务列表
    UIButton* saveBtn;//保存按钮
    NSString* doctor_diagnosisStr;//医生诊断
    NSString* doctor_advice;//医嘱内容
    NSString* doctor_medicine;//用药
    NSString* endTimeStr;//完成时间
    BOOL noRefresh;
}
@property (nonatomic ,strong) MDMyAdviceDetailModel* detailModel;
@property (nonatomic ,strong) ZHPickView* pickerView;
@end

@implementation MDMyAdviceVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的医嘱";
    self.view.backgroundColor = Style_Color_Content_BGColor;
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(LSSCREENWIDTH - 80, 7, 60, 30);
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    [self setUpUi];
}
#pragma mark -- 更多按钮点击
- (void)moreBtnClick
{
    NSLog(@"更多按钮点击");
    MDMyAdviceListVC* myAdviceListVC = [[MDMyAdviceListVC alloc] init];
    myAdviceListVC.userIdStr = self.userId_Str;
    [self.navigationController pushViewController:myAdviceListVC animated:YES];
    
}


#pragma mark -- 创建界面
- (void)setUpUi
{
    
    //提交按钮
    saveBtn = [[UIButton alloc] init];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:BaseColor];
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 6.0f;
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.height.equalTo(@40);
    }];
    //创建界面
    adviceTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    adviceTab.delegate = self;
    adviceTab.dataSource = self;
    [self.view addSubview:adviceTab];
    [adviceTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.top.equalTo(self.view);
        make.bottom.equalTo(saveBtn.mas_top).offset(-10);
    }];
    
    //注册Cell
    [adviceTab registerNib:[UINib nibWithNibName:@"YGBaseTableCell" bundle:nil] forCellReuseIdentifier:@"yGBaseTableCell"];
    
}



#pragma mark -- 保存医嘱
- (void)saveBtnClick
{
    NSLog(@"保存医嘱");
    if (doctor_diagnosisStr.length <= 0 || doctor_diagnosisStr == nil) {
        [XHToast showCenterWithText:@"请填写医生诊断"];
        return;
    }
    if (doctor_advice.length <= 0 || doctor_advice == nil) {
        [XHToast showCenterWithText:@"请填写医嘱"];
        return;
    }
    if (doctor_medicine.length <= 0 || doctor_medicine == nil) {
        [XHToast showCenterWithText:@"请填写用药"];
        return;
    }
    if (endTimeStr.length <= 0 || endTimeStr == nil) {
        [XHToast showCenterWithText:@"请选择完成时间"];
        return;
    }
    
    NSString* endTime = [endTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([endTime integerValue] < [NSDate getCurrentDate]) {
        [XHToast showCenterWithText:@"完成时间不正确，请重新选择"];
        return;
    }
    
    
    
    [self saveMyAdviceData];
}

- (void)viewWillAppear:(BOOL)animated
{
    //获取我的医嘱
    if (!noRefresh) {
        
        [self getMyAdviceData];
        
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    noRefresh = NO;
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //个数
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //第一块儿为时间显示
        UITableViewCell* cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = Style_Color_Content_BGColor;
        if (self.detailModel.visit_date != nil && self.detailModel.visit_date.length > 0) {
            cell.textLabel.text = self.detailModel.visit_date;
        }else{
            cell.textLabel.text = [NSDate getCurrentDateString];
        }
        
        cell.textLabel.textColor = Style_Color_Content_Blue;
        return cell;
        
    }else{
        
        YGBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGBaseTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightImgView.hidden = NO;
        if (indexPath.section == 1) {
            cell.titleLab.text = @"医生诊断";
            cell.detailLab.text = doctor_diagnosisStr;//医生诊断
        }else if (indexPath.section == 2) {
            cell.titleLab.text = @"医嘱";
            cell.detailLab.text = doctor_advice;//医嘱
        }else if (indexPath.section == 3) {
            cell.titleLab.text = @"用药";
            cell.detailLab.text = doctor_medicine;//用药
        }else{
            cell.titleLab.text = @"完成时间";
            cell.detailLab.text = endTimeStr;//用药
        }
        return cell;
    }
    
    
}
#pragma mark -- 点击编辑
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![self.detailModel.visit_date isEqualToString:[NSDate getCurrentDateString]]) {
        [XHToast showCenterWithText:@"不是今天的医嘱不能修改哦"];
        return;
    }
    if (indexPath.section == 4) {
        //选择完成时间
        _pickerView = [[ZHPickView alloc] initDatePickWithDefaultDate:[NSDate date] selectDate:[NSDate date] minDate:[NSDate date] datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        
        _pickerView.delegate=self;
        [_pickerView show];
        
        
        
    }else{
        
        MDEditMyAdviceVC* editMyAdviceVC = [[MDEditMyAdviceVC alloc] init];
        editMyAdviceVC.index = indexPath.section;
        if (indexPath.section == 1) {
            editMyAdviceVC.haveStr = doctor_diagnosisStr;//医生诊断
        }else if (indexPath.section == 2){
            editMyAdviceVC.haveStr = doctor_advice;//医嘱
        }else{
            editMyAdviceVC.haveStr = doctor_medicine;//用药
        }
        editMyAdviceVC.submitBlock = ^(NSString *value) {
            if (indexPath.section == 1) {
                doctor_diagnosisStr = value;//医生诊断
            }else if (indexPath.section == 2){
                doctor_advice = value;//医嘱
            }else{
                doctor_medicine = value;//用药
            }
            noRefresh = YES;
            [adviceTab reloadData];
        };
        [self.navigationController pushViewController:editMyAdviceVC animated:YES];
    }
    
}

#pragma mark ZhpickVIewDelegate 点击确定方法的回调
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    NSLog(@"%@",resultString);
    
    NSArray *array = [resultString componentsSeparatedByString:@" "];
    endTimeStr = array[0];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:4];
    [adviceTab reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark -- 获取我的医嘱
- (void)getMyAdviceData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    [param setValue:self.userId_Str forKey:@"userid"];
    NSString* url = PATH(@"%@/getNewlyAdvice");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                if (responseObj[@"data"]) {
                    
                    self.detailModel = [MDMyAdviceDetailModel yy_modelWithDictionary:responseObj[@"data"]];
                    doctor_diagnosisStr = self.detailModel.diagnosis;
                    doctor_advice = self.detailModel.advice;
                    doctor_medicine = self.detailModel.pharmacy;
                    
                    endTimeStr = self.detailModel.end_date;
                    
                    if (![self.detailModel.visit_date isEqualToString:[NSDate getCurrentDateString]]) {
                        saveBtn.hidden = YES;
                    }else{
                        saveBtn.hidden = NO;
                    }
                    adviceTab.hidden = NO;
                    [adviceTab reloadData];
                }else{
                    
//                    [XHToast showCenterWithText:@"您今天还未下达医嘱"];
                    [XHToast showCenterWithText:@"您还没有医嘱"];
                    
                    adviceTab.hidden = YES;
                    saveBtn.hidden = YES;
                }
                
                
            }else
            {
                [XHToast showCenterWithText:@"获取数据失败"];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
        
        
        
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];

}

#pragma mark -- 保存医嘱
- (void)saveMyAdviceData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    [param setValue:doctor_advice forKey:@"advice"];
    [param setValue:doctor_diagnosisStr forKey:@"diagnosis"];
    [param setValue:endTimeStr forKey:@"end_date"];
    [param setValue:self.detailModel.advice_id forKey:@"id"];
    [param setValue:doctor_medicine forKey:@"pharmacy"];
    
    NSString* url = PATH(@"%@/updateCaseAdvice");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                [XHToast showCenterWithText:@"保存成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else
            {
                [XHToast showCenterWithText:@"获取数据失败"];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
        
        
        
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
    
}



@end
