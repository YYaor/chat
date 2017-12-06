//
//  MDHealthEducationDetailVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/22.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDHealthEducationDetailVC.h"
#import "MDHealthEducationCell.h"
#import "MDActivityStatisticsModel.h"

@interface MDHealthEducationDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* detailTab;//活动明细
}
@property (nonatomic,strong) NSMutableArray *listMultArr;//数据

@end

@implementation MDHealthEducationDetailVC

- (NSMutableArray *)listMultArr{
    
    if (_listMultArr == nil) {
        _listMultArr = [NSMutableArray array];
    }
    return _listMultArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动统计";
    
    [self setUpUi];
}

- (void)viewWillAppear:(BOOL)animated
{
    //获取活动统计详情
    [self getHealthEducationDetalStatisticsRequest];
}

#pragma mark -- 创建界面
- (void)setUpUi
{
    detailTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT) style:UITableViewStyleGrouped];
    detailTab.delegate = self;
    detailTab.dataSource = self;
    [self.view addSubview:detailTab];
    
    
    [detailTab registerNib:[UINib nibWithNibName:@"MDHealthEducationCell" bundle:nil] forCellReuseIdentifier:@"mDHealthEducationCell"];
}

#pragma mark -- UITableViewDelegate 、 UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listMultArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0000001f;
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
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDActivityStatisticsModel* model = self.listMultArr[indexPath.section];
    
    MDHealthEducationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDHealthEducationCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.rightImgView.hidden = YES;
    if (self.typeNum == 1) {
        //本月
        cell.titleStr = [NSString stringWithFormat:@"%@(本月)",model.name];
    }else{
        //本年
        cell.titleStr = [NSString stringWithFormat:@"%@(本年)",model.name];
    }
    cell.signUpNumStr = model.sign_number;
    cell.totalNumStr = model.total_number;
    
    return cell;
}

#pragma mark -- 获取活动数据统计详情
- (void)getHealthEducationDetalStatisticsRequest
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@(self.typeNum) forKey:@"type"];
    
    NSString* url = PATH(@"%@/activityStatistics");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                
                NSArray* list = [NSArray yy_modelArrayWithClass:[MDActivityStatisticsModel class] json:responseObj[@"data"]];
                [self.listMultArr removeAllObjects];
                [self.listMultArr addObjectsFromArray:list];
                
                [detailTab reloadData];
                
                
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
