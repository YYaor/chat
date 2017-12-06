//
//  MDPeerDetailVC.m
//  MyDoctor
//
//  Created by WangQuanjiang on 17/9/20.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDPeerDetailVC.h"
#import "MDPeerDoctorHeadCell.h"
#import "MDPeerinstructCell.h"
#import "MDPeerDiscussCell.h"
#import "MDSingleCommunicateVC.h"//单人聊天室
#import "MDSingleCommunicationVC.h"
#import "MDDoctorDetailModel.h"
#import "MDDoctorDetailEvaluateModel.h"//评价的Model

@interface MDPeerDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* detailTab;
    UIButton* beginTalkBtn;// 对话/申请加好友 按钮
}
@property (nonatomic , strong)MDDoctorDetailModel * detailModel;
@property(nonatomic ,strong)NSMutableArray* evaluateArr;//评价的列表

@end

@implementation MDPeerDetailVC
#pragma mark -- 懒加载
- (NSMutableArray *)evaluateArr{
    
    if (_evaluateArr == nil) {
        _evaluateArr = [[NSMutableArray alloc] init];
        
    }
    return _evaluateArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"医生详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUi];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    //获取医生详情
    [self getDoctorDetailRequest];
}

#pragma mark -- 创建界面
- (void)setUpUi
{
    
    //创建界面
    detailTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT - 60 - 60) style:UITableViewStyleGrouped];
    detailTab.delegate = self;
    detailTab.dataSource = self;
    [self.view addSubview:detailTab];
    
    //注册Cell
    [detailTab registerNib:[UINib nibWithNibName:@"MDPeerDoctorHeadCell" bundle:nil] forCellReuseIdentifier:@"mDPeerDoctorHeadCell"];
    [detailTab registerNib:[UINib nibWithNibName:@"MDPeerinstructCell" bundle:nil] forCellReuseIdentifier:@"mDPeerinstructCell"];
    [detailTab registerNib:[UINib nibWithNibName:@"MDPeerDiscussCell" bundle:nil] forCellReuseIdentifier:@"mDPeerDiscussCell"];
    
    
    
    //对话 、申请加好友按钮
    beginTalkBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, LSSCREENHEIGHT - 50 - 64, LSSCREENWIDTH - 60, 40)];
    [beginTalkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [beginTalkBtn addTarget:self action:@selector(beginTalkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    beginTalkBtn.layer.masksToBounds = YES;
    beginTalkBtn.layer.cornerRadius = 6.0f;
    [self.view addSubview:beginTalkBtn];
    if (self.isFriend) {
        //如果是已经是好友，则显示对话，
        [beginTalkBtn setTitle:@"对话" forState:UIControlStateNormal];
        [beginTalkBtn setBackgroundColor:BaseColor];
    }else{
        //如果不是好友，显示申请加好友
        [beginTalkBtn setTitle:@"申请加好友" forState:UIControlStateNormal];
        [beginTalkBtn setBackgroundColor:BaseColor];
    }
    
    
}

#pragma mark -- 申请加好友、对话按钮点击
- (void)beginTalkBtnClick
{
    if (self.isFriend) {
        //已经是好友
        NSLog(@"对话");
        MDSingleCommunicationVC *chatController = [[MDSingleCommunicationVC alloc] initWithConversationChatter:[NSString stringWithFormat:@"ug369d%@",self.doctorIdStr] conversationType:EMConversationTypeChat];
        chatController.titleStr = self.detailModel.doctor_name;
        chatController.user_idStr = self.doctorIdStr;
        [self.navigationController pushViewController:chatController animated:YES];
    }else{
        //不是好友
        NSLog(@"添加好友");
        [self requestForAddToFriendRequest];
    }
}


#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        //患者评价
        return self.evaluateArr.count;
    }else{
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        //患者评价
        return 50.0f;
    }else{
        return 0.0000001f;
    }
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
    UIView* headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (section == 3) {
        //患者评价
        UILabel* titleLab = [[UILabel alloc] init];
        titleLab.backgroundColor = [UIColor whiteColor];
        titleLab.text = @"   患者评价";
        titleLab.textColor = Style_Color_Content_Black;
        [headView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.mas_top).offset(10);
            make.left.equalTo(headView.mas_left);
            make.right.equalTo(headView.mas_right);
            make.bottom.equalTo(headView.mas_bottom).offset(-1);
        }];
    }
    
    
    return headView;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //医生个人资料
        MDPeerDoctorHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDPeerDoctorHeadCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        return cell;
    }else if(indexPath.section == 1 || indexPath.section == 2){
        //擅长和医生简介
        MDPeerinstructCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDPeerinstructCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            //擅长
            cell.titleStr = @"擅长";
            cell.valueStr = self.detailModel.doctor_specialty;
        }else{
            //医生简介
            cell.titleStr = @"医生简介";
            cell.valueStr = self.detailModel.doctor_introduction;
        }
        return cell;
        
    }else if(indexPath.section == 3){
        //患者评价
        MDPeerDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDPeerDiscussCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.evaluateArr[indexPath.row];
        return cell;
        
    }else{
        
        UITableViewCell* cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"测试";
        return cell;
    }
}

