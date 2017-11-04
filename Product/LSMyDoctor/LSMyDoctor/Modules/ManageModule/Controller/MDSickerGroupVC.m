//
//  MDSickerGroupVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/30.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSickerGroupVC.h"
#import "MDConsultDiscussCell.h"
#import "MDSickerGroupModel.h"
#import "MDGroupCommunicateVC.h"

@interface MDSickerGroupVC ()<UITableViewDelegate , UITableViewDataSource>
{
    UITableView* groupTab;
}
@property (nonatomic , strong) NSMutableArray* groupArr;
@end

@implementation MDSickerGroupVC
#pragma mark -- 懒加载
-(NSMutableArray *)groupArr{
    if (!_groupArr) {
        _groupArr = [[NSMutableArray alloc] init];
    }
    return _groupArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群组";
    
    [self setUpUi];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    //获取列表数据
    [self getSickerGroupListData];
}
#pragma mark -- 创建界面
- (void)setUpUi
{
    //创建界面
    groupTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT - 64) style:UITableViewStyleGrouped];
    groupTab.delegate = self;
    groupTab.dataSource = self;
    [self.view addSubview:groupTab];
    
    //注册Cell
    [groupTab registerNib:[UINib nibWithNibName:@"MDConsultDiscussCell" bundle:nil] forCellReuseIdentifier:@"mDConsultDiscussCell"];
    
    
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupArr.count;
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
    MDSickerGroupModel* listModel = self.groupArr[indexPath.section];
    
    cell.imgUrlStr = listModel.img_url;
    cell.groupNameStr = listModel.name;
    
    
    return cell;
}
#pragma mark -- 群组按钮点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MDSickerGroupModel* listModel = self.groupArr[indexPath.section];
    
    MDGroupCommunicateVC* groupCommunicateVC = [[MDGroupCommunicateVC alloc] initWithConversationChatter:listModel.im_groupid conversationType:EMConversationTypeGroupChat];
    groupCommunicateVC.isPeer = NO;
    groupCommunicateVC.title = listModel.name;
    groupCommunicateVC.groupIdStr = listModel.groupId;
    [self.navigationController pushViewController:groupCommunicateVC animated:YES];
    
}
#pragma mark -- 获取会诊讨论组列表
- (void)getSickerGroupListData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/queryGroupList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                NSArray* list = [NSArray yy_modelArrayWithClass:[MDSickerGroupModel class] json:responseObj[@"data"]];
                [self.groupArr removeAllObjects];
                [self.groupArr addObjectsFromArray:list];
                
                [groupTab reloadData];
                
            }else
            {
                [XHToast showCenterWithText:@"获取数据失败"];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
        
        
        
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}


@end
