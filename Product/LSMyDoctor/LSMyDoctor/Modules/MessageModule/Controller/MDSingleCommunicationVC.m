//
//  MDSingleCommunicationVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/17.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSingleCommunicationVC.h"
#import "YGComRequestCell.h"
#import "YGIllnessomplaintCell.h"
#import "YGSelectMedicalRecordCell.h"
#import "YGMedicalRecordDetailVC.h"

@interface MDSingleCommunicationVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,YGSelectMedicalRecordCellDelegate>

@end

@implementation MDSingleCommunicationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    [self tableViewDidTriggerHeaderRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- 自定义Cell
- (UITableViewCell*)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel
{
    if (messageModel.message.ext) {
        if(messageModel.message.ext[@"bookRequest"]){
            //预约请求
            NSString* cellId = [YGComRequestCell cellIdentifierWithModel:messageModel];
            YGComRequestCell* cell = nil;
 //           (YGComRequestCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (!cell) {
                cell = [[YGComRequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId model:messageModel];
            }
            
            cell.model = messageModel;
            
            cell.sureBlock = ^(NSString *status, NSString *requestId) {
                NSString* statusStr = [status isEqualToString:@"1"] ? @"1" : @"2";
                [self agreeOrRefuseRequestDataWithStatus:statusStr requestId:requestId];
                
            };
            
            return cell;
        }
        
        if(messageModel.message.ext[@"chiefComplaint"]){
            //问诊 病情主诉
            NSString* cellId = [YGIllnessomplaintCell cellIdentifierWithModel:messageModel];
            YGIllnessomplaintCell* cell = (YGIllnessomplaintCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (!cell) {
                cell = [[YGIllnessomplaintCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId model:messageModel];
            }
            cell.delegate = self;
            cell.model = messageModel;
            return cell;
        }
        
        if(messageModel.message.ext[@"medicalRecord"]){
            //病历
            NSString* cellId = [YGSelectMedicalRecordCell cellIdentifierWithModel:messageModel];
            YGSelectMedicalRecordCell* cell = (YGSelectMedicalRecordCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (!cell) {
                cell = [[YGSelectMedicalRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId model:messageModel];
            }
            cell.model = messageModel;
            return cell;
        }
        
        
        
    }
    
    
    return nil;
    
}
//高度
- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    if (messageModel.message.ext) {
        if(messageModel.message.ext[@"bookRequest"]){
            //预约
            //            CGFloat contentHeight = [Function contentHeightWithSize:18.0 with:kScreenWidth * 0.5  string:message] ;
            //            return contentHeight > 30 ? contentHeight + 50 :  80;
            
            return 160.0f;
        }
        if(messageModel.message.ext[@"chiefComplaint"]){
            //病情主诉 问诊
            //            CGFloat contentHeight = [Function contentHeightWithSize:18.0 with:kScreenWidth * 0.5  string:message] ;
            //            return contentHeight > 30 ? contentHeight + 50 :  80;
            
            return 120.0f;
        }
        
        if(messageModel.message.ext[@"medicalRecord"]){
            //我的病历
            //            CGFloat contentHeight = [Function contentHeightWithSize:18.0 with:kScreenWidth * 0.5  string:message] ;
            //            return contentHeight > 30 ? contentHeight + 50 :  80;
            
            return 110.0f;
        }
        
    }
    return 0.f;
}

#pragma mark -- 同意预约请求
- (void)agreeOrRefuseRequestDataWithStatus:(NSString*)statusStr requestId:(NSString*)requestIdStr
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:statusStr forKey:@"status"];
    [param setValue:requestIdStr forKey:@"id"];
    
    NSString* url = PATH(@"%@/updateOrderStatus");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                [XHToast showCenterWithText:@"已处理该请求"];
                [self selectedRequestStatusWithRequestId:requestIdStr];
            }else
            {
                [XHToast showCenterWithText:@"获取数据失败"];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
        
        
        
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
}

#pragma mark -- 查询预约请求状态
- (void)selectedRequestStatusWithRequestId:(NSString*)requestid
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:requestid forKey:@"id"];
    
    NSString* url = PATH(@"%@/getOrderStatus");
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                NSLog(@"获取预约请求的状态为：%@",responseObj[@"data"]);
                
            }else
            {
                [XHToast showCenterWithText:@"获取数据失败"];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
        
        
        
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
}
#pragma mark -- 点击病历查看详情
- (void)yGSelectMedicalRecordCellDetailBtnClick:(WFHelperButton *)sender
{
    YGMedicalRecordDetailVC* recordDetailVC = [[YGMedicalRecordDetailVC alloc] init];
    recordDetailVC.recordIdStr = sender.detail;
    [self.navigationController pushViewController:recordDetailVC animated:YES];
}

@end