#pragma mark  -- 获取医生详情请求
- (void)getDoctorDetailRequest
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.doctorIdStr forKey:@"doctorid"];
    
    NSString* url = PATH(@"%@/doctorInfo");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                self.detailModel = [MDDoctorDetailModel yy_modelWithDictionary:responseObj[@"data"]];
                //变更按钮状态
                self.isFriend = [self.detailModel.isFriend boolValue];
                if (self.isFriend) {
                    //如果是已经是好友，则显示对话，
                    [beginTalkBtn setTitle:@"对话" forState:UIControlStateNormal];
                    beginTalkBtn.enabled = YES;
                    [beginTalkBtn setBackgroundColor:BaseColor];
                }else{
                    //如果不是好友，显示申请加好友
                    if ([self.detailModel.isRequest integerValue] > 0) {
                        [beginTalkBtn setBackgroundColor:[UIColor lightGrayColor]];
                        beginTalkBtn.enabled = NO;
                    }else{
                        [beginTalkBtn setBackgroundColor:BaseColor];
                        beginTalkBtn.enabled = YES;
                    }
                    [beginTalkBtn setTitle:@"申请加好友" forState:UIControlStateNormal];
                    
                }
                //获取评价列表
                [self getEvaluateListData];
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

#pragma mark -- 获取医生评价的列表
- (void)getEvaluateListData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.doctorIdStr forKey:@"doctorid"];
    [param setValue:@(1)forKey:@"pagenum"];
    [param setValue:@(100) forKey:@"pagesize"];
    
    NSString* url = [NSString stringWithFormat:@"%@/patient/evaluteList",UGAPI_HOST];
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"] && responseObj[@"data"] && responseObj[@"data"][@"content"])
            {
                
                NSArray* list = [NSArray yy_modelArrayWithClass:[MDDoctorDetailEvaluateModel class] json:responseObj[@"data"][@"content"]];
                [self.evaluateArr removeAllObjects];
                [self.evaluateArr addObjectsFromArray:list];
                
                [detailTab reloadData];
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


#pragma mark -- 申请添加好友
- (void)requestForAddToFriendRequest
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.doctorIdStr forKey:@"doctorid"];
    
    NSString* url = PATH(@"%@/addPeers");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                //发送请求成功
                if (responseObj[@"data"] && responseObj[@"data"][@"message"]) {
                    [XHToast showCenterWithText:responseObj[@"data"][@"message"]];
                }else{
                    [XHToast showCenterWithText:@"请求已发送成功"];
                }
                
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
        //[XHToast showCenterWithText:@"fail"];
    }];
}


@end
