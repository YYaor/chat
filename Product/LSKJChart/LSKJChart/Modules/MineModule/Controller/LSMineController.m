//
//  LSMineController.m
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineController.h"
#import "LSMineUserSettingController.h"
#import "LSMineSettingController.h"

#import "LSMineHeaderView.h"
#import "LSMineListCell.h"
@interface LSMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *dataTableView;

@property (nonatomic,strong)LSMineHeaderView *headerView;

@end

@implementation LSMineController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
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
    [self setStatusBarBackgroundColor:[UIColor colorFromHexString:LSGREENCOLOR]];
    [self.view addSubview:self.dataTableView];
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

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
    
    [self.headerView updateWithImageURL:@"" name:@"陈医生" room:@"儿科" career:@"主任医生"];
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
            LSMineUserSettingController *userSettingController = [[LSMineUserSettingController alloc]init];
            [self.navigationController pushViewController:userSettingController animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            LSMineSettingController *settingController =  [[LSMineSettingController alloc]init];
            [self.navigationController pushViewController:settingController animated:YES];
        }
    }
}

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
    }
    return _headerView;
}

@end
