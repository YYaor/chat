//
//  LSWorkTailDetailController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkTailDetailController.h"

#import "MDSingleCommunicationVC.h"

#import "LSWorkTailDetailUserCell.h"
#import "LSWorkTailDetailCell.h"

static NSString *cellId1 = @"LSWorkTailDetailUserCell";
static NSString *cellId2 = @"LSWorkTailDetailCell";

@interface LSWorkTailDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end

@implementation LSWorkTailDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
    [self requestData];
}

- (void)initForView
{
    self.navigationItem.title = @"医嘱详情";
    
    self.dataDic = [NSMutableDictionary dictionary];
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId1 bundle:nil] forCellReuseIdentifier:cellId1];
    [self.tableView registerNib:[UINib nibWithNibName:cellId2 bundle:nil] forCellReuseIdentifier:cellId2];
    
    self.tableView.estimatedRowHeight = 10000;

}

- (void)requestData
{
//    请求Url  /dr/getCaseAdviceInfo
//    请求参数列表
//    变量名	含义	类型	备注
//    cookie	医生cookie	string
//    id	医嘱ID	number
    
//    响应参数列表
//    变量名	含义	类型	备注
//    data		object
//    advice	医嘱	string
//    diagnosis	医生诊断	string
//    end_date	任务截止日期(完成时间)	string	yyyy-MM-dd
//    id	医嘱ID	number
//    im_username	患者聊天ID	string	IM第三方聊天接口ID
//    pharmacy	用药及处方	string
//    status	状态	string
//    visit_date	就诊日期	string	yyyy-MM-dd
//    status		number
    
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:[NSNumber numberWithLong:[self.infoDic[@"id"] longValue]] forKey:@"id"];
    
    NSString *url = PATH(@"%@/getCaseAdviceInfo");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:NO httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            if ([responseObj[@"status"] integerValue] == 0) {
                
                if (responseObj[@"data"]) {
                    
                    [weakSelf.dataDic removeAllObjects];
                    [weakSelf.dataDic addEntriesFromDictionary:responseObj[@"data"]];
                    [weakSelf.tableView reloadData];
                    
                }
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}

- (IBAction)chatBtnClick
{
    if (self.dataDic[@"user_id"])
    {
        MDSingleCommunicationVC *chatController = [[MDSingleCommunicationVC alloc]
                                                     initWithConversationChatter:[NSString stringWithFormat:@"ug369P%@", self.dataDic[@"user_id"]] conversationType:EMConversationTypeChat];
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        LSWorkTailDetailUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1 forIndexPath:indexPath];
        [cell setDataWithDictionary:self.infoDic];
        return cell;
    }
    else
    {
        LSWorkTailDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2 forIndexPath:indexPath];
        [cell setDataWithDictionary:self.dataDic indexPath:indexPath];
        return cell;
    }
}

@end
