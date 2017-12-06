//
//  MDMyAdviceDetailVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDMyAdviceDetailVC.h"
#import "YGBaseTableCell.h"
#import "MDMyAdviceDetailModel.h"

@interface MDMyAdviceDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* adviceTab;//医嘱任务列表
    
    NSString* doctor_diagnosisStr;//医生诊断
    NSString* doctor_advice;//医嘱内容
    NSString* doctor_medicine;//用药
}

@property (nonatomic , strong)MDMyAdviceDetailModel* detailModel;

@end

@implementation MDMyAdviceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医嘱详情";
    self.view.backgroundColor = Style_Color_Content_BGColor;
    //创建界面
    [self setUpUi];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self getMyAdviceInfoData];
}
#pragma mark -- 创建界面
- (void)setUpUi
{
    //提交按钮
    UIButton* copyBtn = [[UIButton alloc] init];
    [copyBtn setTitle:@"复制医嘱" forState:UIControlStateNormal];
    [copyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [copyBtn setBackgroundColor:BaseColor];
    copyBtn.layer.masksToBounds = YES;
    copyBtn.layer.cornerRadius = 6.0f;
    [copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyBtn];
    
    if (!self.isNotNeedBtn) {
        
        [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.left.equalTo(self.view.mas_left).offset(30);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
            make.height.equalTo(@40);
        }];
        
    }else{
        [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.left.equalTo(self.view.mas_left).offset(30);
            make.bottom.equalTo(self.view.mas_bottom);
            make.height.equalTo(@0);
        }];
    }
    //创建界面
    adviceTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    adviceTab.delegate = self;
    adviceTab.dataSource = self;
    [self.view addSubview:adviceTab];
    [adviceTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.top.equalTo(self.view);
        make.bottom.equalTo(copyBtn.mas_top).offset(-10);
    }];
    
    //注册Cell
    [adviceTab registerNib:[UINib nibWithNibName:@"YGBaseTableCell" bundle:nil] forCellReuseIdentifier:@"yGBaseTableCell"];
    
}


#pragma mark -- 复制医嘱
- (void)copyBtnClick
{
    NSLog(@"复制医嘱");
    [self copyToNowAdviceInfoData];
    
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
        cell.textLabel.text = self.detailModel.visit_date;
        cell.textLabel.textColor = Style_Color_Content_Blue;
        return cell;
        
    }else{
        
        YGBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGBaseTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.rightImgView.hidden = YES;
        if (indexPath.section == 1) {
            cell.titleLab.text = @"医生诊断";
            cell.detailLab.text = self.detailModel.diagnosis;//医生诊断
        }else if (indexPath.section == 2) {
            cell.titleLab.text = @"医嘱";
            cell.detailLab.text = self.detailModel.advice;//医嘱
        }else if (indexPath.section == 3) {
            cell.titleLab.text = @"用药";
            cell.detailLab.text = self.detailModel.pharmacy;//用药
        }else{
            cell.titleLab.text = @"完成时间";
            cell.detailLab.text = self.detailModel.end_date;//用药
        }
        return cell;
    }
    
    
}

#pragma mark -- 获取我的医嘱
- (void)getMyAdviceInfoData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    [param setValue:self.adviceIdStr forKey:@"id"];
    NSString* url = PATH(@"%@/getCaseAdviceInfo");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                self.detailModel = [MDMyAdviceDetailModel yy_modelWithDictionary:responseObj[@"data"]];
                
                [adviceTab reloadData];
                
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
#pragma mark -- 获取我的医嘱
- (void)copyToNowAdviceInfoData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    [param setValue:self.adviceIdStr forKey:@"id"];
    NSString* url = PATH(@"%@/copyCaseAdvice");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                
                UIViewController* vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
                [self.navigationController popToViewController:vc animated:YES];
                
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
