//
//  LSMineUserSettingController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/27.
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
    [self initForView];
}

-(void)initForView{
    
    self.navigationItem.title = @"基本资料";
    
    [self.view addSubview:self.dataTableView];
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
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

@end
