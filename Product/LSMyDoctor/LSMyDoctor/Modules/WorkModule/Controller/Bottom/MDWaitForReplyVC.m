//
//  LSMessageController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDWaitForReplyVC.h"

#import "MDSingleCommunicationVC.h"

#import "LSMessageCell.h"

#import "FMDBTool.h"

static NSString *cellId = @"LSMessageCell";

@interface MDWaitForReplyVC () <UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;//筛选好的聊天列表

@end

@implementation MDWaitForReplyVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [self requestData];
    [self registerNotifications];
}
- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"待回复";
    
    self.dataList = [NSMutableArray array];
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.rowHeight = 100;
    [self tableViewDidTriggerHeaderRefresh];
}


- (void)requestData
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
    if ([self.dataArray count] > 1) {
        if ([[self.dataArray objectAtIndex:0] isKindOfClass:[EaseConversationModel class]]) {
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (EaseConversationModel *model in self.dataArray) {
                if (([model.conversation.conversationId containsString:@"d"] || [model.conversation.conversationId containsString:@"D"]) && model.conversation.unreadMessagesCount > 0) {
                    [temp addObject:model];
                }
            }
            
            NSArray* sorted = [temp sortedArrayUsingComparator:
                               ^(EaseConversationModel *obj1, EaseConversationModel* obj2){
                                   EMMessage *message1 = [obj1.conversation latestMessage];
                                   EMMessage *message2 = [obj2.conversation latestMessage];
                                   if(message1.timestamp > message2.timestamp) {
                                       return(NSComparisonResult)NSOrderedAscending;
                                   }else {
                                       return(NSComparisonResult)NSOrderedDescending;
                                   }
                               }];
            
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:sorted];
        }
    }
    else
    {
        NSMutableArray *temp = [NSMutableArray array];
        
        for (EaseConversationModel *model in self.dataArray) {
            if (([model.conversation.conversationId containsString:@"d"] || [model.conversation.conversationId containsString:@"D"]) && model.conversation.unreadMessagesCount > 0) {
                [temp addObject:model];
            }
        }
        
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:temp];
    }
    
    for (EaseConversationModel *model in self.dataList)
    {
        NSLog(@"=== %@ ===", model.conversation.lastReceivedMessage.ext);
        
        if (model.conversation.lastReceivedMessage.ext)
        {
            model.title = model.conversation.lastReceivedMessage.ext[@"username"];
            model.avatarURLPath = model.conversation.lastReceivedMessage.ext[@"userimage"];
        }
        else if (!model.avatarURLPath)
        {
            [self requestNicknameAndUserimageWithModel:model];
        }
    }
    
    if (self.dataList.count == 0)
    {
        [XHToast showCenterWithText:@"您没有需要回复的消息"];
    }
    
    [self.tableView reloadData];

}

- (void)requestNicknameAndUserimageWithModel:(EaseConversationModel *)model
{
    if ([model.conversation.conversationId containsString:@"p"] || [model.conversation.conversationId containsString:@"P"])
    {
        NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
        
        [param setObject:@[model.conversation.conversationId] forKey:@"im_username"];
        
        NSString *url = PATH(@"%@/getPatientByIM");
        
        [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:NO httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
            if ([responseObj isKindOfClass:[NSDictionary class]])
            {
                if ([responseObj[@"status"] integerValue] == 0) {
                    if (responseObj[@"data"]) {
                        for (NSDictionary *dic in responseObj[@"data"]) {
                            for (EaseConversationModel *conversation in self.dataList) {
                                if ([conversation.conversation.conversationId isEqualToString:model.conversation.conversationId]) {
                                    conversation.title = dic[@"username"];
                                    conversation.avatarURLPath = dic[@"img_url"];
                                }
                            }
                        }
                        [self.tableView reloadData];
                    }
                }
            }
        } failBlock:^(NSError *error) {
            
        }];
    }
    else
    {
        NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
        
        [param setObject:@[model.conversation.conversationId] forKey:@"im_username"];
        
        NSString *url = PATH(@"%@/getDoctorByIM");
        
        [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:NO httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
            if ([responseObj isKindOfClass:[NSDictionary class]])
            {
                if ([responseObj[@"status"] integerValue] == 0) {
                    if (responseObj[@"data"]) {
                        for (NSDictionary *dic in responseObj[@"data"]) {
                            for (EaseConversationModel *conversation in self.dataList) {
                                if ([conversation.conversation.conversationId isEqualToString:model.conversation.conversationId]) {
                                    conversation.title = dic[@"doctor_name"];
                                    conversation.avatarURLPath = dic[@"doctor_image"];
                                }
                            }
                        }
                        [self.tableView reloadData];
                    }
                }
            }
        } failBlock:^(NSError *error) {
            
        }];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EaseConversationModel *converSation = self.dataList[indexPath.row];
    MDSingleCommunicationVC *chatController = [[MDSingleCommunicationVC alloc]
                                                 initWithConversationChatter:converSation.conversation.conversationId conversationType:converSation.conversation.type];
    chatController.titleStr = converSation.conversation.lastReceivedMessage.ext[@"username"]?converSation.conversation.lastReceivedMessage.ext[@"username"]:converSation.title;
    chatController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatController animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EaseConversationModel *model = [self.dataList objectAtIndex:indexPath.row];
        [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:nil];
        [self.dataList removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.conversation = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - EMChatManagerDelegate

- (void)messagesDidReceive:(NSArray *)aMessages
{
    [self tableViewDidTriggerHeaderRefresh];
    [self requestData];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

@end



