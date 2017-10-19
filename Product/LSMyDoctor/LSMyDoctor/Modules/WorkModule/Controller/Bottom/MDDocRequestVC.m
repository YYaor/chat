//
//  MDDocRequestVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/18.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDDocRequestVC.h"
#import "MDSickerRequestCell.h"

@interface MDDocRequestVC ()<UITableViewDelegate,UITableViewDataSource,MDSickerRequestCellDelegate>
{
    UITableView* requestTab;
}
@property (nonatomic,strong) NSMutableArray *sickerRequestArr;

@end

@implementation MDDocRequestVC
#pragma mark -- 懒加载
- (NSMutableArray *)sickerRequestArr{
    
    if (_sickerRequestArr == nil) {
        _sickerRequestArr = [NSMutableArray array];
        
    }
    return _sickerRequestArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"同行请求";
    
    [self setUpUi];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark -- 创建界面
- (void)setUpUi
{
    requestTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT) style:UITableViewStyleGrouped];
    
    requestTab.delegate = self;
    requestTab.dataSource = self;
    [self.view addSubview:requestTab];
    
    //注册Cell
    [requestTab registerNib:[UINib nibWithNibName:@"MDSickerRequestCell" bundle:nil] forCellReuseIdentifier:@"mDSickerRequestCell"];
}

#pragma mark -- UITableViewDelegate 、 UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDSickerRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDSickerRequestCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
    
}
#pragma mark -- 左滑删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"移除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"删除");
        
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    MDServiceListModel* listModel = self.sickerRequestArr[indexPath.section];
    //
    //    MDSickerDetailVC* sickerDetailVC = [[MDSickerDetailVC alloc] init];
    //
    //    sickerDetailVC.isRequestComing = YES;
    //    sickerDetailVC.userIdStr = listModel.user_id;
    //    sickerDetailVC.serialnumberStr = listModel.serialnumber;
    //    [self.navigationController pushViewController:sickerDetailVC animated:YES];
    
    
    
}


#pragma mark -- 同意按钮点击
/*
- (void)mDSickerRequestCellDelegateAgreeBtnClickWithSickerModel:(MDServiceListModel *)sickerModel
{
    NSLog(@"同意按钮点击：%@",sickerModel.username);
}
*/




@end
