//
//  LSMineUserSettingController.m
//  LSKJChart
//
//  Created by 刘博宇 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineUserSettingController.h"
#import "LSMineUserSettingCell.h"
@interface LSMineUserSettingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *dataTableView;

@end

@implementation LSMineUserSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    [self initForView];
}

-(void)initNavView{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,64)];
    navView.backgroundColor = [UIColor colorFromHexString:LSGREENCOLOR];
    [self.view addSubview:navView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"基本资料";
    titleLabel.backgroundColor = [UIColor clearColor];
    [navView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navView);
        make.centerY.equalTo(navView).offset(8);
    }];
}

-(void)initForView{
    [self.view addSubview:self.dataTableView];
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSMineUserSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSMineUserSettingCell"];
    if (!cell) {
        cell = [[LSMineUserSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMineUserSettingCell"];
    }
    
    NSArray *titleArray = @[@"头 像",@"姓 名",@"医 院",@"科 室",@"职 称",@"擅 长",@"简 介"];
    [cell updateTitle:titleArray[indexPath.row]];
    
    if (indexPath.row == 0) {
        [cell hideHeadImageView:NO];
        [cell updateHead:nil];
    }else{
        [cell hideHeadImageView:YES];
        if (indexPath.row == 1) {
            [cell updateName:@"囧城"];
        }
        if (indexPath.row == 2) {
            [cell updateHospital:@"华西"];
        }
        if (indexPath.row == 3) {
            [cell updateRoom:@"妇科"];
        }
        if (indexPath.row == 4) {
            [cell updateCareer:@"助手"];
        }
        if (indexPath.row == 5) {
            [cell updateGoodat:@"善解人衣"];
        }
        if (indexPath.row == 6) {
            [cell updateInfo:@"个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介"];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90;
    }else{
        return 50;
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)dataTableView{
    if (!_dataTableView) {
        _dataTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dataTableView.delegate = self;
        _dataTableView.dataSource = self;
        _dataTableView.backgroundColor = [UIColor colorFromHexString:@"dedede"];
    }
    return _dataTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
