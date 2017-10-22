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


@end

@implementation LSMessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    
//    [param setValue:[Defaults objectForKey:@"cookie"] forKey:@"cookie"];
//    [param setValue:@100 forKey:@"pagenum"];
//    [param setValue:@1 forKey:@"pagesize"];
//    [param setValue:@1 forKey:@"type"];
//    
//    NSString *url = PATH(@"%@/dr/beRequestList");
//    
//    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
//        if ([responseObj isKindOfClass:[NSDictionary class]])
//        {
//            NSDictionary * dict = responseObj;
//        }
//    } failBlock:^(NSError *error) {
//        [XHToast showCenterWithText:@"fail"];
//    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    return cell;
}

@end
