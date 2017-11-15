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

#import "MDDataStatisticsModel.h"

@interface MDDataStatistics ()<UITableViewDelegate,UITableViewDataSource>
{
    
    
    UITableView* statisticsTab;
}

@property (nonatomic,strong) NSMutableArray *titleArray;//头部菜单栏标题
@property (nonatomic,strong) WFSegTitleView *titleView;

@property (nonatomic,strong)MDDataStatisticsModel* totalModel;
@property (nonatomic,strong)MDDataStatisticsModel* yearModel;
@property (nonatomic,strong)MDDataStatisticsModel* monthModel;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据统计";
    
    [self setUpUI];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString* nowTime = [NSString stringWithFormat:@"%ld",(long)[NSDate getCurrentDate]];
    NSString* year = [nowTime substringToIndex:4];
    NSString* yearAndMonth = [nowTime substringToIndex:6];
    
    //获取总数
    [self getDataStatisticsRequestWithBeginDate:@"19000101" withStatues:@"0"];
    //获取年数
    [self getDataStatisticsRequestWithBeginDate:[NSString stringWithFormat:@"%@0101",year] withStatues:@"1"];
    //获取月数
    [self getDataStatisticsRequestWithBeginDate:[NSString stringWithFormat:@"%@01",yearAndMonth] withStatues:@"2"];
    
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
    
    
    statisticsTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 104) style:UITableViewStyleGrouped];
    statisticsTab.delegate = self;
    statisticsTab.dataSource = self;
    [self.view addSubview:statisticsTab];
    
    //注册Cell
    [statisticsTab registerNib:[UINib nibWithNibName:@"MDDataStatisticsCell" bundle:nil] forCellReuseIdentifier:@"mDDataStatisticsCell"];
    
}

#pragma mark -- 头部菜单栏显示
- (void)titleBtnclick: (WFSegTitleView*)segView
{
    NSInteger index = segView.selectedSegmentIndex;
    NSLog(@"%@",self.titleArray[index]);
    
    if (index == 0) {
        //综合数据
        NSString* nowTime = [NSString stringWithFormat:@"%ld",(long)[NSDate getCurrentDate]];
        NSString* year = [nowTime substringToIndex:4];
        NSString* yearAndMonth = [nowTime substringToIndex:6];
        
        //获取总数
        [self getDataStatisticsRequestWithBeginDate:@"19000101" withStatues:@"0"];
        //获取年数
        [self getDataStatisticsRequestWithBeginDate:[NSString stringWithFormat:@"%@0101",year] withStatues:@"1"];
        //获取月数
        [self getDataStatisticsRequestWithBeginDate:[NSString stringWithFormat:@"%@01",yearAndMonth] withStatues:@"2"];
    }else{
        //健康教育
        
    }
    
    
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //个数
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
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
    [headerBtn addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerBtn.mas_centerY);
        make.left.equalTo(headerBtn.mas_left).offset(15);
    }];
    
    if (section == 0) {
        titleLab.text = @"综合统计";
    }else if (section == 1){
        titleLab.text = @"随访统计";
    }else if (section == 2){
        titleLab.text = @"出诊记录";
    }else{
        titleLab.text = @"测试标题";
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
    //备注信息
    MDDataStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDDataStatisticsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.lefTitleLab.text = @"总患者人数";
        if (self.totalModel.signCount) {
            cell.leftValueLab.text = self.totalModel.signCount;
        }else{
            cell.leftValueLab.text = @"0";
        }
        cell.midTitleLab.text = @"年新增人数";
        if (self.yearModel.signCount) {
            cell.midValueLab.text = self.yearModel.signCount;
        }else{
            cell.midValueLab.text = @"0";
        }
        cell.rightTitleLab.text = @"月新增人数";
        if (self.monthModel.signCount) {
            cell.rightValueLab.text = self.monthModel.signCount;
        }else{
            cell.rightValueLab.text = @"0";
        }
        
    }else if (indexPath.section == 1){
        cell.lefTitleLab.text = @"总随访次数";
        if (self.totalModel.followUp) {
            cell.leftValueLab.text = self.totalModel.followUp;
        }else{
            cell.leftValueLab.text = @"0";
        }
        cell.midTitleLab.text = @"年随访次数";
        if (self.yearModel.followUp) {
            
            cell.midValueLab.text = self.yearModel.followUp;
        }else{
            
            cell.midValueLab.text = @"0";
        }
        cell.rightTitleLab.text = @"月随访次数";
        if (self.monthModel.followUp) {
            
            cell.rightValueLab.text = self.monthModel.followUp;
        }else{
            
            cell.rightValueLab.text = @"0";
        }
        
    }else if (indexPath.section == 2){
        cell.lefTitleLab.text = @"总出诊次数";
        if (self.totalModel.visit) {
            
            cell.leftValueLab.text = self.totalModel.visit;
        }else{
            
            cell.leftValueLab.text = @"0";
        }
        cell.midTitleLab.text = @"年出诊次数";
        if (self.yearModel.visit) {
            
            cell.midValueLab.text = self.yearModel.visit;
        }else{
            
            cell.midValueLab.text = @"0";
        }
        cell.rightTitleLab.text = @"月出诊次数";
        if (self.monthModel.visit) {
            
            cell.rightValueLab.text = self.monthModel.visit;
        }else{
            
            cell.rightValueLab.text = @"0";
        }
    }else{
        
    }
    return cell;
    
}

#pragma mark -- 获取数据统计
- (void)getDataStatisticsRequestWithBeginDate:(NSString*)beginDate withStatues:(NSString*)statues
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:beginDate forKey:@"bdate"];
    
    [param setValue:[NSString stringWithFormat:@"%ld",(long)[NSDate getCurrentDate]] forKey:@"edate"];
    
    NSString* url = PATH(@"%@/statistics");
    
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                if ([statues isEqualToString:@"0"]) {
                    self.totalModel = [MDDataStatisticsModel yy_modelWithDictionary:responseObj[@"data"]];
                }else if ([statues isEqualToString:@"1"]){
                    self.yearModel = [MDDataStatisticsModel yy_modelWithDictionary:responseObj[@"data"]];
                }else{
                    self.monthModel = [MDDataStatisticsModel yy_modelWithDictionary:responseObj[@"data"]];
                }
                
                
                
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
