//
//  MDSickerMedicalRecordListVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSickerMedicalRecordListVC.h"
#import "YGMedicalRecordListModel.h"
#import "YGMedicalListCell.h"
#import "YGMedicalRecordDetailVC.h"

@interface MDSickerMedicalRecordListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* recordTab;
}
@property (nonatomic ,strong)NSMutableArray* listMultArr;


@end

@implementation MDSickerMedicalRecordListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"患者病历";
    
    [self setUpUi];
}

#pragma mark -- 懒加载
- (NSMutableArray *)listMultArr{
    
    if (_listMultArr == nil) {
        _listMultArr = [[NSMutableArray alloc] init];
    }
    return _listMultArr;
}
- (void)viewWillAppear:(BOOL)animated
{
    //获取病历数据
    [self getMyMedicalListData];
}

#pragma mark -- 创建界面
- (void)setUpUi
{
    //创建界面
    recordTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    recordTab.delegate = self;
    recordTab.dataSource = self;
    [self.view addSubview:recordTab];
    
    
    //注册Cell
    [recordTab registerNib:[UINib nibWithNibName:@"YGMedicalListCell" bundle:nil] forCellReuseIdentifier:@"yGMedicalListCell"];
    
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //个数
    return self.listMultArr.count;
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
    YGMedicalListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGMedicalListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YGMedicalRecordListModel* listModel = self.listMultArr[indexPath.section];
    cell.model = listModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YGMedicalRecordListModel* listModel = self.listMultArr[indexPath.section];
    YGMedicalRecordDetailVC* medicalRecordDetailVC = [[YGMedicalRecordDetailVC alloc] init];
    medicalRecordDetailVC.recordIdStr = listModel.recordId;
    [self.navigationController pushViewController:medicalRecordDetailVC animated:YES];
    
}

#pragma mark -- 获取病历列表
- (void)getMyMedicalListData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    [param setValue:self.user_idStr forKey:@"userid"];
    NSString* url = PATH(@"%@/getPatientCaseList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                //获取成功
                NSArray* list = [NSArray yy_modelArrayWithClass:[YGMedicalRecordListModel class] json:responseObj[@"data"]];
                [self.listMultArr removeAllObjects];
                [self.listMultArr addObjectsFromArray:list];
                
                [recordTab reloadData];
                
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
