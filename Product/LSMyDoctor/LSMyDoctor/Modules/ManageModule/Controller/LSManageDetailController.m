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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
}

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

- (void)requestData
{
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.model.user_id forKey:@"userid"];
    
    NSString* url = PATH(@"%@//patienInfo");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
//            NSArray *dataList = [NSArray yy_modelArrayWithClass:[LSManageModel class] json:responseObj[@"data"]];
//            
//            [weakSelf.groupDataArr removeAllObjects];
//            [weakSelf.groupDataArr addObjectsFromArray:dataList];
//            
//            weakSelf.indexArray = [BMChineseSort IndexWithArray:weakSelf.groupDataArr Key:@"username"];
//            weakSelf.letterResultArr = [BMChineseSort sortObjectArray:weakSelf.groupDataArr Key:@"username"];
//            
//            [weakSelf.sickerTab reloadData];
            
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        
    }];
}

- (IBAction)chartBtnClick
{
    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"ug369P%@", self.model.user_id] conversationType:EMConversationTypeChat];
    chatController.title = self.model.username;
    [self.navigationController pushViewController:chatController animated:YES];
}

@end
