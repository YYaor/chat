//
//  YGMedicalRecordDetailVC.m
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/9.
//
//

#import "YGMedicalRecordDetailVC.h"
#import "YGMedicalInfoCell.h"
#import "YGMedicalPrescriptionCell.h"
#import "YGMedicalRecordDetailModel.h"

@interface YGMedicalRecordDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* detailTab;
}
@property (nonatomic , strong)YGMedicalRecordDetailModel* detailModel;
@property (nonatomic , strong)NSMutableArray* checkImgArr;
@end

@implementation YGMedicalRecordDetailVC

- (NSMutableArray*)checkImgArr
{
    if (_checkImgArr == nil) {
        _checkImgArr = [NSMutableArray array];
    }
    return _checkImgArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"病历详情";
    //创建界面
    [self setUpUi];
}
- (void)viewWillAppear:(BOOL)animated
{
    //获取病历详情
    [self getMedicalRecordDetailData];
}
#pragma mark -- 创建界面
- (void)setUpUi
{
    detailTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 60) style:UITableViewStyleGrouped];
    detailTab.delegate = self;
    detailTab.dataSource = self;
    [self.view addSubview:detailTab];
    //注册Cell
    [detailTab registerNib:[UINib nibWithNibName:@"YGMedicalInfoCell" bundle:nil] forCellReuseIdentifier:@"yGMedicalInfoCell"];
    [detailTab registerNib:[UINib nibWithNibName:@"YGMedicalPrescriptionCell" bundle:nil] forCellReuseIdentifier:@"yGMedicalPrescriptionCell"];//用药及处方
    
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //个数
    return 6;
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
    if (indexPath.section == 0) {
        return 120.0f;
    }else{
        return UITableViewAutomaticDimension;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //挂号信息
        YGMedicalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGMedicalInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        return cell;
    }else{
        //用药及处方
        YGMedicalPrescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGMedicalPrescriptionCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            cell.titleStr = @"病情主诉";
            cell.valueStr = self.detailModel.chief_complaint;
        }else if (indexPath.section == 2){
            cell.titleStr = @"医生诊断";
            cell.valueStr = self.detailModel.diagnosis;
        }else if (indexPath.section == 3){
            cell.titleStr = @"医嘱";
            cell.valueStr = self.detailModel.advice;
        }else if (indexPath.section == 4){
            cell.titleStr = @"检查检验";
            NSMutableArray* arr = [NSMutableArray array];
            [arr removeAllObjects];
            for (YGMedicalRecordImgModel* imgModel in self.detailModel.checke_imgs) {
                [arr addObject:imgModel.img_url];
            }
            cell.imgArr = arr;
            cell.valueStr = self.detailModel.check_content;
        }else{
            //用药及处方
            
            NSMutableArray* arr = [NSMutableArray array];
            [arr removeAllObjects];
            for (YGMedicalRecordImgModel* imgModel in self.detailModel.pharmacy_imgs) {
                [arr addObject:imgModel.img_url];
            }
            cell.titleStr = @"用药及处方";
            cell.imgArr = arr;
            cell.valueStr = self.detailModel.pharmacy;
        }
        
        return cell;
    }
    
}

#pragma mark -- 获取病历详情
- (void)getMedicalRecordDetailData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    [param setValue:self.recordIdStr forKey:@"id"];
    NSString* url = PATH(@"%@/getPatientCaseInfo");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                self.detailModel = [YGMedicalRecordDetailModel yy_modelWithDictionary:responseObj[@"data"]];
                
                [detailTab reloadData];
                
            }else
            {
                [XHToast showCenterWithText:@"获取数据失败"];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
        
        
        
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
    
    
}







@end
