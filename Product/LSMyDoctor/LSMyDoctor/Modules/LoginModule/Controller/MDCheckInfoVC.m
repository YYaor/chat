//
//  MDCheckInfoVC.m
//  MyDoctor
//
//  Created by 惠生 on 17/5/18.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDCheckInfoVC.h"
#import "MDCheckInfoCell.h"
#import "MDSetPasswordVC.h"

@interface MDCheckInfoVC () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView* checkTab;
}

@end

@implementation MDCheckInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"核对信息";
//    self.view.backgroundColor = Style_Color_Content_BGColor;
    
    [self setUpUI];
    // Do any additional setup after loading the view.
}

#pragma mark -- 创建View
- (void)setUpUI
{
    checkTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT) style:UITableViewStyleGrouped];
    checkTab.delegate = self;
    checkTab.dataSource = self;
    checkTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:checkTab];
    
    //注册Cell
    [checkTab registerNib:[UINib nibWithNibName:@"MDCheckInfoCell" bundle:nil] forCellReuseIdentifier:@"mDCheckInfoCell"];
    
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10.0f;
    }else{
        return 0.00000001f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80.0f;
    }else if(indexPath.section == 2){
        return 60.0f;
    }else{
        return UITableViewAutomaticDimension;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        UITableViewCell* cell = [[UITableViewCell alloc] init];
        UILabel* titleLab = [[UILabel alloc] init];
        titleLab.text =@"请核对信息是否正确";
        if (_dict[@"header"]) {
            
            titleLab.text = _dict[@"header"];
        }
        titleLab.font = [UIFont systemFontOfSize:20];
//        titleLab.textColor = Style_Color_Content_Blue;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.mas_centerX);
            make.centerY.equalTo(cell.mas_centerY);
            make.top.equalTo(cell.mas_top);
            make.left.equalTo(cell.mas_left);
        }];
        return cell;
    }else if(indexPath.section == 1){
        
        MDCheckInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDCheckInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDict = self.dict;
        return cell;
    }else{
        UITableViewCell* cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //联系客服
        UIButton* callBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, (LSSCREENWIDTH - 40)/2, 40)];
        [callBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [callBtn setTitleColor:[UIColor colorFromHexString:LSGREENCOLOR] forState:UIControlStateNormal];
        callBtn.layer.masksToBounds = YES;
        callBtn.layer.cornerRadius = 4.5f;
        callBtn.layer.borderWidth = 1.0f;
        callBtn.layer.borderColor = [UIColor colorFromHexString:LSGREENCOLOR].CGColor;
        [cell addSubview:callBtn];
        
        //确定按钮
        UIButton* sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + 15+(LSSCREENWIDTH - 40)/2, 10, (LSSCREENWIDTH - 40)/2, 40)];
        [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn setBackgroundColor:[UIColor colorFromHexString:LSGREENCOLOR]];
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 4.5f;
        sureBtn.layer.borderWidth = 1.0f;
        sureBtn.layer.borderColor = [UIColor colorFromHexString:LSGREENCOLOR].CGColor;
        [cell addSubview:sureBtn];
        
        
        return cell;
    }
}

#pragma mark -- 联系客服按钮点击
- (void)callBtnClick
{
    NSLog(@"联系客服");
    if (_dict[@"customerService"]) {
        //客服电话
        
       [AlertHelper InitMyAlertWithTitle:@" " AndMessage:[NSString stringWithFormat:@"电话：%@",_dict[@"customerService"]] And:self CanCleBtnName:@"取消" SureBtnName:@"拨打" AndCancleBtnCallback:^(id data) {
           //取消按钮点击
       } AndSureBtnCallback:^(id data) {
           //拨打电话
           NSString* telNum = [[NSMutableString alloc] initWithFormat:@"tel:%@",_dict[@"customerService"]];
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum]];
       }];
    }
}
#pragma mark -- 确认按钮点击
- (void)sureBtnClick
{
    NSLog(@"确认按钮点击");
    [self makeSureInfoData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 确认核对的信息
- (void)makeSureInfoData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/login/confirm");
    
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if ([responseObj[@"status"] isEqualToString:@"0"])
        {
            MDSetPasswordVC* setPswVC = [[MDSetPasswordVC alloc] init];
            
            [self.navigationController pushViewController:setPswVC animated:YES];
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

@end
