//
//  LSWorkTailController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkTailController.h"

#import "LSWorkTailDetailController.h"

#import "LSWorkTailCell.h"

static NSString *cellId = @"LSWorkTailCell";

@interface LSWorkTailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *content;

@end

@implementation LSWorkTailController

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
    self.navigationItem.title = @"医患跟踪";
    
    self.content = [NSMutableArray array];
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.rowHeight = 140;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, 20)];
    self.tableView.tableFooterView = footer;
}

- (void)requestData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@1 forKey:@"pagenum"];
    [param setValue:@100 forKey:@"pagesize"];
    
    NSString *url = PATH(@"%@/getAllCaseAdviceList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:NO httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            if ([responseObj[@"status"] integerValue] == 0) {
                
                if (responseObj[@"data"]) {
                    
                    [self.content removeAllObjects];
                    [self.content addObjectsFromArray:responseObj[@"data"][@"content"]];
                    [self.tableView reloadData];
                    
                    if (self.content.count == 0)
                    {
                        [XHToast showCenterWithText:@"您没有需要跟踪的医嘱"];
                    }
                    
                }
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LSWorkTailDetailController *vc = [[LSWorkTailDetailController alloc] initWithNibName:@"LSWorkTailDetailController" bundle:nil];
    vc.infoDic = self.content[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWorkTailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [cell setDataWithDictionary:self.content[indexPath.row]];
    return cell;
}

@end
