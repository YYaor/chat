//
//  LSMessageController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDWaitForReplyVC.h"

#import "LSMessageCell.h"

#import "FMDBTool.h"
static NSString *cellId = @"LSMessageCell";

@interface MDWaitForReplyVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *dataArray;


@end

@implementation MDWaitForReplyVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self initForView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestData];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"待回复";
    //    self.view.backgroundColor = [UIColor colorFromHexString:@"EEE9E9"];
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.rowHeight = 100;
}

- (void)requestData
{
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    
    
    [self.dataArray removeAllObjects];
    for (EMConversation *converstion in sorted) {
        EaseConversationModel *model = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
            model = [self.dataSource conversationListViewController:self
                                               modelForConversation:converstion];
        }
        else{
            model = [[EaseConversationModel alloc] initWithConversation:converstion];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            
            NSDictionary *dicDB = [FMDBTool selectUserLoginViewInfoSqlTableWithTypeListName:CHATUSERTABLE
                                                                                     search:@[[NSString stringWithFormat:@"uid = '%@'",converstion.conversationId]] dataTyep:CHATUSERKEYS];
            if (model) {
                if (dicDB) {
                    model.title = dicDB[@"nickName"];
                    model.avatarURLPath = dicDB[@"headerUrl"];
                }else{
                    [self requestPdata:converstion.conversationId];
                }
                if ([model.conversation.conversationId containsString:@"D"] || [model.conversation.conversationId containsString:@"d"]) {
                    if (model.conversation.unreadMessagesCount > 0) {
                        [self.dataArray addObject:model];
                    }
                }
            }
        });
    }
    
    [self.tableView reloadData];
}

-(void)checkDoctor:(NSString *)conversationId{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setObject:@[conversationId] forKey:@"im_username"];
    
    NSString *url = PATH(@"%@/getDoctorByIM");
    self.dataArray = [[NSMutableArray alloc]init];
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:NO httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            if ([responseObj[@"status"] integerValue] == 0) {
                
                if (responseObj[@"data"]) {
                    
                    for (NSDictionary *dic in responseObj[@"data"]) {
                        [FMDBTool insertTypeListToSqlTableWithTypeListName:CHATUSERTABLE
                                                                      data:@{@"uid" : dic[@"im_username"],
                                                                             @"nickName" : dic[@"doctor_name"] ? dic[@"doctor_name"] : @"",
                                                                             @"headerUrl" : dic[@"doctor_image"] ? dic[@"doctor_image"] : @""}];
                        for (EaseConversationModel *conversation in self.dataArray) {
                            if ([conversation.conversation.conversationId isEqualToString:conversationId]) {
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

-(void)checkPatient:(NSString *)conversationId{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setObject:@[conversationId] forKey:@"im_username"];
    
    NSString *url = PATH(@"%@/getPatientByIM");
    self.dataArray = [[NSMutableArray alloc]init];
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:NO httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            if ([responseObj[@"status"] integerValue] == 0) {
                
                if (responseObj[@"data"]) {
                    
                    for (NSDictionary *dic in responseObj[@"data"]) {
                        [FMDBTool insertTypeListToSqlTableWithTypeListName:CHATUSERTABLE
                                                                      data:@{@"uid" : dic[@"im_username"],
                                                                             @"nickName" : dic[@"username"] ? dic[@"username"] : @"",
                                                                             @"headerUrl" : dic[@"img_url"] ? dic[@"img_url"] : @""}];
                        for (EaseConversationModel *conversation in self.dataArray) {
                            if ([conversation.conversation.conversationId isEqualToString:conversationId]) {
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

-(void)requestPdata:(NSString *)conversationId
{
    
    if ([conversationId containsString:@"P"] || [conversationId containsString:@"p"]) {
        //病人查询
        [self checkPatient:conversationId];
    }else{
        //医生查询
        [self checkDoctor:conversationId];
    }
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EaseConversationModel *converSation = self.dataArray[indexPath.row];
    EaseMessageViewController *chatController = [[EaseMessageViewController alloc]
                                                 initWithConversationChatter:converSation.conversation.conversationId conversationType:converSation.conversation.type];
    chatController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.conversation = self.dataArray[indexPath.row];
    return cell;
}

@end



