//
//  MDDataStatistics.m
//  MyDoctor
//
//  Created by 惠生 on 17/8/3.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDDataStatistics.h"
#import "WFSegTitleView.h"
#import "MDDataStatisticsCell.h"
#import "MDDataTotalCell.h"
#import "MDHealthEducationCell.h"
#import "MDDataStatisticsModel.h"
#import "MDHealthEducationDetailVC.h"

@interface MDDataStatistics ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* statisticsTab;
    NSInteger selectIndex;//选项卡选择项
}

@property (nonatomic,strong) NSMutableArray *titleArray;//头部菜单栏标题
@property (nonatomic,strong) WFSegTitleView *titleView;
@property (nonatomic,strong) NSMutableArray *listDataArr;//数据

@end

@implementation MDDataStatistics

#pragma mark -- 懒加载
- (NSMutableArray *)titleArray{
    
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
        
        [_titleArray addObject:@"综合数据"];
        [_titleArray addObject:@"健康教育"];
    }
    return _titleArray;
}
- (NSMutableArray *)listDataArr{
    
    if (_listDataArr == nil) {
        _listDataArr = [NSMutableArray array];
    }
    return _listDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据统计";
    
    [self setUpUI];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    /*
    if (selectIndex == 0) {
        //获取综合统计
        [self getTotalDataStatisticsRequest];
    }else{
        
        //获取健康教育统计数据
        [self getHealthEducationRequest];
    }
     */
    
}

#pragma mark -- 创建View
- (void)setUpUI
{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    _titleView = [[WFSegTitleView alloc] initWithItems:self.titleArray];
    _titleView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    _titleView.showLine = YES;//是否显示分割线
    _titleView.numOfScreenW = self.titleArray.count;
    [_titleView addTarget:self action:@selector(titleBtnclick:)];
    [self.view addSubview:_titleView];
    
    selectIndex = 0;
    [self getTotalDataStatisticsRequest];
    
    statisticsTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 104) style:UITableViewStyleGrouped];
    statisticsTab.delegate = self;
    statisticsTab.dataSource = self;
    [self.view addSubview:statisticsTab];
    
    //注册Cell
    [statisticsTab registerNib:[UINib nibWithNibName:@"MDDataTotalCell" bundle:nil] forCellReuseIdentifier:@"mDDataTotalCell"];
    [statisticsTab registerNib:[UINib nibWithNibName:@"MDDataStatisticsCell" bundle:nil] forCellReuseIdentifier:@"mDDataStatisticsCell"];
    [statisticsTab registerNib:[UINib nibWithNibName:@"MDHealthEducationCell" bundle:nil] forCellReuseIdentifier:@"mDHealthEducationCell"];
    
}

