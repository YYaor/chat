//
//  MDSingleCommunicationVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/17.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSingleCommunicationVC.h"

#import "LSDoctorAdviceController.h"
#import "LSRecommendArticleController.h"
#import "LSWorkArticleDetailController.h"
#import "MDMyAdviceDetailVC.h"
#import "MDPeerDetailVC.h"//医生详情
#import "MDSickerDetailVC.h"//患者详情
#import "YGComRequestCell.h"
#import "YGIllnessomplaintCell.h"
#import "YGSelectMedicalRecordCell.h"
#import "YGMedicalRecordDetailVC.h"
#import "LSDoctorAdviceMessageCell.h"
#import "LSRecommendArticleMessageCell.h"

@interface MDSingleCommunicationVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,YGSelectMedicalRecordCellDelegate,EMContactManagerDelegate>

@property(nonatomic,strong)EaseMessageViewController *easeMessage;

@end

@implementation MDSingleCommunicationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
//    [self tableViewDidTriggerHeaderRefresh];
    self.title = self.titleStr;
    if (!([self.conversation.conversationId containsString:@"p"] || [self.conversation.conversationId containsString:@"P"]))
    {
        //非医患聊天
        
        [self.chatBarMoreView removeItematIndex:3];
    }
    
    if (self.user_idStr.length > 0 && ![self.user_idStr isEqualToString:@""]) {
        //如果user_id存在，则可以跳转至详情
        UIButton* singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        singleBtn.frame = CGRectMake(LSSCREENWIDTH - 100, 7, 80, 30);
        [singleBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [singleBtn setImage:[UIImage imageNamed:@"person"] forState:UIControlStateNormal];
        [singleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
        UIBarButtonItem *copyBarBtn = [[UIBarButtonItem alloc] initWithCustomView:singleBtn];
        self.navigationItem.rightBarButtonItem = copyBarBtn;
        
    }
    
    
    
}
#pragma mark -- 右上角查看用户详情按钮点击
- (void)rightBtnClick
{
    if (!([self.conversation.conversationId containsString:@"p"] || [self.conversation.conversationId containsString:@"P"]))
    {
        //非医患聊天
        
        MDPeerDetailVC* detailVC = [[MDPeerDetailVC alloc] init];
        detailVC.doctorIdStr = self.user_idStr;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else
    {
        //医患聊天
        MDSickerDetailVC* sickerDetailVC = [[MDSickerDetailVC alloc] init];
        sickerDetailVC.sickerIdStr = self.user_idStr;
        
        [self.navigationController pushViewController:sickerDetailVC animated:YES];
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- 自定义Cell
- (UITableViewCell*)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel
{
    NSDictionary *dic = messageModel.message.ext;
    NSLog(@"===%@===", dic);
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
                [self agreeOrRefuseRequestDataWithStatus:statusStr requestId:requestId WithModel:messageModel];
                
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
            YGSelectMedicalRecordCell* cell = nil;
    //        (YGSelectMedicalRecordCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (!cell) {
                cell = [[YGSelectMedicalRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId model:messageModel];
            }
            cell.model = messageModel;
            return cell;
        }
        
        if(messageModel.message.ext[@"messageType"]){
            //医嘱
            NSString* cellId = [LSDoctorAdviceMessageCell cellIdentifierWithModel:messageModel];
            LSDoctorAdviceMessageCell* cell = (LSDoctorAdviceMessageCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (!cell) {
                cell = [[LSDoctorAdviceMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId model:messageModel];
            }
            cell.model = messageModel;
            return cell;
        }
        
        if(messageModel.message.ext[@"recommendArticle"]){
            //文章推荐
            NSString* cellId = [LSRecommendArticleMessageCell cellIdentifierWithModel:messageModel];
            LSRecommendArticleMessageCell* cell = (LSRecommendArticleMessageCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (!cell) {
                cell = [[LSRecommendArticleMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId model:messageModel];
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
        if(messageModel.message.ext[@"messageType"]){
            //医嘱
            return 110.0f;
        }
        
        if(messageModel.message.ext[@"recommendArticle"]){
            //文章推荐
            return 110.0f;
        }
        
    }
    return 0.f;
}


- (BOOL)messageViewController:(EaseMessageViewController *)viewController didSelectMessageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    
    if (messageModel.message.ext[@"messageType"])
    {
        flag = YES;
        
//        LSDoctorAdviceController *vc = [[LSDoctorAdviceController alloc] initWithNibName:@"LSDoctorAdviceController" bundle:nil];
//        vc.message = messageModel.message;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        vc.sureBlock = ^(NSDictionary *dataDic)
//        {
//            
//            [self.conversation updateMessageChange:messageModel.message error:nil];
//        };
        
        MDMyAdviceDetailVC *vc = [[MDMyAdviceDetailVC alloc] init];
        vc.isNotNeedBtn = YES;
        vc.adviceIdStr = messageModel.message.ext[@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (messageModel.message.ext[@"recommendArticle"])
    {
        flag = YES;
        
        LSWorkArticleDetailController *vc = [[LSWorkArticleDetailController alloc] initWithNibName:@"LSWorkArticleDetailController" bundle:nil];
        vc.dic = messageModel.message.ext;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    return flag;
}


#pragma mark -- 同意预约请求
- (void)agreeOrRefuseRequestDataWithStatus:(NSString*)statusStr requestId:(NSString*)requestIdStr WithModel:(id<IMessageModel>)messageModel
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
                
                
                [self selectedRequestStatusWithRequestId:requestIdStr WithModel:messageModel];
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
- (void)selectedRequestStatusWithRequestId:(NSString*)requestid WithModel:(id<IMessageModel>)messageModel
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:requestid forKey:@"id"];
    
    NSString* url = PATH(@"%@/getOrderStatus");
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                NSLog(@"获取预约请求的状态为：%@",responseObj[@"data"]);
                
                
                EMMessage *chatMessage = messageModel.message;
                if (chatMessage.ext) {
                    NSMutableDictionary *dict = [chatMessage.ext mutableCopy];
                    [dict setObject:responseObj[@"data"] forKey:@"isHaveStatus"];
                    chatMessage.ext = dict;
                    [[EMClient sharedClient].chatManager updateMessage:chatMessage completion:nil];
                    
                } else {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:chatMessage.ext];
                    [dic setObject:responseObj[@"data"] forKey:@"isHaveStatus"];
                    chatMessage.ext = dic;
                    [[EMClient sharedClient].chatManager updateMessage:chatMessage completion:nil];
                }
                
                
                
                NSMutableDictionary *data = [NSMutableDictionary dictionary];
                [data setValue:requestid forKey:@"id"];
                [data setValue:responseObj[@"data"] forKey:@"remindData"];
                [data setObject:UserName forKey:@"username"];
                [data setObject:DoctorId forKey:@"doctorid"];
                [data setValue:UserImage forKey:@"userimage"];
                
  //              [self sendTextMessage:@" " withExt:data];
                
                EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"已同意请求"];
                NSString *from = [[EMClient sharedClient] currentUsername];;
                //生成Message
                
                EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:from to:self.conversation.conversationId body:body ext:data];
                message.chatType = EMChatTypeChat;// 设置为单聊消息
                [self _sendCmdmessage:message];//上面的只是在创建消息，这一步才是发送
                
                /*
                EMMessage* cmdMessage = [EaseSDKHelper sendCmdMessage:@"mmm" to:self.conversation.conversationId  messageType:EMChatTypeChat messageExt:data cmdParams:[NSArray arrayWithObjects:@"1", nil]];
                
                [self _sendMessage:cmdMessage];
            
                */
                
                
                
                [self.tableView reloadData];
                
                
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

- (void)_sendCmdmessage:(EMMessage *)message{
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        [_easeMessage _refreshAfterSentMessage:aMessage];
    }];
}




#pragma mark -- 点击病历查看详情
- (void)yGSelectMedicalRecordCellDetailBtnClick:(WFHelperButton *)sender
{
    YGMedicalRecordDetailVC* recordDetailVC = [[YGMedicalRecordDetailVC alloc] init];
    recordDetailVC.recordIdStr = sender.detail;
    [self.navigationController pushViewController:recordDetailVC animated:YES];
}

#pragma mark -- 选择图片
- (void)morePhotoCallButtonAction:(EaseChatBarMoreView *)moreView
{
    //图片
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"选照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //首先需要判断资源是否可用
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            pickerImage.delegate = self;
            //设置允许编辑
            pickerImage.allowsEditing = YES;
            
            [self presentViewController:pickerImage animated:YES completion:^{
            }];
        }
    }];
    
    
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"拍照片");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//设置类型为相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;//设置代理
            picker.allowsEditing = YES;//设置照片可编辑
            picker.sourceType = sourceType;
            //设置是否显示相机控制按钮 默认为YES
            picker.showsCameraControls = YES;
            
            [self presentViewController:picker animated:YES completion:^{
            }];
        }
        else {
            [AlertHelper InitMyAlertMessage:@"您的设备不支持相机" And:self];
        }
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 从相册选择图片后操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //获取裁剪后的图像
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    
    //如果是拍照，将照片存到媒体库
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
    
    
    [self.chatToolbar endEditing:YES];
    //发送图片
    [self sendImageMessage:image];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 照片存到本地后的回调
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"存储成功");
    } else {
        NSLog(@"存储失败：%@", error);
    }
}

- (void)moreIssueadviceCallButtonAction:(EaseChatBarMoreView *)moreView
{
    // Hide the keyboard
    [self.chatToolbar endEditing:YES];
    
    LSDoctorAdviceController *vc = [[LSDoctorAdviceController alloc] initWithNibName:@"LSDoctorAdviceController" bundle:nil];
    vc.conversation = self.conversation;
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.sureBlock = ^(NSDictionary *dataDic) {
        [self sendTextMessage:@"[下达医嘱]" withExt:dataDic];
    };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.conversation.conversationId, @"type":[NSNumber numberWithInt:0]}];
}

- (void)moreArticlerecommendCallButtonAction:(EaseChatBarMoreView *)moreView
{
    // Hide the keyboard
    [self.chatToolbar endEditing:YES];
    
    LSRecommendArticleController *vc = [[LSRecommendArticleController alloc] initWithNibName:@"LSRecommendArticleController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.sureBlock = ^(NSDictionary *dataDic) {
        [self sendTextMessage:@"[文章推荐]" withExt:dataDic];
    };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.conversation.conversationId, @"type":[NSNumber numberWithInt:0]}];
}

@end
