//
//  MDDocRequestVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/18.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDDocRequestVC.h"
#import "MDSickerRequestCell.h"
#import "MDPeerReuqestModel.h"

#import "FMDBTool.h"
@interface MDDocRequestVC ()<UITableViewDelegate,UITableViewDataSource,MDSickerRequestCellDelegate>
{
    UITableView* requestTab;
}

@property (nonatomic ,strong)MDPeerReuqestModel * requestModel;

@end

@implementation MDDocRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"同行请求";
    
    [self setUpUi];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    //获取请求列表
    [self getRequestData];
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
    return self.requestModel.content.count;
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
    cell.contentModel = self.requestModel.content[indexPath.section];
    
    return cell;
    
}
#pragma mark -- 左滑删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDRequestContentModel* contentModel = self.requestModel.content[indexPath.section];
    if ([contentModel.result isEqualToString:@"已通过"]) {
        return @"移除";
    }else{
        return @"拒绝";
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        MDRequestContentModel* contentModel = self.requestModel.content[indexPath.section];
        if ([contentModel.result isEqualToString:@"已通过"]) {
            //移除按钮点击
            [self removeTheRequestWithRequestId:contentModel.requestId];
        }else{
            //拒绝按钮点击
            [self dealWithTheRequestWithResult:2 requestId:contentModel.requestId mDRequestContentModel:contentModel];
        }
        
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark -- 同意按钮点击
- (void)mDSickerRequestCellDelegateAgreeBtnClickWithSickerModel:(MDRequestContentModel *)contentModel
{
    NSLog(@"同意按钮点击：%@",contentModel.requestId);
    
    [self dealWithTheRequestWithResult:1 requestId:contentModel.requestId mDRequestContentModel:contentModel];
}

#pragma mark -- 获取请求列表
- (void)getRequestData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@(1) forKey:@"pagenum"];
    [param setValue:@(100) forKey:@"pagesize"];
    [param setValue:@(2) forKey:@"type"];
    
    NSString* url = PATH(@"%@/beRequestList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                self.requestModel = [MDPeerReuqestModel yy_modelWithDictionary:responseObj[@"data"]];
                
                [requestTab reloadData];
                
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
#pragma mark -- 同意或拒绝请求
- (void)dealWithTheRequestWithResult:(NSInteger)result requestId:(NSString*)requestIdStr mDRequestContentModel:(MDRequestContentModel *)MDRequestContentModel
{
    //result值：1 -- 同意     2 -- 拒绝
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:requestIdStr forKey:@"id"];
    [param setValue:@(result) forKey:@"result"];
    
    NSString* url = PATH(@"%@/dealwithRequest");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                [self getRequestData];
                if (result == 1) {
                    [FMDBTool insertTypeListToSqlTableWithTypeListName:CHATUSERTABLE
                                                                  data:@{@"uid" : [NSString stringWithFormat:@"ug369P%@",MDRequestContentModel.requestId],
                                                                         @"nickName" : MDRequestContentModel.username ? MDRequestContentModel.username : @"",
                                                                         @"headerUrl" : MDRequestContentModel.img_url ? MDRequestContentModel.img_url : @""}];
                }
                
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

#pragma mark -- 删除请求
- (void)removeTheRequestWithRequestId:(NSString*)requestIdStr
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:requestIdStr forKey:@"id"];
    
    NSString* url = PATH(@"%@/removeRequest");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                [self getRequestData];
                
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
