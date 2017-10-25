//
//  LSMessageController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMessageController.h"

#import "LSMessageCell.h"

static NSString *cellId = @"LSMessageCell";

@interface LSMessageController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *dataArray;


@end

@implementation LSMessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self initForView];
    [self requestData];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"消息";
//    self.view.backgroundColor = [UIColor colorFromHexString:@"EEE9E9"];
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.rowHeight = 100;
}

- (void)requestData
{
    NSArray *aaaa = [[EMClient sharedClient].chatManager getAllConversations];
    [self.dataArray addObjectsFromArray:[[EMClient sharedClient].chatManager getAllConversations]];

    [self.tableView reloadData];
}

//- (EaseConversationModel *)getConversationModel:(EMConversation *)conversation
//{
//    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
//    if (model.conversation.type == EMConversationTypeChat) {
//        
//        EMMessage *lastMessage = conversation.lastReceivedMessage;
//        
//        NSDictionary *data = [HXUser getUser:conversation.conversationId];
//        
//        if (data){
//            model.avatarURLPath = [data valueForKey:@"headerUrl"];
//            model.title = [data valueForKey:@"nickName"];
//        } else {
//            NSDictionary *dic = lastMessage.ext;
//            if (dic){
//                NSString *nickName = [dic valueForKey:@"nickName"];
//                model.title = nickName;
//                model.avatarURLPath = [dic valueForKey:@"headerUrl"];
//            }
//        }
//    } else if (model.conversation.type == EMConversationTypeGroupChat) {
//        
//        EMMessage *lastMessage = conversation.latestMessage;
//        
//        NSDictionary *data = [HXUser getUser:conversation.conversationId];
//        if (data){
//            model.avatarURLPath = [data valueForKey:@"groupHeaderUrl"];
//            model.title = [data valueForKey:@"groupHeaderName"];
//        } else {
//            NSDictionary *dic = lastMessage.ext;
//            NSString *nickName = [dic valueForKey:@"groupHeaderName"];
//            model.title = nickName;
//            model.avatarURLPath = [dic valueForKey:@"groupHeaderUrl"];
//        }
//        
//        NSDictionary *groupDic = lastMessage.ext;
//        NSDictionary *dic = conversation.ext;
//        NSString * subject = [dic valueForKey:@"subject"];
//        if (subject&&subject.length>0){
//            model.title = subject;
//        } else {
//            model.title = [groupDic valueForKey:@"groupHeaderName"];
//        }
//        model.avatarURLPath = [groupDic valueForKey:@"groupHeaderUrl"];
//    }
//    return model;
//}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    return cell;
}

@end
