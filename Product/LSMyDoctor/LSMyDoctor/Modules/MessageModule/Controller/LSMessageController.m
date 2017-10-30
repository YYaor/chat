//
//  LSMessageController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMessageController.h"

#import "LSMessageCell.h"

#import "FMDBTool.h"
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
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
            if (dicDB) {
                model.title = dicDB[@"nickName"];
                model.avatarURLPath = dicDB[@"headerUrl"];
            }
            [self.tableView reloadData];
        });
        
        if (model) {
            [self.dataArray addObject:model];
        }
    }
    
    [self.tableView reloadData];
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
