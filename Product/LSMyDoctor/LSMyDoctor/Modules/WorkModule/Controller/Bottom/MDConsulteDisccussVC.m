//
//  MDConsulteDisccussVC.m
//  MyDoctor
//
//  Created by WangQuanjiang on 17/9/20.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDConsulteDisccussVC.h"
#import "MDConsultDiscussCell.h"
#import "MDDiscussListModel.h"
#import "MDGroupCommunicateVC.h"

@interface MDConsulteDisccussVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* listTab;//列表
}
@property (nonatomic , strong) NSMutableArray* groupArr;

@end

@implementation MDConsulteDisccussVC

-(NSMutableArray *)groupArr{
    if (!_groupArr) {
        _groupArr = [[NSMutableArray alloc] init];
    }
    return _groupArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"会诊讨论";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self setUpUi];
    
}
#pragma mark -- 返回按钮点击
- (void)backBtnClick
{
    //返回
    if (self.isSkipPop) {
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //获取会诊讨论组列表
    [self getDiscussListData];
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
    MDDiscussListModel* listModel = self.groupArr[indexPath.section];
    
    cell.imgUrlStr = listModel.img_url;
    cell.groupNameStr = listModel.name;
    
    return cell;
}

//群组点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"点击跳转对应群组对话");
    MDDiscussListModel* listModel = self.groupArr[indexPath.section];
    
    MDGroupCommunicateVC* groupCommunicateVC = [[MDGroupCommunicateVC alloc] initWithConversationChatter:listModel.im_roomid conversationType:EMConversationTypeChatRoom];
    groupCommunicateVC.isPeer = YES;
    groupCommunicateVC.title = listModel.name;
    groupCommunicateVC.groupIdStr = listModel.groupId;
    [self.navigationController pushViewController:groupCommunicateVC animated:YES];
    
}


#pragma mark -- 获取会诊讨论组列表
- (void)getDiscussListData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/queryRoomList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                NSArray* list = [NSArray yy_modelArrayWithClass:[MDDiscussListModel class] json:responseObj[@"data"]];
                [self.groupArr removeAllObjects];
                [self.groupArr addObjectsFromArray:list];
                
                [listTab reloadData];
                
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
