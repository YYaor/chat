//
//  LSMineController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineController.h"
#import "LSMineSettingController.h"
#import "LSMineFeedbackController.h"
#import "LSMineCardController.h"

#import "LSMineHeaderView.h"
#import "LSMineListCell.h"

#import "LSMineModel.h"

@interface LSMineController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

@property (nonatomic,strong)UITableView *dataTableView;

@property (nonatomic,strong)LSMineHeaderView *headerView;

@property (nonatomic, strong) LSMineModel *mineModel;

@end

@implementation LSMineController

- (void)viewWillAppear:(BOOL)animated
{
    //获取个人信息
    [self getMineInfoData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initForView];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)initForView
{
    self.navigationController.delegate = self;
    
    [self setStatusBarBackgroundColor:[UIColor colorFromHexString:LSGREENCOLOR]];
    [self.view addSubview:self.dataTableView];
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowMine = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowMine animated:YES];
}

#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSMineListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSMineListCell"];
    if (!cell) {
        cell = [[LSMineListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMineListCell"];
    }
    
    NSArray *iconArray0 = @[@"mine_businesscard",@"mine_find"];
    NSArray *title0 = @[@"我的名片",@"发现"];
    NSArray *iconArray1 = @[@"mine_contact",@"mine_feedback",@"mine_setup"];
    NSArray *title1 = @[@"联系客服",@"意见反馈",@"设置"];
    if (indexPath.section == 0) {
        [cell updateCellWithIcon:iconArray0[indexPath.row] title:title0[indexPath.row]];
        
        if (indexPath.row == iconArray0.count-1) {
            [cell hideBottomLine:YES];
        }else{
            [cell hideBottomLine:NO];
        }
        
    }else{
        [cell updateCellWithIcon:iconArray1[indexPath.row] title:title1[indexPath.row]];
        if (indexPath.row == iconArray1.count-1) {
            [cell hideBottomLine:YES];
        }else{
            [cell hideBottomLine:NO];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor colorFromHexString:@"dedede"];
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LSMineCardController *cardController = [[LSMineCardController alloc]init];
            cardController.user = [[LSUserModel alloc]init];
            cardController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cardController animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
        }
        if (indexPath.row == 1) {
            LSMineFeedbackController *feedbackController = [[LSMineFeedbackController alloc]init];
            feedbackController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedbackController animated:YES];
        }
        if (indexPath.row == 2) {
            LSMineSettingController *settingController =  [[LSMineSettingController alloc]init];
            settingController.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:settingController animated:YES];
        }
    }
}

#pragma mark -- 获取个人信息
- (void)getMineInfoData
{
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:[Defaults valueForKey:@"cookie"] forKey:@"cookie"];
    [param setValue:[Defaults valueForKey:@"accessToken"] forKey:@"accessToken"];
    
    NSString* url = PATH(@"%@/my/info");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            
//            self.myInfoModel = [MDMyInfoModel yy_modelWithDictionary:responseObj];
//            
//            MyServiceCountModel* serviceModel = self.myInfoModel.myServiceCount[0];
//            MyBaseInfoModel* baseModel = self.myInfoModel.myBaseInfo[0];
//            
//            [mineTab reloadData];
            weakSelf.mineModel = [LSMineModel yy_modelWithJSON:responseObj];
            
            [weakSelf.headerView updateWithImageURL:weakSelf.mineModel.myImage?weakSelf.mineModel.myImage:@"" name:weakSelf.mineModel.myName career:weakSelf.mineModel.myRemark];
            
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

#pragma mark - getter & setter

-(UITableView *)dataTableView{
    if (!_dataTableView) {
        _dataTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dataTableView.delegate = self;
        _dataTableView.dataSource = self;
        _dataTableView.tableHeaderView = self.headerView;
        _dataTableView.backgroundColor = [UIColor colorFromHexString:@"dedede"];
    }
    return _dataTableView;
}

-(LSMineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[LSMineHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
        _headerView.backgroundColor = [UIColor colorFromHexString:LSGREENCOLOR];
        _headerView.controller = self;
    }
    return _headerView;
}

@end
