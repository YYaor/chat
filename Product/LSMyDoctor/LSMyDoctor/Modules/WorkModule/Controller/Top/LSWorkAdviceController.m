//
//  LSWorkAdviceController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkAdviceController.h"

#import "LSWorkAdviceDetailController.h"

#import "LSWorkAdviceCell.h"

static NSString *cellId = @"LSWorkAdviceCell";

@interface LSWorkAdviceController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LSWorkAdviceController

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
    [self requestData];
}

- (void)initForView
{
    self.navigationItem.title = @"患者请求";
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.rowHeight = 100;
}

- (void)requestData
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setValue:[Defaults objectForKey:@"cookie"] forKey:@"cookie"];
    [param setValue:@100 forKey:@"pagenum"];
    [param setValue:@1 forKey:@"pagesize"];
    [param setValue:@1 forKey:@"type"];
    
    NSString *url = PATH(@"%@/dr/beRequestList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary * dict = responseObj;
        }
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LSWorkAdviceDetailController *vc = [[LSWorkAdviceDetailController alloc] initWithNibName:@"LSWorkAdviceDetailController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWorkAdviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
    {
        NSLog(@"___%s___", __func__);
    }];
    
    return @[action];
}

@end