#pragma mark -- 头部菜单栏显示
- (void)titleBtnclick: (WFSegTitleView*)segView
{
    NSInteger index = segView.selectedSegmentIndex;
    NSLog(@"%@",self.titleArray[index]);
    
    if (index == 0) {
        //获取总数
        selectIndex = 0;
        [self getTotalDataStatisticsRequest];
    }else{
        //健康教育
        selectIndex = 1;
        //获取健康教育统计数据
        [self getHealthEducationRequest];
        
    }
    
    
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //个数
    if (selectIndex == 1) {
        return 3;
    }
    return self.listDataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (selectIndex == 0) {
        MDDataStatisticsModel* model = self.listDataArr[section];
        if ([model.type isEqualToString:@"1"]) {
            return 0.00001f;
        }
        return 40.0f;
    }else{
        if (section == 2) {
            //阅读统计
            return 40.0f;
        }
        return 0.00001f;
    }
   
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
    return 50.0f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WFHelperButton* headerBtn = [[WFHelperButton alloc] init];
    headerBtn.backgroundColor = [UIColor whiteColor];
    [headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //标题
    UILabel* titleLab = [[UILabel alloc] init];
    titleLab.textColor = Style_Color_Content_Black;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [headerBtn addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(headerBtn.mas_centerY);
        make.left.right.top.bottom.equalTo(headerBtn);
    }];
    if (selectIndex != 1) {
        //综合数据
        MDDataStatisticsModel* model = self.listDataArr[section];
        if (![model.type isEqualToString:@"1"]) {
            //非总访问量
            if ([model.type isEqualToString:@"2"]) {
                titleLab.text = @"综合统计";
            }else if ([model.type isEqualToString:@"3"]){
                titleLab.text = @"随访统计";
            }else if ([model.type isEqualToString:@"4"]){
                titleLab.text = @"出诊记录";
            }else{
                titleLab.text = @"测试标题";
            }
            
        }
        
    }else{
        if (section == 2) {
            titleLab.text = @"阅读统计";
        }
    }
    
    
    return headerBtn;
}
#pragma mark -- 头部按钮点击
- (void)headerBtnClick:(WFHelperButton*)sender
{
    NSLog(@"头部按钮点击");
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectIndex == 0) {
        //综合数据
        
        MDDataStatisticsModel* model = self.listDataArr[indexPath.section];
        if ([model.type isEqualToString:@"1"]) {
            MDDataTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDDataTotalCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.totalNum.text = model.total;
            if ([model.year_sum isEqualToString:@"0"] || model.year_sum == nil) {
                cell.addNum.text = @"0";
            }else{
                
                cell.addNum.text = [NSString stringWithFormat:@"+%@",model.year_sum];
            }
            
            return cell;
        }else{
            //备注信息
            MDDataStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDDataStatisticsCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if ([model.type isEqualToString:@"2"]) {
                cell.leftValueLab.text = @"总患者人数";
                cell.midValueLab.text = @"年新增人数";
                cell.rightValueLab.text = @"月新增人数";
                
                
            }else if ([model.type isEqualToString:@"3"]){
                cell.leftValueLab.text = @"总随访次数";
                cell.midValueLab.text = @"年随访次数";
                cell.rightValueLab.text = @"月随访次数";
                
                
            }else if ([model.type isEqualToString:@"4"]){
                cell.leftValueLab.text = @"总出诊次数";
                cell.midValueLab.text = @"年出诊次数";
                cell.rightValueLab.text = @"月出诊次数";
                
            }
            
            if (model.total) {
                cell.lefTitleLab.text = model.total;
            }else{
                cell.lefTitleLab.text = @"0";
            }
            if (model.year_sum) {
                cell.midTitleLab.text = model.year_sum;
            }else{
                cell.midTitleLab.text = @"0";
            }
            
            if (model.month_sum) {
                cell.rightTitleLab.text = model.month_sum;
            }else{
                cell.rightTitleLab.text = @"0";
            }
            return cell;
        }
    }else{
        //健康教育
        
        if (indexPath.section == 2) {
            
            MDDataStatisticsModel* model = self.listDataArr[1];
            MDDataStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDDataStatisticsCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.leftValueLab.text = @"总阅读次数";
            cell.midValueLab.text = @"年阅读次数";
            cell.rightValueLab.text = @"月阅读次数";
            if (model.total) {
                cell.lefTitleLab.text = model.total;
            }else{
                cell.lefTitleLab.text = @"0";
            }
            if (model.year_sum) {
                cell.midTitleLab.text = model.year_sum;
            }else{
                cell.midTitleLab.text = @"0";
            }
            
            if (model.month_sum) {
                cell.rightTitleLab.text = model.month_sum;
            }else{
                cell.rightTitleLab.text = @"0";
            }
            return cell;
        }else{
            //活动
            MDDataStatisticsModel* model = self.listDataArr[0];
            MDHealthEducationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDHealthEducationCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.rightImgView.hidden = NO;
            if (indexPath.section == 0) {
                //本月
                cell.titleStr = @"所有活动(本月)";
                cell.signUpNumStr = model.month_sum;
                cell.totalNumStr = model.month_total;
            }else{
                //本年
                cell.titleStr = @"所有活动(本年)";
                cell.signUpNumStr = model.year_sum;
                cell.totalNumStr = model.year_total;
            }
            return cell;
        }
        
    }
    
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectIndex == 1 && indexPath.section != 2) {
        
        MDHealthEducationDetailVC* healthEducationDetailVC = [[MDHealthEducationDetailVC alloc] init];
        
        healthEducationDetailVC.typeNum = indexPath.section + 1;
        
        [self.navigationController pushViewController:healthEducationDetailVC animated:YES];
    }
    
}


#pragma mark -- 获取数据统计
- (void)getTotalDataStatisticsRequest
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/summaryStatistics");
    
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                NSArray* list = [NSArray yy_modelArrayWithClass:[MDDataStatisticsModel class] json:responseObj[@"data"]];
                [self.listDataArr removeAllObjects];
                [self.listDataArr addObjectsFromArray:list];
                
                [statisticsTab reloadData];
                
                
            }else
            {
                [XHToast showCenterWithText:@"请求错误"];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
        
        
        
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
    
    
}
#pragma mark -- 获取健康教育统计数据
- (void)getHealthEducationRequest
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/healthEduStatistics");
    
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                NSArray* list = [NSArray yy_modelArrayWithClass:[MDDataStatisticsModel class] json:responseObj[@"data"]];
                [self.listDataArr removeAllObjects];
                [self.listDataArr addObjectsFromArray:list];
                
                [statisticsTab reloadData];
                
                
            }else
            {
                [XHToast showCenterWithText:@"请求错误"];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
        
        
        
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
    
    
}

@end
