//
//  LSWorkUnreplyListController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkUnreplyListController.h"

@interface LSWorkUnreplyListController () <EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource>

@end

@implementation LSWorkUnreplyListController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
    [self requestData];
}

- (void)initForView
{
    self.navigationItem.title = @"待回复";
    
}

- (void)requestData
{
//    EaseConversationModel *model = [EaseConversationModel new];
//    model.title = @"123";
//    
//    [self.dataArray removeAllObjects];
//    
//    [self.dataArray addObject:model];
//    [self.dataArray addObject:model];
//    [self.dataArray addObject:model];
//    
//    [self.tableView reloadData];
}

@end
