//
//  MDSickerDetailVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/30.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSickerDetailVC.h"
#import "MDSickerDetailInfoCell.h"
#import "MDSickerClassCell.h"
#import "MDSickerDetailBottomCell.h"
#import "MDSickerDetailModel.h"

@interface MDSickerDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* detailTab;
}
@property (nonatomic , strong)MDSickerDetailModel* detailModel;

@end

@implementation MDSickerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"患者主页";
    
    [self setUpUi];
}
#pragma mark -- 创建界面
- (void)setUpUi
{
    //创建界面
    detailTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT - 60 - 64) style:UITableViewStyleGrouped];
    detailTab.delegate = self;
    detailTab.dataSource = self;
    [self.view addSubview:detailTab];
    
    
    //注册
    [detailTab registerNib:[UINib nibWithNibName:@"MDSickerDetailInfoCell" bundle:nil] forCellReuseIdentifier:@"mDSickerDetailInfoCell"];
 
    [detailTab registerNib:[UINib nibWithNibName:@"MDSickerClassCell" bundle:nil] forCellReuseIdentifier:@"mDSickerClassCell"];
    
    [detailTab registerNib:[UINib nibWithNibName:@"MDSickerDetailBottomCell" bundle:nil] forCellReuseIdentifier:@"mDSickerDetailBottomCell"];
    
    UIButton* talkBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, LSSCREENHEIGHT - 50 - 64, LSSCREENWIDTH - 60, 40)];
    [talkBtn setTitle:@"对 话" forState:UIControlStateNormal];
    [talkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [talkBtn setBackgroundColor:BaseColor];
    talkBtn.layer.masksToBounds = YES;
    talkBtn.layer.cornerRadius = 6.0f;
    [talkBtn addTarget:self action:@selector(talkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:talkBtn];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    //获取患者详情
    [self getSickerDetailRequestData];
}

#pragma mark -- 对话按钮点击
- (void)talkBtnClick
{
    NSLog(@"点击对话");
    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"ug369P%@", self.sickerIdStr] conversationType:EMConversationTypeChat];
    chatController.title = @"测试标题";
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        //个人信息
        return 3;
    }else{
        return 1;
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0000001f;
    }
    return 15.0f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MDSickerDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDSickerDetailInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.infoModel = self.detailModel;
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //是否为重点
            UITableViewCell* cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel* importantLab = [[UILabel alloc] init];
            
            importantLab.text = @"是否为重点";
            importantLab.textColor = Style_Color_Content_Black;
            importantLab.font = [UIFont systemFontOfSize:18];
            [cell addSubview:importantLab];
            [importantLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.left.equalTo(cell.mas_left).offset(15);
            }];
            
            
            UISwitch* isImportantSwitch = [[UISwitch alloc] init];
            isImportantSwitch.on = self.detailModel.is_focus;
//            isImportant = self.sickerModel.keyflag;
            [isImportantSwitch addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:isImportantSwitch];
            [isImportantSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-15);
            }];
            return cell;
        }else{
            //患者分类信息
            
            MDSickerClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDSickerClassCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 1) {
                cell.cellTitleLab.text = @"患者分类";
            }else{
                cell.cellTitleLab.text = @"备注";
            }
            
            return cell;
        }
        
        
        
    }else{
        
        MDSickerDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDSickerDetailBottomCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
}


#pragma mark -- 是否为重点点击
- (void)switchBtnClick:(UISwitch*)sender
{
//    isImportant = sender.isOn;
    if (sender.isOn) {
        NSLog(@"打开");
    }else{
        NSLog(@"关闭");
    }
    
}






#pragma mark -- 获取患者详情
- (void)getSickerDetailRequestData
{
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.sickerIdStr forKey:@"userid"];
    
    NSString* url = PATH(@"%@/patienInfo");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            self.detailModel = [MDSickerDetailModel yy_modelWithDictionary:responseObj[@"data"]];
            
            [detailTab reloadData];
            
        }else
        {
            [XHToast showCenterWithText:@"获取信息失败"];
        }
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
}


@end
