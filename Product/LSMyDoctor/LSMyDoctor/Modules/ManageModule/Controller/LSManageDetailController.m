//
//  LSManageDetailController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSManageDetailController.h"

@interface LSManageDetailController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LSManageDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"患者主页";
}

- (IBAction)chartBtnClick
{
    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"ug369P%@", self.model.user_id] conversationType:EMConversationTypeChat];
    chatController.title = self.model.username;
    [self.navigationController pushViewController:chatController animated:YES];
}

@end
