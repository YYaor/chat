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
#import "EaseMessageViewController.h"//单人聊天室

@interface MDPeerDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* detailTab;
    UIButton* beginTalkBtn;// 对话/申请加好友 按钮
}
@end

@implementation MDPeerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"医生详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUi];
    
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
        EaseMessageViewController* singleCoummunicateVC = [[EaseMessageViewController alloc] initWithConversationChatter:self.doctorIdStr conversationType:EMConversationTypeChat];
        singleCoummunicateVC.title = @"某医生";
        [self.navigationController pushViewController:singleCoummunicateVC animated:YES];
        
    }else{
        //不是好友
        NSLog(@"添加好友");
        
        
        
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
        return 5;
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
        return 50;
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
        
        return cell;
    }else if(indexPath.section == 1 || indexPath.section == 2){
        //擅长和医生简介
        MDPeerinstructCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDPeerinstructCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            //擅长
            cell.titleStr = @"擅长";
            cell.valueStr = @"hadsfjakdjksajksjafklaskdj";
        }else{
            //医生简介
            cell.titleStr = @"医生简介";
            cell.valueStr = @"儿科博士，主任医师，硕士研究生导师。";
        }
        return cell;
        
    }else if(indexPath.section == 3){
        //患者评价
        MDPeerDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDPeerDiscussCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
    
}



@end
