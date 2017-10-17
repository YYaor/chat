//
//  MDConsulteDisccussVC.m
//  MyDoctor
//
//  Created by WangQuanjiang on 17/9/20.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDConsulteDisccussVC.h"
#import "MDConsultDiscussCell.h"

@interface MDConsulteDisccussVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* listTab;//列表
}

@end

@implementation MDConsulteDisccussVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"会诊讨论";
    
    [self setUpUi];
    
}

#pragma mark -- 创建界面
- (void)setUpUi
{
    //创建界面
    listTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT) style:UITableViewStyleGrouped];
    listTab.delegate = self;
    listTab.dataSource = self;
    [self.view addSubview:listTab];
    
    //注册Cell
    [listTab registerNib:[UINib nibWithNibName:@"MDConsultDiscussCell" bundle:nil] forCellReuseIdentifier:@"mDConsultDiscussCell"];
    
    
    
}


#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0000001f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDConsultDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDConsultDiscussCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//群组点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"点击跳转对应群组对话");
}



@end
